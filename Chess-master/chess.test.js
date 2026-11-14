/* Run with: node --test chess.test.js */
const { test } = require('node:test');
const assert = require('node:assert/strict');
const Chess = require('./chess.js');

function perft(game, depth) {
  if (!depth) return 1;
  let count = 0;
  for (const move of game.legalMoves()) {
    const before = game.snapshot(); game.apply(move);
    count += perft(game, depth - 1); game.restore(before);
  }
  return count;
}
function play(game, moves) {
  for (const move of moves.split(' ')) assert.ok(game.move(move.slice(0, 2), move.slice(2, 4), move[4] || 'q'), move);
}
test('initial position: standard perft counts through depth four', () => {
  const game = new Chess();
  for (const [depth, nodes] of [[1,20],[2,400],[3,8902],[4,197281]]) assert.equal(perft(game, depth), nodes);
  assert.equal(game.fen(), Chess.START);
});
test('Kiwipete: castling and tactical legality through depth three', () => {
  const game = new Chess('r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1');
  for (const [depth, nodes] of [[1,48],[2,2039],[3,97862]]) assert.equal(perft(game, depth), nodes);
});
test('en passant and rook endgame perft', () => {
  const game = new Chess('8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1');
  assert.equal(perft(game, 3), 2812);
});
test('checkmate, legal-move rejection, and full undo', () => {
  const game = new Chess(); assert.equal(game.move('e2','e5'), null);
  play(game, 'f2f3 e7e5 g2g4 d8h4');
  assert.equal(game.history.at(-1).san, 'Qh4#');
  assert.equal(game.status().reason, 'checkmate'); assert.equal(game.status().winner, 'b');
  while (game.history.length) game.undo();
  assert.equal(game.fen(), Chess.START); assert.equal(game.positions.length, 1);
});
test('castling moves rook, changes rights, and undoes correctly', () => {
  const fen = 'r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1', game = new Chess(fen);
  assert.equal(game.move('e1','g1').san, 'O-O');
  assert.equal(game.board[Chess.index('f1')], 'R'); assert.equal(game.castle, 'kq');
  game.undo(); assert.equal(game.fen(), fen);
  const throughCheck = new Chess('r3k2r/8/8/8/8/5r2/8/R3K2R w KQkq - 0 1');
  assert.equal(throughCheck.move('e1','g1'), null);
});
test('en passant captures and cannot expose own king', () => {
  const game = new Chess(); play(game, 'e2e4 a7a6 e4e5 d7d5');
  assert.equal(game.move('e5','d6').san, 'exd6'); assert.equal(game.board[Chess.index('d5')], null);
  game.undo(); assert.equal(game.board[Chess.index('d5')], 'p');
  const pinned = new Chess('k3r3/8/8/3pP3/8/8/8/4K3 w - d6 0 1');
  assert.equal(pinned.move('e5','d6'), null);
});
test('all four promotions and underpromotion', () => {
  const game = new Chess('7k/P7/8/8/8/8/8/7K w - - 0 1');
  assert.equal(game.legalMoves(Chess.index('a7')).length, 4);
  assert.equal(game.move('a7','a8','n').san, 'a8=N');
  assert.equal(game.board[0], 'N'); assert.equal(game.status().reason, 'insufficient material');
});
test('draws: stalemate, material, fifty moves, repetition and undo', () => {
  assert.equal(new Chess('7k/5Q2/6K1/8/8/8/8/8 b - - 0 1').status().reason, 'stalemate');
  assert.equal(new Chess('7k/8/8/8/8/8/8/K7 w - - 0 1').status().reason, 'insufficient material');
  assert.equal(new Chess('7k/8/8/8/8/8/8/KR6 w - - 100 1').status().reason, '50-move rule');
  const game = new Chess(); play(game, 'g1f3 g8f6 f3g1 f6g8 g1f3 g8f6 f3g1 f6g8');
  assert.equal(game.status().reason, 'threefold repetition'); game.undo(); assert.equal(game.status().over, false);
});
test('SAN distinguishes knights that share a destination', () => {
  const game = new Chess('7k/8/8/8/8/8/8/1N2KN2 w - - 0 1');
  assert.equal(game.move('b1','d2').san, 'Nbd2');
});
