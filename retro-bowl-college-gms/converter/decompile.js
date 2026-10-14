// GameMaker HTML5 (JS) -> GML decompiler for non-obfuscated GMS 2.3+/2024 HTML5 exports.
'use strict';

const BINOPS = {
  yyfplus: '+', yyfminus: '-', yyftime: '*', yyfdivide: '/', yyfmod: 'mod', yyfdiv: 'div',
  yyfequal: '==', yyfnotequal: '!=', yyfless: '<', yyflessequal: '<=', yyfgreater: '>', yyfgreaterequal: '>=',
  yyfbitand: '&', yyfbitor: '|', yyfbitxor: '^', yyfbitshiftleft: '<<', yyfbitshiftright: '>>',
  yyfand: '&&', yyfor: '||', yyfxor: '^^',
};
const PREC = {
  '||': 1, '^^': 1, '&&': 2,
  '==': 3, '!=': 3, '<': 3, '<=': 3, '>': 3, '>=': 3,
  '|': 4, '^': 4, '&': 4, '<<': 5, '>>': 5,
  '+': 6, '-': 6, '*': 7, '/': 7, 'mod': 7, 'div': 7, '%': 7,
};
const P_TERNARY = 0, P_UNARY = 8, P_POSTFIX = 9, P_ATOM = 10;
const UNWRAP1 = new Set(['yyGetBool', '__yy_gml_errCheck', 'yyGetInt32', 'yyGetReal', 'yyGetString', 'yyGetInt64',
  '__yy_gml_array_check_index', '__yy_gml_array_check_index_set', '__yy_gml_array_check_index_chain']);
// asset type nibble from YYASSET_REF
const ASSET_TYPES = { 0: 'GMObjects', 1: 'Sprites', 2: 'Sounds', 3: 'GMRooms', 5: 'Paths', 7: 'Fonts', 10: 'Shaders' };
const SPECIAL_INST = { '-1': 'self', '-2': 'other', '-3': 'all', '-4': 'noone', '-5': 'global' };

class Decompiler {
  constructor(game, ast, src, runnerSrc) {
    this.game = game; this.src = src;
    this.funcs = new Map();           // name -> FunctionDeclaration
    for (const st of ast.body) if (st.type === 'FunctionDeclaration') this.funcs.set(st.id.name, st);
    this.scriptIds = game.ScriptNames; // index -> gml_Script_x
    this.onlySelf = new Set([...(src + runnerSrc).matchAll(/(\w+)\.__yy_onlySelfNoOther = true/g)].map(m => m[1]));
    this.selfOther = new Set([...(src + runnerSrc).matchAll(/(\w+)\.__yy_bothSelfAndOther = true/g)].map(m => m[1]));
    this.issues = new Map();
    this.fnName = new Map();          // gml_Script_X -> declared GML name
    this.fnDefined = new Set();       // functions emitted at a definition site
    this.roomInstNames = new Map();   // numeric id -> instance name
    this.buildNameMap();
  }

  issue(kind, node) {
    const e = this.issues.get(kind) || { count: 0, sample: this.src.slice(node.start, Math.min(node.end, node.start + 200)) };
    e.count++; this.issues.set(kind, e);
  }

  // Pre-pass: X.gmlNAME = __yy_method(S, gml_Script_F) -> F is called NAME in GML.
  buildNameMap() {
    const walk = (n) => {
      if (!n || typeof n.type !== 'string') return;
      if (n.type === 'AssignmentExpression' && n.right.type === 'CallExpression' && n.right.callee.name === '__yy_method' &&
          n.left.type === 'MemberExpression' && !n.left.computed && n.left.property.name.startsWith('gml') &&
          n.right.arguments[1] && n.right.arguments[1].type === 'Identifier') {
        const F = n.right.arguments[1].name, NAME = n.left.property.name.slice(3);
        if (!F.includes('___struct___') && !this.fnName.has(F)) this.fnName.set(F, NAME);
      }
      for (const k in n) {
        const v = n[k];
        if (Array.isArray(v)) v.forEach(walk); else if (v && typeof v.type === 'string') walk(v);
      }
    };
    for (const [name, fn] of this.funcs) if (name.startsWith('gml_')) walk(fn.body);
  }

  scriptName(F) {
    if (this.fnName.has(F)) return this.fnName.get(F);
    let m = /^gml_Script_(.*)$/.exec(F);
    if (m) return m[1];
    m = /^gml_GlobalScript_(.*)$/.exec(F);
    return m ? m[1] : F;
  }

  assetName(type, index) {
    const tbl = this.game[ASSET_TYPES[type]];
    if (!tbl || !tbl[index]) return null;
    return tbl[index].pName || tbl[index].name;
  }

  // ---------- helpers ----------
  isIdent(n, name) { return n && n.type === 'Identifier' && (name === undefined || n.name === name); }
  isCall(n, name) { return n && n.type === 'CallExpression' && n.callee.type === 'Identifier' && (name === undefined || n.callee.name === name); }

  // Parameters of a compiled function (after _inst, _other)
  params(fn) { return fn.params.slice(2).map(p => p.name); }
  paramName(js) { const m = /^argument(\d+)$/.exec(js); return m ? '_arg' + m[1] : js.replace(/^gmll?_?/, ''); }

  // ---------- context ----------
  makeCtx(fn, kind) {
    const locals = new Set();
    const walk = (n) => {
      if (!n || typeof n.type !== 'string') return;
      if (n.type === 'FunctionExpression' || n.type === 'ArrowFunctionExpression') return;
      if (n.type === 'VariableDeclarator' && n.id.name.startsWith('gml')) locals.add(n.id.name.replace(/^gmll?_?/, '').replace(/^gml/, ''));
      for (const k in n) { const v = n[k]; if (Array.isArray(v)) v.forEach(walk); else if (v && typeof v.type === 'string') walk(v); }
    };
    walk(fn.body);
    return { kind, self: '_inst', other: '_other', locals, withDepth: 0, args: null, fn };
  }

  localName(js) {
    if (js.startsWith('gmll_')) return js.slice(5);
    if (js.startsWith('gml')) return js.slice(3);
    return js;
  }

  // Translate an instance reference (object side of a member access) -> GML text or 'self'/'other'
  instRef(n, ctx) {
    if (n.type === 'Identifier') {
      if (n.name === ctx.self) return 'self';
      if (n.name === ctx.other) return 'other';
      if (n.name === 'global') return 'global';
      if (n.name === '__temp__' && ctx.tempRef) return ctx.tempRef;
      if (n.name === '_inst' || n.name === '_other' || /^__yy__v\d+$/.test(n.name)) { this.issue('unreachable-scope-ref', n); return n.name === '_other' ? 'other' : 'self'; }
    }
    if (this.isCall(n, 'yyInst')) {
      const t = n.arguments[2];
      if (t.type === 'Literal' && typeof t.value === 'number') {
        if (t.value >= 100000) return this.roomInstName(t.value);
        if (SPECIAL_INST[t.value]) return SPECIAL_INST[t.value];
      }
      if (t.type === 'UnaryExpression' && t.operator === '-' && t.argument.type === 'Literal' && SPECIAL_INST['-' + t.argument.value]) return SPECIAL_INST['-' + t.argument.value];
      const e = this.expr(t, ctx);
      return e.p >= P_POSTFIX ? e.s : '(' + e.s + ')';
    }
    const e = this.expr(n, ctx);
    return e.p >= P_POSTFIX ? e.s : '(' + e.s + ')';
  }

  roomInstName(id) {
    if (!this.roomInstNames.has(id)) this.roomInstNames.set(id, 'inst_' + id);
    return this.roomInstNames.get(id);
  }

  member(n, ctx) {
    // n: MemberExpression
    if (n.computed && this.isIdent(n.object, '$$args')) {
      // $$args[check_index(2 + k, $$args)] -> argument[k] (or the struct literal's k-th value)
      let ix = n.property;
      while (this.isCall(ix) && UNWRAP1.has(ix.callee.name)) ix = ix.arguments[0];
      let k = null, kExpr;
      if (ix.type === 'BinaryExpression' && ix.operator === '+' && ix.left.type === 'Literal' && ix.left.value === 2) {
        if (ix.right.type === 'Literal') k = ix.right.value; else kExpr = this.expr(ix.right, ctx).s;
      } else kExpr = this.wrap(this.expr(ix, ctx), 7) + ' - 2';
      if (k !== null && ctx.structArgs) {
        if (k < ctx.structArgs.length) return { s: ctx.structArgs[k], p: -1 };
        return { s: 'undefined', p: P_ATOM };
      }
      if (ctx.structArgs) this.issue('struct-dynamic-arg', n);
      return { s: 'argument[' + (k !== null ? k : kExpr) + ']', p: P_POSTFIX };
    }
    if (n.computed) {
      const obj = this.expr(n.object, ctx);
      return { s: (obj.p >= P_POSTFIX ? obj.s : '(' + obj.s + ')') + '[' + this.expr(n.property, ctx).s + ']', p: P_POSTFIX };
    }
    const prop = n.property.name;
    if (prop === 'undefined') return { s: 'undefined', p: P_ATOM };
    if (this.isIdent(n.object, '$$args') && prop === 'length') return { s: 'argument_count + 2', p: 6 };
    const base = this.instRef(n.object, ctx);
    const name = prop.startsWith('gml') ? prop.slice(3) : prop;
    if (base === 'self') {
      if (ctx.locals.has(name) || ctx.paramSet && ctx.paramSet.has(name)) return { s: 'self.' + name, p: P_POSTFIX };
      return { s: name, p: P_ATOM };
    }
    return { s: base + '.' + name, p: P_POSTFIX };
  }

  // ---------- expressions: return {s, p} ----------
  expr(n, ctx) {
    switch (n.type) {
      case 'Literal': return { s: this.literal(n.value), p: P_ATOM };
      case 'Identifier': return this.ident(n, ctx);
      case 'MemberExpression': return this.member(n, ctx);
      case 'CallExpression': return this.call(n, ctx);
      case 'NewExpression':
        if (n.callee.name === 'Long') {
          const lo = n.arguments[0].value >>> 0, hi = n.arguments[1].type === 'Literal' ? n.arguments[1].value : -n.arguments[1].argument.value;
          const v = hi * 4294967296 + lo;
          return { s: v > 0xffffffff || v < 0 ? String(BigInt(hi) * 4294967296n + BigInt(lo)) : (v >= 0x1000000 ? '0x' + v.toString(16).toUpperCase() : String(v)), p: P_ATOM };
        }
        this.issue('new-' + n.callee.name, n); return { s: '/*?new*/undefined', p: P_ATOM };
      case 'ArrayExpression': return { s: '[' + n.elements.map(e => this.expr(e, ctx).s).join(', ') + ']', p: P_ATOM };
      case 'UnaryExpression': {
        if (n.operator === '-' && n.argument.type === 'Literal') return { s: '-' + this.literal(n.argument.value), p: P_UNARY };
        const a = this.expr(n.argument, ctx);
        const op = { '!': '!', '-': '-', '~': '~', '+': '' }[n.operator];
        if (op === undefined) { this.issue('unary-' + n.operator, n); return { s: '/*?*/' + a.s, p: P_UNARY }; }
        return { s: op + (a.p >= P_UNARY ? a.s : '(' + a.s + ')'), p: P_UNARY };
      }
      case 'BinaryExpression': {
        // $$args.length - 2  -> argument_count
        if (n.operator === '-' && n.left.type === 'MemberExpression' && this.isIdent(n.left.object, '$$args') && n.right.value === 2) return { s: 'argument_count', p: P_ATOM };
        let op = n.operator;
        if (op === '===') op = '=='; if (op === '!==') op = '!=';
        if (op === '%') op = 'mod';
        if (!(op in PREC)) { this.issue('binop-' + op, n); }
        return this.bin(op, n.left, n.right, ctx);
      }
      case 'LogicalExpression': return this.bin(n.operator, n.left, n.right, ctx);
      case 'ConditionalExpression': {
        const t = this.expr(n.test, ctx), a = this.expr(n.consequent, ctx), b = this.expr(n.alternate, ctx);
        return { s: this.wrap(t, 1) + ' ? ' + this.wrap(a, 1) + ' : ' + this.wrap(b, 1), p: P_TERNARY };
      }
      case 'AssignmentExpression': {
        // (X.gml___struct___N = __yy_method(...)) inside object_create handled there.
        const l = this.expr(n.left, ctx), r = this.expr(n.right, ctx);
        if (n.operator !== '=') this.issue('assignop-' + n.operator, n);
        return { s: l.s + ' ' + n.operator + ' ' + r.s, p: -1 };
      }
      case 'SequenceExpression': {
        const r = this.prePost(n, ctx);
        if (r) return r;
        this.issue('sequence', n);
        return { s: '/*?seq*/(' + n.expressions.map(e => this.expr(e, ctx).s).join(', ') + ')', p: P_ATOM };
      }
      case 'UpdateExpression': {
        const a = this.expr(n.argument, ctx);
        return { s: n.prefix ? n.operator + a.s : a.s + n.operator, p: P_POSTFIX };
      }
      default:
        this.issue('expr-' + n.type, n);
        return { s: '/*?' + n.type + '*/undefined', p: P_ATOM };
    }
  }

  wrap(e, minP) { return e.p >= minP ? e.s : '(' + e.s + ')'; }

  bin(op, L, R, ctx) {
    const p = PREC[op] !== undefined ? PREC[op] : 3;
    const l = this.expr(L, ctx), r = this.expr(R, ctx);
    // GML precedence differs from C for bitwise vs comparison; parenthesize liberally.
    const mixed = l.op !== op && (p === 4 || p <= 3 || (p === 7 && (/^(mod|div)$/.test(op) || /^(mod|div)$/.test(l.op))));
    const needL = l.p < p || (l.p === p && mixed);
    const needR = r.p < p || (r.p === p && !(r.op === op && (op === '&&' || op === '||')));
    return { s: (needL ? '(' + l.s + ')' : l.s) + ' ' + op + ' ' + (needR ? '(' + r.s + ')' : r.s), p, op };
  }

  literal(v) {
    if (v === null) return 'undefined';
    if (typeof v === 'boolean') return v ? 'true' : 'false';
    if (typeof v === 'number') {
      if (!isFinite(v)) return isNaN(v) ? 'NaN' : 'infinity';
      let s = String(v);
      if (/e/i.test(s)) {
        if (Math.abs(v) < 1) s = v.toFixed(20).replace(/0+$/, '');
        else s = BigInt(Math.round(v)).toString();
      }
      return s;
    }
    if (typeof v === 'string') {
      return '"' + v.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n').replace(/\r/g, '\\r').replace(/\t/g, '\\t')
        .replace(/\x08/g, '\\b').replace(/\x0c/g, '\\f').replace(/\x0b/g, '\\v').replace(/\x07/g, '\\a')
        .replace(/[\u0000-\u001f]/g, c => '\\x' + c.charCodeAt(0).toString(16).padStart(2, '0')) + '"';
    }
    return String(v);
  }

  ident(n, ctx) {
    const name = n.name;
    if (name === 'undefined') return { s: 'undefined', p: P_ATOM };
    if (name === ctx.self) return { s: 'self', p: P_ATOM };
    if (name === ctx.other) return { s: 'other', p: P_ATOM };
    if (name === 'global') return { s: 'global', p: P_ATOM };
    if (name === 'Infinity') return { s: 'infinity', p: P_ATOM };
    if (name === 'NaN') return { s: 'NaN', p: P_ATOM };
    if (/^argument\d+$/.test(name)) return { s: this.paramName(name), p: P_ATOM };
    if (name.startsWith('kgml_Script_') || name.startsWith('kgml_GlobalScript_')) return { s: this.scriptName(name.slice(1)), p: P_ATOM };
    if (name.startsWith('gml_Script_') || name.startsWith('gml_GlobalScript_')) return { s: this.scriptName(name), p: P_ATOM };
    if (name.startsWith('gml')) return { s: this.localName(name), p: P_ATOM };
    if (name === '_inst' || name === '_other' || /^__yy__v\d+$/.test(name)) { this.issue('unreachable-scope-ident', n); return { s: name === '_other' ? 'other' : 'self', p: P_ATOM }; }
    if (name === 'gml_exception') return { s: 'gml_exception', p: P_ATOM };
    return { s: name, p: P_ATOM };
  }

  // (g = V, V = g instanceof Long ? V.add(1) : ++V, g)   -> V++
  // (V = V instanceof Long ? V.add(1) : ++V) as assignment -> ++V handled in call/assign
  prePost(n, ctx) {
    const ex = n.expressions;
    if (ex.length === 3 && ex[0].type === 'AssignmentExpression' && this.isIdent(ex[0].left, 'g_yyPrePostObject__') &&
        ex[1].type === 'AssignmentExpression' && ex[1].right.type === 'ConditionalExpression') {
      const target = this.expr(ex[0].right, ctx).s;
      const cons = ex[1].right.consequent;
      const op = cons.type === 'CallExpression' && cons.callee.property && cons.callee.property.name === 'subtract' ? '--' : '++';
      return { s: target + op, p: P_POSTFIX, update: true };
    }
    // (V = V instanceof Long ? V.add(1) : ++V, V)  -> ++V
    if (ex.length === 2 && ex[0].type === 'AssignmentExpression') {
      const pre = this.preIncrement(ex[0], ctx);
      if (pre) return pre;
      // (__temp__ = E, use(__temp__))  -> use(E)
      if (this.isIdent(ex[0].left, '__temp__')) {
        const saved = ctx.tempRef;
        ctx.tempRef = this.instRef(ex[0].right, ctx);
        const r = this.expr(ex[1], ctx);
        ctx.tempRef = saved;
        return r;
      }
    }
    return null;
  }

  // V = V instanceof Long ? V.add(1) : ++V   (pre-increment)
  preIncrement(n, ctx) {
    if (n.type === 'AssignmentExpression' && n.right.type === 'ConditionalExpression' && n.right.test.type === 'BinaryExpression' &&
        n.right.test.operator === 'instanceof') {
      const cons = n.right.consequent;
      const op = cons.type === 'CallExpression' && cons.callee.property && cons.callee.property.name === 'subtract' ? '--' : '++';
      return { s: op + this.expr(n.left, ctx).s, p: P_UNARY, update: true };
    }
    return null;
  }

  callArgs(args, ctx) { return args.map(a => this.expr(a, ctx).s).join(', '); }

  call(n, ctx) {
    const c = n.callee;
    if (c.type === 'Identifier') {
      const f = c.name;
      if (UNWRAP1.has(f)) return this.expr(n.arguments[0], ctx);
      if (BINOPS[f]) return this.bin(BINOPS[f], n.arguments[0], n.arguments[1], ctx);
      if (f === 'YYASSET_REF') {
        const v = n.arguments[0].value, type = (v >> 24) & 0xff, idx = v & 0xffffff;
        const nm = this.assetName(type, idx);
        if (!nm) { this.issue('asset-ref-unknown', n); return { s: String(idx), p: P_ATOM }; }
        return { s: nm, p: P_ATOM };
      }
      if (f === '__yy_gml_array_create') return this.expr(n.arguments[0], ctx);
      if (f === '__yy_gml_array_check') return this.expr(n.arguments[0], ctx);
      if (f === 'yyInst') { const r = this.instRef(n, ctx); return { s: r, p: P_POSTFIX }; }
      if (f === '__yy_method') return this.methodExpr(n.arguments[0], n.arguments[1], ctx);
      if (f === '__yy_gml_object_create') return this.objectCreate(n, ctx);
      if (f === 'yyCompareVal') { this.issue('comparevalue-outside-switch', n); return { s: '/*cmp*/(' + this.callArgs(n.arguments.slice(0, 2), ctx) + ')', p: P_ATOM }; }
      if (f === '__yy__processException') return this.expr(n.arguments[0], ctx);
      if (f.startsWith('gml_Script_') || f.startsWith('gml_GlobalScript_')) {
        // script call: (self, other, ...args)
        return { s: this.scriptName(f) + '(' + this.callArgs(n.arguments.slice(2), ctx) + ')', p: P_POSTFIX };
      }
      if (this.selfOther.has(f)) return { s: f + '(' + this.callArgs(n.arguments.slice(2), ctx) + ')', p: P_POSTFIX };
      if (this.onlySelf.has(f)) {
        const first = n.arguments[0];
        let rest = n.arguments.slice(1);
        if (first && !(this.isIdent(first, ctx.self))) {
          // called on a different instance; GML equivalent is with(...)
          this.issue('onlyself-other-target', n);
        }
        return { s: f + '(' + this.callArgs(rest, ctx) + ')', p: P_POSTFIX };
      }
      return { s: f + '(' + this.callArgs(n.arguments, ctx) + ')', p: P_POSTFIX };
    }
    if (c.type === 'MemberExpression' && this.isIdent(c.object, 'g_pBuiltIn')) {
      const p = c.property.name;
      if (p.startsWith('get_')) return { s: p.slice(4), p: P_ATOM };
      if (p.startsWith('set_')) return { s: p.slice(4) + ' = ' + this.callArgs(n.arguments, ctx), p: -1 };
    }
    if (c.type === 'CallExpression' && this.isCall(c, '__yyg_call_method')) {
      // __yyg_call_method(F)(self, other, ...args)
      const fn = this.expr(c.arguments[0], ctx);
      return { s: this.wrap(fn, P_POSTFIX) + '(' + this.callArgs(n.arguments.slice(2), ctx) + ')', p: P_POSTFIX };
    }
    this.issue('call-' + (c.type === 'MemberExpression' ? 'member.' + (c.property.name || '?') : c.type), n);
    return { s: '/*?call*/undefined', p: P_ATOM };
  }

  // __yy_method(S, F)
  methodExpr(S, F, ctx) {
    const target = this.instRef(S, ctx);
    let fnText;
    if (F.type === 'Identifier' && this.funcs.has(F.name) && this.isNested(F.name)) {
      fnText = this.functionText(F.name, null, ctx.indent || '');
    } else {
      fnText = this.expr(F, ctx).s;
      return { s: target === 'self' ? 'method(self, ' + fnText + ')' : 'method(' + target + ', ' + fnText + ')', p: P_POSTFIX };
    }
    if (target === 'self') return { s: fnText, p: P_ATOM };
    return { s: 'method(' + target + ', ' + fnText + ')', p: P_POSTFIX };
  }

  // true when a gml_Script_ function is defined inline at its use site (always true for scripts we have bodies for)
  isNested(F) { return F.startsWith('gml_Script_'); }

  // Render `function NAME(params) { body }` (NAME may be null for anonymous)
  functionText(F, NAME, indent) {
    this.fnDefined.add(F);
    const fn = this.funcs.get(F);
    const ctx = this.makeCtx(fn, 'function');
    const ps = this.params(fn).map(p => this.paramName(p));
    ctx.paramSet = new Set(ps);
    ctx.indent = indent;
    const isCtor = fn.body.body.some(s => s.type === 'IfStatement' && this.src.slice(s.test.start, s.test.end).includes('__yyIsGMLObject'));
    const body = this.block(fn.body.body, ctx, indent + '\t');
    return 'function' + (NAME ? ' ' + NAME : '') + '(' + ps.join(', ') + ')' + (isCtor ? ' constructor' : '') + ' {\n' + body + indent + '}';
  }

  // __yy_gml_object_create(_inst, (X = __yy_method(_inst, CTOR)) | CTOR, ...args)
  objectCreate(n, ctx) {
    let ctorNode = n.arguments[1];
    if (ctorNode.type === 'AssignmentExpression') ctorNode = ctorNode.right;
    let F = null;
    if (this.isCall(ctorNode, '__yy_method')) F = ctorNode.arguments[1].name;
    else if (ctorNode.type === 'Identifier') F = ctorNode.name;
    const args = n.arguments.slice(2).map(a => this.expr(a, ctx).s);
    if (F && F.includes('___struct___') && this.funcs.has(F)) {
      this.fnDefined.add(F);
      return { s: this.structLiteral(F, args, ctx), p: P_ATOM };
    }
    const fnExpr = F ? this.scriptName(F) : this.expr(ctorNode, ctx).s;
    return { s: 'new ' + fnExpr + '(' + args.join(', ') + ')', p: P_POSTFIX };
  }

  structLiteral(F, args, outerCtx) {
    const fn = this.funcs.get(F);
    const fields = [];
    const ctx = this.makeCtx(fn, 'struct');
    ctx.indent = (outerCtx.indent || '') + '\t';
    ctx.structArgs = args;
    const visit = (stmts) => {
      for (const s of stmts) {
        if (s.type === 'BlockStatement') { visit(s.body); continue; }
        if (s.type === 'IfStatement') {
          const t = this.src.slice(s.test.start, s.test.end);
          if (t.includes('__yyIsGMLObject') || t.includes('prototype.__type')) continue;
        }
        if (s.type === 'VariableDeclaration' && s.declarations[0].id.name === '$$args') continue;
        if (s.type === 'ExpressionStatement' && s.expression.type === 'AssignmentExpression' &&
            s.expression.left.type === 'MemberExpression' && this.isIdent(s.expression.left.object, '_inst')) {
          const name = s.expression.left.property.name.replace(/^gml/, '');
          fields.push(name + ': ' + this.expr(s.expression.right, ctx).s);
          continue;
        }
        this.issue('struct-stmt-' + s.type, s);
        fields.push('/*?' + this.src.slice(s.start, s.end).slice(0, 80).replace(/\*\//g, '') + '*/');
      }
    };
    visit(fn.body.body);
    if (!fields.length) return '{}';
    const ind = outerCtx.indent || '';
    const oneLine = '{ ' + fields.join(', ') + ' }';
    if (oneLine.length < 100 && !oneLine.includes('\n')) return oneLine;
    return '{\n' + fields.map(f => ind + '\t' + f).join(',\n') + '\n' + ind + '}';
  }

  // ---------- statements ----------
  block(stmts, ctx, indent) {
    let out = '';
    const list = this.flatten(stmts);
    for (let i = 0; i < list.length; i++) {
      const s = list[i];
      // merge `var i = 0; for (; ...)` into `for (var i = 0; ...)`
      if (s.type === 'VariableDeclaration' && list[i + 1] && list[i + 1].type === 'ForStatement' && !list[i + 1].init &&
          s.declarations.length === 1 && s.declarations[0].init) {
        const loopVar = s.declarations[0].id.name;
        const upd = list[i + 1].update ? this.src.slice(list[i + 1].update.start, list[i + 1].update.end) : '';
        if (upd.includes(loopVar)) { out += this.forStmt(list[i + 1], ctx, indent, s); i++; continue; }
      }
      // merge `i = 0; for (; ...)` into `for (i = 0; ...)`
      if (s.type === 'ExpressionStatement' && s.expression.type === 'AssignmentExpression' && list[i + 1] &&
          list[i + 1].type === 'ForStatement' && !list[i + 1].init && list[i + 1].update) {
        const lhs = this.src.slice(s.expression.left.start, s.expression.left.end);
        if (this.src.slice(list[i + 1].update.start, list[i + 1].update.end).includes(lhs)) {
          out += this.forStmt(list[i + 1], ctx, indent, null, this.exprStmtText(s.expression, ctx)); i++; continue;
        }
      }
      // with pattern
      if (s.type === 'BlockStatement' && this.isWithBlock(s)) { out += this.withStmt(s, ctx, indent); continue; }
      // switch pattern: var ___swN___ = E; var ___swcM___ = -1; if-chain; switch(___swcM___)
      if (s.type === 'VariableDeclaration' && /^___sw\d+___$/.test(s.declarations[0].id.name)) {
        const r = this.switchStmt(list, i, ctx, indent);
        if (r) { out += r.text; i = r.next - 1; continue; }
      }
      out += this.stmt(s, ctx, indent);
    }
    return out;
  }

  flatten(stmts) {
    const out = [];
    for (const s of stmts) {
      if (s.type === 'BlockStatement' && !this.isWithBlock(s)) out.push(...this.flatten(s.body));
      else if (s.type !== 'EmptyStatement') out.push(s);
    }
    return out;
  }

  isWithBlock(b) {
    const s = b.body;
    return s.length === 2 && s[0].type === 'VariableDeclaration' && this.isCall(s[0].declarations[0].init, 'GetWithArray') && s[1].type === 'ForInStatement';
  }

  withStmt(b, ctx, indent) {
    const target = b.body[0].declarations[0].init.arguments[0];
    const loop = b.body[1];
    let body = loop.body.body;
    // skip `if (!A.hasOwnProperty(B)) continue;` and `var C = A[B];`
    const selfVar = body[1].declarations[0].id.name;
    body = body.slice(2);
    const t = this.withTarget(target, ctx);
    const inner = Object.assign({}, ctx, { self: selfVar, other: ctx.self, withDepth: ctx.withDepth + 1 });
    return indent + 'with (' + t + ') {\n' + this.block(body, inner, indent + '\t') + indent + '}\n';
  }

  withTarget(n, ctx) {
    if (n.type === 'Literal' && typeof n.value === 'number') {
      if (n.value >= 100000) return this.roomInstName(n.value);
      if (SPECIAL_INST[n.value]) return SPECIAL_INST[n.value];
    }
    if (n.type === 'UnaryExpression' && n.operator === '-' && n.argument.type === 'Literal' && SPECIAL_INST['-' + n.argument.value]) return SPECIAL_INST['-' + n.argument.value];
    return this.expr(n, ctx).s;
  }

  switchStmt(list, i, ctx, indent) {
    const d0 = list[i], d1 = list[i + 1];
    const swVar = d0.declarations[0].id.name;
    if (!d1 || d1.type !== 'VariableDeclaration' || !/^___swc\d+___$/.test(d1.declarations[0].id.name)) return null;
    const swc = d1.declarations[0].id.name;
    const caseVals = new Map(); // swc index -> [values]
    let j = i + 2;
    let ifs = list[j];
    if (ifs && ifs.type === 'IfStatement') {
      let cur = ifs;
      while (cur) {
        const vals = [];
        const collect = (t) => {
          if (t.type === 'LogicalExpression' && t.operator === '||') { collect(t.left); collect(t.right); return; }
          // yyCompareVal(sw, V, eps, false) == 0
          if (t.type === 'BinaryExpression' && this.isCall(t.left, 'yyCompareVal')) vals.push(this.expr(t.left.arguments[1], ctx).s);
          else vals.push('/*?case*/' + this.src.slice(t.start, t.end));
        };
        collect(cur.test);
        const cons = cur.consequent.type === 'BlockStatement' ? cur.consequent.body[0] : cur.consequent;
        const k = cons.expression.right.value;
        caseVals.set(k, (caseVals.get(k) || []).concat(vals));
        cur = cur.alternate;
        if (cur && cur.type === 'BlockStatement') cur = cur.body[0];
      }
      j++;
    }
    const sw = list[j];
    if (!sw || sw.type !== 'SwitchStatement' || !this.isIdent(sw.discriminant, swc)) return null;
    const disc = this.expr(d0.declarations[0].init, ctx).s;
    let text = indent + 'switch (' + disc + ') {\n';
    for (const cs of sw.cases) {
      if (cs.test === null) text += indent + '\tdefault:\n';
      else {
        const vals = caseVals.get(cs.test.value) || ['/*?unreached*/' + cs.test.value];
        for (const v of vals) text += indent + '\tcase ' + v + ':\n';
      }
      text += this.block(cs.consequent, ctx, indent + '\t\t');
    }
    text += indent + '}\n';
    return { text, next: j + 1 };
  }

  forStmt(s, ctx, indent, initDecl, initText) {
    // repeat (N): for (var a = 0, b = yyGetInt32(N); a < b; a++)
    if (!initDecl && s.init && s.init.type === 'VariableDeclaration' && s.init.declarations.length === 2 &&
        /^__yy__v\d+$/.test(s.init.declarations[0].id.name) && /^__yy__v\d+$/.test(s.init.declarations[1].id.name)) {
      let n = s.init.declarations[1].init;
      if (this.isCall(n, 'yyGetInt32')) n = n.arguments[0];
      return indent + 'repeat (' + this.expr(n, ctx).s + ') ' + this.body(s.body, ctx, indent);
    }
    let init = initText || '';
    if (initDecl) init = this.varDecl(initDecl, ctx).replace(/;$/, '');
    else if (s.init) init = s.init.type === 'VariableDeclaration' ? this.varDecl(s.init, ctx).replace(/;$/, '') : this.exprStmtText(s.init, ctx);
    const test = s.test ? this.expr(s.test, ctx).s : 'true';
    const upd = s.update ? this.exprStmtText(s.update, ctx) : '';
    if (!init) {
      // GML requires an initializer: hoist a no-op
      return indent + 'for (; ' + test + '; ' + upd + ') ' + this.body(s.body, ctx, indent);
    }
    return indent + 'for (' + init + '; ' + test + '; ' + upd + ') ' + this.body(s.body, ctx, indent);
  }

  body(s, ctx, indent) {
    if (s.type === 'BlockStatement') return '{\n' + this.block(s.body, ctx, indent + '\t') + indent + '}\n';
    return '{\n' + this.block([s], ctx, indent + '\t') + indent + '}\n';
  }

  varDecl(s, ctx) {
    const parts = s.declarations.map(d => {
      const name = this.localName(d.id.name);
      return d.init ? name + ' = ' + this.expr(d.init, ctx).s : name;
    });
    return 'var ' + parts.join(', ') + ';';
  }

  exprStmtText(e, ctx) {
    if (e.type === 'SequenceExpression') {
      const pp = this.prePost(e, ctx);
      if (pp) return pp.s;
    }
    const pre = this.preIncrement(e, ctx);
    if (pre) return pre.s;
    if (e.type === 'AssignmentExpression') {
      // a = yyfplus(a, b) -> a += b
      const l = this.expr(e.left, ctx).s;
      const r = e.right;
      if (this.isCall(r) && ['yyfplus', 'yyfminus', 'yyftime', 'yyfdivide'].includes(r.callee.name)) {
        const lhs = this.src.slice(e.left.start, e.left.end);
        let a0 = r.arguments[0];
        while (this.isCall(a0) && UNWRAP1.has(a0.callee.name)) a0 = a0.arguments[0];
        if (this.src.slice(a0.start, a0.end) === lhs) {
          const op = BINOPS[r.callee.name];
          return l + ' ' + op + '= ' + this.expr(r.arguments[1], ctx).s;
        }
      }
      return l + ' = ' + this.expr(e.right, ctx).s;
    }
    return this.expr(e, ctx).s;
  }

  stmt(s, ctx, indent) {
    switch (s.type) {
      case 'ExpressionStatement': {
        const e = s.expression;
        // drop copy-on-write array ownership checks: X = __yy_gml_array_check(X, owner)
        if (e.type === 'AssignmentExpression' && this.isCall(e.right, '__yy_gml_array_check')) return '';
        if (e.type === 'Literal' && typeof e.value === 'string') return ''; // "use strict" etc.
        // function declarations: SELF.gmlNAME = __yy_method(SELF, gml_Script_F)
        if (e.type === 'AssignmentExpression' && this.isCall(e.right, '__yy_method') && e.left.type === 'MemberExpression' &&
            !e.left.computed && this.isIdent(e.left.object, ctx.self) && this.isIdent(e.right.arguments[0], ctx.self)) {
          const NAME = e.left.property.name.replace(/^gml/, '');
          const F = e.right.arguments[1].name;
          if (F && this.funcs.has(F) && !F.includes('___struct___') && this.fnName.get(F) === NAME) {
            ctx.indent = indent;
            return indent + this.functionText(F, NAME, indent) + '\n\n';
          }
        }
        ctx.indent = indent;
        return indent + this.exprStmtText(e, ctx) + ';\n';
      }
      case 'VariableDeclaration': {
        if (s.declarations[0].id.name === '$$args') return '';
        ctx.indent = indent;
        return indent + this.varDecl(s, ctx) + '\n';
      }
      case 'BlockStatement':
        if (this.isWithBlock(s)) return this.withStmt(s, ctx, indent);
        return this.block(s.body, ctx, indent);
      case 'IfStatement': {
        let out = indent + 'if (' + this.expr(s.test, ctx).s + ') ' + this.body(s.consequent, ctx, indent);
        if (s.alternate) {
          if (s.alternate.type === 'IfStatement') out = out.replace(/\n$/, '') + ' else ' + this.stmt(s.alternate, ctx, indent).replace(/^\s+/, '');
          else {
            const alt = s.alternate.type === 'BlockStatement' ? this.flatten(s.alternate.body) : [s.alternate];
            if (alt.length === 1 && alt[0].type === 'IfStatement') out = out.replace(/\n$/, '') + ' else ' + this.stmt(alt[0], ctx, indent).replace(/^\s+/, '');
            else out = out.replace(/\n$/, '') + ' else ' + this.body(s.alternate, ctx, indent);
          }
        }
        return out;
      }
      case 'ForStatement': return this.forStmt(s, ctx, indent, null);
      case 'WhileStatement': return indent + 'while (' + this.expr(s.test, ctx).s + ') ' + this.body(s.body, ctx, indent);
      case 'DoWhileStatement': {
        const t = this.expr(s.test, ctx);
        return indent + 'do ' + this.body(s.body, ctx, indent).replace(/\n$/, '') + ' until (!' + this.wrap(t, P_UNARY) + ');\n';
      }
      case 'ReturnStatement':
        if (!s.argument) return indent + (ctx.kind === 'event' ? 'exit;\n' : 'return;\n');
        return indent + 'return ' + this.expr(s.argument, ctx).s + ';\n';
      case 'BreakStatement': return indent + 'break;\n';
      case 'ContinueStatement': return indent + 'continue;\n';
      case 'ThrowStatement': return indent + 'throw ' + this.expr(s.argument, ctx).s + ';\n';
      case 'TryStatement': {
        let out = indent + 'try ' + this.body(s.block, ctx, indent).replace(/\n$/, '');
        if (s.handler) {
          const p = s.handler.param ? this.localName(s.handler.param.name) : 'e';
          // first stmt is `gml_exception = __yy__processException(gml_exception)`
          const hb = s.handler.body.body.filter(x => !(x.type === 'ExpressionStatement' && x.expression.type === 'AssignmentExpression' &&
            this.isCall(x.expression.right, '__yy__processException')));
          out += ' catch (' + p + ') {\n' + this.block(hb, ctx, indent + '\t') + indent + '}';
        }
        if (s.finalizer) out += ' finally ' + this.body(s.finalizer, ctx, indent).replace(/\n$/, '');
        return out + '\n';
      }
      case 'SwitchStatement': {
        this.issue('raw-switch', s);
        let out = indent + 'switch (' + this.expr(s.discriminant, ctx).s + ') {\n';
        for (const c of s.cases) {
          out += indent + '\t' + (c.test ? 'case ' + this.expr(c.test, ctx).s + ':' : 'default:') + '\n';
          out += this.block(c.consequent, ctx, indent + '\t\t');
        }
        return out + indent + '}\n';
      }
      case 'ForInStatement': this.issue('raw-forin', s); return indent + '/*? for-in */\n';
      case 'EmptyStatement': return '';
      default:
        this.issue('stmt-' + s.type, s);
        return indent + '/*? ' + s.type + ' */\n';
    }
  }

  // ---------- entry points ----------
  // Object event / room code (no params, self=_inst)
  eventCode(F) {
    const fn = this.funcs.get(F);
    if (!fn) return null;
    this.fnDefined.add(F);
    const ctx = this.makeCtx(fn, 'event');
    ctx.paramSet = new Set();
    return this.block(fn.body.body, ctx, '');
  }

  // Global script top-level code
  globalScript(F) { return this.eventCode(F); }

  // Translate a single expression in the context of a PreCreate function (for variable definitions)
  preCreateAssignments(F) {
    const fn = this.funcs.get(F);
    if (!fn) return null;
    this.fnDefined.add(F);
    const ctx = this.makeCtx(fn, 'event');
    ctx.paramSet = new Set();
    const res = { inherited: false, vars: [], other: [] };
    for (const s of this.flatten(fn.body.body)) {
      if (s.type === 'ExpressionStatement' && this.isCall(s.expression, 'event_inherited')) { res.inherited = true; continue; }
      if (s.type === 'ExpressionStatement' && s.expression.type === 'AssignmentExpression' && s.expression.left.type === 'MemberExpression' &&
          this.isIdent(s.expression.left.object, '_inst') && !s.expression.left.computed) {
        ctx.indent = '';
        res.vars.push({ name: s.expression.left.property.name.replace(/^gml/, ''), value: this.expr(s.expression.right, ctx).s });
        continue;
      }
      res.other.push(this.stmt(s, ctx, ''));
    }
    return res;
  }
}

module.exports = { Decompiler };
