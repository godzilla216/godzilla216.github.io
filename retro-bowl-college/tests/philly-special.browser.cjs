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
                var jet=RetroJetSweep.afterSetup,philly=RetroPhillySpecial.afterSetup;RetroJetSweep.afterSetup=RetroJetSweep.reset;RetroPhillySpecial.afterSetup=RetroPhillySpecial.reset;try{gml_Script_s_set_up_play(m,m,true);}finally{RetroHalfbackPass.afterSetup=original;RetroJetSweep.afterSetup=jet;RetroPhillySpecial.afterSetup=philly;}
                GetWithArray(109).forEach(function(p){p.x=2200;p.y=440;});
                return !!m._halfbackPass;
            },
            info:function(){var m=GetWithArray(105)[0],s=m._halfbackPass,b=GetWithArray(global.gmlmaster_ball)[0];return {phase:s&&s.phase,state:b.gmlstate,holder:b.gmlholder,running:m.gmlrunning_play,qb:s&&s.qb,rb:s&&s.rb};},
            point:function(x,y){var rect=document.getElementById('canvas').getBoundingClientRect(),c=g_pBuiltIn.view_camera[0];return {x:rect.left+(x-camera_get_view_x(c))/camera_get_view_width(c)*rect.width,y:rect.top+(y-camera_get_view_y(c))/camera_get_view_height(c)*rect.height};}
        };true`);
        for (const [dir, scrim] of [[1, -25], [-1, -25], [1, 49]]) {
            await ev(`hbTest.setup(${dir},false);true`);
            if (scrim > 0) await ev(`(function(){var m=GetWithArray(105)[0],delta=(${scrim}-m.gmlscrimmage)*20*m.gmldrivedir;m.gmlscrimmage=${scrim};m.gmlx_scrim+=delta;GetWithArray(108).forEach(function(p){p.x+=delta;});GetWithArray(109).forEach(function(p){p.x=500;p.y=145;});return true;})()`);
            const before = await ev(`(function(){var m=GetWithArray(105)[0],rand=irandom;try{irandom=function(){return 0;};RetroPhillySpecial.afterSetup(m);}finally{irandom=rand;}
                var s=m._phillySpecial,q=GetWithArray(s.qb)[0],rb=GetWithArray(s.rb)[0],te=GetWithArray(s.te)[0];
                window.phillyTest={phases:[],holders:[],throws:[],nativeThrow:gml_Script_s_throw_ball,nativeUpdate:RetroPhillySpecial.updateBall};
                gml_Script_s_throw_ball=function(b,o){var holder=b.gmlholder,previous=b.gmlstate,result=phillyTest.nativeThrow(b,o);if(previous!==3&&b.gmlstate===3)phillyTest.throws.push(holder);return result;};
                RetroPhillySpecial.updateBall=function(b){var result=phillyTest.nativeUpdate(b),s=m._phillySpecial;if(s){if(phillyTest.phases[phillyTest.phases.length-1]!==s.phase)phillyTest.phases.push(s.phase);if(phillyTest.holders[phillyTest.holders.length-1]!==b.gmlholder)phillyTest.holders.push(b.gmlholder);}return result;};
                return {qb:s.qb,rb:s.rb,te:s.te,qy:q.y,side:s.side,teName:te.gmlpos_name,rbx:rb.x,tex:te.x,line:m.gmlx_scrim};})()`);
            assert((before.rbx - before.line) * dir < 0);
            assert((before.tex - before.rbx) * dir < 0, 'reverse pitch must be backward');
            assert.equal(await ev('RetroPhillySpecial.locked()'), true);
            assert.equal(await ev('(function(){var b=GetWithArray(global.gmlmaster_ball)[0];gml_Script_s_qb_run(b,b,true);gml_Script_s_throw_ball(b,b);return b.gmlstate;})()'),0);
            assert.equal(await ev('GetWithArray(122).length+GetWithArray(124).length'),0);
            assert.equal(await ev('gml_Script_s_can_throw(GetWithArray(global.gmlmaster_ball)[0],GetWithArray(global.gmlmaster_ball)[0])'), false);
            const point = await ev('(function(){var r=document.getElementById("canvas").getBoundingClientRect();return {x:r.left+r.width/2,y:r.top+r.height/2};})()');
            await game.send('Input.dispatchMouseEvent', { type: 'mousePressed', ...point, button: 'left', clickCount: 1 });
            await game.until('GetWithArray(105)[0]._phillySpecial.phase==="shift"');
            await game.send('Input.dispatchMouseEvent', { type: 'mouseMoved', x: point.x - dir * 130, y: point.y + 70, button: 'left', buttons: 1 });
            await game.sleep(100);
            await game.send('Input.dispatchMouseEvent', { type: 'mouseReleased', x: point.x - dir * 130, y: point.y + 70, button: 'left', clickCount: 1 });
            await game.until('GetWithArray(105)[0]._phillySpecial.phase==="snap"', 6000);
            assert((await ev(`GetWithArray(${before.qb})[0].y`) - before.qy) * before.side > 35, 'QB shifts right before snap');
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlholder'), -4);
            await game.until('GetWithArray(105)[0]._phillySpecial.phase==="reverse"');
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlholder'), before.rb, 'snap goes directly to RB');
            await game.until('GetWithArray(105)[0]._phillySpecial.phase==="pitch"', 6000);
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlholder'), -4);
            await game.until('GetWithArray(105)[0]._phillySpecial.phase==="rollout"');
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlholder'), before.te);
            assert.equal(await ev('gml_Script_s_can_throw(GetWithArray(global.gmlmaster_ball)[0],GetWithArray(global.gmlmaster_ball)[0])'), false);
            await game.until('GetWithArray(105)[0]._phillySpecial.phase==="pass"', 7000);
            await game.sleep(250);
            assert.deepEqual(await ev('phillyTest.throws'), [], 'TE waits for user to throw');
            assert.equal(await ev('gml_Script_s_can_throw(GetWithArray(global.gmlmaster_ball)[0],GetWithArray(global.gmlmaster_ball)[0])'), true);
            assert((await ev(`GetWithArray(${before.qb})[0].x`) - before.line) * dir > 20, 'QB runs the forced route');
            assert.equal(await ev('(function(){var b=GetWithArray(global.gmlmaster_ball)[0];gml_Script_s_qb_run(b,b,true);return b.gmlstate;})()'),18);
            const aim = await ev(`hbTest.point(GetWithArray(${before.te})[0].x,GetWithArray(${before.te})[0].y)`);
            await game.send('Input.dispatchMouseEvent', {type:'mousePressed',...aim,button:'left',clickCount:1});
            await game.sleep(100);
            const end = {x:Math.max(5,Math.min(1275,aim.x-dir*100)),y:aim.y+(dir===1?30:-30)};
            await game.send('Input.dispatchMouseEvent', {type:'mouseMoved',...end,button:'left',buttons:1});
            await game.until('GetWithArray(global.gmlmaster_ball)[0].gmlstate===2');
            await game.sleep(70);
            const angle = await ev('GetWithArray(global.gmlmaster_ball)[0].gmldirec');
            await game.send('Input.dispatchMouseEvent', {type:'mouseReleased',...end,button:'left',clickCount:1});
            await game.until('GetWithArray(105)[0]._phillySpecial.phase==="flight"');
            assert.deepEqual(await ev('phillyTest.throws'), [before.te], 'user releases the TE pass');
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmldirec'),angle,'user sets pass direction');
            // Exercise native reception and control transfer for a different WR as
            // well as the intended QB; the throw above uses real pointer input.
            const caught = await ev(`(function(){var m=GetWithArray(105)[0],s=m._phillySpecial,b=GetWithArray(global.gmlmaster_ball)[0],shadow=GetWithArray(112)[0];
                var p=${dir===1&&scrim<0?'GetWithArray(108).find(function(p){return p.gmlposition===4&&p.id!==s.qb;})':'GetWithArray(s.qb)[0]'};
                p.x=Math.max(160,Math.min(2440,m.gmlx_scrim+m.gmldrivedir*145));p.y=s.route.y;p.gmlnearest_opp=-4;p.gmlballdist=0;p.gmltackling=-4;p.gmlskill=10;p.gmlintheclear=true;p.gmldead=0;
                b.x=p.x;b.y=p.y;b.gmlheight=20;b.gmldropped_time=0;shadow.gmlbounce_x=p.x;shadow.gmlbounce_y=p.y;gml_Script_s_check_ball_collision(p,p);
                return {caught:b.gmlholder===p.id,id:p.id};})()`);
            assert.equal(caught.caught,true);
            if(scrim<0){await game.until('GetWithArray(105)[0]._phillySpecial.phase==="run"');assert.equal(await ev('RetroPhillySpecial.locked()'),false);}
            const phases = await ev('phillyTest.phases');
            assert.deepEqual(phases.filter(p => p !== 'ready').slice(0, 7), ['shift', 'snap', 'reverse', 'pitch', 'rollout', 'pass', 'flight']);
            if (process.argv.includes('--screenshots')) await game.screenshot(require('node:path').join(require('node:os').tmpdir(), 'philly-special-' + dir + '-' + scrim + '.png'));
            await ev('gml_Script_s_throw_ball=phillyTest.nativeThrow;RetroPhillySpecial.updateBall=phillyTest.nativeUpdate;true');
            console.log('PASS: QB shift, direct RB snap, backward TE pitch, manual TE aim, throw and native receiver catch: ' + dir + '/' + scrim);
        }
        await ev('hbTest.setup(1,false);true');
        const frequency = await ev(`(function(){var m=GetWithArray(105)[0],baseline=GetWithArray(108).map(function(p){return {p:p,pos:p.gmlposition,blocking:p.gmlte_blocking,x:p.x,y:p.y};}),count={halfback:0,jet:0,philly:0,overlap:0};random_set_seed(151513);
            for(var i=0;i<3900;i++){baseline.forEach(function(v){v.p.gmlposition=v.pos;v.p.gmlte_blocking=v.blocking;v.p.x=v.x;v.p.y=v.y;});RetroHalfbackPass.afterSetup(m);RetroJetSweep.afterSetup(m);RetroPhillySpecial.afterSetup(m);
                var n=0;if(m._halfbackPass){count.halfback++;n++;}if(m._jetSweep){count.jet++;n++;}if(m._phillySpecial){count.philly++;n++;}if(n>1)count.overlap++;}
            baseline.forEach(function(v){v.p.gmlposition=v.pos;v.p.gmlte_blocking=v.blocking;v.p.x=v.x;v.p.y=v.y;});return count;})()`);
        for (const key of ['halfback', 'philly']) assert(frequency[key] > 200 && frequency[key] < 320, JSON.stringify(frequency));
        assert(frequency.jet > 240 && frequency.jet < 360, JSON.stringify(frequency));
        assert.equal(frequency.overlap, 0);
        for (const mode of ['gmlsim_action', 'gmlqb_mode', 'gmlgamepractice']) {
            assert.equal(await ev(`(function(){var c=GetWithArray(98)[0],m=GetWithArray(105)[0];m._halfbackPass=null;m._jetSweep=null;c.${mode}=true;RetroPhillySpecial.afterSetup(m);c.${mode}=false;return !!m._phillySpecial;})()`), false);
        }
        assert.equal(await ev('(function(){var m=GetWithArray(105)[0];m.gmlpossession=1-Number(m.gmlhuman_team);RetroPhillySpecial.afterSetup(m);return !!m._phillySpecial;})()'), false);
        await ev('hbTest.setup(1,false);gml_Script_s_destroy_match_objects(GetWithArray(105)[0],GetWithArray(105)[0]);true');
        assert.equal(await ev('GetWithArray(105)[0]._phillySpecial'), null);
        assert.equal(game.errors.length, 0, JSON.stringify(game.errors));
        console.log('PASS: exclusive frequencies, excluded modes and cleanup: ' + JSON.stringify(frequency));
    } finally { await game.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });
