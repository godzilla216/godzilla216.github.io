const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { openGame } = require('./browser-harness.cjs');
async function main() {
    const game = await openGame(), ev = game.evaluate;
    let passed = 0;
    const pass = name => { passed++; console.log('PASS: ' + name); };
    const folder = path.resolve(__dirname, '../artifacts/punts'); fs.mkdirSync(folder, { recursive: true });
    const key = async (type, key, code, number) => game.send('Input.dispatchKeyEvent', { type, key, code, windowsVirtualKeyCode: number });
    try {
        await ev('(function(){var c=GetWithArray(98)[0];gml_Script_s_msg_clear(c,c);gml_Script_btn_click_Details_Continue(c,c);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_home"');
        await ev('(function(){var c=GetWithArray(98)[0];c.gmlintro=0;c.gmltimeout_message_done=true;c.gmlbullet_throw_message_done=true;c.gmlstage=2;gml_Script_s_play(c,c,1);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_pre_match"');
        await ev('gml_Script_btn_click_Continue(GetWithArray(100400)[0],GetWithArray(98)[0]);true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_match"&&GetWithArray(105).length===1');
        await ev(`window.puntTest={
            setup:function(dir,cpu,scrim){var m=GetWithArray(105)[0];gml_Script_s_msg_clear(m,m);gml_Script_s_destroy_match_objects(m,m);
                m.gmlstate=2;m.gmlcomm_stage=3;m.gmlcomm_proceed=false;m.gmlkicking=0;m.gmlpossession=cpu?1-Number(m.gmlhuman_team):Number(m.gmlhuman_team);
                m.gmldown=4;m.gmlyards=10;m.gmlscrimmage=scrim===undefined?-15:scrim;m.gmldrivedir=dir;m.gmlquarter=1;
                m.gmlminutes=2;m.gmlseconds=0;m.gmltime_subtract=0;m.alarm[0]=-1;m.alarm[1]=-1;random_set_seed(1234);
                RetroPunt.start(m);return this.summary();},
            summary:function(){var m=GetWithArray(105)[0],s=m._punt,b=GetWithArray(global.gmlmaster_ball)[0];return {state:m.gmlstate,down:m.gmldown,yards:m.gmlyards,scrim:m.gmlscrimmage,
                possession:Number(m.gmlpossession),human:Number(m.gmlhuman_team),orientation:m.gmldrivedir,phase:s&&s.phase,dir:s&&s.dir,launches:s&&s.launches,
                ball:b&&{x:b.x,y:b.y,z:b.gmlheight,holder:b.gmlholder},last:m._lastPunt};},
            advance:function(n){var m=GetWithArray(105)[0];for(var i=0;i<n&&m._punt;i++){m._punt.frame++;this.update(GetWithArray(global.gmlmaster_ball)[0]);}return this.summary();},
            freeze:function(){this.step=RetroPunt.step;this.update=RetroPunt.updateBall;RetroPunt.step=function(){return true;};RetroPunt.updateBall=function(){return true;};},
            unfreeze:function(){RetroPunt.step=this.step;RetroPunt.updateBall=this.update;},
            camera:function(){var m=GetWithArray(105)[0],s=m._punt,cam=g_pBuiltIn.view_camera[0];camera_set_view_size(cam,960,540);camera_set_view_pos(cam,Math.max(0,Math.min(1640,s.scrim-480)),30);}
        };true`);
        await ev('puntTest.setup(1,false);gml_Script_s_destroy_match_objects(GetWithArray(105)[0],GetWithArray(105)[0]);gml_Script_s_set_up_play(GetWithArray(105)[0],GetWithArray(105)[0],false);true');
        assert.deepEqual(await ev('GetWithArray(35).map(function(b){return b.gmltext}).sort()'), ['Field Goal', 'Go for it', 'Punt'].sort());
        pass('fourth-down decision offers all three actions through native buttons');
        assert.equal(await ev('typeof RetroPunt.drawPlayer'),'undefined');
        for (const choice of ['Go for it','Field Goal','Punt']) {
            const point = await ev(`(function(){puntTest.setup(1,false);var m=GetWithArray(105)[0];gml_Script_s_destroy_match_objects(m,m);gml_Script_s_set_up_play(m,m,false);
                var b=GetWithArray(35).find(function(b){return b.gmltext===${JSON.stringify(choice)}}),c=document.querySelector('canvas').getBoundingClientRect();
                return {action:b.gmlonClickAction,x:c.x+(b.x+b.sprite_width/2)/display_get_gui_width()*c.width,y:c.y+(b.y+b.sprite_height/2)/display_get_gui_height()*c.height};})()`);
            assert.equal(typeof point.action,'number',`${choice} must have a defined native script ID`);
            await game.send('Input.dispatchMouseEvent',{type:'mouseMoved',x:point.x,y:point.y});
            await game.send('Input.dispatchMouseEvent',{type:'mousePressed',x:point.x,y:point.y,button:'left',clickCount:1});
            await game.sleep(120);
            await game.send('Input.dispatchMouseEvent',{type:'mouseReleased',x:point.x,y:point.y,button:'left',clickCount:1});
            await game.until('!instance_exists(79)');
            const result = await ev('(function(){var m=GetWithArray(105)[0];return {punt:!!m._punt,kicking:m.gmlkicking,down:m.gmldown};})()');
            assert.equal(result.punt,choice==='Punt');assert.equal(result.kicking,choice==='Punt'?3:choice==='Field Goal'?1:0);
            assert.equal(game.errors.length,0,JSON.stringify(game.errors));
            pass(`actual ${choice} dialog click executes a valid callback without the undefined-script crash`);
        }
        for (const dir of [-1, 1]) {
            const aiming = await ev(`(function(){
                puntTest.setup(${dir},false);var m=GetWithArray(105)[0],s=m._punt,values=[];
                for(var i=0;i<180;i++){RetroPunt.step(m);values.push(s.aim);}
                var originalSprite=draw_sprite_ext,originalTriangle=draw_triangle,arrows=[],triangles=[];
                try {
                    draw_sprite_ext=function(p,sprite,frame,x,y,sx,sy,rotation,color,alpha){arrows.push({sprite:sprite_get_name(sprite),x:x,y:y,rotation:rotation,sx:sx,sy:sy,alpha:alpha});};
                    draw_triangle=function(x1,y1,x2,y2,x3,y3){triangles.push({x1:x1,y1:y1,x2:x2,y2:y2,x3:x3,y3:y3});};
                    s.aim=-20;RetroPunt.drawField(m);s.aim=20;RetroPunt.drawField(m);
                    RetroPunt.confirm(m);var locked=s.aim;
                    for(var j=0;j<30;j++)RetroPunt.step(m);
                    var stable=s.aim===locked;RetroPunt.drawField(m);
                    s.phase='bend';RetroPunt.drawField(m);
                    var p=GetWithArray(s.punter)[0];
                    return {values:values,arrows:arrows,triangles:triangles,stable:stable,p:{x:p.x,y:p.y},sprite:sprite_get_name(YYASSET_REF(0x0100004d))};
                } finally {draw_sprite_ext=originalSprite;draw_triangle=originalTriangle;}
            })()`);
            assert(Math.min(...aiming.values) < -20 && Math.max(...aiming.values) > 20);
            assert(aiming.values.every(a => a >= -25 && a <= 25));
            assert(aiming.stable); assert.equal(aiming.arrows.length, 3); assert.equal(aiming.triangles.length, 3);
            aiming.arrows.forEach(a => {assert.equal(a.sprite, aiming.sprite);assert.equal(a.sx,.75);assert.equal(a.sy,.75);assert.equal(a.alpha,.75);assert((a.x-aiming.p.x)*dir>0);});
            assert(aiming.arrows[0].y < aiming.p.y && aiming.arrows[1].y > aiming.p.y);
            aiming.triangles.forEach(t => {assert.equal(t.x3,aiming.p.x);assert.equal(t.y3,aiming.p.y);assert((t.x1-t.x3)*dir>0);assert(t.y1<t.y3&&t.y2>t.y3);});
            await ev(`puntTest.setup(${dir},false);puntTest.freeze();GetWithArray(105)[0]._punt.aim=-20;true`);
            await game.sleep(80);await game.screenshot(path.join(folder,`${dir}-aim-up.png`));
            await ev('GetWithArray(105)[0]._punt.aim=20;true');
            await game.sleep(80);await game.screenshot(path.join(folder,`${dir}-aim-down.png`));
            await ev('RetroPunt.confirm(GetWithArray(105)[0]);true');
            await game.sleep(80);await game.screenshot(path.join(folder,`${dir}-aim-locked.png`));
            await ev('puntTest.unfreeze();true');
            pass(`field-goal arrow sprite sweeps both ways inside a triangle, mirrors and locks during power in direction ${dir}`);
        }
        await ev('puntTest.setup(1,false);true');
        await key('keyDown', 'ArrowDown', 'ArrowDown', 40); await game.sleep(120); await key('keyUp', 'ArrowDown', 'ArrowDown', 40);
        assert((await ev('GetWithArray(105)[0]._punt.aim')) > 0);
        await key('keyDown', ' ', 'Space', 32); await game.sleep(50); await key('keyUp', ' ', 'Space', 32);
        await game.until('GetWithArray(105)[0]._punt.phase==="power"');
        await game.sleep(350); await key('keyDown', ' ', 'Space', 32); await game.sleep(40); await key('keyUp', ' ', 'Space', 32);
        for (let i=0;i<6;i++) { await key('keyDown',' ','Space',32);await game.sleep(20);await key('keyUp',' ','Space',32);await game.sleep(20); }
        await game.until('GetWithArray(105)[0]._punt.phase==="flight"');
        assert.equal(await ev('GetWithArray(105)[0]._punt.launches'), 1);
        pass('real keyboard aims, locks power, and completes snap through kick once despite rapid input');
        await ev('puntTest.freeze();true');
        for (const dir of [-1, 1]) for (const aim of [-20, 20]) {
            const result = await ev(`(function(){
                puntTest.setup(${dir},false);var m=GetWithArray(105)[0],s=m._punt;
                var held=true,my=200,original={};
                ['keyboard_check','keyboard_check_pressed','device_mouse_check_button','device_mouse_check_button_pressed','device_mouse_x_to_gui','device_mouse_y_to_gui'].forEach(function(k){original[k]=window[k];});
                try {
                    keyboard_check=keyboard_check_pressed=function(){return false;};
                    device_mouse_check_button=device_mouse_check_button_pressed=function(device){return device===0&&held;};
                    device_mouse_x_to_gui=function(){return 300;};device_mouse_y_to_gui=function(){return my;};
                    // Keep the sweep still on the initial press so the chosen angle is exact.
                    s.aim=${aim};s.pointer={device:0,x:300,y:200,phase:'aim',button:false,aim:s.aim,dragging:false};
                    puntTest.step(m);var pressed=s.aim;
                    my+=2;puntTest.step(m);var jitter=s.aim;
                    held=false;puntTest.step(m);var locked=s.aim,phase=s.phase;
                    s.meter=.65;RetroPunt.confirm(m);puntTest.advance(100);
                    var b=GetWithArray(global.gmlmaster_ball)[0];
                    return {pressed:pressed,jitter:jitter,locked:locked,phase:phase,dy:b.y-s.launchY,dx:b.x-s.launchX};
                } finally {Object.keys(original).forEach(function(k){window[k]=original[k];});}
            })()`);
            assert.equal(result.pressed,aim);assert.equal(result.jitter,aim);assert.equal(result.locked,aim);
            assert.equal(result.phase,'power');assert(result.dy*aim>0);assert(result.dx*dir>0);
            pass(`field tap preserves aim ${aim} through launch and flight in direction ${dir}`);
        }
        const speedComparison=await ev(`(function(){var cases=[];[-1,1].forEach(function(dir){[.15,.65,1].forEach(function(power){puntTest.setup(dir,false);var m=GetWithArray(105)[0],s=m._punt,b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(s.punter)[0],t=RetroPunt.logic.trajectory(1200,300,dir,12,power,p.gmlmy_kick_power);
            b.x=1200;b.y=300;b.gmlheight=12;b.gmlbouncecount=0;b.gmlholder=p.id;b.gmlkickpow=Math.max(15,power*55);b.gmlvelocity=(50+b.gmlkickpow)*p.gmlmy_kick_power;b.gmlzvel=b.gmlvelocity*.4;b.gmldirec=Math.atan2(t.dy,t.dx)*180/Math.PI;
            gml_Script_s_kick_ball(b,b);var kickoffSpeed=b.gmlvelocity,normal=[];for(var i=0;i<30;i++){gml_Script_s_update_ball_movement(b,b,false);normal.push([b.x,b.y,b.gmlvelocity]);}
            s.phase='flight';s.frame=0;s.launchX=1200;s.launchY=300;s.flight=t;b.x=1200;b.y=300;b.gmlheight=12;b.gmlbouncecount=0;b.gmlvelocity=t.velocity;b.gmlzvel=t.zvel;b.gmlholder=-4;b.gmlstate=3;var punt=[];
            for(var j=0;j<30;j++){puntTest.advance(1);punt.push([b.x,b.y,b.gmlvelocity]);}cases.push({kickoffSpeed:kickoffSpeed,puntSpeed:t.velocity,normal:normal,punt:punt});});});return cases;})()`);
        speedComparison.forEach(c=>{assert.equal(c.kickoffSpeed,c.puntSpeed);assert.deepEqual(c.normal,c.punt);});
        pass('all three power levels match actual native kickoff launch speed and thirty frames of air movement in both directions');
        for (const dir of [-1, 1]) {
            let setup = await ev(`puntTest.setup(${dir},false)`);
            assert.equal(setup.dir, dir);
            const formation = await ev('(function(){var m=GetWithArray(105)[0],s=m._punt;return {scrim:s.scrim,players:GetWithArray(107).map(function(p){return {x:p.x,y:p.y,role:p._puntRole,facing:p.gmlfacing,offense:p.gmloffense}})};})()');
            const punter = formation.players.find(p => p.role === 'punter'), snapper = formation.players.find(p => p.role === 'snapper');
            assert.equal((snapper.x - punter.x) * dir, 290);
            assert(formation.players.every(p => p.facing === (p.offense ? -dir : dir)));
            await ev('puntTest.camera();true'); await game.sleep(100); await game.screenshot(path.join(folder, `${dir}-formation.png`));
            await ev('RetroPunt.confirm(GetWithArray(105)[0]);GetWithArray(105)[0]._punt.meter=.85;RetroPunt.confirm(GetWithArray(105)[0]);true');
            const sequence = [];
            for (const [n, phase] of [[10,'bend'],[8,'snap'],[8,'snap'],[8,'catch'],[10,'approach'],[10,'approach'],[10,'drop'],[7,'drop'],[7,'flight'],[8,'flight']]) {
                const state = await ev(`puntTest.advance(${n})`); sequence.push(state);
                assert.equal(state.phase, phase, JSON.stringify(state));
                await ev('puntTest.camera();true'); await game.sleep(30);
                if (sequence.length === 9) {
                    const pose = await ev('(function(){var s=GetWithArray(105)[0]._punt,p=GetWithArray(s.punter)[0];return {sprite:sprite_get_name(p.sprite_index),frame:p.image_index,facing:p.image_xscale};})()');
                    assert.match(pose.sprite,/^spr_kick2/);assert.equal(pose.frame,1);assert.equal(pose.facing,dir*2);
                }
                await game.screenshot(path.join(folder, `${dir}-${sequence.length}-${phase}.png`));
            }
            assert((sequence[2].ball.x - sequence[1].ball.x) * dir < 0);
            assert((sequence.at(-1).ball.x - sequence.at(-2).ball.x) * dir > 0);
            assert.equal(sequence.at(-1).launches, 1);
            assert(sequence.every(s => s.ball.z > 0));
            const foot = await ev('(function(){var s=GetWithArray(105)[0]._punt,p=GetWithArray(s.punter)[0];return {distance:(s.launchX-p.x)*s.dir,height:RetroPunt.logic.CONTACT.height};})()');
            assert.equal(foot.distance,12);assert.equal(sequence[8].ball.z,foot.height);
            await ev('(function(){var m=GetWithArray(105)[0];for(var i=0;i<100;i++){RetroPunt.confirm(m);RetroPunt.start(m);}return true;})()');
            assert.equal(await ev('GetWithArray(105)[0]._punt.launches'), 1);
            pass(`formation, full ordered animation, backward airborne snap and forward kick in direction ${dir}`);
            for (const reason of ['return', 'fair', 'out of bounds', 'touchback']) {
                const result = await ev(`(function(){puntTest.setup(${dir},false);var m=GetWithArray(105)[0],team=Number(m.gmlpossession),drives=m.gmldrives;RetroPunt.end(m,${JSON.stringify(reason)},1300+${dir}*400);gml_Object_obj_controller_Alarm_0(m,m);var first=puntTest.summary();first.driveDelta=m.gmldrives-drives;first.team=team;return first;})()`);
                assert.equal(result.possession, 1 - result.team); assert.equal(result.down, 1); assert.equal(result.yards, 10);
                assert.equal(result.scrim, reason === 'touchback' ? -30 : -20); assert.equal(result.orientation, dir); assert.equal(result.driveDelta, 1);
            }
            pass(`native possession and punt spots for return, fair catch, sideline and 20-yard touchback in direction ${dir}`);
        }
        for (const dir of [-1,1]) {
            const bounced = await ev(`(function(){puntTest.setup(${-dir},true);var m=GetWithArray(105)[0],s=m._punt,b=GetWithArray(global.gmlmaster_ball)[0];
                GetWithArray(107).forEach(function(p){p.x=600;p.y=440;p.hspeed=0;p.vspeed=0;});
                s.phase='flight';s.frame=200;s.fair=true;b.gmlholder=-4;b.gmlstate=3;b.x=1300;b.y=300;b.gmlheight=2;b.gmlzvel=-3;b.gmlvelocity=6;b.gmldirec=${dir===1?0:180};b.gmlbouncecount=0;
                puntTest.advance(1);return {phase:s.phase,dead:b.gmlis_dead,bounces:b.gmlbouncecount,z:b.gmlzvel,velocity:b.gmlvelocity,fair:s.fair};})()`);
            assert.equal(bounced.phase,'ground');assert.equal(bounced.dead,false);assert.equal(bounced.bounces,1);assert(bounced.z>0);assert(bounced.velocity>0&&bounced.velocity<6);assert.equal(bounced.fair,false);
            const risen=await ev('puntTest.advance(8)');assert(risen.ball.z>2);
            await ev('puntTest.camera();true');await game.sleep(40);await game.screenshot(path.join(folder,`${dir}-bounce.png`));
            const resting=await ev('puntTest.advance(600)');assert.equal(resting.phase,'ground');
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlvelocity'),0);
            assert.equal(await ev('GetWithArray(global.gmlmaster_ball)[0].gmlis_dead'),false);
            pass(`actual kickoff bounce physics rises, loses energy and rests without auto-downing in direction ${dir}`);
            const downed=await ev(`(function(){var m=GetWithArray(105)[0],s=m._punt,b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(109)[2],before=Number(m.gmlpossession),drives=m.gmldrives;
                p.x=b.x;p.y=b.y;puntTest.advance(1);var reason=s.reason,spot=b.x;
                var receiver=GetWithArray(108)[0];receiver.x=b.x;receiver.y=b.y;puntTest.advance(1);var stopped=s.phase==='dead'&&b.gmlholder===-4;
                RetroPunt.resolve(m);RetroPunt.resolve(m);return {reason:reason,stopped:stopped,spot:spot,pos:Number(m.gmlpossession),before:before,down:m.gmldown,yards:m.gmlyards,drives:m.gmldrives-drives};})()`);
            assert.equal(downed.reason,'downed');assert.equal(downed.stopped,true);assert.equal(downed.pos,1-downed.before);assert.equal(downed.down,1);assert.equal(downed.yards,10);assert.equal(downed.drives,1);
            pass(`coverage touch downs the rested ball once and prevents a later pickup in direction ${dir}`);
            const pickup=await ev(`(function(){puntTest.setup(${-dir},true);var m=GetWithArray(105)[0],s=m._punt,b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(108)[0];GetWithArray(107).forEach(function(p){p.x=600;p.y=440;p.hspeed=0;p.vspeed=0;});
                s.phase='ground';s.frame=0;b.gmlstate=13;b.gmlholder=-4;b.x=1300;b.y=300;b.gmlheight=1;b.gmlzvel=0;b.gmlvelocity=0;b.gmlbouncecount=2;p.x=b.x;p.y=b.y;var old=s.returner;puntTest.advance(1);return {phase:s.phase,carrier:s.returner,old:old,id:p.id,holder:b.gmlholder,dead:b.gmlis_dead};})()`);
            assert.equal(pickup.phase,'return');assert.equal(pickup.carrier,pickup.id);assert.notEqual(pickup.carrier,pickup.old);assert.equal(pickup.holder,pickup.id);assert.equal(pickup.dead,false);
            await ev('puntTest.unfreeze();true');
            const startX=await ev(`GetWithArray(${pickup.id})[0].x`);
            await key('keyDown',dir===1?'ArrowLeft':'ArrowRight',dir===1?'ArrowLeft':'ArrowRight',dir===1?37:39);await game.sleep(250);
            await key('keyUp',dir===1?'ArrowLeft':'ArrowRight',dir===1?'ArrowLeft':'ArrowRight',dir===1?37:39);
            assert((await ev(`GetWithArray(${pickup.id})[0].x`)-startX)*-dir>0);
            await game.screenshot(path.join(folder,`${dir}-ground-pickup-return.png`));
            pass(`a receiving blocker scoops the live punt and becomes keyboard-controllable in direction ${dir}`);
            await ev('puntTest.freeze();true');
        }
        await ev('puntTest.unfreeze();puntTest.setup(1,true);true');
        assert.equal(await ev('GetWithArray(105)[0]._punt.dir'), -1);
        await game.until('GetWithArray(105)[0]._punt.phase==="flight"');
        await key('keyDown','f','KeyF',70); await game.sleep(50); await key('keyUp','f','KeyF',70);
        await game.until('GetWithArray(105)[0]._punt===null');
        assert.equal(await ev('GetWithArray(105)[0]._lastPunt.reason'), 'fair');
        const fairSpot = await ev('GetWithArray(105)[0].gmlscrimmage');
        await ev('(function(){var m=GetWithArray(105)[0];gml_Script_s_update_commentary(m,m);gml_Script_s_update_commentary(m,m);return true;})()');
        assert.equal(await ev('GetWithArray(105)[0].gmlscrimmage'),fairSpot);
        pass('CPU punts enter live flight and actual user fair catch resolves on receiving the ball');
        // Exercise real flight/result paths, rather than only injecting results.
        for (const orientation of [-1, 1]) {
            await ev(`puntTest.setup(${orientation},true);true`);
            await game.until('GetWithArray(105)[0]._punt.phase==="return"');
            const returnBefore = await ev('(function(){var m=GetWithArray(105)[0],p=GetWithArray(m._punt.returner)[0];GetWithArray(109).forEach(function(x){x.x=1300;x.y=440;});return {id:p.id,x:p.x,y:p.y,seconds:m.gmlseconds};})()');
            await key('keyDown',orientation===1?'ArrowRight':'ArrowLeft',orientation===1?'ArrowRight':'ArrowLeft',orientation===1?39:37);
            await game.sleep(220);
            await key('keyUp',orientation===1?'ArrowRight':'ArrowLeft',orientation===1?'ArrowRight':'ArrowLeft',orientation===1?39:37);
            assert((await ev(`GetWithArray(${returnBefore.id})[0].x`) - returnBefore.x) * orientation > 0);
            await game.screenshot(path.join(folder, `${orientation}-return.png`));
            await key('keyDown',' ','Space',32); await game.sleep(40); await key('keyUp',' ','Space',32);
            await game.until('GetWithArray(105)[0]._punt===null');
            const returned = await ev('puntTest.summary()');
            assert.equal(returned.possession, returned.human); assert.equal(returned.down,1); assert.equal(returned.yards,10);
            assert.equal(returned.last.reason,'return');
            assert.equal(await ev('GetWithArray(105)[0].gmlseconds < 120'),true);
            pass(`actual CPU snap, catch, controlled return, dive and possession in orientation ${orientation}`);
            for (const outcome of ['out of bounds','touchback']) {
                await ev(`(function(){puntTest.setup(${orientation},false,${outcome==='touchback'?30:-15});var m=GetWithArray(105)[0];m._punt.aim=${outcome==='touchback'?0:25};RetroPunt.confirm(m);m._punt.meter=1;RetroPunt.confirm(m);return true;})()`);
                await game.until('GetWithArray(105)[0]._punt===null');
                const result = await ev('puntTest.summary()');
                assert.equal(result.last.reason,outcome); assert.equal(result.last.launches,1);
                assert.equal(result.possession,1-result.human); assert.equal(result.down,1); assert.equal(result.yards,10);
                if(outcome==='touchback') assert.equal(result.scrim,-30);
                else assert.equal(result.scrim,10);
                pass(`actual punt flight ends ${outcome} in direction ${orientation}`);
            }
        }
        await ev('puntTest.setup(-1,true);true');
        await game.until('GetWithArray(105)[0]._punt.phase==="flight"');
        await key('keyDown','f','KeyF',70);await game.sleep(40);await key('keyUp','f','KeyF',70);
        await game.until('GetWithArray(105)[0]._punt===null');
        const fairOther = await ev('puntTest.summary()');
        assert.equal(fairOther.last.reason,'fair');assert.equal(fairOther.possession,fairOther.human);assert.equal(fairOther.down,1);assert.equal(fairOther.yards,10);
        pass('actual fair catch in the other field direction starts a first down at the catch spot');
        for (const device of ['mouse','touch']) {
            await ev('puntTest.setup(1,true);true');
            await game.until('GetWithArray(105)[0]._punt.phase==="return"');
            const movement = await ev('(function(){var m=GetWithArray(105)[0],p=GetWithArray(m._punt.returner)[0];GetWithArray(109).forEach(function(x){x.x=1300;x.y=440;});var r=document.querySelector("canvas").getBoundingClientRect();return {id:p.id,x:p.x,px:r.x+r.width*.4,py:r.y+r.height*.5};})()');
            if(device==='mouse') {
                await game.send('Input.dispatchMouseEvent',{type:'mousePressed',x:movement.px,y:movement.py,button:'left',clickCount:1});await game.sleep(80);
                await game.until('!!GetWithArray(105)[0]._punt.pointer');
                await game.send('Input.dispatchMouseEvent',{type:'mouseMoved',x:movement.px+80,y:movement.py,button:'left',buttons:1});
            } else {
                await game.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:[{x:movement.px,y:movement.py,id:0}]});await game.sleep(80);
                await game.send('Input.dispatchTouchEvent',{type:'touchMove',touchPoints:[{x:movement.px,y:movement.py,id:0}]});
                await game.until('!!GetWithArray(105)[0]._punt.pointer');
                await game.send('Input.dispatchTouchEvent',{type:'touchMove',touchPoints:[{x:movement.px+80,y:movement.py,id:0}]});
            }
            await game.until('GetWithArray(105)[0]._punt.input.x > .5');
            await game.until(`GetWithArray(${movement.id})[0].x > ${movement.x}+2`,3000);
            assert((await ev(`GetWithArray(${movement.id})[0].x`))>movement.x);
            if(device==='mouse') await game.send('Input.dispatchMouseEvent',{type:'mouseReleased',x:movement.px+80,y:movement.py,button:'left',clickCount:1});
            else await game.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]});
            pass(`real ${device} drag moves a caught punt returner`);
        }
        // Both pointer devices use the same polled runner input, without DOM listeners.
        for (const device of ['mouse','touch']) {
            await ev('puntTest.setup(1,false);true');
            const rect = await ev('(function(){var r=document.querySelector("canvas").getBoundingClientRect();return {x:r.x,y:r.y,w:r.width,h:r.height,gw:display_get_gui_width(),gh:display_get_gui_height()};})()');
            const px = rect.x + rect.w/2, py = rect.y + (rect.gh-17)/rect.gh*rect.h;
            async function tap(){
                if(device==='mouse') { await game.send('Input.dispatchMouseEvent',{type:'mousePressed',x:px,y:py,button:'left',clickCount:1});await game.sleep(80);await game.send('Input.dispatchMouseEvent',{type:'mouseReleased',x:px,y:py,button:'left',clickCount:1}); }
                else { await game.send('Input.dispatchTouchEvent',{type:'touchStart',touchPoints:[{x:px,y:py,id:0}]});await game.send('Input.dispatchTouchEvent',{type:'touchMove',touchPoints:[{x:px+1,y:py,id:0}]});await game.sleep(120);await game.send('Input.dispatchTouchEvent',{type:'touchEnd',touchPoints:[]}); }
                await game.sleep(100);
            }
            await tap(); assert.equal(await ev('GetWithArray(105)[0]._punt.phase'),'power');
            await game.sleep(450); await tap();
            await game.until('GetWithArray(105)[0]._punt.phase==="flight"');
            assert.equal(await ev('GetWithArray(105)[0]._punt.launches'),1);
            pass(`real ${device} input selects aim and power and launches once`);
        }
        const cpuPath = await ev('(function(){puntTest.setup(1,true);var m=GetWithArray(105)[0];gml_Script_s_destroy_match_objects(m,m);m.gmlkicking=0;m.gmlstate=1;m.gmlcomm_stage=5;m.gmldown=1;gml_Script_s_update_commentary(m,m);return puntTest.summary();})()');
        assert.equal(cpuPath.phase,'aim'); assert.equal(cpuPath.dir,-1); assert.equal(cpuPath.state,2);
        pass('native simulated opponent punt commentary enters the actual playable punt');
        const go = await ev('(function(){puntTest.setup(1,false);var m=GetWithArray(105)[0];gml_Script_s_destroy_match_objects(m,m);m.gmlkicking=0;gml_Script_s_set_up_play(m,m,false);gml_Script_btn_response_kick_no(m,m);return {punt:!!m._punt,kicking:m.gmlkicking,down:m.gmldown,ball:GetWithArray(global.gmlmaster_ball)[0].gmlstate,popup:instance_exists(79)};})()');
        assert.deepEqual(go,{punt:false,kicking:0,down:4,ball:0,popup:false});
        pass('Go for it closes the choice and leaves the original fourth-down offense ready');
        const fg = await ev('(function(){var m=GetWithArray(105)[0];m.gmlscrimmage=30;gml_Script_btn_response_fg_yes(m,m);var b=GetWithArray(global.gmlmaster_ball)[0];b.gmlkickpow=40;b.gmlvelocity=15;b.gmlzvel=4;gml_Script_s_kick_ball(b,b);return {punt:!!m._punt,kicking:m.gmlkicking,state:b.gmlstate,holder:b.gmlholder,velocity:b.gmlvelocity};})()');
        assert.equal(fg.punt,false); assert.equal(fg.kicking,1); assert.equal(fg.state,3); assert.equal(fg.holder,-4);assert(fg.velocity>0);
        pass('user field-goal selection and native kick launch remain operational');
        const ko = await ev('(function(){var m=GetWithArray(105)[0];gml_Script_s_destroy_match_objects(m,m);m.gmlstate=2;m.gmldown=99;m.gmlpossession=1-Number(m.gmlhuman_team);m.gmlkicking=0;gml_Script_s_set_up_play(m,m,true);var b=GetWithArray(global.gmlmaster_ball)[0];b.gmlkickpow=40;b.gmlvelocity=15;b.gmlzvel=4;gml_Script_s_kick_ball(b,b);var oldx=b.x;gml_Object_obj_ball_Step_0(b,b);return {punt:!!m._punt,kicking:m.gmlkicking,down:m.gmldown,state:b.gmlstate,moved:b.x!==oldx};})()');
        assert.deepEqual(ko,{punt:false,kicking:3,down:99,state:3,moved:true});
        pass('normal kickoff setup, kick and native ball movement retain their original path');
        const switched = await ev('(function(){puntTest.setup(1,false);var m=GetWithArray(105)[0];gml_Script_s_destroy_match_objects(m,m);m.gmlkicking=0;gml_Script_s_switch_drivedirection(m,m);RetroPunt.start(m);return puntTest.summary();})()');
        assert.equal(switched.dir,-1);
        await game.sleep(800);await game.screenshot(path.join(folder,'end-zone-switch-formation.png'));
        await ev('puntTest.freeze();var m=GetWithArray(105)[0];RetroPunt.confirm(m);m._punt.meter=.85;RetroPunt.confirm(m);puntTest.advance(26);puntTest.camera();true');
        await game.sleep(60);await game.screenshot(path.join(folder,'end-zone-switch-snap.png'));
        await ev('puntTest.unfreeze();true');
        pass('native end-zone switch changes the next punt direction');
        const scored = await ev('(function(){var results=[];for(var i=0;i<2;i++){puntTest.setup(i===0?1:-1,true);var m=GetWithArray(105)[0],s=m._punt,b=GetWithArray(global.gmlmaster_ball)[0],human=Number(m.gmlhuman_team),before=m.gmlteam_score.slice();RetroPunt.end(m,i===0?"touchdown":"safety",i===0?2300:300);RetroPunt.resolve(m);RetroPunt.resolve(m);results.push({delta:m.gmlteam_score.map(function(n,j){return n-before[j]}),human:human});}return results;})()');
        assert.equal(scored[0].delta[scored[0].human],6);assert.equal(scored[1].delta[1-scored[1].human],2);
        pass('return touchdown and safety use native scoring once');
        assert.equal(game.errors.length, 0, JSON.stringify(game.errors));
        assert.equal(game.external.length, 0, JSON.stringify(game.external));
        console.log(`${passed} punt browser checks passed. Screenshots: ${folder}`);
    } finally { await game.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });
