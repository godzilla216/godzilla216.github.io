const assert = require('node:assert/strict');
const { openGame } = require('./browser-harness.cjs');
const { checkControllerAim, checkCanceledAim } = require('./trick-pass-controls.cjs');
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
                this.air=null;
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
        };
        hbTest.nativeUpdate=RetroHalfbackPass.updateBall;
        RetroHalfbackPass.updateBall=function(b){
            var result=hbTest.nativeUpdate(b),m=GetWithArray(105)[0],s=m&&m._halfbackPass;
            // Capture a simulated flight frame instead of polling its brief
            // visibility window through asynchronous browser commands.
            if(s&&s.phase==='pitch'&&s.frame>=2&&!hbTest.air)
                hbTest.air={state:b.gmlstate,holder:b.gmlholder,hidden:b.gmlhidden};
            return result;
        };true`);
        for (const dir of [1, -1]) {
            assert.equal(await ev(`hbTest.setup(${dir},true)`), true);
            await game.sleep(80);
            const before = await ev(`(function(){var s=GetWithArray(105)[0]._halfbackPass,q=GetWithArray(s.qb)[0],r=GetWithArray(s.rb)[0];return {qx:q.x,qy:q.y,rx:r.x,ry:r.y,point:hbTest.point(q.x,q.y)};})()`);
            if (process.argv.includes('--screenshots')) await game.screenshot(require('node:path').join(require('node:os').tmpdir(), 'halfback-pass-ready-' + dir + '.png'));
            before.point = await ev('(function(){var r=document.getElementById("canvas").getBoundingClientRect();return {x:r.left+r.width/2,y:r.top+r.height/2};})()');
            assert((before.rx - before.qx) * dir < 0, 'pitch must be backward');
            await game.send('Input.dispatchMouseEvent', { type: 'mousePressed', ...before.point, button: 'left', clickCount: 1 });
            await game.until('!!hbTest.air');
            assert.deepEqual(await ev('hbTest.air'),{state:19,holder:-4,hidden:false});
            await game.until('hbTest.info().phase==="pass"');
            await game.sleep(100);
            assert.equal(await ev('hbTest.info().state'),18,'held snap must not aim or throw');
            await game.send('Input.dispatchMouseEvent', { type: 'mouseReleased', ...before.point, button: 'left', clickCount: 1 });
            await game.until('!GetWithArray(105)[0]._halfbackPass.waitRelease');
            const info = await ev('hbTest.info()');
            assert.equal(info.holder, info.rb);
            assert.equal(info.state, 18);
            assert.equal(info.running, false);
            assert.equal(await ev('gml_Script_s_can_throw(GetWithArray(global.gmlmaster_ball)[0],GetWithArray(global.gmlmaster_ball)[0])'), true);
            await game.until(`(GetWithArray(${info.qb})[0].x-${before.qx})*${dir}>5`,3000);
            if (process.argv.includes('--screenshots')) await game.screenshot(require('node:path').join(require('node:os').tmpdir(), 'halfback-pass-route-' + dir + '.png'));
            await checkControllerAim(game,'_halfbackPass',info.rb);
            // Aim away from the player, then cancel and retry without re-snapping.
            const aim = await ev(`hbTest.point(GetWithArray(${info.rb})[0].x,GetWithArray(${info.rb})[0].y)`);
            aim.y -= 100;
            await checkCanceledAim(game,aim,info.rb,dir===-1);
            await game.send('Input.dispatchMouseEvent', { type: 'mousePressed', ...aim, button: 'left', clickCount: 1 });
            await game.sleep(100);
            const end = { x: Math.max(5, Math.min(1275, aim.x - dir * 90)), y: aim.y + 20 };
            await game.send('Input.dispatchMouseEvent', { type: 'mouseMoved', ...end, button: 'left', buttons: 1 });
            await game.sleep(100);
            await game.send('Input.dispatchMouseEvent', { type: 'mouseReleased', ...end, button: 'left', clickCount: 1 });
            await game.until('GetWithArray(global.gmlmaster_ball)[0].gmlstate===3');
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlholder'), -4);
            assert.equal(await ev('gml_Script_s_can_throw(GetWithArray(global.gmlmaster_ball)[0],GetWithArray(global.gmlmaster_ball)[0])'), false);
            const caught = await ev(`(function(){var m=GetWithArray(105)[0],s=m._halfbackPass,q=GetWithArray(s.qb)[0],b=GetWithArray(global.gmlmaster_ball)[0],shadow=GetWithArray(112)[0];
                q.x=m.gmlx_scrim+m.gmldrivedir*180;q.y=300;q.gmlnearest_opp=-4;q.gmlballdist=0;q.gmltackling=-4;q.gmlskill=10;q.gmlintheclear=true;q.gmldead=0;
                gml_Script_s_set_anim(q,q,0);
                b.x=q.x;b.y=q.y;b.gmlstate=3;b.gmlis_dead=false;b.gmlholder=-4;b.gmlheight=20;b.gmldropped_time=0;shadow.gmlbounce_x=q.x;shadow.gmlbounce_y=q.y;
                gml_Script_s_check_ball_collision(q,q);return {caught:b.gmlholder===q.id,state:b.gmlstate};})()`);
            assert.deepEqual(caught, { caught: true, state: 5 });
            assert.equal(await ev('gml_Script_s_can_throw(GetWithArray(global.gmlmaster_ball)[0],GetWithArray(global.gmlmaster_ball)[0])'), false);
            const fumble = await ev(`(function(){
                var s=GetWithArray(105)[0]._halfbackPass,q=GetWithArray(s.qb)[0],b=GetWithArray(global.gmlmaster_ball)[0];
                var before=yyGetBool(q.gmlpmap)?ds_map_find_value(q.gmlpmap,'stat_fumbles'):0;
                gml_Script_s_drop_ball(q,q,true);
                b.gmlheight=1;b.gmlzvel=-1;
                gml_Script_s_update_ball_movement(b,b,false);
                return {state:b.gmlstate,dead:gml_Script_s_is_ball_dead(b,b),last:b.gmllast_touched_by,
                    tracked:yyGetBool(q.gmlpmap),fumbles:(yyGetBool(q.gmlpmap)?ds_map_find_value(q.gmlpmap,'stat_fumbles'):0)-before};
            })()`);
            assert.equal(fumble.state,13,'a real fumble after a catch remains recoverable');
            assert.equal(fumble.dead,false);
            assert.equal(fumble.last,info.qb);
            assert.equal(fumble.fumbles,fumble.tracked?1:0);
            console.log('PASS: backward pitch, QB route and actual RB mouse pass in direction ' + dir);
        }
        for (const dir of [1, -1]) {
            for (const miss of ['ground', 'sideline']) {
                const result = await ev(`(function(){
                    hbTest.setup(${dir},true);
                    var m=GetWithArray(105)[0],s=m._halfbackPass,b=GetWithArray(global.gmlmaster_ball)[0],mouse=mouse_check_button;
                    try {
                        mouse_check_button=function(){return true;};
                        for(var i=0;i<16;i++)gml_Script_s_update_ball(b,b);
                    } finally {mouse_check_button=mouse;}
                    s.waitRelease=false;
                    var received=b.gmllast_touched_by,rb=GetWithArray(s.rb)[0],line=m.gmlx_scrim;
                    var fumbles=yyGetBool(rb.gmlpmap)?ds_map_find_value(rb.gmlpmap,'stat_fumbles'):0;
                    b.gmldirec=${miss === 'ground' ? (dir === 1 ? 0 : 180) : 80};
                    b.gmlvelocity=8;b.gmlzvel=2.8;
                    gml_Script_s_throw_ball(b,b);
                    var touchAfterThrow=b.gmllast_touched_by;
                    for(var i=0;i<200&&!gml_Script_s_is_ball_dead(b,b);i++)gml_Object_obj_ball_Step_0(b,b);
                    return {received:received,rb:s.rb,touchAfterThrow:touchAfterThrow,state:b.gmlstate,
                        dead:b.gmlis_dead,holder:b.gmlholder,spot:m.gmlx_scrim,line:line,
                        possession:m.gmlpossession,human:Number(m.gmlhuman_team),
                        fumbles:(yyGetBool(rb.gmlpmap)?ds_map_find_value(rb.gmlpmap,'stat_fumbles'):0)-fumbles};
                })()`);
                assert.equal(result.received,result.rb,'test begins with an actual pitch reception');
                assert.equal(result.touchAfterThrow,-4,'forward pass clears the pitch reception marker');
                assert.equal(result.state,7,'missed HB pass is incomplete: '+JSON.stringify(result));
                assert.equal(result.dead,true,'incomplete pass cannot be recovered');
                assert.equal(result.holder,-4);
                assert.equal(result.spot,result.line,'incompletion keeps the original line of scrimmage');
                assert.equal(result.possession,result.human);
                assert.equal(result.fumbles,0);
                console.log('PASS: HB pass '+miss+' incompletion, dead ball and unchanged spot/possession: '+dir);
            }
        }
        assert.equal(await ev('hbTest.setup(1,false)'), false);
        assert.equal(await ev('GetWithArray(108).filter(function(p){return p.gmlposition===1;}).length'), 1);
        const frequency = await ev(`(function(){var m=GetWithArray(105)[0],count=0;random_set_seed(12015);for(var i=0;i<1500;i++){RetroHalfbackPass.afterSetup(m);if(m._halfbackPass)count++;}return count;})()`);
        assert(frequency > 65 && frequency < 135, '1/15 selection rate: ' + frequency);
        for (const mode of ['gmlqb_mode', 'gmlsim_action', 'gmlgamepractice']) {
            assert.equal(await ev(`(function(){var c=GetWithArray(98)[0],m=GetWithArray(105)[0];c.${mode}=true;RetroHalfbackPass.afterSetup(m);c.${mode}=false;return !!m._halfbackPass;})()`), false);
        }
        assert.equal(await ev('(function(){var m=GetWithArray(105)[0];m.gmlpossession=1-Number(m.gmlhuman_team);RetroHalfbackPass.afterSetup(m);return !!m._halfbackPass;})()'), false);
        assert.equal(game.errors.length, 0, JSON.stringify(game.errors));
        console.log('PASS: ordinary play reset, excluded modes/CPU and rare selection (' + frequency + '/1500)');
    } finally { await game.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });
