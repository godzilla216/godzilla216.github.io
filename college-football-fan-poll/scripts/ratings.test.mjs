import assert from 'node:assert/strict';
import {test} from 'node:test';
import {calculateTeamRating, collectRecords, completedGames, describeRating, loadRatings,
  parseRecord, RATING_SEASON, RATINGS_CACHE_KEY} from '../app/ratings.js';

const game = (id, result = 1, margin = 7) => ({id, opponentId: id, result, margin});
const records = entries => new Map(entries.map(([id, summary]) => [id, parseRecord(summary)]));
const standings = entries => ({season: {year: RATING_SEASON}, children: [{standings: {
  entries: entries.map(([id, summary]) => ({team: {id}, stats: [
    {name: 'vs. conf.', displayValue: '0-8'}, {name: 'overall', displayValue: summary}
  ]}))
}}]});
const event = (id, own, opponent, points, against, completed = true) => ({
  id, season: {year: RATING_SEASON}, competitions: [{status: {type: {completed}}, competitors: [
    {id: own, score: {value: points}}, {id: opponent, score: String(against)}
  ]}]
});

test('records use overall season totals and handle nested conferences, ties, and invalid data', () => {
  assert.deepEqual(parseRecord(' 8-2-1 '), {wins: 8, losses: 2, ties: 1, played: 11, summary: '8-2-1'});
  assert.equal(parseRecord('missing'), null);
  assert.equal(parseRecord(undefined), null);
  assert.equal(collectRecords(standings([['a', '8-2']])).get('a').summary, '8-2');
});

test('only completed games in the requested season with valid scores are used, without duplicates', () => {
  const valid = event('g1', 'a', 'b', 28, 14);
  const priorSeason = {...event('old', 'a', 'b', 14, 28), season: {year: RATING_SEASON - 1}};
  const data = {season: {year: RATING_SEASON}, events: [valid, valid, priorSeason,
    event('future', 'a', 'b', 0, 0, false), event('missing', 'a', 'b', null, 7)]};
  assert.deepEqual(completedGames(data, 'a'), [{id: 'g1', opponentId: 'b', result: 1, margin: 14}]);
  assert.throws(() => completedGames({...data, season: {year: RATING_SEASON - 1}}, 'a'), /not for/);
});

test('equal records earn more stars against stronger opposition', () => {
  const record = parseRecord('1-0');
  const games = [game('b')];
  const weak = calculateTeamRating(record, games, records([['b', '1-9']]));
  const strong = calculateTeamRating(record, games, records([['b', '8-2']]));
  assert.ok(strong.stars > weak.stars);
  assert.equal(strong.strongGames, 1);
  assert.equal(weak.strongGames, 0);
  assert.equal(weak.strongPerformance, 0.5);
  assert.ok(strong.stars <= 5 && weak.stars >= 1);
});

test('opponent strength excludes all head-to-head games, including rematches', () => {
  const result = calculateTeamRating(parseRecord('1-1'), [game('b', 1), game('b', 0, -7)], records([['b', '3-2']]));
  assert.equal(result.opponentWinPct, 2 / 3);
  assert.equal(result.strongGames, 2);
  assert.equal(result.strongWins, 1);
  assert.equal(result.strongLosses, 1);
});

test('strong opponents require three other games; no other games is neutral', () => {
  const early = calculateTeamRating(parseRecord('1-0'), [game('b')], records([['b', '2-1']]));
  assert.equal(early.strongGames, 0);
  const first = calculateTeamRating(parseRecord('1-0'), [game('b')], records([['b', '0-1']]));
  assert.equal(first.opponentWinPct, 0.5);
  assert.equal(first.strongPerformance, 0.5);
});

test('wins and close losses against strong teams improve performance, and margin is capped', () => {
  const opposition = records([['b', '9-1'], ['c', '1-9']]);
  const record = parseRecord('1-1');
  const strongWin = calculateTeamRating(record, [game('b', 1), game('c', 0, -7)], opposition);
  const strongLoss = calculateTeamRating(record, [game('b', 0, -7), game('c', 1)], opposition);
  assert.ok(strongWin.stars > strongLoss.stars);
  const close = calculateTeamRating(parseRecord('0-1'), [game('b', 0, -1)], opposition);
  const big = calculateTeamRating(parseRecord('0-1'), [game('b', 0, -21)], opposition);
  const huge = calculateTeamRating(parseRecord('0-1'), [game('b', 0, -70)], opposition);
  assert.ok(close.strongPerformance > big.strongPerformance);
  assert.equal(big.stars, huge.stars);
  assert.match(describeRating(strongWin, record), /Against strong opponents: 1-0/);
});

test('ties count as half a win; missing and inconsistent data never receive invented stars', () => {
  const result = calculateTeamRating(parseRecord('0-0-1'), [game('b', 0.5, 0)], records([['b', '3-0-1']]));
  assert.equal(result.winPct, 0.5);
  assert.equal(result.strongPerformance, 0.5);
  assert.equal(calculateTeamRating(parseRecord('1-0'), [], new Map()), null);
  assert.equal(calculateTeamRating(parseRecord('1-0'), [game('missing')], new Map()), null);
  assert.equal(calculateTeamRating(parseRecord('0-1'), [game('b')], records([['b', '3-1']])), null);
  assert.equal(calculateTeamRating(parseRecord('0-0'), [], new Map()), null);
  assert.equal(calculateTeamRating(parseRecord('1-0'), [game('b')], records([['b', '3-0']])), null);
});

test('live loader includes FCS records, caches complete ratings, and refreshes on request', async () => {
  const entries = new Map();
  const storage = {getItem: key => entries.get(key) ?? null, setItem: (key, value) => entries.set(key, value)};
  let requests = 0;
  const fetchImpl = async url => {
    requests++;
    const parsed = new URL(url);
    const data = parsed.pathname.endsWith('/standings')
      ? standings(parsed.searchParams.get('group') === '80' ? [['a', '1-0']] : [['fcs', '3-1']])
      : {season: {year: RATING_SEASON}, events: [event('g', 'a', 'fcs', 21, 14)]};
    return Response.json(data);
  };
  const updates = [];
  const onUpdate = data => updates.push({...data});
  await loadRatings(['a'], {fetchImpl, storage, onUpdate, now: 100000});
  assert.equal(requests, 3);
  assert.equal(updates.at(-1).ratings.get('a').strongGames, 1);
  assert.ok(entries.has(RATINGS_CACHE_KEY));
  await loadRatings(['a'], {fetchImpl, storage, onUpdate, now: 100001});
  assert.equal(requests, 3, 'fresh cache avoids all network requests');
  assert.equal(updates.at(-1).updatedAt, 100000);
  await loadRatings(['a'], {fetchImpl, storage, now: 100002, force: true});
  assert.equal(requests, 6, 'Refresh ratings bypasses the cache');
  await loadRatings(['a'], {fetchImpl, storage, now: 100002 + 3600001});
  assert.equal(requests, 9, 'hour-old data is fetched again');
});

test('failed schedules are unavailable, cannot poison the cache, and do not block other teams', async () => {
  let last;
  const storage = {getItem: () => null, setItem: () => assert.fail('incomplete data must not be cached')};
  const fetchImpl = async url => {
    if (url.includes('/standings')) return Response.json(standings([['a', '1-0'], ['b', '0-0'], ['c', '4-1']]));
    return new Response('unavailable', {status: 503});
  };
  await loadRatings(['a', 'b'], {fetchImpl, storage, onUpdate: data => last = data});
  assert.equal(last.completed, 2);
  assert.equal(last.failures, 1);
  assert.equal(last.ratings.get('a'), null);
  assert.equal(last.records.get('b').played, 0);
});

test('postseason is merged once; blocked browser storage does not prevent live ratings', async () => {
  const storage = {getItem() { throw new Error('blocked'); }, setItem() { throw new Error('blocked'); }};
  let last;
  const fetchImpl = async url => {
    if (url.includes('/standings')) return Response.json(standings([['a', '2-0'], ['b', '4-1'], ['c', '3-1']]));
    const regular = event('reg', 'a', 'b', 28, 21);
    const events = url.includes('seasontype=3') ? [regular, event('bowl', 'a', 'c', 21, 14)] : [regular];
    return Response.json({season: {year: RATING_SEASON}, events});
  };
  await loadRatings(['a'], {fetchImpl, storage, onUpdate: data => last = data});
  assert.equal(last.failures, 0);
  assert.equal(last.ratings.get('a').strongGames, 2);
});
