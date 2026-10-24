'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const { Decompiler } = require('./decompile');
const dc = Object.create(Decompiler.prototype);
dc.scriptName = name => name.replace(/^gml_(?:Global)?Script_/, '');
const ctx = { self: '_inst', other: '_other', locals: new Set(), paramSet: new Set() };
const ident = name => ({ type: 'Identifier', name });
const member = (object, name) => ({ type: 'MemberExpression', object, property: ident(name), computed: false });
const builtin = name => member(ident('g_pBuiltIn'), name);

test('startup reads native room dimensions', () => {
  for (const name of ['room_width', 'room_height']) assert.equal(dc.expr(builtin(name), ctx).s, name);
});
test('camera arrays retain their index without the HTML5 runner object', () => {
  const indexed = { type: 'MemberExpression', object: builtin('view_camera'), property: { type: 'Literal', value: 0 }, computed: true };
  assert.equal(dc.expr(indexed, ctx).s, 'view_camera[0]');
});
test('keyboard assignments write the native built-in', () => {
  const assignment = { type: 'AssignmentExpression', operator: '=', left: builtin('keyboard_string'), right: { type: 'Literal', value: '' } };
  assert.equal(dc.expr(assignment, ctx).s, 'keyboard_string = ""');
});
test('ordinary instance members keep their owner', () => {
  assert.equal(dc.expr(member(ident('obj_camera'), 'x'), ctx).s, 'obj_camera.x');
});
test('HTML5 current-room getter reads the native room variable', () => {
  const getter = { type: 'CallExpression', callee: builtin('get_current_room'), arguments: [] };
  assert.equal(dc.expr(getter, ctx).s, 'room');
});
test('HTML5 view-enable setter writes the native view_enabled variable', () => {
  const setter = { type: 'CallExpression', callee: builtin('set_view_enable'), arguments: [{ type: 'Literal', value: true }] };
  assert.equal(dc.expr(setter, ctx).s, 'view_enabled = true');
});
test('button callbacks omit HTML5 self and other arguments', () => {
  const call = { type: 'CallExpression', callee: ident('script_execute'), arguments: [ident('_inst'), ident('_other'), member(ident('_inst'), 'gmlonClickAction')] };
  assert.equal(dc.expr(call, ctx).s, 'script_execute(onClickAction)');
});
test('script execution preserves callback payload arguments', () => {
  const call = { type: 'CallExpression', callee: ident('script_execute'), arguments: [ident('_inst'), ident('_other'), ident('callback'), { type: 'Literal', value: 7 }, { type: 'Literal', value: 9 }] };
  assert.equal(dc.expr(call, ctx).s, 'script_execute(callback, 7, 9)');
});
test('timer callbacks inside with keep the controller as their caller', () => {
  const inner = { ...ctx, self: '__yy__ball', other: '_inst', withDepth: 1 };
  const call = { type: 'CallExpression', callee: ident('gml_Script_s_subtract_time'), arguments: [ident('_inst'), ident('__yy__ball'), { type: 'Literal', value: 1 }, { type: 'Literal', value: 1 }, { type: 'Literal', value: 'Tick' }] };
  assert.equal(dc.expr(call, inner).s, 'method(other, s_subtract_time)(1, 1, "Tick")');
  call.callee = ident('gml_Script_s_update_game_clock'); call.arguments = call.arguments.slice(0, 2);
  assert.equal(dc.expr(call, inner).s, 'method(other, s_update_game_clock)()');
});
test('script calls on the current with instance retain that instance', () => {
  const inner = { ...ctx, self: '__yy__ball', other: '_inst', withDepth: 1 };
  const call = { type: 'CallExpression', callee: ident('gml_Script_s_is_kickoff'), arguments: [ident('__yy__ball'), ident('_inst'), { type: 'Literal', value: true }] };
  assert.equal(dc.expr(call, inner).s, 's_is_kickoff(true)');
});
test('PreCreate array defaults become properties before Create, without self-reads', () => {
  const field = member(ident('_inst'), 'gmlteam_name');
  const assign = (left, right) => ({ type: 'ExpressionStatement', expression: { type: 'AssignmentExpression', operator: '=', left, right } });
  const ownership = { type: 'CallExpression', callee: ident('__yy_gml_array_check'), arguments: [field, { type: 'Literal', value: 123 }] };
  const indexed = { type: 'MemberExpression', object: field, computed: true, property: { type: 'CallExpression', callee: ident('__yy_gml_array_check_index_set'), arguments: [{ type: 'Literal', value: 4 }] } };
  const parser = Object.create(Decompiler.prototype);
  parser.funcs = new Map([['pre', { body: { body: [assign(field, ownership), assign(indexed, { type: 'Literal', value: 'Team' })] } }]]);
  parser.fnDefined = new Set();
  parser.makeCtx = () => ({ ...ctx });
  assert.deepEqual(parser.preCreateAssignments('pre'), { inherited: false, vars: [{ name: 'team_name', value: '[0, 0, 0, 0, "Team"]' }], other: [] });
});
