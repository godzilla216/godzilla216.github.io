const assert = require('node:assert/strict');
const { openGame } = require('./browser-harness.cjs');
async function main() {
    const game = await openGame(), ev = game.evaluate;
    try {
        await ev('(function(){var c=GetWithArray(98)[0];gml_Script_s_msg_clear(c,c);gml_Script_btn_click_Details_Continue(c,c);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_home"');
        await ev('(function(){var c=GetWithArray(98)[0];c.gmlintro=0;c.gmltimeout_message_done=true;c.gmlbullet_throw_message_done=true;c.gmlstage=2;gml_Script_s_play(c,c,1);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_pre_match"');
        await ev('gml_Script_btn_click_Continue(GetWithArray(100400)[0],GetWithArray(98)[0]);true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_match"&&GetWithArray(105).length===1');
        await ev(`window.hbTest={
            setup:function(dir, force){
                var m=GetWithArray(105)[0], original=RetroHalfbackPass.afterSetup;
                gml_Script_s_msg_clear(m,m);gml_Script_s_destroy_match_objects(m,m);
                m.gmlstate=2;m.gmlcomm_stage=3;m.gmlcomm_proceed=false;m.gmlkicking=0;
                m.gmlpossession=Number(m.gmlhuman_team);m.gmldown=1;m.gmlyards=10;m.gmlscrimmage=-25;
                m.gmldrivedir=dir;m.gmlminutes=2;m.gmlseconds=0;m.gmltime_subtract=0;m.alarm[0]=-1;m.alarm[1]=-1;
                RetroHalfbackPass.afterSetup=function(m){var rand=irandom;try{irandom=function(n){return n===14?(force?0:1):rand(n);};original(m);}finally{irandom=rand;}};
                var philly=RetroPhillySpecial.afterSetup;RetroPhillySpecial.afterSetup=RetroPhillySpecial.reset;try{gml_Script_s_set_up_play(m,m,true);}finally{RetroHalfbackPass.afterSetup=original;RetroPhillySpecial.afterSetup=philly;}
                GetWithArray(109).forEach(function(p){p.x=2200;p.y=440;});
                return !!m._halfbackPass;
            },
            info:function(){var m=GetWithArray(105)[0],s=m._halfbackPass,b=GetWithArray(global.gmlmaster_ball)[0];return {phase:s&&s.phase,state:b.gmlstate,holder:b.gmlholder,running:m.gmlrunning_play,qb:s&&s.qb,rb:s&&s.rb};},
            point:function(x,y){var rect=document.getElementById('canvas').getBoundingClientRect(),c=g_pBuiltIn.view_camera[0];return {x:rect.left+(x-camera_get_view_x(c))/camera_get_view_width(c)*rect.width,y:rect.top+(y-camera_get_view_y(c))/camera_get_view_height(c)*rect.height};}
        };true`);
        for (const dir of [1, -1]) {
            await ev(`hbTest.setup(${dir},false);true`);
            const before = await ev(`(function(){var m=GetWithArray(105)[0],rand=irandom;
                try{irandom=function(){return 0;};RetroJetSweep.afterSetup(m);}finally{irandom=rand;}
                var s=m._jetSweep,q=GetWithArray(s.qb)[0],r=GetWithArray(s.receiver)[0];window.jetTest={nativeUpdate:RetroJetSweep.updateBall,flight:null};RetroJetSweep.updateBall=function(b){var result=jetTest.nativeUpdate(b),s=m._jetSweep;if(s&&s.phase==="touch"&&s.frame>=2&&!jetTest.flight)jetTest.flight={state:b.gmlstate,holder:b.gmlholder,x:b.x,origin:b.gmlxthrow,hidden:b.gmlhidden};return result;};
                return {receiver:s.receiver,qb:s.qb,qx:q.x,qy:q.y,rx:r.x,ry:r.y,side:s.side,
                    blockers:s.blockers.map(function(id){var p=GetWithArray(id)[0];return {id:id,x:p.x,y:p.y};}),
                    attempts:q.gmlpmap>=0?ds_map_find_value(q.gmlpmap,'stat_attempts'):null};})()`);
            assert.equal(await ev('RetroJetSweep.locked()'), true);
            assert.equal(await ev('gml_Script_s_can_throw(GetWithArray(global.gmlmaster_ball)[0],GetWithArray(global.gmlmaster_ball)[0])'), false);
            const point = await ev('(function(){var r=document.getElementById("canvas").getBoundingClientRect();return {x:r.left+r.width/2,y:r.top+r.height/2};})()');
            // A full passing drag must still produce only the prescribed touch pass.
            await game.send('Input.dispatchMouseEvent', { type: 'mousePressed', ...point, button: 'left', clickCount: 1 });
            await game.until('GetWithArray(105)[0]._jetSweep.phase==="motion"');
            await game.send('Input.dispatchMouseEvent', { type: 'mouseMoved', x: point.x - dir * 120, y: point.y, button: 'left', buttons: 1 });
            await game.sleep(150);
            await game.send('Input.dispatchMouseEvent', { type: 'mouseReleased', x: point.x - dir * 120, y: point.y, button: 'left', clickCount: 1 });
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlholder'), before.qb);
            assert.equal(await ev('GetWithArray(105)[0].gmlrunning_play'), false);
            assert.equal(await ev(`GetWithArray(${before.qb})[0].x`), before.qx);
            await game.until('jetTest.flight!==null', 7000);
            const flight = await ev('jetTest.flight');
            assert.equal(flight.state, 3);
            assert.equal(flight.holder, -4);
            assert.equal(flight.hidden, false);
            assert((flight.x - flight.origin) * dir > 0, 'touch pass must travel forward');
            await game.until('GetWithArray(105)[0]._jetSweep.phase==="run"');
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlholder'), before.receiver);
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlstate'), 5);
            assert.equal(await ev('gml_Script_s_can_throw(GetWithArray(global.gmlmaster_ball)[0],GetWithArray(global.gmlmaster_ball)[0])'), false);
            assert((await ev(`GetWithArray(${before.receiver})[0].y`) - before.ry) * before.side > 60, 'receiver crosses the formation');
            const shifted = await ev(`(${JSON.stringify(before.blockers)}).filter(function(old){var p=GetWithArray(old.id)[0];return Math.hypot(p.x-old.x,p.y-old.y)>8;}).length`);
            assert(shifted >= 2, 'multiple blockers shift toward sweep');
            await game.sleep(200);
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlholder'), before.receiver);
            if (before.attempts !== null) assert.equal(await ev(`ds_map_find_value(GetWithArray(${before.qb})[0].gmlpmap,'stat_attempts')`), before.attempts + 1);
            if (process.argv.includes('--screenshots')) await game.screenshot(require('node:path').join(require('node:os').tmpdir(), 'jet-sweep-' + dir + '.png'));
            await ev('RetroJetSweep.updateBall=jetTest.nativeUpdate;true');
            console.log('PASS: forced forward touch, receiver motion, shifted blockers and locked QB in direction ' + dir);
        }
        await ev('hbTest.setup(1,false);true');
        const frequency = await ev(`(function(){var m=GetWithArray(105)[0],jet=0,halfback=0,overlap=0;random_set_seed(11315);
            for(var i=0;i<3900;i++){RetroHalfbackPass.afterSetup(m);RetroJetSweep.afterSetup(m);if(m._halfbackPass)halfback++;if(m._jetSweep)jet++;if(m._halfbackPass&&m._jetSweep)overlap++;}
            return {jet:jet,halfback:halfback,overlap:overlap};})()`);
        assert(frequency.jet > 240 && frequency.jet < 360, JSON.stringify(frequency));
        assert(frequency.halfback > 200 && frequency.halfback < 320, JSON.stringify(frequency));
        assert.equal(frequency.overlap, 0);
        for (const mode of ['gmlqb_mode', 'gmlsim_action', 'gmlgamepractice']) {
            assert.equal(await ev(`(function(){var c=GetWithArray(98)[0],m=GetWithArray(105)[0];m._halfbackPass=null;c.${mode}=true;RetroJetSweep.afterSetup(m);c.${mode}=false;return !!m._jetSweep;})()`), false);
        }
        assert.equal(await ev('(function(){var m=GetWithArray(105)[0];m.gmlpossession=1-Number(m.gmlhuman_team);RetroJetSweep.afterSetup(m);return !!m._jetSweep;})()'), false);
        await ev('hbTest.setup(1,false);gml_Script_s_destroy_match_objects(GetWithArray(105)[0],GetWithArray(105)[0]);true');
        assert.equal(await ev('GetWithArray(105)[0]._jetSweep'), null);
        assert.equal(game.errors.length, 0, JSON.stringify(game.errors));
        console.log('PASS: exclusive selection rates, excluded modes and reset: ' + JSON.stringify(frequency));
    } finally { await game.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });
