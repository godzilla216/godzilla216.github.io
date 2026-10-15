const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { openGame } = require('./browser-harness.cjs');
async function main() {
    const game = await openGame(), ev = game.evaluate;
    const folder = fs.mkdtempSync(path.join(require('node:os').tmpdir(), 'retro-cpu-field-goals-'));
    try {
        await ev('(function(){var c=GetWithArray(98)[0];gml_Script_s_msg_clear(c,c);gml_Script_btn_click_Details_Continue(c,c);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_home"');
        await ev('(function(){var c=GetWithArray(98)[0];c.gmlintro=0;c.gmltimeout_message_done=true;c.gmlbullet_throw_message_done=true;c.gmlstage=2;gml_Script_s_play(c,c,1);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_pre_match"');
        await ev('gml_Script_btn_click_Continue(GetWithArray(100400)[0],GetWithArray(98)[0]);true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_match"&&GetWithArray(105).length===1');
        await ev(`window.cpuKickTest={setup:function(orientation,miss,scrim){
            var m=GetWithArray(105)[0],c=GetWithArray(98)[0];gml_Script_s_msg_clear(m,m);gml_Script_s_destroy_match_objects(m,m);
            ds_map_set(c.gmlmap_options,'op_replays',0);ds_map_set(c.gmlmap_options,'op_kickoffs',0);
            c.gmltag_kr_message_done=3;
            m.gmlstate=2;m.gmlcomm_stage=3;m.gmlcomm_proceed=false;m.gmlkicking=0;m.gmlquarter=1;m.gmlcollege_overtime=false;
            m.gmlpossession=1-Number(m.gmlhuman_team);m.gmldown=4;m.gmlyards=10;m.gmlscrimmage=scrim===undefined?45:scrim;m.gmldrivedir=orientation;
            m.gmlminutes=2;m.gmlseconds=0;m.gmltime_subtract=0;m.alarm[0]=-1;m.alarm[1]=-1;random_set_seed(1234);
            var before=m.gmlteam_score.slice();gml_Script_s_set_up_play(m,m,true);
            var b=GetWithArray(global.gmlmaster_ball)[0];b.gmlkicky=miss?450:300;
            return {team:Number(m.gmlpossession),human:Number(m.gmlhuman_team),before:before,ball:b.id,kicker:b.gmlholder,dir:m.gmldrivedir};
        }};true`);
        for (const orientation of [-1, 1]) for (const miss of [false, true]) {
            const initial = await ev(`cpuKickTest.setup(${orientation},${miss})`);
            assert.equal(initial.dir, -orientation);
            assert.equal(await ev('RetroDefense.cpuFieldGoal(GetWithArray(105)[0])'), true);
            await game.screenshot(path.join(folder, `${orientation}-${miss ? 'miss' : 'make'}-setup.png`));
            await game.until(`GetWithArray(${initial.ball})[0]&&GetWithArray(${initial.ball})[0].gmlstate===3`);
            const flight = await ev(`(function(){var b=GetWithArray(${initial.ball})[0];return {x:b.x,height:b.gmlheight,velocity:b.gmlvelocity,holder:b.gmlholder};})()`);
            assert(flight.velocity>0);assert.equal(flight.holder,-4);
            await game.sleep(650);
            assert.notEqual(await ev(`GetWithArray(${initial.ball})[0].x`), flight.x);
            assert.equal(await ev(`(function(){var b=GetWithArray(${initial.ball})[0],cam=g_pBuiltIn.view_camera[0];return !b.gmlhidden&&b.x>camera_get_view_x(cam)&&b.x<camera_get_view_x(cam)+camera_get_view_width(cam)&&b.y-b.gmlheight>=camera_get_view_y(cam);})()`),true);
            await game.screenshot(path.join(folder, `${orientation}-${miss ? 'miss' : 'make'}-flight.png`));
            if (!miss) {
                await game.until('GetWithArray(105)[0].gmlkicking===3&&GetWithArray(105)[0].gmldown===99',30000);
                const kickoff = await ev('(function(){var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0];return {score:m.gmlteam_score.slice(),possession:Number(m.gmlpossession),dir:m.gmldrivedir,ball:b&&b.id,players:GetWithArray(107).length};})()');
                assert.equal(kickoff.score[initial.team],initial.before[initial.team]+3);
                assert.equal(kickoff.score[initial.human],initial.before[initial.human]);
                assert.equal(kickoff.possession,initial.team);assert.equal(kickoff.dir,orientation);
                assert.notEqual(kickoff.ball,initial.ball);assert.equal(kickoff.players,22);
                await game.until('GetWithArray(global.gmlmaster_ball)[0].gmlstate===3');
                await game.screenshot(path.join(folder,`${orientation}-kickoff.png`));
                console.log(`PASS: CPU field goal animates, flies, scores once and launches a real kickoff in orientation ${orientation}`);
            } else {
                await game.until('Number(GetWithArray(105)[0].gmlpossession)===Number(GetWithArray(105)[0].gmlhuman_team)&&GetWithArray(105)[0].gmlstate===2&&GetWithArray(105)[0].gmlkicking===0',30000);
                const result=await ev('(function(){var m=GetWithArray(105)[0];return {score:m.gmlteam_score.slice(),down:m.gmldown,kicking:m.gmlkicking,dir:m.gmldrivedir,live:RetroDefense.cpuFieldGoal(m)};})()');
                assert.deepEqual(result.score,initial.before);assert.equal(result.down,1);assert.equal(result.kicking,0);assert.equal(result.dir,orientation);assert.equal(result.live,false);
                assert.equal(await ev('GetWithArray(98)[0].gmltag_kr_message_done'),3);
                console.log(`PASS: CPU missed field goal flies wide, awards no points and gives the human first down in orientation ${orientation}`);
            }
        }
        for (const orientation of [-1,1]) {
            assert.equal(await ev(`(function(){cpuKickTest.setup(${orientation},false,0);var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(b.gmlholder)[0],cam=g_pBuiltIn.view_camera[0];
                var ready=p.x>camera_get_view_x(cam)&&p.x<camera_get_view_x(cam)+camera_get_view_width(cam);
                b.gmlstate=3;b.x=m.gmldrivedir===1?2250:350;RetroDefense.cpuKickCamera(m);
                return ready&&b.x>camera_get_view_x(cam)&&b.x<camera_get_view_x(cam)+camera_get_view_width(cam);})()`),true);
        }
        console.log('PASS: long-attempt camera frames the kicker and follows flight in both directions');
        assert.equal(game.errors.length,0,JSON.stringify(game.errors));assert.equal(game.external.length,0);
        console.log('No runtime errors or external requests. Screenshots: '+folder);
    } finally {await game.close();}
}
main().catch(error=>{console.error(error);process.exitCode=1;});
