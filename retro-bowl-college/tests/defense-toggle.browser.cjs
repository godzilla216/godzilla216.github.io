const assert = require('node:assert/strict');
const path = require('node:path');
const os = require('node:os');
const { openGame } = require('./browser-harness.cjs');
async function main() {
    const game = await openGame(), ev = game.evaluate;
    try {
        await ev('room_goto(asset_get_index("rm_options"));true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_options" && GetWithArray(100318).length===1');
        assert.deepEqual(await ev('[GetWithArray(100317)[0].visible,GetWithArray(100317)[0].gmltext,GetWithArray(100318)[0].visible,GetWithArray(100318)[0].gmltext]'), [true, 'PLAYABLE DEFENSE', true, 'ON']);
        await game.sleep(150);
        const preview = path.join(os.tmpdir(), 'retro-defense-toggle.png');
        await game.screenshot(preview);
        console.log('Options preview: ' + preview);
        assert.equal(await ev('(function(){var b=GetWithArray(100318)[0];script_execute(b,b,b.gmlonClickAction);return b.gmltext;})()'), 'OFF');
        assert.equal(await ev('RetroDefense.shouldPlay({gmlpossession:1,gmlhuman_team:0,gmlcomm_stage:3})'), false);
        assert.equal(await ev('RetroPunt.eligible({gmlpossession:1,gmlhuman_team:0,gmldown:4})'), false);
        await ev('gml_Script_s_update_options(GetWithArray(98)[0],GetWithArray(98)[0]);true');
        assert.equal(await ev('GetWithArray(100318)[0].gmltext'), 'OFF');
        await game.send('Page.reload');
        await game.until('typeof RetroDefense!=="undefined" && typeof GetWithArray==="function" && GetWithArray(98).length===1 && g_pBuiltIn.room===2');
        assert.equal(await ev('RetroDefense.isEnabled()'), false);
        await ev('room_goto(asset_get_index("rm_options"));true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_options" && GetWithArray(100318).length===1');
        assert.equal(await ev('(function(){var b=GetWithArray(100318)[0];script_execute(b,b,b.gmlonClickAction);return b.gmltext;})()'), 'ON');
        assert.equal(await ev('RetroDefense.shouldPlay({gmlpossession:1,gmlhuman_team:0,gmlcomm_stage:3})'), true);
        assert.equal(game.errors.length, 0, JSON.stringify(game.errors));
        console.log('PASS: native Options toggle, simulation gates, refresh, reload persistence and re-enabling');
    } finally { await game.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });

