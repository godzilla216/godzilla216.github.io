import {API_BASE_URL} from './config.js';
import {createPollApi} from './api.js';
import {loadRatings, describeRating, RATING_SEASON} from './ratings.js';

const read = createPollApi({apiBaseUrl: API_BASE_URL});
const el = id => document.getElementById(id);
const search = el('search');
const conference = el('conference');
const status = el('status');
const submit = el('submit');
const ranks = el('ranks');
let drag = null;
let teams = [];
let byId = new Map();
let ballot = [];
let saved = [];
let ready = false;
let saving = false;
let resultsRequest = 0;

let teamRecords = new Map();
let teamRatings = new Map();
let ratingsLoading = true;

function ratingDescription(id) {
  const rating = teamRatings.get(id);
  if (rating) return describeRating(rating, teamRecords.get(id));
  if (ratingsLoading && !teamRatings.has(id)) return 'Star rating loading';
  return teamRecords.get(id)?.played === 0 ? 'Not rated: no completed games' : 'Star rating unavailable';
}

function paintRating(badge) {
  const id = badge.dataset.ratingFor;
  const description = ratingDescription(id);
  if (badge.dataset.ratingState === description) return;
  badge.dataset.ratingState = description;
  badge.title = description;
  badge.setAttribute('aria-label', description);
  const rating = teamRatings.get(id);
  badge.classList.toggle('rating-pending', !rating);
  if (rating) {
    const stars = node('span', 'rating-stars');
    stars.setAttribute('aria-hidden', 'true');
    stars.append(node('span', 'rating-empty', '\u2605\u2605\u2605\u2605\u2605'),
      node('span', 'rating-filled', '\u2605\u2605\u2605\u2605\u2605'));
    stars.style.setProperty('--rating-fill', rating.stars / 5 * 100 + '%');
    const number = node('span', 'rating-number', rating.stars.toFixed(1) + '/5');
    number.setAttribute('aria-hidden', 'true');
    badge.replaceChildren(stars, number);
  } else {
    badge.textContent = ratingsLoading && !teamRatings.has(id) ? 'Rating loading\u2026'
      : teamRecords.get(id)?.played === 0 ? 'Not rated yet' : 'Rating unavailable';
  }
  const choice = badge.closest('.team-choice');
  if (choice) choice.setAttribute('aria-label', 'Add ' + byId.get(id).name + '. ' + description);
}

function updateTeamBadges() {
  for (const badge of document.querySelectorAll('[data-record-for]')) {
    const record = teamRecords.get(badge.dataset.recordFor);
    badge.textContent = record ? ' (' + record.summary + ')' : '';
  }
  for (const badge of document.querySelectorAll('[data-rating-for]')) paintRating(badge);
}

async function refreshTeamRatings(force = false) {
  ratingsLoading = true;
  teamRatings = new Map();
  el('refresh-ratings').disabled = true;
  el('ratings-status').textContent = 'Loading ' + RATING_SEASON + ' records and game results\u2026';
  updateTeamBadges();
  try {
    await loadRatings(teams.map(team => team.id), {force, readData(url) {
      const source = new URL(url);
      const teamId = source.pathname.match(/\/teams\/([^/]+)\/schedule$/)?.[1];
      const query = new URLSearchParams(teamId
        ? {team: teamId, seasontype: source.searchParams.get('seasontype')}
        : {group: source.searchParams.get('group')});
      if (force) query.set('refresh', '1');
      return read('/api/ratings-data/' + (teamId ? 'schedule' : 'standings') + '?' + query);
    }, onUpdate(data) {
      teamRecords = data.records;
      teamRatings = data.ratings;
      const done = data.completed === data.total;
      ratingsLoading = !done;
      updateTeamBadges();
      const rated = [...teamRatings.values()].filter(Boolean).length;
      el('ratings-status').textContent = done
        ? rated + ' of ' + data.total + ' teams rated \u00b7 Updated ' + new Date(data.updatedAt).toLocaleString() +
          (data.failures ? ' \u00b7 Some results unavailable; try Refresh ratings.' : '')
        : 'Loading game results: ' + data.completed + ' of ' + data.total + ' teams';
    }});
  } catch (error) {
    el('ratings-status').textContent = 'Ratings unavailable. Try Refresh ratings; you can still vote.';
    console.warn('Team ratings unavailable:', error);
  } finally {
    ratingsLoading = false;
    updateTeamBadges();
    el('refresh-ratings').disabled = false;
  }
}

function node(tag, className, content) {
  const item = document.createElement(tag);
  if (className) item.className = className;
  if (content !== undefined) item.textContent = content;
  return item;
}

function button(className, text, label, action, disabled = false) {
  const control = node('button', className, text);
  control.type = 'button';
  control.title = label;
  control.setAttribute('aria-label', label);
  control.disabled = disabled;
  control.addEventListener('click', action);
  return control;
}

function teamInfo(team, subtitle = team.conference) {
  const logo = node('img', 'logo');
  logo.src = './assets/' + team.id + '.webp';
  logo.alt = '';
  logo.loading = 'lazy';
  const label = node('span', 'label');
  const name = node('b', '', team.name);
  const record = node('span', 'team-record', teamRecords.has(team.id) ? ' (' + teamRecords.get(team.id).summary + ')' : '');
  record.dataset.recordFor = team.id;
  record.title = RATING_SEASON + ' overall win-loss record';
  name.append(record);
  label.append(name, node('small', '', subtitle));
  const rating = node('span', 'team-rating');
  rating.dataset.ratingFor = team.id;
  rating.setAttribute('role', 'img');
  paintRating(rating);
  label.append(rating);
  return [logo, label];
}

function normalize(text) {
  return text.normalize('NFD').replace(/[\u0300-\u036fʻ']/g, '').toLowerCase();
}

function showDirectory() {
  const query = normalize(search.value.trim());
  const alreadyPicked = new Set(ballot);
  const visible = teams.filter(team =>
    !alreadyPicked.has(team.id) &&
    (!conference.value || team.conference === conference.value) &&
    normalize([team.name, team.mascot, team.abbr, team.searchName].join(' ')).includes(query)
  );
  const directory = el('team-list');
  el('team-count').textContent = visible.length + (visible.length === 1 ? ' TEAM' : ' TEAMS');
  const rows = visible.map((team, index) => {
    const row = button('team team-choice', '', 'Add ' + team.name + '. ' + ratingDescription(team.id), () => {
      ballot.push(team.id);
      updateBallot();
      const chosen = ranks.children[ballot.length - 1];
      if (chosen.offsetTop + chosen.offsetHeight > ranks.scrollTop + ranks.clientHeight) {
        ranks.scrollTop = chosen.offsetTop + chosen.offsetHeight - ranks.clientHeight;
      }
      if (ballot.length === 25 && !submit.disabled) submit.focus({preventScroll:true});
      else if (ballot.length === 25) ranks.focus({preventScroll:true});
      else (directory.children[Math.min(index, visible.length - 2)] ?? search).focus({preventScroll:true});
      status.textContent = team.name + ' added at No. ' + ballot.length + '. ' + ballotMessage();
    }, ballot.length === 25 || !ready || saving);
    row.dataset.team = team.id;
    const plus = node('span', 'pick', '+');
    plus.setAttribute('aria-hidden', 'true');
    row.append(...teamInfo(team, team.mascot + ' · ' + team.conference), plus);
    return row;
  });
  directory.replaceChildren(...(rows.length ? rows : [node('p', 'empty', 'No available teams match your search.')]));
}

function ballotMessage() {
  if (ballot.length < 25) return 'Choose 25 teams to submit your ballot.';
  if (ballot.join() === saved.join()) return 'Your ballot is saved.';
  return 'Ready to submit. You can edit your ballot later.';
}

function updateBallot(focus) {
  if (drag) endDrag();
  const rows = Array.from({length: 25}, (_, index) => {
    const id = ballot[index];
    const row = node('div', id ? 'rank' : 'rank slot');
    row.append(node('span', 'position', index + 1));
    if (!id) {
      row.append(node('span', '', 'Select a team'));
      return row;
    }
    const team = byId.get(id);
    const controls = node('div', 'rank-controls');
    const move = (change, control) => {
      const next = index + change;
      [ballot[index], ballot[next]] = [ballot[next], ballot[index]];
      updateBallot({index: next, control});
      status.textContent = team.name + ' moved to No. ' + (next + 1) + '.';
    };
    controls.append(
      button('rank-button', '↑', 'Move ' + team.name + ' up', () => move(-1, 0), index === 0 || saving),
      button('rank-button', '↓', 'Move ' + team.name + ' down', () => move(1, 1), index === ballot.length - 1 || saving),
      button('rank-button', '×', 'Remove ' + team.name, () => {
        ballot.splice(index, 1);
        updateBallot();
        el('team-list').querySelector('[data-team="' + id + '"]')?.focus({preventScroll:true});
        status.textContent = team.name + ' removed. ' + ballotMessage();
      }, saving)
    );
    row.classList.add('draggable-rank');
    if (index < 12) row.classList.add('playoff-rank');
    if (index === 12 || index === 13) row.classList.add('teams-out');
    row.addEventListener('pointerdown', event => {
      if (!event.target.closest('.rank-controls')) startDrag(event, row, index);
    });
    const subtitle = team.conference + (index < 12 ? ' · Seed ' + (index + 1) + (index < 4 ? ' · Bye' : '') : index === 12 ? ' · First team out' : index === 13 ? ' · Second team out' : '');
    row.append(...teamInfo(team, subtitle), controls);
    return row;
  });
  ranks.replaceChildren(...rows);
  if (focus) {
    const controls = rows[focus.index].querySelectorAll('button');
    const control = controls[focus.control];
    (control.disabled ? controls[1 - focus.control] : control).focus();
  }
  el('progress-count').textContent = ballot.length + ' / 25';
  el('progress').value = ballot.length;
  submit.disabled = !ready || saving || ballot.length !== 25 || ballot.join() === saved.join();
  submit.textContent = saving ? 'Saving…' : saved.length ? 'Update ballot' : 'Submit ballot';
  status.textContent = ballotMessage();
  showDirectory();
}

function startDrag(event, row, index) {
  if (!event.isPrimary || event.button !== 0 || saving || drag) return;
  event.preventDefault();
  row.setPointerCapture(event.pointerId);
  drag = {
    row, pointer: event.pointerId, from: index, to: index,
    x: event.clientX, y: event.clientY, frame: 0
  };
  ranks.children[index].classList.add('dragging');
  ranks.classList.add('sorting');
}

function updateDropTarget() {
  const bounds = ranks.getBoundingClientRect();
  const y = Math.min(Math.max(drag.y, bounds.top + 1), bounds.bottom - 1);
  // The target rank follows the pointer as the list scrolls underneath it.
  let target = 0;
  while (target < ballot.length - 1 && y >= ranks.children[target].getBoundingClientRect().bottom) {
    target++;
  }
  ranks.children[drag.to].classList.remove('drop-target');
  drag.to = target;
  if (target !== drag.from) ranks.children[target].classList.add('drop-target');
}

function scrollWhileDragging() {
  if (!drag) return;
  drag.frame = 0;
  const bounds = ranks.getBoundingClientRect();
  if (drag.x < bounds.left - 24 || drag.x > bounds.right + 24) return;
  const edge = 36;
  const delta = drag.y < bounds.top + edge ? -Math.min(15, (bounds.top + edge - drag.y) / 2)
    : drag.y > bounds.bottom - edge ? Math.min(15, (drag.y - bounds.bottom + edge) / 2) : 0;
  const before = ranks.scrollTop;
  ranks.scrollTop += delta;
  updateDropTarget();
  if (ranks.scrollTop !== before) drag.frame = requestAnimationFrame(scrollWhileDragging);
}

function endDrag() {
  const previous = drag;
  drag = null;
  cancelAnimationFrame(previous.frame);
  ranks.children[previous.from].classList.remove('dragging');
  ranks.children[previous.to].classList.remove('drop-target');
  ranks.classList.remove('sorting');
  if (previous.row.hasPointerCapture(previous.pointer)) previous.row.releasePointerCapture(previous.pointer);
  return previous;
}

ranks.addEventListener('pointermove', event => {
  if (drag?.pointer !== event.pointerId) return;
  drag.x = event.clientX;
  drag.y = event.clientY;
  updateDropTarget();
  if (!drag.frame) drag.frame = requestAnimationFrame(scrollWhileDragging);
});

ranks.addEventListener('pointerup', event => {
  if (drag?.pointer !== event.pointerId) return;
  const bounds = ranks.getBoundingClientRect();
  drag.y = event.clientY;
  updateDropTarget();
  const {from, to} = endDrag();
  if (from === to || event.clientX < bounds.left || event.clientX > bounds.right ||
      event.clientY < bounds.top - 24 || event.clientY > bounds.bottom + 24) return;
  const [teamId] = ballot.splice(from, 1);
  ballot.splice(to, 0, teamId);
  updateBallot();
  status.textContent = byId.get(teamId).name + ' moved to No. ' + (to + 1) + '.';
});

for (const type of ['pointercancel', 'lostpointercapture']) {
  ranks.addEventListener(type, event => {
    if (drag?.pointer === event.pointerId) endDrag();
  });
}

function seedBadge(seed) {
  const badge = node('span', 'seed-badge' + (seed <= 4 ? ' bye-badge' : ''), 'SEED ' + seed);
  badge.title = seed <= 4 ? 'First-round bye' : 'First-round matchup';
  return badge;
}

function showRankings(data) {
  const rows = data.rankings.map((entry, index) => {
    const seed = index + 1;
    const row = node('div', 'team' + (seed <= 12 ? ' playoff-team' : '') + (seed === 12 ? ' playoff-cutoff' : ''));
    if (seed === 13 || seed === 14) row.classList.add('teams-out');
    const points = node('span', 'points', entry.points + ' ');
    points.append(node('small', '', entry.points === 1 ? 'pt' : 'pts'));
    const firsts = entry.firsts ? ' · ' + entry.firsts + ' first-place ' + (entry.firsts === 1 ? 'vote' : 'votes') : '';
    const team = byId.get(entry.id);
    row.append(node('span', 'position', seed), ...teamInfo(team, team.conference + firsts));
    if (seed <= 12) row.append(seedBadge(seed));
    if (seed === 13 || seed === 14) row.append(node('span', 'seed-badge out-badge', seed === 13 ? 'First team out' : 'Second team out'));
    row.append(points);
    return row;
  });
  el('leaderboard').replaceChildren(...(rows.length ? rows : [node('p', 'empty', 'The fan rankings will appear after the first ballot is submitted.')]));
}

function showPlayoff(data) {
  const board = el('playoff-board');
  if (!data.rankings.length) {
    board.replaceChildren(node('p', 'card empty', 'The playoff bracket will appear after the first ballot is submitted.'));
    return;
  }
  const field = data.rankings.slice(0, 12);
  const slot = (seed, placeholder) => {
    const team = seed && field[seed - 1] ? byId.get(field[seed - 1].id) : null;
    const row = node('div', 'bracket-team' + (!team ? ' bracket-placeholder' : '') + (seed && seed <= 4 ? ' bracket-bye' : ''));
    if (team) {
      row.append(...teamInfo(team, seed <= 4 ? 'First-round bye' : team.conference));
    } else {
      row.append(node('span', 'bracket-placeholder-label', seed ? 'Awaiting No. ' + seed : placeholder));
    }
    row.append(node('span', 'bracket-seed', seed || '—'));
    return row;
  };
  const game = (label, slots) => {
    const match = node('div', 'bracket-game');
    match.setAttribute('role', 'group');
    match.setAttribute('aria-label', label);
    match.append(...slots);
    return match;
  };
  const round = (title, subtitle, className, games) => {
    const column = node('section', 'bracket-round ' + className);
    const heading = node('div', 'round-heading');
    heading.append(node('h3', '', title), node('p', '', subtitle));
    const matches = node('div', 'round-matches');
    matches.append(...games);
    column.append(heading, matches);
    return column;
  };
  // Keep the same fixed paths as the reference; there is no reseeding between rounds.
  const paths = [[8, 9, 1], [5, 12, 4], [6, 11, 3], [7, 10, 2]];
  const bracket = node('div', 'bracket-grid');
  bracket.append(
    round('First round', 'Seeds 5–8 host', 'first-round', paths.map(([a, b]) =>
      game('First round: seed ' + a + ' vs. seed ' + b, [slot(a), slot(b)]))),
    round('Quarterfinals', 'Top four enter', 'quarterfinals', paths.map(([a, b, bye]) =>
      game('Quarterfinal: seed ' + bye + ' vs. winner of ' + a + ' / ' + b, [slot(bye), slot(null, 'Winner ' + a + ' / ' + b)]))),
    round('Semifinals', 'The final four', 'semifinals', [
      game('Semifinal 1: winners of quarterfinals 1 and 2', [slot(null, 'Winner QF 1'), slot(null, 'Winner QF 2')]),
      game('Semifinal 2: winners of quarterfinals 3 and 4', [slot(null, 'Winner QF 3'), slot(null, 'Winner QF 4')])
    ]),
    round('Championship', 'For the national title', 'championship', [
      game('National championship: semifinal winners', [slot(null, 'Winner SF 1'), slot(null, 'Winner SF 2')])
    ])
  );
  const scroll = node('div', 'bracket-scroll');
  scroll.tabIndex = 0;
  scroll.setAttribute('role', 'region');
  scroll.setAttribute('aria-label', '12-team playoff bracket. Scroll horizontally to see every round.');
  scroll.append(bracket);
  const heading = node('div', 'bracket-banner');
  const title = node('div');
  title.append(node('p', 'eyebrow', 'FAN POLL PLAYOFF'), node('h3', '', '12 teams. One champion.'));
  heading.append(title, node('span', 'bracket-projection', 'PROJECTED FIELD'));
  const card = node('div', 'playoff-card');
  card.append(heading, scroll, node('p', 'bracket-note', 'Seeds are based only on fan-poll order. Later-round teams are determined by game results. Scroll to explore all rounds on smaller screens.'));
  board.replaceChildren(card);
}

async function view(selected) {
  const request = ++resultsRequest;
  for (const name of ['ballot', 'results', 'playoff']) {
    const active = name === selected;
    el(name + '-view').hidden = !active;
    const tab = el(name + '-tab');
    tab.classList.toggle('active', active);
    tab.setAttribute('aria-pressed', active);
  }
  if (drag) endDrag();
  if (selected === 'ballot') return;
  const board = el(selected === 'results' ? 'leaderboard' : 'playoff-board');
  const count = el(selected === 'results' ? 'voter-count' : 'playoff-voter-count');
  count.textContent = '';
  board.replaceChildren(node('p', 'empty', selected === 'results' ? 'Loading fan rankings…' : 'Loading playoff bracket…'));
  try {
    const [data] = await Promise.all([read('/api/rankings'), initializedTeams]);
    if (request !== resultsRequest) return;
    count.textContent = data.count + (data.count === 1 ? ' BALLOT' : ' BALLOTS');
    if (selected === 'results') showRankings(data);
    else showPlayoff(data);
  } catch (error) {
    if (request === resultsRequest) board.replaceChildren(node('p', 'empty', error.message));
  }
}

search.addEventListener('input', showDirectory);
conference.addEventListener('change', showDirectory);
el('ballot-tab').addEventListener('click', () => view('ballot'));
el('results-tab').addEventListener('click', () => view('results'));
el('playoff-tab').addEventListener('click', () => view('playoff'));
submit.addEventListener('click', async () => {
  saving = true;
  updateBallot();
  let message;
  try {
    const data = await read('/api/ballot', {
      method: 'PUT',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({teams: ballot})
    });
    saved = data.teams.slice();
    message = 'Ballot saved. See the updated Fan Rankings.';
  } catch (error) {
    message = error.message;
  } finally {
    saving = false;
    updateBallot();
    status.textContent = message;
  }
});

const initializedTeams = read('./teams.json').then(data => {
  teams = data;
  byId = new Map(data.map(team => [team.id, team]));
  const conferences = [...new Set(data.map(team => team.conference))].sort();
  for (const name of conferences) conference.add(new Option(name, name));
});

// Ratings load independently and never delay ballot editing or fan rankings.
el('refresh-ratings').addEventListener('click', () => void refreshTeamRatings(true));
void initializedTeams.then(() => refreshTeamRatings()).catch(() => {
  el('ratings-status').textContent = 'Ratings unavailable: the team directory could not be loaded.';
});

try {
  const [, current] = await Promise.all([initializedTeams, read('/api/ballot')]);
  ballot = current.teams.slice();
  saved = current.teams.slice();
  ready = true;
  updateBallot();
} catch (error) {
  if (teams.length) showDirectory();
  else el('team-list').replaceChildren(node('p', 'empty', 'Could not load the team directory.'));
  status.textContent = error.message;
}
