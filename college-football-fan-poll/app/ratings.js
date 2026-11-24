export const RATING_SEASON = 2026;
export const RATINGS_CACHE_KEY = 'fan-poll:ratings:' + RATING_SEASON + ':v1';
const CACHE_AGE = 60 * 60 * 1000;
const ROOT = 'https://site.api.espn.com/apis';
const clamp = (value, low, high) => Math.max(low, Math.min(high, value));

export function parseRecord(summary) {
  if (typeof summary !== 'string' || !/^\d+-\d+(?:-\d+)?$/.test(summary.trim())) return null;
  const [wins, losses, ties = 0] = summary.trim().split('-').map(Number);
  const played = wins + losses + ties;
  return {wins, losses, ties, played, summary: summary.trim()};
}

export function collectRecords(group, records = new Map()) {
  for (const entry of group?.standings?.entries ?? []) {
    const overall = entry.stats?.find(stat => stat.name === 'overall' || stat.type === 'total');
    const record = parseRecord(overall?.displayValue ?? overall?.summary ?? entry.team?.record?.summary);
    if (entry.team?.id != null && record) records.set(String(entry.team.id), record);
  }
  for (const child of group?.children ?? []) collectRecords(child, records);
  return records;
}

export function completedGames(data, teamId) {
  if (Number(data?.season?.year) !== RATING_SEASON || !Array.isArray(data.events)) {
    throw new Error('The schedule is not for the ' + RATING_SEASON + ' season.');
  }
  const games = new Map();
  for (const event of data.events) {
    if (event.season?.year != null && Number(event.season.year) !== RATING_SEASON) continue;
    const competition = event.competitions?.[0];
    if (!competition?.status?.type?.completed) continue;
    const own = competition.competitors?.find(team => String(team.id) === String(teamId));
    const opponent = competition.competitors?.find(team => String(team.id) !== String(teamId));
    const score = value => {
      const raw = value && typeof value === 'object' ? value.value : value;
      return raw === '' || raw == null ? NaN : Number(raw);
    };
    const points = score(own?.score);
    const against = score(opponent?.score);
    if (!own || !opponent || !Number.isFinite(points) || !Number.isFinite(against) || points < 0 || against < 0) continue;
    games.set(String(event.id), {id: String(event.id), opponentId: String(opponent.id),
      result: points > against ? 1 : points < against ? 0 : 0.5, margin: points - against});
  }
  return [...games.values()];
}

// This is an independent resume rating. Fan-poll votes and playoff seeds never enter it.
export function calculateTeamRating(record, games, records) {
  if (!record?.played || !Array.isArray(games) || games.length !== record.played) return null;
  const wins = games.filter(game => game.result === 1).length;
  const losses = games.filter(game => game.result === 0).length;
  if (wins !== record.wins || losses !== record.losses || games.length - wins - losses !== record.ties) return null;

  const meetings = new Map();
  for (const game of games) {
    const totals = meetings.get(game.opponentId) ?? {wins: 0, losses: 0, ties: 0};
    if (game.result === 1) totals.losses++;
    else if (game.result === 0) totals.wins++;
    else totals.ties++;
    meetings.set(game.opponentId, totals);
  }
  const opponents = new Map();
  for (const [id, headToHead] of meetings) {
    const opponent = records.get(id);
    if (!opponent) return null;
    const wins = opponent.wins - headToHead.wins;
    const losses = opponent.losses - headToHead.losses;
    const ties = opponent.ties - headToHead.ties;
    if (Math.min(wins, losses, ties) < 0) return null;
    const played = wins + losses + ties;
    opponents.set(id, {played, winPct: played ? (wins + ties / 2) / played : 0.5});
  }
  const winPct = (record.wins + record.ties / 2) / record.played;
  const opponentWinPct = games.reduce((sum, game) => sum + opponents.get(game.opponentId).winPct, 0) / games.length;
  const strong = games.filter(game => {
    const opponent = opponents.get(game.opponentId);
    return opponent.played >= 3 && opponent.winPct >= 2 / 3;
  });
  const strongWins = strong.filter(game => game.result === 1).length;
  const strongLosses = strong.filter(game => game.result === 0).length;
  const strongTies = strong.length - strongWins - strongLosses;
  const strongWinPct = strong.length ? (strongWins + strongTies / 2) / strong.length : null;
  const strongMargin = strong.length
    ? strong.reduce((sum, game) => sum + clamp(game.margin, -21, 21), 0) / strong.length : null;
  const strongPerformance = strong.length ? 0.75 * strongWinPct + 0.25 * (0.5 + strongMargin / 42) : 0.5;
  const score = 0.5 * winPct + 0.3 * opponentWinPct + 0.2 * strongPerformance;
  return {stars: Math.round(clamp(1 + 4 * score, 1, 5) * 10) / 10,
    winPct, opponentWinPct, strongPerformance, strongGames: strong.length,
    strongWins, strongLosses, strongTies, strongMargin};
}

export function describeRating(rating, record) {
  const strongRecord = rating.strongWins + '-' + rating.strongLosses + (rating.strongTies ? '-' + rating.strongTies : '');
  return rating.stars.toFixed(1) + ' out of 5 stars. Record: ' + record.summary +
    '. Opponents win ' + (rating.opponentWinPct * 100).toFixed(1) + '% of their other games. ' +
    (rating.strongGames ? 'Against strong opponents: ' + strongRecord +
      '; average capped scoring margin ' + (rating.strongMargin >= 0 ? '+' : '') + rating.strongMargin.toFixed(1) + '.'
      : 'No strong opponents faced; that component is neutral.');
}

export async function loadRatings(teamIds, {fetchImpl = globalThis.fetch, readData, storage, onUpdate = () => {},
  now = Date.now(), force = false} = {}) {
  const records = new Map();
  const ratings = new Map();
  const schedules = new Map();
  let completed = 0;
  let failures = 0;
  const publish = (updatedAt = now) => onUpdate({records, ratings, completed, total: teamIds.length, failures, updatedAt});
  const cacheStorage = () => storage ?? globalThis.localStorage;
  if (!force) {
    try {
      const cache = JSON.parse(cacheStorage().getItem(RATINGS_CACHE_KEY));
      if (cache?.season === RATING_SEASON && now >= cache.updatedAt && now - cache.updatedAt < CACHE_AGE) {
        const cachedRecords = new Map(cache.records);
        const cachedSchedules = new Map(cache.schedules);
        const cachedRatings = teamIds.map(id => calculateTeamRating(cachedRecords.get(id), cachedSchedules.get(id), cachedRecords));
        if (teamIds.every((id, index) => cachedRecords.get(id)?.played === 0 || cachedRatings[index])) {
          for (const [id, record] of cachedRecords) records.set(id, record);
          teamIds.forEach((id, index) => ratings.set(id, cachedRatings[index]));
          completed = teamIds.length;
          publish(cache.updatedAt);
          return;
        }
      }
    } catch { /* Storage is optional; blocked or outdated caches do not prevent live ratings. */ }
  }
  const get = readData ?? (async url => {
    const response = await fetchImpl(url, {signal: AbortSignal.timeout(15000)});
    if (!response.ok) throw new Error('ESPN data returned HTTP ' + response.status);
    return response.json();
  });
  const standings = await Promise.allSettled([80, 81].map(group =>
    get(ROOT + '/v2/sports/football/college-football/standings?season=' + RATING_SEASON + '&group=' + group)));
  if (standings[0].status !== 'fulfilled' || Number(standings[0].value.season?.year) !== RATING_SEASON) {
    throw new Error('Season records are unavailable.');
  }
  for (const result of standings) {
    if (result.status === 'fulfilled' && Number(result.value.season?.year) === RATING_SEASON) collectRecords(result.value, records);
  }
  if (!records.size) throw new Error('Season records are unavailable.');
  publish();
  let next = 0;
  await Promise.all(Array.from({length: Math.min(6, teamIds.length)}, async () => {
    while (next < teamIds.length) {
      const id = teamIds[next++];
      try {
        const record = records.get(id);
        if (!record) throw new Error('Missing team record.');
        let games = [];
        const url = ROOT + '/site/v2/sports/football/college-football/teams/' + encodeURIComponent(id) +
          '/schedule?season=' + RATING_SEASON;
        if (record.played) {
          games = completedGames(await get(url + '&seasontype=2'), id);
          if (games.length < record.played) {
            const postseason = completedGames(await get(url + '&seasontype=3'), id);
            games = [...new Map([...games, ...postseason].map(game => [game.id, game])).values()];
          }
        }
        const rating = calculateTeamRating(record, games, records);
        if (record.played && !rating) throw new Error('Incomplete opponent records or results.');
        schedules.set(id, games);
        ratings.set(id, rating);
      } catch {
        ratings.set(id, null);
        failures++;
      }
      completed++;
      publish();
    }
  }));
  if (!failures) {
    try {
      cacheStorage().setItem(RATINGS_CACHE_KEY, JSON.stringify({season: RATING_SEASON, updatedAt: now,
        records: [...records], schedules: [...schedules]}));
    } catch { /* Voting and ratings also work without persistent browser storage. */ }
  }
}
