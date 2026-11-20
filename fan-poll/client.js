import {API_BASE_URL} from './config.js';
import {createPollApi} from './api.js';

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
  label.append(node('b', '', team.name), node('small', '', subtitle));
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
    const row = button('team team-choice', '', 'Add ' + team.name, () => {
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
    row.addEventListener('pointerdown', event => {
      if (!event.target.closest('.rank-controls')) startDrag(event, row, index);
    });
    row.append(...teamInfo(team), controls);
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

async function view(results) {
  el('ballot-view').hidden = results;
  el('results-view').hidden = !results;
  for (const [id, active] of [['ballot-tab', !results], ['results-tab', results]]) {
    const tab = el(id);
    tab.classList.toggle('active', active);
    tab.setAttribute('aria-pressed', active);
  }
  if (drag) endDrag();
  if (!results) return;
  const request = ++resultsRequest;
  const board = el('leaderboard');
  el('voter-count').textContent = '';
  board.replaceChildren(node('p', 'empty', 'Loading fan rankings…'));
  try {
    const [data] = await Promise.all([read('/api/rankings'), initializedTeams]);
    if (request !== resultsRequest) return;
    el('voter-count').textContent = data.count + (data.count === 1 ? ' BALLOT' : ' BALLOTS');
    const rows = data.rankings.map((entry, index) => {
      const row = node('div', 'team');
      const points = node('span', 'points', entry.points + ' ');
      points.append(node('small', '', entry.points === 1 ? 'pt' : 'pts'));
      const firsts = entry.firsts ? ' · ' + entry.firsts + ' first-place ' + (entry.firsts === 1 ? 'vote' : 'votes') : '';
      const team = byId.get(entry.id);
      row.append(node('span', 'position', index + 1), ...teamInfo(team, team.conference + firsts), points);
      return row;
    });
    board.replaceChildren(...(rows.length ? rows : [node('p', 'empty', 'The fan rankings will appear after the first ballot is submitted.')]));
  } catch (error) {
    if (request === resultsRequest) board.replaceChildren(node('p', 'empty', error.message));
  }
}

search.addEventListener('input', showDirectory);
conference.addEventListener('change', showDirectory);
el('ballot-tab').addEventListener('click', () => view(false));
el('results-tab').addEventListener('click', () => view(true));
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
