// Builds a GameMaker project (2.3 / 2022 LTS resource format; newer IDEs upgrade it on open)
// from a GameMaker HTML5 export.
// usage: node build.js <html5 export dir> <output project dir> [ProjectName]
'use strict';
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { PNG } = require('pngjs');
const { load } = require('./load');
const { extractGame } = require('./jsongame');
const { Decompiler } = require('./decompile');

const [, , SRC, OUT, PROJ = 'RetroBowlCollege'] = process.argv;
const H5 = path.join(SRC, 'html5game');
const log = [];

const { src, runnerSrc, ast } = load(SRC);
const game = extractGame(ast);
const dc = new Decompiler(game, ast, src, runnerSrc);

// ---------- utils ----------
const guid = (s) => {
  const h = crypto.createHash('md5').update(s).digest('hex');
  return `${h.slice(0, 8)}-${h.slice(8, 12)}-${h.slice(12, 16)}-${h.slice(16, 20)}-${h.slice(20, 32)}`;
};
const mkdir = (d) => fs.mkdirSync(d, { recursive: true });
const write = (p, data) => { mkdir(path.dirname(p)); fs.writeFileSync(p, data); };
const writeJson = (p, o) => write(p, JSON.stringify(o, null, 2).replace(/"__ALL_TARGETS__"/g, '461609314234257646'));
const ref = (type, name) => ({ name, path: `${type}/${name}/${name}.yy` });
const folder = (name) => ({ name, path: `folders/${name}.yy` });
const resources = [];
const addRes = (type, name) => resources.push({ id: ref(type, name), order: resources.length });
const fnName = (s) => (typeof s === 'string' && s.startsWith('@fn:') ? s.slice(4) : null);

if (fs.existsSync(OUT) && fs.readdirSync(OUT).length) { console.error('Output dir not empty: ' + OUT); process.exit(1); }
mkdir(OUT);

// ---------- textures ----------
const pages = game.Textures.map(f => PNG.sync.read(fs.readFileSync(path.join(H5, f))));
function blit(tpe, canvasW, canvasH) {
  const page = pages[tpe.tp];
  const img = new PNG({ width: canvasW, height: canvasH, fill: true });
  if (tpe.w !== tpe.CropWidth || tpe.h !== tpe.CropHeight) log.push(`scaled texture entry (${tpe.w}x${tpe.h} vs ${tpe.CropWidth}x${tpe.CropHeight}); copied 1:1`);
  for (let y = 0; y < tpe.h; y++) {
    for (let x = 0; x < tpe.w; x++) {
      const dx = tpe.XOffset + x, dy = tpe.YOffset + y;
      if (dx < 0 || dy < 0 || dx >= canvasW || dy >= canvasH) continue;
      const si = ((tpe.y + y) * page.width + (tpe.x + x)) * 4, di = (dy * canvasW + dx) * 4;
      img.data[di] = page.data[si]; img.data[di + 1] = page.data[si + 1]; img.data[di + 2] = page.data[si + 2]; img.data[di + 3] = page.data[si + 3];
    }
  }
  return PNG.sync.write(img);
}
const crop = (tp, x, y, w, h) => blit({ tp, x, y, w, h, XOffset: 0, YOffset: 0, CropWidth: w, CropHeight: h }, w, h);

// ---------- sprites ----------
const spriteName = (i) => (i >= 0 && game.Sprites[i] ? game.Sprites[i].pName : null);
for (const sp of game.Sprites) {
  const tpe0 = game.TPageEntries[sp.TPEntryIndex[0]] || {};
  if (sp.width === undefined) sp.width = tpe0.ow || 16;
  if (sp.height === undefined) sp.height = tpe0.oh || 16;
  const name = sp.pName, dir = path.join(OUT, 'sprites', name), r = ref('sprites', name);
  const layerId = guid(name + ':layer');
  const frames = [], keyframes = [];
  sp.TPEntryIndex.forEach((tpi, k) => {
    const fid = guid(name + ':frame:' + k);
    const png = blit(game.TPageEntries[tpi], sp.width, sp.height);
    write(path.join(dir, fid + '.png'), png);
    write(path.join(dir, 'layers', fid, layerId + '.png'), png);
    frames.push({
      compositeImage: { FrameId: { name: fid, path: r.path }, LayerId: null, resourceVersion: '1.0', name: '', tags: [], resourceType: 'GMSpriteBitmap' },
      images: [{ FrameId: { name: fid, path: r.path }, LayerId: { name: layerId, path: r.path }, resourceVersion: '1.0', name: '', tags: [], resourceType: 'GMSpriteBitmap' }],
      parent: r, resourceVersion: '1.0', name: fid, tags: [], resourceType: 'GMSpriteFrame',
    });
    keyframes.push({
      id: guid(name + ':kf:' + k), Key: k, Length: 1.0, Stretch: false, Disabled: false, IsCreationKey: false,
      Channels: { 0: { Id: { name: fid, path: r.path }, resourceVersion: '1.0', resourceType: 'SpriteFrameKeyframe' } },
      resourceVersion: '1.0', resourceType: 'Keyframe<SpriteFrameKeyframe>',
    });
  });
  const seq = sp.sequence || {};
  const ns = sp.nineslice && sp.nineslice.nEnabled ? {
    left: sp.nineslice.nLeft, top: sp.nineslice.nTop, right: sp.nineslice.nRight, bottom: sp.nineslice.nBottom,
    guideColour: [4294902015, 4294902015, 4294902015, 4294902015], highlightColour: 1728023040, highlightStyle: 0,
    enabled: true, tileMode: sp.nineslice.nTilemode || [0, 0, 0, 0, 0], resourceVersion: '1.0', loadedVersion: null, resourceType: 'GMNineSliceData',
  } : null;
  writeJson(path.join(dir, name + '.yy'), {
    bboxMode: sp.bboxMode || 0, collisionKind: 1, type: 0, origin: 9, preMultiplyAlpha: false, edgeFiltering: !!sp.smooth,
    collisionTolerance: 0, swfPrecision: 2.525,
    bbox_left: sp.bboxLeft || 0, bbox_right: sp.bboxRight, bbox_top: sp.bboxTop || 0, bbox_bottom: sp.bboxBottom,
    HTile: false, VTile: false, For3D: false, width: sp.width, height: sp.height,
    textureGroupId: { name: 'Default', path: 'texturegroups/Default' }, swatchColours: null, gridX: 0, gridY: 0,
    frames,
    sequence: {
      spriteId: r, timeUnits: 1, playback: 1, playbackSpeed: seq.playbackSpeed !== undefined ? seq.playbackSpeed : sp.playbackspeed,
      playbackSpeedType: seq.playbackSpeedType || 0, autoRecord: true, volume: 1.0, length: frames.length,
      events: { Keyframes: [], resourceVersion: '1.0', resourceType: 'KeyframeStore<MessageEventKeyframe>' },
      moments: { Keyframes: [], resourceVersion: '1.0', resourceType: 'KeyframeStore<MomentsEventKeyframe>' },
      tracks: [{
        name: 'frames', spriteId: null,
        keyframes: { Keyframes: keyframes, resourceVersion: '1.0', resourceType: 'KeyframeStore<SpriteFrameKeyframe>' },
        trackColour: 0, inheritsTrackColour: true, builtinName: 0, traits: 0, interpolation: 1, tracks: [], events: [], modifiers: [],
        isCreationTrack: false, resourceVersion: '1.0', tags: [], resourceType: 'GMSpriteFramesTrack',
      }],
      visibleRange: null, lockOrigin: false, showBackdrop: true, showBackdropImage: false, backdropImagePath: '', backdropImageOpacity: 0.5,
      backdropWidth: 1366, backdropHeight: 768, backdropXOffset: 0.0, backdropYOffset: 0.0,
      xorigin: sp.xOrigin || 0, yorigin: sp.yOrigin || 0, eventToFunction: {}, eventStubScript: null,
      parent: r, resourceVersion: '1.4', name, tags: [], resourceType: 'GMSequence',
    },
    layers: [{ visible: true, isLocked: false, blendMode: 0, opacity: 100.0, displayName: 'default', resourceVersion: '1.0', name: layerId, tags: [], resourceType: 'GMImageLayer' }],
    nineSlice: ns, parent: folder('Sprites'), resourceVersion: '1.0', name, tags: [], resourceType: 'GMSprite',
  });
  addRes('sprites', name);
}

// ---------- sounds ----------
function silentWav() {
  const rate = 22050, n = rate; const b = Buffer.alloc(44 + n * 2);
  b.write('RIFF', 0); b.writeUInt32LE(36 + n * 2, 4); b.write('WAVE', 8); b.write('fmt ', 12); b.writeUInt32LE(16, 16);
  b.writeUInt16LE(1, 20); b.writeUInt16LE(1, 22); b.writeUInt32LE(rate, 24); b.writeUInt32LE(rate * 2, 28); b.writeUInt16LE(2, 32); b.writeUInt16LE(16, 34);
  b.write('data', 36); b.writeUInt32LE(n * 2, 40); return b;
}
for (const s of game.Sounds) {
  const name = s.pName, dir = path.join(OUT, 'sounds', name);
  let file = name + '.ogg';
  const srcFile = path.join(H5, name + '.ogg');
  if (fs.existsSync(srcFile)) { mkdir(dir); fs.copyFileSync(srcFile, path.join(dir, file)); }
  else { file = name + '.wav'; write(path.join(dir, file), silentWav()); log.push(`MISSING AUDIO: ${name}.ogg is not in the export; wrote a 1s silent placeholder ${file}`); }
  writeJson(path.join(dir, name + '.yy'), {
    compression: s.kind === 1 ? 3 : 1, volume: s.volume, preload: !!s.preload, bitRate: 128, sampleRate: 44100, type: 1, bitDepth: 1,
    audioGroupId: { name: 'audiogroup_default', path: 'audiogroups/audiogroup_default' }, soundFile: file, duration: s.duration || 0.0,
    parent: folder('Sounds'), resourceVersion: '1.0', name, tags: [], resourceType: 'GMSound',
  });
  addRes('sounds', name);
}

// ---------- fonts ----------
for (const f of game.Fonts) {
  const name = f.pName, dir = path.join(OUT, 'fonts', name);
  const tpe = game.TPageEntries[f.TPageEntry];
  write(path.join(dir, name + '.png'), crop(tpe.tp, tpe.x, tpe.y, tpe.w, tpe.h));
  const glyphs = {};
  for (const gl of f.glyphs) glyphs[gl.i] = { x: gl.x, y: gl.y, w: gl.w, h: gl.h, character: gl.i, shift: gl.shift, offset: gl.offset };
  writeJson(path.join(dir, name + '.yy'), {
    hinting: 0, glyphOperations: 0, interpreter: 0, pointRounding: 0, applyKerning: 0,
    fontName: f.fontname, styleName: f.bold ? 'Bold' : 'Regular', size: f.size, bold: f.bold, italic: f.italic, charset: f.charset,
    AntiAlias: f.antialias, first: 0, last: 0, sampleText: 'abcdef ABCDEF\n0123456789 .,<>"\'&!?', includeTTF: false, TTFName: '',
    textureGroupId: { name: 'Default', path: 'texturegroups/Default' }, ascenderOffset: f.ascenderOffset || 0,
    glyphs, kerningPairs: [], ranges: [{ lower: f.first, upper: f.last }],
    regenerateBitmap: false, canGenerateBitmap: true, maintainGms1Font: false,
    parent: folder('Fonts'), resourceVersion: '1.0', name, tags: [], resourceType: 'GMFont',
  });
  addRes('fonts', name);
}

// ---------- paths ----------
for (const p of game.Paths) {
  writeJson(path.join(OUT, 'paths', p.pName, p.pName + '.yy'), {
    kind: p.kind, closed: p.closed, precision: p.precision,
    points: p.points.map(pt => ({ speed: pt.speed, x: pt.x, y: pt.y })),
    parent: folder('Paths'), resourceVersion: '1.0', name: p.pName, tags: [], resourceType: 'GMPath',
  });
  addRes('paths', p.pName);
}

// ---------- shaders (skip runner-internal __yy_ shaders) ----------
const userPart = (s) => { const i = s.indexOf('#define _YY_GLSLES_ 1'); return i >= 0 ? s.slice(i + '#define _YY_GLSLES_ 1'.length).replace(/^\r?\n/, '') : s; };
for (const sh of game.Shaders) {
  if (sh.name.startsWith('__yy')) continue;
  const dir = path.join(OUT, 'shaders', sh.name);
  write(path.join(dir, sh.name + '.vsh'), userPart(sh.Vertex));
  write(path.join(dir, sh.name + '.fsh'), userPart(sh.Fragment));
  writeJson(path.join(dir, sh.name + '.yy'), { type: 1, parent: folder('Shaders'), resourceVersion: '1.0', name: sh.name, tags: [], resourceType: 'GMShader' });
  addRes('shaders', sh.name);
}

// ---------- objects ----------
const EVT = { Create: 0, Destroy: 1, Alarm: 2, Step: 3, Collision: 4, Keyboard: 5, Mouse: 6, Other: 7, Draw: 8, KeyPress: 9, KeyRelease: 10, CleanUp: 12, Gesture: 13 };
const objName = (i) => (i >= 0 && game.GMObjects[i] ? game.GMObjects[i].pName : null);
const objFns = new Map(); // object -> [{fn, type, num, suffix}]
for (const [F] of dc.funcs) {
  if (!F.startsWith('gml_Object_')) continue;
  const rest = F.slice('gml_Object_'.length);
  let m = /^(.*)_([A-Za-z]+)_(\d+)$/.exec(rest), ev;
  const cm = /^(.*?)_Collision_(.+)$/.exec(rest);
  if (cm && game.GMObjects.some(o => o.pName === cm[1])) {
    const idx = game.GMObjects.findIndex(o => o.pName === cm[2]);
    ev = { obj: cm[1], fn: F, type: 'Collision', num: idx, other: cm[2] };
  } else if (m) ev = { obj: m[1], fn: F, type: m[2], num: +m[3] };
  else { log.push('unparsed event fn ' + F); continue; }
  (objFns.get(ev.obj) || objFns.set(ev.obj, []).get(ev.obj)).push(ev);
}

// variable definitions from PreCreate events
const objVars = new Map(); // obj -> {inherited, vars:[{name,value}]}
for (const o of game.GMObjects) {
  const pre = (objFns.get(o.pName) || []).find(e => e.type === 'PreCreate');
  if (pre) {
    const r = dc.preCreateAssignments(pre.fn);
    if (r.other.length) log.push(`${o.pName}: PreCreate has non-assignment statements (moved to top of Create): ${r.other.join(' ').slice(0, 120)}`);
    objVars.set(o.pName, r);
  }
}
const parentOf = (name) => { const o = game.GMObjects.find(x => x.pName === name); return o ? objName(o.parent) : null; };
// root-most ancestor (or self) that declares a variable
function declaringObject(obj, v) {
  let found = null;
  for (let cur = obj; cur; cur = parentOf(cur)) {
    const r = objVars.get(cur);
    if (r && r.vars.some(x => x.name === v)) found = cur;
  }
  return found;
}

const prop = (name, value) => ({ varType: 4, value, rangeEnabled: false, rangeMin: 0.0, rangeMax: 10.0, listItems: [], multiselect: false, filters: [], resourceVersion: '1.0', name, tags: [], resourceType: 'GMObjectProperty' });
const overProp = (declObj, name, value) => ({ propertyId: { name, path: ref('objects', declObj).path }, objectId: ref('objects', declObj), value, resourceVersion: '1.0', name: '', tags: [], resourceType: 'GMOverriddenProperty' });

for (const o of game.GMObjects) {
  const name = o.pName, dir = path.join(OUT, 'objects', name);
  const events = [];
  const pre = objVars.get(name);
  for (const e of objFns.get(name) || []) {
    if (e.type === 'PreCreate') continue;
    if (!(e.type in EVT)) { log.push(`${name}: unknown event type ${e.type}`); continue; }
    let code = dc.eventCode(e.fn);
    if (e.type === 'Create' && pre && pre.other.length) code = pre.other.join('') + code;
    const isCol = e.type === 'Collision';
    write(path.join(dir, isCol ? `Collision_${e.other}.gml` : `${e.type}_${e.num}.gml`), code);
    events.push({ isDnD: false, eventNum: isCol ? 0 : e.num, eventType: EVT[e.type], collisionObjectId: isCol ? ref('objects', e.other) : null, resourceVersion: '1.0', name: '', tags: [], resourceType: 'GMEvent' });
  }
  const properties = [], overridden = [];
  if (pre) for (const v of pre.vars) {
    const decl = declaringObject(name, v.name);
    if (decl === name) properties.push(prop(v.name, v.value));
    else overridden.push(overProp(decl, v.name, v.value));
  }
  const spr = spriteName(o.spriteIndex), mask = o.spriteMask !== undefined ? spriteName(o.spriteMask) : null, par = objName(o.parent);
  mkdir(dir);
  writeJson(path.join(dir, name + '.yy'), {
    spriteId: spr ? ref('sprites', spr) : null, solid: !!o.solid, visible: o.visible !== false, managed: true,
    spriteMaskId: mask ? ref('sprites', mask) : null, persistent: !!o.persistent, parentObjectId: par ? ref('objects', par) : null,
    physicsObject: false, physicsSensor: false, physicsShape: 1, physicsGroup: 1, physicsDensity: 0.5, physicsRestitution: 0.1,
    physicsLinearDamping: 0.1, physicsAngularDamping: 0.1, physicsFriction: 0.2, physicsStartAwake: true, physicsKinematic: false, physicsShapePoints: [],
    eventList: events, properties, overriddenProperties: overridden,
    parent: folder('Objects'), resourceVersion: '1.0', name, tags: [], resourceType: 'GMObject',
  });
  addRes('objects', name);
}

// ---------- scripts ----------
for (const [F] of dc.funcs) {
  if (!F.startsWith('gml_GlobalScript_')) continue;
  const name = F.slice('gml_GlobalScript_'.length), dir = path.join(OUT, 'scripts', name);
  let code = dc.globalScript(F);
  // Native targets may enable linear filtering by default. It blends palette
  // markers before the uniform shader can replace them, leaving neon colors.
  if (name === 's_startup') code = code.replace('function s_startup() {',
    'function s_startup() {\n\t// Palette replacement requires exact sprite colors before scaling.\n\tgpu_set_texfilter(false);');
  write(path.join(dir, name + '.gml'), code);
  writeJson(path.join(dir, name + '.yy'), { isDnD: false, isCompatibility: false, parent: folder('Scripts'), resourceVersion: '1.0', name, tags: [], resourceType: 'GMScript' });
  addRes('scripts', name);
}

// ---------- rooms ----------
const instName = (id) => dc.roomInstName(id);
for (const rm of game.GMRooms) {
  const name = rm.pName, dir = path.join(OUT, 'rooms', name), r = ref('rooms', name);
  mkdir(dir);
  const instById = new Map(rm.pInstances.map(i => [i.id, i]));
  const layers = [];
  for (const L of rm.layers) {
    const common = {
      visible: !!L.visible, depth: L.depth, userdefinedDepth: false, inheritLayerDepth: false, inheritLayerSettings: false,
      gridX: 32, gridY: 32, layers: [], hierarchyFrozen: false, effectEnabled: L.effectEnabled !== 0, effectType: L.effectType || null,
      properties: [], resourceVersion: '1.0', name: L.pName, tags: [],
    };
    if (L.type === 2) {
      const instances = (L.iinstIDs || []).map(id => {
        const ins = instById.get(id);
        const obj = objName(ins.index);
        const iname = instName(id);
        const cc = fnName(ins.pCode);
        const ccText = cc ? dc.eventCode(cc) : '';
        if (ccText.trim()) write(path.join(dir, `InstanceCreationCode_${iname}.gml`), ccText);
        const props = [];
        const pcc = fnName(ins.pPreCreateCode);
        if (pcc) {
          const res = dc.preCreateAssignments(pcc);
          for (const v of res.vars) {
            const decl = declaringObject(obj, v.name);
            if (decl) props.push(overProp(decl, v.name, v.value));
            else log.push(`${name}/${iname}: override of undeclared variable ${v.name} (no definition on ${obj}); kept as creation code`) ;
          }
          const undeclared = res.vars.filter(v => !declaringObject(obj, v.name));
          if (undeclared.length || res.other.length) {
            const extra = undeclared.map(v => `${v.name} = ${v.value};\n`).join('') + res.other.join('');
            const f = path.join(dir, `InstanceCreationCode_${iname}.gml`);
            write(f, extra + (fs.existsSync(f) ? fs.readFileSync(f, 'utf8') : ''));
          }
        }
        const hasCC = fs.existsSync(path.join(dir, `InstanceCreationCode_${iname}.gml`));
        return {
          properties: props, isDnd: false, objectId: ref('objects', obj), inheritCode: false, hasCreationCode: hasCC,
          colour: ins.colour >>> 0, rotation: ins.rotation, scaleX: ins.scaleX, scaleY: ins.scaleY, imageIndex: ins.imageIndex, imageSpeed: ins.imageSpeed,
          inheritedItemId: null, frozen: false, ignore: false, inheritItemSettings: false, x: ins.x, y: ins.y,
          resourceVersion: '1.0', name: iname, tags: [], resourceType: 'GMRInstance',
        };
      });
      layers.push(Object.assign({ instances }, common, { resourceType: 'GMRInstanceLayer' }));
    } else if (L.type === 1) {
      const spr = spriteName(L.bindex);
      layers.push(Object.assign({
        spriteId: spr ? ref('sprites', spr) : null, colour: L.bblend >>> 0, x: L.x, y: L.y, htiled: !!L.bhtiled, vtiled: !!L.bvtiled,
        hspeed: L.hspeed, vspeed: L.vspeed, stretch: !!L.bstretch, animationFPS: L.bimage_speed, animationSpeedType: 0, userdefinedAnimFPS: false,
      }, common, { visible: L.bvisible !== false && !!L.visible, resourceType: 'GMRBackgroundLayer' }));
    } else if (L.type === 3) {
      if ((L.assets && L.assets.length) || (L.sprites && L.sprites.length) || (L.sequences && L.sequences.length)) log.push(`${name}: asset layer ${L.pName} has content that was not converted`);
      layers.push(Object.assign({ assets: [] }, common, { resourceType: 'GMRAssetLayer' }));
    } else log.push(`${name}: unsupported layer type ${L.type}`);
  }
  const views = [];
  for (let i = 0; i < 8; i++) {
    const v = rm.views[i] || {};
    views.push({
      inherit: false, visible: !!v.visible, xview: v.xview || 0, yview: v.yview || 0, wview: v.wview || 1366, hview: v.hview || 768,
      xport: v.xport || 0, yport: v.yport || 0, wport: v.wport || 1366, hport: v.hport || 768,
      hborder: v.hborder !== undefined ? v.hborder : 32, vborder: v.vborder !== undefined ? v.vborder : 32,
      hspeed: v.hspeed !== undefined ? v.hspeed : -1, vspeed: v.vspeed !== undefined ? v.vspeed : -1,
      objectId: v.index !== undefined && v.index >= 0 && objName(v.index) ? ref('objects', objName(v.index)) : null,
    });
  }
  let ccFile = '';
  const rcc = fnName(rm.pCode);
  if (rcc && dc.eventCode(rcc).trim()) { write(path.join(dir, 'RoomCreationCode.gml'), dc.eventCode(rcc)); ccFile = `\${project_dir}/rooms/${name}/RoomCreationCode.gml`; }
  writeJson(path.join(dir, name + '.yy'), {
    isDnd: false, volume: 1.0, parentRoom: null, views, layers, inheritLayers: false, creationCodeFile: ccFile, inheritCode: false,
    instanceCreationOrder: rm.pInstances.map(i => ({ name: instName(i.id), path: r.path })), inheritCreationOrder: false, sequenceId: null,
    roomSettings: { inheritRoomSettings: false, Width: rm.width, Height: rm.height, persistent: !!rm.persistent },
    viewSettings: { inheritViewSettings: false, enableViews: !!rm.enableViews, clearViewBackground: !!rm.viewClearScreen, clearDisplayBuffer: true },
    physicsSettings: { inheritPhysicsSettings: false, PhysicsWorld: false, PhysicsWorldGravityX: 0.0, PhysicsWorldGravityY: 10.0, PhysicsWorldPixToMetres: 0.1 },
    parent: folder('Rooms'), resourceVersion: '1.0', name, tags: [], resourceType: 'GMRoom',
  });
  addRes('rooms', name);
}

// ---------- orphan script functions (extension GML, e.g. Poki) ----------
const orphans = [...dc.funcs.keys()].filter(n => n.startsWith('gml_Script_') && !dc.fnDefined.has(n));
if (orphans.length) {
  const name = 'poki_gml', dir = path.join(OUT, 'scripts', name);
  let code = '// Functions that shipped inside the Poki extension (recovered from the HTML5 build).\n\n';
  for (const F of orphans) code += dc.functionText(F, dc.scriptName(F), '') + '\n\n';
  write(path.join(dir, name + '.gml'), code);
  writeJson(path.join(dir, name + '.yy'), { isDnD: false, isCompatibility: false, parent: folder('Scripts'), resourceVersion: '1.0', name, tags: [], resourceType: 'GMScript' });
  addRes('scripts', name);
}

// functions called by game code that are not GML built-ins (runner), scripts, or extension functions
function unknownCallsFor() {
  const known = new Set([...runnerSrc.matchAll(/(?:^|\n)\s*function\s+([a-z_][a-z0-9_]*)\s*\(/g)].map(m => m[1]));
  for (const m of runnerSrc.matchAll(/(?:^|\n)\s*var\s+([a-z_][a-z0-9_]*)\s*=/g)) known.add(m[1]);
  for (const e of game.Extensions.filter(x => x.name)) for (const jf of e.jsFiles || [])
    for (const m of fs.readFileSync(path.join(H5, jf), 'utf8').matchAll(/^function\s+(\w+)/gm)) known.add(m[1]);
  const scriptFns = new Set(dc.fnName.values());
  const res = {};
  for (const [F, fn] of dc.funcs) {
    if (!F.startsWith('gml_')) continue;
    const walk = (n) => {
      if (!n || typeof n.type !== 'string') return;
      if (n.type === 'CallExpression' && n.callee.type === 'Identifier') {
        const c = n.callee.name;
        if (c.startsWith('gml_') ? !dc.funcs.has(c) : /^[a-z]/.test(c) && !c.startsWith('yy') && !known.has(c) && !scriptFns.has(c)) res[c] = (res[c] || 0) + 1;
      }
      for (const k in n) { const v = n[k]; if (Array.isArray(v)) v.forEach(walk); else if (v && typeof v.type === 'string') walk(v); }
    };
    walk(fn.body);
  }
  return res;
}

// ---------- stubs for console-only (Nintendo Switch) functions the HTML5 build never calls ----------
{
  const stubs = Object.keys(unknownCallsFor()).filter(n => /^switch_/.test(n));
  if (stubs.length) {
    const name = 'switch_stubs', dir = path.join(OUT, 'scripts', name);
    let code = '// Nintendo Switch-only functions referenced by the game. Only called when os_type == os_switch.\n// Stubs so the project compiles without the Switch export module. Delete this script if you have it.\n\n';
    for (const s of stubs) code += `function ${s}() { return 0; }\n`;
    write(path.join(dir, name + '.gml'), code);
    writeJson(path.join(dir, name + '.yy'), { isDnD: false, isCompatibility: false, parent: folder('Scripts'), resourceVersion: '1.0', name, tags: [], resourceType: 'GMScript' });
    addRes('scripts', name);
  }
}

// ---------- extension (Poki JS) ----------
for (const ext of game.Extensions.filter(e => e.name)) {
  const dir = path.join(OUT, 'extensions', ext.name);
  const files = [];
  for (const jf of ext.jsFiles || []) {
    const js = fs.readFileSync(path.join(H5, jf), 'utf8');
    write(path.join(dir, jf), js);
    const functions = [...js.matchAll(/^function\s+(\w+)\s*\(([^)]*)\)/gm)].map(m => {
      const args = m[2].split(',').map(s => s.trim()).filter(Boolean);
      return { externalName: m[1], kind: 5, help: '', hidden: false, returnType: 2, argCount: args.length, args: args.map(() => 2), resourceVersion: '1.0', name: m[1], tags: [], resourceType: 'GMExtensionFunction' };
    });
    files.push({
      filename: jf, origname: '', init: '', final: '', kind: 5, uncompress: false, functions, constants: [], ProxyFiles: [],
      copyToTargets: -1, order: functions.map(f => ({ name: f.name, path: `extensions/${ext.name}/${ext.name}.yy` })),
      resourceVersion: '1.0', name: '', tags: [], resourceType: 'GMExtensionFile',
    });
  }
  writeJson(path.join(dir, ext.name + '.yy'), {
    optionsFile: 'options.json', options: [], exportToGame: true, supportedTargets: -1, extensionVersion: ext.version || '1.0.0',
    packageId: '', productId: '', author: '', date: '2023-10-25T00:00:00', license: '', description: '', helpfile: '',
    iosProps: false, tvosProps: false, androidProps: false, installdir: '', files,
    classname: '', tvosclassname: null, tvosdelegatename: null, iosdelegatename: '', androidclassname: '', sourcedir: '', androidsourcedir: '',
    macsourcedir: '', maccompilerflags: '', tvosmaccompilerflags: '', maclinkerflags: '', tvosmaclinkerflags: '', iosplistinject: '', tvosplistinject: '',
    androidinject: '', androidmanifestinject: '', androidactivityinject: '', gradleinject: '', androidcodeinjection: '', hasConvertedCodeInjection: true,
    ioscodeinjection: '', tvoscodeinjection: '', iosSystemFrameworkEntries: [], tvosSystemFrameworkEntries: [], iosThirdPartyFrameworkEntries: [],
    tvosThirdPartyFrameworkEntries: [], IncludedResources: [], androidPermissions: [], copyToTargets: -1, iosCocoaPods: '', tvosCocoaPods: '',
    iosCocoaPodDependencies: '', tvosCocoaPodDependencies: '', parent: folder('Extensions'), resourceVersion: '1.2', name: ext.name, tags: [], resourceType: 'GMExtension',
  });
  addRes('extensions', ext.name);
}

// ---------- included files ----------
const included = [];
const skipH5 = (f) => /^RetroBowl(_texture_\d+\.png|\.js)$/.test(f) || /^snd_.*\.ogg$/.test(f) || f === 'splash.png' || f === 'uph_poki.js' || f === 'sound';
(function walk(rel) {
  for (const f of fs.readdirSync(path.join(H5, rel))) {
    const full = path.join(H5, rel, f);
    if (!rel && skipH5(f)) continue;
    if (fs.statSync(full).isDirectory()) { walk(path.join(rel, f)); continue; }
    const dest = path.join(OUT, 'datafiles', rel, f);
    mkdir(path.dirname(dest)); fs.copyFileSync(full, dest);
    included.push({ CopyToMask: -1, filePath: ('datafiles/' + rel.replace(/\\/g, '/')).replace(/\/$/, ''), resourceVersion: '1.0', name: f, resourceType: 'GMIncludedFile' });
  }
})('');

// ---------- options & project ----------
const opt = game.Options;
writeJson(path.join(OUT, 'options', 'main', 'options_main.yy'), {
  option_gameguid: opt.gameGuid || guid(PROJ), option_gameid: '0', option_game_speed: opt.GameSpeed, option_mips_for_3d_textures: false,
  option_draw_colour: opt.DrawColour >>> 0, option_window_colour: 255, option_steam_app_id: '0', option_sci_usesci: false, option_author: '',
  option_collision_compatibility: !!opt.CollisionCompatibility, option_copy_on_write_enabled: true, option_lastchanged: '', option_spine_licence: false,
  option_template_image: '${base_options_dir}/main/template_image.png', option_template_icon: '${base_options_dir}/main/template_icon.png',
  option_template_description: null, resourceVersion: '1.4', name: 'Main', tags: [], resourceType: 'GMMainOptions',
});
const folders = ['Sprites', 'Sounds', 'Paths', 'Scripts', 'Shaders', 'Fonts', 'Objects', 'Rooms', 'Extensions', 'Notes', 'Sequences', 'Tile Sets', 'Timelines', 'Animation Curves']
  .map((n, i) => ({ folderPath: `folders/${n}.yy`, order: i + 1, resourceVersion: '1.0', name: n, tags: [], resourceType: 'GMFolder' }));
writeJson(path.join(OUT, PROJ + '.yyp'), {
  resources,
  Options: [{ name: 'Main', path: 'options/main/options_main.yy' }],
  defaultScriptType: 1, isEcma: false, configs: { name: 'Default', children: [] },
  RoomOrderNodes: game.RoomOrder.map(i => ({ roomId: ref('rooms', game.GMRooms[i].pName) })),
  Folders: folders,
  AudioGroups: [{ targets: '__ALL_TARGETS__', resourceVersion: '1.3', name: 'audiogroup_default', resourceType: 'GMAudioGroup' }],
  TextureGroups: [{ isScaled: true, autocrop: true, border: 2, mipsToGenerate: 0, groupParent: null, targets: '__ALL_TARGETS__', resourceVersion: '1.3', name: 'Default', resourceType: 'GMTextureGroup' }],
  IncludedFiles: included,
  MetaData: { IDEVersion: '2022.0.2.51' },
  resourceVersion: '1.6', name: PROJ, tags: [], resourceType: 'GMProject',
});

// ---------- report ----------
const unknownCalls = unknownCallsFor();
const usedInst = [...dc.roomInstNames.keys()].filter(id => !game.GMRooms.some(r => r.pInstances.some(i => i.id === id)));
if (usedInst.length) log.push('code references room instance ids that exist in no room: ' + usedInst.join(', '));
const counts = {}; for (const r of resources) { const t = r.id.path.split('/')[0]; counts[t] = (counts[t] || 0) + 1; }
const report = {
  resources: counts, includedFiles: included.length, roomInstances: game.GMRooms.reduce((a, r) => a + r.pInstances.length, 0),
  decompilerIssues: Object.fromEntries([...dc.issues].map(([k, v]) => [k, v.count])),
  unresolvedCalls: unknownCalls, notes: [...new Set(log)],
};
writeJson(path.join(OUT, '..', PROJ + '_conversion_report.json'), report);
console.log(JSON.stringify(report, null, 2));
