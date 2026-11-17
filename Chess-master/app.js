/* The Chess Room — local, two-player play. No account or server required. */
'use strict';
const $ = id => document.getElementById(id);
const glyphs = { k: '♚', q: '♛', r: '♜', b: '♝', n: '♞', p: '♟' };
const names = { k: 'king', q: 'queen', r: 'rook', b: 'bishop', n: 'knight', p: 'pawn' };
const sideName = side => side === 'w' ? 'White' : 'Black';
const storageKey = 'the-chess-room-v1';
let game = new Chess(), flipped = false, selected = null, targets = [], pendingPromotion = null, focusSquare = 60;

function save() {
  try { localStorage.setItem(storageKey, JSON.stringify({ flipped, moves: game.history.map(m => [m.from, m.to, m.promotion || 'q']) })); }
  catch { /* Play remains available when browser storage is disabled. */ }
}
function load() {
  try {
    const data = JSON.parse(localStorage.getItem(storageKey));
    if (!data || !Array.isArray(data.moves)) return;
    const restored = new Chess();
    for (const m of data.moves) {
      if (!Array.isArray(m) || m.length !== 3 || restored.status().over || !restored.move(...m)) return;
    }
    game = restored; flipped = data.flipped === true;
  } catch { /* A damaged or unavailable save starts a fresh board. */ }
}
function pieceMarkup(piece) {
  return `<span class="piece ${Chess.color(piece) === 'w' ? 'white' : 'black'}" aria-hidden="true">${glyphs[piece.toLowerCase()]}</span>`;
}
function renderPlayer(element, side, state) {
  const captured = game.history.filter(m => Chess.color(m.piece) === side && m.captured).map(m => m.captured);
  const active = game.turn === side && !state.over;
  element.innerHTML = `<span class="player-avatar ${side === 'w' ? 'white' : ''}" aria-hidden="true">${side === 'w' ? '♙' : '♟'}</span><div><div class="player-name">${sideName(side)}</div><div class="player-subtitle">${side === 'w' ? 'The opening move' : 'A worthy opponent'}</div></div><div class="captured" aria-label="${captured.length} pieces captured">${captured.map(p => glyphs[p.toLowerCase()]).join('')}</div>${active ? '<span class="player-active">TO MOVE</span>' : ''}`;
}
function render() {
  const keepFocus = $('board').contains(document.activeElement);
  const state = game.status(), last = game.history.at(-1);
  const checkedKing = state.check ? game.board.indexOf(game.turn === 'w' ? 'K' : 'k') : -1;
  const squares = [];
  for (let visual = 0; visual < 64; visual++) {
    const i = flipped ? 63 - visual : visual, p = game.board[i], legal = targets.some(m => m.to === i);
    const classes = ['square', ((i >> 3) + i % 8) % 2 ? 'dark' : '', selected === i ? 'selected' : '', legal ? 'legal' : '', legal && p ? 'capture' : '', last && (last.from === i || last.to === i) ? 'last' : '', checkedKing === i ? 'in-check' : ''].filter(Boolean).join(' ');
    const label = `${Chess.square(i)}${p ? ', ' + sideName(Chess.color(p)) + ' ' + names[p.toLowerCase()] : ', empty'}${legal ? ', legal move' : ''}${checkedKing === i ? ', in check' : ''}`;
    squares.push(`<button class="${classes}" data-square="${i}" tabindex="${i === focusSquare ? 0 : -1}" aria-label="${label}" aria-pressed="${selected === i}">${p ? pieceMarkup(p) : ''}${visual % 8 === 0 ? `<span class="coordinate rank" aria-hidden="true">${Chess.square(i)[1]}</span>` : ''}${visual >= 56 ? `<span class="coordinate file" aria-hidden="true">${Chess.square(i)[0]}</span>` : ''}</button>`);
  }
  $('board').innerHTML = squares.join('');
  if (keepFocus) $('board').querySelector(`[data-square="${focusSquare}"]`).focus({ preventScroll: true });
  renderPlayer($('top-player'), flipped ? 'w' : 'b', state);
  renderPlayer($('bottom-player'), flipped ? 'b' : 'w', state);
  $('turn-indicator').className = 'turn-indicator' + (state.over ? ' ended' : game.turn === 'b' ? ' black' : '');
  if (state.over) {
    $('status').textContent = state.winner ? `${sideName(state.winner)} wins!` : 'A drawn game';
    $('status-detail').textContent = state.reason === 'checkmate' ? 'Checkmate. Well played — ready for a rematch?' : `Draw by ${state.reason}. A good game, evenly matched.`;
  } else {
    $('status').textContent = `${sideName(game.turn)} to move${state.check ? ' · Check' : ''}`;
    $('status-detail').textContent = state.check ? 'Your king is under attack. Find a safe way out.' : game.history.length ? 'The board is yours. Make it a good one.' : 'Every great game starts with a single move.';
  }
  $('undo').disabled = !game.history.length;
  $('move-count').textContent = `${game.history.length} PLAYED`;
  if (!game.history.length) {
    $('moves').innerHTML = '<div class="empty-moves"><span aria-hidden="true">♙</span><p>A clean slate.</p><small>Your story starts with the first move.</small></div>';
  } else {
    const rows = [];
    for (let i = 0; i < game.history.length; i += 2) {
      rows.push(`<div class="move-row"><span>${i / 2 + 1}.</span><span class="${i === game.history.length - 1 ? 'latest' : ''}">${game.history[i].san}</span><span class="${i + 1 === game.history.length - 1 ? 'latest' : ''}">${game.history[i + 1]?.san || ''}</span></div>`);
    }
    $('moves').innerHTML = rows.join('');
    $('moves').scrollTop = $('moves').scrollHeight;
  }
}
function clearSelection() { selected = null; targets = []; }
function makeMove(to, promotion = 'q') {
  if (game.move(selected, to, promotion)) { clearSelection(); focusSquare = to; save(); render(); }
}
function selectSquare(i) {
  if (game.status().over) return;
  focusSquare = i;
  const matching = targets.filter(m => m.to === i);
  if (selected !== null && matching.length) {
    if (matching[0].promotion) {
      pendingPromotion = i;
      $('promotion-options').innerHTML = ['q', 'r', 'b', 'n'].map(type => `<button data-promotion="${type}" aria-label="Promote to ${names[type]}">${pieceMarkup(game.turn === 'w' ? type.toUpperCase() : type)}<small>${names[type][0].toUpperCase() + names[type].slice(1)}</small></button>`).join('');
      $('promotion-dialog').showModal();
    } else makeMove(i);
    return;
  }
  if (selected === i) clearSelection();
  else if (Chess.color(game.board[i]) === game.turn) { selected = i; targets = game.legalMoves(i); }
  else clearSelection();
  render();
}
$('board').addEventListener('click', event => {
  const button = event.target.closest('[data-square]');
  if (button) selectSquare(Number(button.dataset.square));
});
$('board').addEventListener('keydown', event => {
  if (event.key === 'Escape') { clearSelection(); render(); return; }
  const directions = { ArrowUp: [-1, 0], ArrowDown: [1, 0], ArrowLeft: [0, -1], ArrowRight: [0, 1] };
  if (!directions[event.key]) return;
  event.preventDefault();
  const visual = flipped ? 63 - focusSquare : focusSquare, [dr, dc] = directions[event.key];
  const r = Math.max(0, Math.min(7, (visual >> 3) + dr)), c = Math.max(0, Math.min(7, visual % 8 + dc));
  focusSquare = flipped ? 63 - (r * 8 + c) : r * 8 + c;
  $('board').querySelectorAll('[data-square]').forEach(b => b.tabIndex = Number(b.dataset.square) === focusSquare ? 0 : -1);
  $('board').querySelector(`[data-square="${focusSquare}"]`).focus();
});
$('promotion-options').addEventListener('click', event => {
  const button = event.target.closest('[data-promotion]');
  if (!button || pendingPromotion === null) return;
  const to = pendingPromotion; pendingPromotion = null;
  $('promotion-dialog').close(); makeMove(to, button.dataset.promotion);
  $('board').querySelector(`[data-square="${focusSquare}"]`).focus();
});
$('promotion-dialog').addEventListener('cancel', () => { pendingPromotion = null; clearSelection(); render(); });
$('undo').addEventListener('click', () => { const move = game.undo(); if (move) focusSquare = move.from; clearSelection(); save(); render(); });
$('flip').addEventListener('click', () => { flipped = !flipped; save(); render(); });
function newGame() { game = new Chess(); clearSelection(); focusSquare = flipped ? 4 : 60; save(); render(); }
$('new-game').addEventListener('click', () => { if (game.history.length && !game.status().over) $('new-game-dialog').showModal(); else newGame(); });
$('cancel-new').addEventListener('click', () => $('new-game-dialog').close());
$('confirm-new').addEventListener('click', () => { $('new-game-dialog').close(); newGame(); });
$('rules-button').addEventListener('click', () => $('rules-dialog').showModal());
$('close-rules').addEventListener('click', () => $('rules-dialog').close());
load(); render();
