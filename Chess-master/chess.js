/* Dependency-free chess rules. Squares run from a8 (0) to h1 (63). */
(function (root) {
  'use strict';
  const START = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  const color = p => p ? (p === p.toUpperCase() ? 'w' : 'b') : null;
  const opposite = c => c === 'w' ? 'b' : 'w';
  const square = i => 'abcdefgh'[i % 8] + (8 - Math.floor(i / 8));
  const index = s => (8 - Number(s[1])) * 8 + 'abcdefgh'.indexOf(s[0]);
  class Chess {
    constructor(fen = START) { this.load(fen); }
    load(fen) {
      const [layout, turn, castle, ep, half, full] = fen.split(' ');
      this.board = [];
      for (const c of layout.replaceAll('/', '')) {
        if (/\d/.test(c)) this.board.push(...Array(Number(c)).fill(null));
        else this.board.push(c);
      }
      this.turn = turn; this.castle = castle === '-' ? '' : castle;
      this.ep = ep === '-' ? -1 : index(ep);
      this.half = Number(half); this.full = Number(full);
      this.history = []; this.positions = [this.key()];
    }
    fen() {
      const rows = [];
      for (let r = 0; r < 8; r++) {
        let row = '', empty = 0;
        for (let c = 0; c < 8; c++) {
          const p = this.board[r * 8 + c];
          if (!p) empty++;
          else { if (empty) row += empty; empty = 0; row += p; }
        }
        if (empty) row += empty;
        rows.push(row);
      }
      return `${rows.join('/')} ${this.turn} ${this.castle || '-'} ${this.ep < 0 ? '-' : square(this.ep)} ${this.half} ${this.full}`;
    }
    key() {
      // An en passant target distinguishes repetitions only if it is legally usable.
      let ep = '-';
      if (this.ep >= 0 && this.legalMoves().some(m => m.enPassant)) ep = square(this.ep);
      return `${this.board.map(p => p || '.').join('')} ${this.turn} ${this.castle} ${ep}`;
    }
    attacked(target, by) {
      const tr = target >> 3, tc = target % 8;
      for (let i = 0; i < 64; i++) {
        const p = this.board[i]; if (color(p) !== by) continue;
        const r = i >> 3, c = i % 8, dr = tr - r, dc = tc - c, type = p.toLowerCase();
        if (type === 'p' && dr === (by === 'w' ? -1 : 1) && Math.abs(dc) === 1) return true;
        if (type === 'n' && Math.abs(dr) * Math.abs(dc) === 2) return true;
        if (type === 'k' && Math.max(Math.abs(dr), Math.abs(dc)) === 1) return true;
        const diagonal = Math.abs(dr) === Math.abs(dc) && dr !== 0;
        const straight = (dr === 0) !== (dc === 0);
        if ((diagonal && 'bq'.includes(type)) || (straight && 'rq'.includes(type))) {
          const sr = Math.sign(dr), sc = Math.sign(dc); let rr = r + sr, cc = c + sc;
          while (rr !== tr || cc !== tc) { if (this.board[rr * 8 + cc]) break; rr += sr; cc += sc; }
          if (rr === tr && cc === tc) return true;
        }
      }
      return false;
    }
    inCheck(side = this.turn) { const king = this.board.indexOf(side === 'w' ? 'K' : 'k'); return king < 0 || this.attacked(king, opposite(side)); }
    pseudoMoves() {
      const moves = [], side = this.turn, enemy = opposite(side);
      const add = (from, to, extra = {}) => {
        const p = this.board[from];
        if (this.board[to]?.toLowerCase() === 'k') return;
        const base = { from, to, piece: p, captured: this.board[to], ...extra };
        if (p.toLowerCase() === 'p' && ((to >> 3) === 0 || (to >> 3) === 7)) {
          for (const promotion of ['q', 'r', 'b', 'n']) moves.push({ ...base, promotion });
        } else moves.push(base);
      };
      for (let from = 0; from < 64; from++) {
        const p = this.board[from]; if (color(p) !== side) continue;
        const r = from >> 3, c = from % 8, type = p.toLowerCase();
        if (type === 'p') {
          const step = side === 'w' ? -1 : 1, next = from + step * 8;
          if (next >= 0 && next < 64 && !this.board[next]) {
            add(from, next);
            if (r === (side === 'w' ? 6 : 1) && !this.board[from + step * 16]) add(from, from + step * 16, { double: true });
          }
          for (const dc of [-1, 1]) {
            const to = next + dc;
            if (c + dc < 0 || c + dc > 7 || to < 0 || to > 63) continue;
            if (color(this.board[to]) === enemy) add(from, to);
            else if (to === this.ep && !this.board[to] && this.board[to - step * 8] === (side === 'w' ? 'p' : 'P')) add(from, to, { enPassant: true, captured: side === 'w' ? 'p' : 'P' });
          }
          continue;
        }
        const directions = type === 'n' ? [[-2,-1],[-2,1],[-1,-2],[-1,2],[1,-2],[1,2],[2,-1],[2,1]]
          : type === 'b' ? [[-1,-1],[-1,1],[1,-1],[1,1]]
          : type === 'r' ? [[-1,0],[1,0],[0,-1],[0,1]]
          : [[-1,-1],[-1,1],[1,-1],[1,1],[-1,0],[1,0],[0,-1],[0,1]];
        for (const [dr, dc] of directions) {
          let rr = r + dr, cc = c + dc;
          while (rr >= 0 && rr < 8 && cc >= 0 && cc < 8) {
            const to = rr * 8 + cc;
            if (color(this.board[to]) === side) break;
            add(from, to);
            if (this.board[to] || type === 'n' || type === 'k') break;
            rr += dr; cc += dc;
          }
        }
        if (type === 'k' && from === (side === 'w' ? 60 : 4) && !this.inCheck(side)) {
          const rook = side === 'w' ? 'R' : 'r';
          for (const kingSide of [true, false]) {
            const right = side === 'w' ? (kingSide ? 'K' : 'Q') : (kingSide ? 'k' : 'q');
            const dir = kingSide ? 1 : -1, rookAt = from + (kingSide ? 3 : -4);
            if (!this.castle.includes(right) || this.board[rookAt] !== rook) continue;
            const clear = (kingSide ? [1, 2] : [-1, -2, -3]).every(d => !this.board[from + d]);
            if (clear && !this.attacked(from + dir, enemy) && !this.attacked(from + 2 * dir, enemy)) add(from, from + 2 * dir, { castling: kingSide ? 'K' : 'Q' });
          }
        }
      }
      return moves;
    }
    snapshot() { return { board: [...this.board], turn: this.turn, castle: this.castle, ep: this.ep, half: this.half, full: this.full }; }
    restore(s) { Object.assign(this, s); }
    apply(m) {
      const side = this.turn, pawn = m.piece.toLowerCase() === 'p';
      this.board[m.from] = null;
      this.board[m.to] = m.promotion ? (side === 'w' ? m.promotion.toUpperCase() : m.promotion) : m.piece;
      if (m.enPassant) this.board[m.to + (side === 'w' ? 8 : -8)] = null;
      if (m.castling) {
        const rookFrom = m.from + (m.castling === 'K' ? 3 : -4), rookTo = m.from + (m.castling === 'K' ? 1 : -1);
        this.board[rookTo] = this.board[rookFrom]; this.board[rookFrom] = null;
      }
      if (m.piece === 'K') this.castle = this.castle.replace(/[KQ]/g, '');
      if (m.piece === 'k') this.castle = this.castle.replace(/[kq]/g, '');
      for (const [pos, right] of [[0,'q'],[7,'k'],[56,'Q'],[63,'K']]) if (m.from === pos || m.to === pos) this.castle = this.castle.replace(right, '');
      this.ep = m.double ? (m.from + m.to) / 2 : -1;
      this.half = pawn || m.captured ? 0 : this.half + 1;
      if (side === 'b') this.full++;
      this.turn = opposite(side);
    }
    legalMoves(from) {
      const side = this.turn, result = [];
      for (const m of this.pseudoMoves()) {
        if (from !== undefined && m.from !== from) continue;
        const before = this.snapshot(); this.apply(m);
        if (!this.inCheck(side)) result.push(m);
        this.restore(before);
      }
      return result;
    }
    move(from, to, promotion = 'q') {
      if (typeof from === 'string') from = index(from);
      if (typeof to === 'string') to = index(to);
      const legal = this.legalMoves(), m = legal.find(m => m.from === from && m.to === to && (!m.promotion || m.promotion === promotion));
      if (!m) return null;
      let san;
      if (m.castling) san = m.castling === 'K' ? 'O-O' : 'O-O-O';
      else {
        const type = m.piece.toUpperCase(); let disambiguate = '';
        if (type !== 'P') {
          const others = legal.filter(x => x.from !== from && x.to === to && x.piece === m.piece);
          if (others.length) disambiguate = others.every(x => x.from % 8 !== from % 8) ? square(from)[0] : others.every(x => (x.from >> 3) !== (from >> 3)) ? square(from)[1] : square(from);
        }
        san = (type === 'P' ? (m.captured ? square(from)[0] : '') : type + disambiguate) + (m.captured ? 'x' : '') + square(to) + (m.promotion ? '=' + m.promotion.toUpperCase() : '');
      }
      const before = this.snapshot(); this.apply(m);
      if (this.inCheck()) san += this.legalMoves().length ? '+' : '#';
      const entry = { ...m, san, before };
      this.history.push(entry); this.positions.push(this.key()); return entry;
    }
    undo() { const m = this.history.pop(); if (!m) return null; this.restore(m.before); this.positions.pop(); return m; }
    insufficientMaterial() {
      const pieces = this.board.map((p, i) => ({ p: p?.toLowerCase(), i })).filter(x => x.p && x.p !== 'k');
      if (!pieces.length) return true;
      if (pieces.length === 1 && ['b', 'n'].includes(pieces[0].p)) return true;
      return pieces.every(x => x.p === 'b') && pieces.every(x => ((x.i >> 3) + x.i % 8) % 2 === ((pieces[0].i >> 3) + pieces[0].i % 8) % 2);
    }
    status() {
      const check = this.inCheck(), moves = this.legalMoves();
      if (!moves.length) return { over: true, reason: check ? 'checkmate' : 'stalemate', check, winner: check ? opposite(this.turn) : null };
      if (this.insufficientMaterial()) return { over: true, reason: 'insufficient material', check };
      if (this.half >= 100) return { over: true, reason: '50-move rule', check };
      if (this.positions.filter(p => p === this.positions[this.positions.length - 1]).length >= 3) return { over: true, reason: 'threefold repetition', check };
      return { over: false, check };
    }
  }
  Chess.START = START; Chess.color = color; Chess.square = square; Chess.index = index;
  if (typeof module !== 'undefined' && module.exports) module.exports = Chess;
  else root.Chess = Chess;
})(typeof globalThis !== 'undefined' ? globalThis : this);
