# The Chess Room

A responsive, two-player HTML chess game. Open **index.html** in a modern browser, or serve this folder with any static web server. There is no build step or runtime dependency. Optional Google Fonts fall back to system fonts offline.

Select a piece, then a highlighted destination. Both players use the same device. Includes legal moves, check and checkmate, castling, en passant, a promotion picker, automatic draws, SAN move history, undo, board flipping, and automatic browser saves (when local storage is available). Use Tab, arrow keys, and Enter/Space to play with a keyboard.

Draws by threefold repetition and the 50-move rule are automatic in this casual game rather than requiring a player claim. Insufficient-material detection covers bare kings, king and one bishop/knight, and positions with only bishops on squares of the same color.

Run the chess rule tests with Node.js:

```sh
node --test chess.test.js
```

The tests include standard opening, castling, and en passant move-tree counts, special moves, checkmate, draw detection, notation, and undo.
