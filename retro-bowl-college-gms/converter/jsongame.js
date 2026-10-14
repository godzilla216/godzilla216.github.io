// Converts the JSON_game object literal AST into a plain JS value.
// Function identifiers become the string "@fn:<name>"; `new Long(lo, hi)` becomes a number.
function lit(n) {
  switch (n.type) {
    case 'ObjectExpression': {
      const o = {};
      for (const p of n.properties) {
        const k = p.key.type === 'Identifier' ? p.key.name : p.key.value;
        o[k] = lit(p.value);
      }
      return o;
    }
    case 'ArrayExpression': return n.elements.map(e => (e ? lit(e) : null));
    case 'Literal': return n.value;
    case 'Identifier': return n.name === 'undefined' ? undefined : '@fn:' + n.name;
    case 'UnaryExpression':
      if (n.operator === '-') return -lit(n.argument);
      if (n.operator === '!') return !lit(n.argument);
      break;
    case 'NewExpression':
      if (n.callee.name === 'Long') return lit(n.arguments[1]) * 4294967296 + (lit(n.arguments[0]) >>> 0);
      break;
  }
  return '@expr:' + n.type;
}

function extractGame(ast) {
  let game = null;
  const extra = {};
  for (const st of ast.body) {
    if (st.type === 'VariableDeclaration' && st.declarations[0].id.name === 'JSON_game') game = lit(st.declarations[0].init);
    if (st.type === 'ExpressionStatement' && st.expression.type === 'AssignmentExpression' &&
        st.expression.left.type === 'MemberExpression' && st.expression.left.object.name === 'JSON_game') {
      extra[st.expression.left.property.name] = lit(st.expression.right);
    }
  }
  Object.assign(game, extra);
  return game;
}
module.exports = { extractGame, lit };
