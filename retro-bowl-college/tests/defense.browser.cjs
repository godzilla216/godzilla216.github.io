const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { openGame } = require('./browser-harness.cjs');
async function main() {
    const game = await openGame(), ev = game.evaluate;
    let passed = 0;
    function pass(name) { passed++; console.log('PASS: ' + name); }
    try {
        await ev('(function(){var c=GetWithArray(98)[0];gml_Script_s_msg_clear(c,c);gml_Script_btn_click_Details_Continue(c,c);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_home"');
        await ev('(function(){var c=GetWithArray(98)[0];c.gmlintro=0;c.gmltimeout_message_done=true;c.gmlbullet_throw_message_done=true;c.gmlstage=2;gml_Script_s_play(c,c,1);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_pre_match"');
        await ev('gml_Script_btn_click_Continue(GetWithArray(100400)[0],GetWithArray(98)[0]);true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_match"&&GetWithArray(105).length===1');
        await ev(`window.defenseTest = {
            setup: function(options) {
                var m=GetWithArray(105)[0]; options=options||{};
                gml_Script_s_msg_clear(m,m);
                gml_Script_s_destroy_match_objects(m,m);
                m.gmlstate=2; m.gmlcomm_stage=3; m.gmlcomm_proceed=false; m.gmlkicking=0;
                m.gmlpossession=options.offense?Number(m.gmlhuman_team):1-Number(m.gmlhuman_team);
                m.gmldown=options.down||1; m.gmlyards=options.yards||10; m.gmlscrimmage=options.scrim===undefined?-25:options.scrim;
                m.gmlminutes=2; m.gmlseconds=0; m.gmltime_subtract=0; m.alarm[0]=-1; m.alarm[1]=-1;
                random_set_seed(1234);gml_Script_s_set_up_play(m,m,true);
                return {live:!!m._liveDefense,ball:global.gmlmaster_ball,offense:GetWithArray(108).length,defense:GetWithArray(109).length};
            },
            isolate: function(){var m=GetWithArray(105)[0]; GetWithArray(107).forEach(function(p){p.x=2000+p.gmlinum*23;p.y=440;p.hspeed=0;p.vspeed=0;p.gmltackling=-4;});return m;},
            summary: function(){var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0];return {down:m.gmldown,yards:m.gmlyards,scrim:m.gmlscrimmage,possession:Number(m.gmlpossession),human:Number(m.gmlhuman_team),score:m.gmlteam_score.slice(),state:m.gmlstate,ballState:b&&b.gmlstate};}
        };true`);
        assert.deepEqual(await ev('defenseTest.setup()'), { live: true, ball: await ev('global.gmlmaster_ball'), offense: 11, defense: 11 });
        pass('live opponent possession creates eleven offensive and eleven defensive players');
        const layout = await ev(`(function(){
            var m=GetWithArray(105)[0], originalWidth=display_get_gui_width, originalText=gml_Script_draw_hd_text_ext_transformed;
            var originalRectangle=draw_rectangle, originalSnapped=m._liveDefense.snapped, results=[];
            try {
                [320,480,640].forEach(function(width){[false,true].forEach(function(snapped){
                    var labels=[],buttons=[];display_get_gui_width=function(){return width;};m._liveDefense.snapped=snapped;
                    gml_Script_draw_hd_text_ext_transformed=function(a,b,x,y,text,sep,w,sx){var half=gml_Script_string_hd_width(a,b,text)*sx/2;labels.push({left:x-half,right:x+half,y:y});};
                    draw_rectangle=function(x,y,right,bottom,outline){if(outline)buttons.push({left:x,right:right,y:y});};
                    RetroDefense.draw(m);
                    var items=labels.concat(buttons);
                    results.push(items.every(function(item){return item.left>=0&&item.right<=width;})&&
                        labels.every(function(a,i){return labels.every(function(b,j){return i===j||Math.abs(a.y-b.y)>=10||a.right<=b.left||b.right<=a.left;});})&&
                        buttons.every(function(a,i){return buttons.every(function(b,j){return i===j||a.right<b.left||b.right<a.left;});})&&
                        buttons.every(function(button){return labels.some(function(label){return label.y>button.y&&label.left>=button.left+4&&label.right<=button.right-4;});}));
                });});
                return results;
            } finally {display_get_gui_width=originalWidth;gml_Script_draw_hd_text_ext_transformed=originalText;draw_rectangle=originalRectangle;m._liveDefense.snapped=originalSnapped;}
        })()`);
        assert(layout.every(Boolean), JSON.stringify(layout));
        pass('defense labels and buttons fit without overlap before and after snap at three GUI widths');
        const identity = await ev(`(function(){
            var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(b.gmlholder)[0];
            var savedName=p.gmlpos_name,savedMap=p.gmlpmap,originalText=gml_Script_draw_hd_text_ext_transformed,originalSprite=draw_sprite;
            var map=ds_map_create(),labels=[],icons=[];ds_map_set(map,'attitude',100);
            try {
                p.gmlpmap=map;p.gmlpos_name='QB A VERY LONG PLAYER NAME THAT MUST FIT BELOW THE SCOREBUG';
                gml_Script_draw_hd_text_ext_transformed=function(a,b,x,y,text,sep,w,sx){if(text===p.gmlpos_name)labels.push({x:x,y:y,right:x+gml_Script_string_hd_width(a,b,text)*sx});};
                draw_sprite=function(a,sprite,frame,x,y){if(x===22)icons.push({x:x,y:y});};
                gml_Script_s_draw_scoreboard(m,m);
                return {labels:labels,icons:icons,width:display_get_gui_width()};
            } finally {p.gmlpos_name=savedName;p.gmlpmap=savedMap;ds_map_destroy(map);gml_Script_draw_hd_text_ext_transformed=originalText;draw_sprite=originalSprite;}
        })()`);
        assert.equal(identity.labels.length, 1);
        assert.equal(identity.labels[0].x, 34); assert.equal(identity.labels[0].y, 28);
        assert(identity.labels[0].right <= Math.min(254, identity.width - 14));
        assert.deepEqual(identity.icons, [{ x: 22, y: 28 }]);
        pass('carrier name and attitude render together below the scorebug, with long names fitted');
        if (process.argv.includes('--screenshots')) {
            const folder = fs.mkdtempSync(path.join(require('node:os').tmpdir(), 'retro-bowl-defense-preview-'));
            await ev(`(function(){var b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(b.gmlholder)[0];window.identityPreview={p:p,name:p.gmlpos_name,map:p.gmlpmap};p.gmlpmap=ds_map_create();ds_map_set(p.gmlpmap,'attitude',100);p.gmlpos_name='QB ALEXANDER MONTGOMERY';return true;})()`);
            await game.sleep(150); await game.screenshot(path.join(folder, 'pregame.png'));
            await ev(`(function(){var s=window.identityPreview;ds_map_destroy(s.p.gmlpmap);s.p.gmlpos_name=s.name;s.p.gmlpmap=s.map;delete window.identityPreview;return true;})()`);
            game.screenshotFolder = folder; console.log('Screenshots: ' + folder);
        }
        await ev('RetroDefense.snap(GetWithArray(105)[0]);true');
        const before = await ev('(function(){var m=GetWithArray(105)[0],p=GetWithArray(m._liveDefense.selected)[0];return {id:p.id,x:p.x,y:p.y};})()');
        await game.send('Input.dispatchKeyEvent', { type: 'keyDown', key: 'ArrowDown', code: 'ArrowDown', windowsVirtualKeyCode: 40 });
        await game.sleep(250);
        await game.send('Input.dispatchKeyEvent', { type: 'keyUp', key: 'ArrowDown', code: 'ArrowDown', windowsVirtualKeyCode: 40 });
        assert((await ev(`GetWithArray(${before.id})[0].y`)) > before.y);
        pass('actual keyboard input accelerates and moves the selected defender');
        const oldSelected = await ev('GetWithArray(105)[0]._liveDefense.selected');
        await game.send('Input.dispatchKeyEvent', { type: 'keyDown', key: 'q', code: 'KeyQ', windowsVirtualKeyCode: 81 });
        await game.sleep(80);
        await game.send('Input.dispatchKeyEvent', { type: 'keyUp', key: 'q', code: 'KeyQ', windowsVirtualKeyCode: 81 });
        assert.notEqual(await ev('GetWithArray(105)[0]._liveDefense.selected'), oldSelected);
        pass('actual switching input chooses another valid defender');
        if (game.screenshotFolder) await game.screenshot(path.join(game.screenshotFolder, 'live.png'));
        assert.equal(await ev('(function(){var p=GetWithArray(109)[0];p.x=99999;p.y=-100;RetroDefense.bounds(p);return p.x===2455&&p.y===134&&p.hspeed===0&&p.vspeed===0;})()'), true);
        pass('movement bounds clamp defenders without leaving outward velocity');
        // Resolve a deterministic sack using actual native ball/down functions.
        const sack = await ev(`(function(){defenseTest.setup();var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],qb=GetWithArray(b.gmlholder)[0],p=GetWithArray(109)[0];
            RetroDefense.snap(m);qb.x=m.gmlx_scrim-m.gmldrivedir*80;qb.y=300;p.x=qb.x;p.y=qb.y;
            var first=RetroDefense.tackle(m,p,qb,14),again=RetroDefense.tackle(m,p,qb,14),state=b.gmlstate;
            gml_Object_obj_controller_Alarm_0(m,m);var result=defenseTest.summary();result.first=first;result.again=again;result.sackState=state;return result;})()`);
        assert.equal(sack.first, true); assert.equal(sack.again, false); assert.equal(sack.sackState, 11); assert.equal(sack.down, 2); assert.equal(sack.yards, 14); assert.equal(sack.scrim, -29);
        pass('sack ends once at the carrier spot and native rules apply a four-yard loss');
        const wrong = await ev('(function(){defenseTest.setup();var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(109)[0],receiver=GetWithArray(108).find(function(x){return x.gmlposition===4});RetroDefense.snap(m);p.x=receiver.x;p.y=receiver.y;return RetroDefense.tackle(m,p,receiver,24);})()');
        assert.equal(wrong, false); pass('a nearby receiver without the ball cannot end a play');
        const gain = await ev(`(function(){defenseTest.setup();var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],rb=GetWithArray(108).find(function(p){return p.gmlposition===2}),p=GetWithArray(109)[0];
            RetroDefense.snap(m);rb.x=m.gmlx_scrim+m.gmldrivedir*240;rb.y=300;rb.gmlstiff_arm=0;gml_Script_s_receive_ball(rb,rb);p.x=rb.x;p.y=rb.y;
            RetroDefense.tackle(m,p,rb,14);gml_Object_obj_controller_Alarm_0(m,m);return defenseTest.summary();})()`);
        assert.equal(gain.down, 1); assert.equal(gain.yards, 10); assert.equal(gain.scrim, -13);
        pass('completed catch and tackle beyond the sticks grant the native first down');
        const incomplete = await ev('(function(){defenseTest.setup();var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0];RetroDefense.snap(m);b.gmlholder=-4;b.gmlstate=7;b.gmlis_dead=true;gml_Object_obj_controller_Alarm_0(m,m);return defenseTest.summary();})()');
        assert.equal(incomplete.down, 2); assert.equal(incomplete.scrim, -25); assert.equal(incomplete.yards, 10);
        pass('native incomplete-pass outcome advances the down without moving the spot');
        const interceptions = await ev(`(function(){defenseTest.setup();var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(109).find(function(p){return p.gmlposition===8||p.gmlposition===9}),qb=GetWithArray(b.gmlholder)[0];
            RetroDefense.snap(m);p.x=1300;p.y=300;p.gmlnearest_opp=-4;p.gmltackling=-4;p.gmlballdist=0;p.gmlskill=10;b.x=p.x;b.y=p.y;b.gmlxthrow=1000;b.gmlythrow=300;b.gmlholder=-4;b.gmlstate=3;
            b.gmlheight=50;gml_Script_s_check_ball_collision(p,p);var high=b.gmlholder===-4;
            b.gmlheight=20;p.gmlballdist=50;gml_Script_s_check_ball_collision(p,p);var far=b.gmlholder===-4;
            p.gmlballdist=0;p.y=100;gml_Script_s_check_ball_collision(p,p);var outside=b.gmlholder===-4;
            p.y=300;gml_Script_s_check_ball_collision(p,p);var caught=b.gmlholder===p.id&&b.gmlstate===9;
            qb.x=p.x;qb.y=p.y;var tackled=RetroDefense.tackle(m,qb,p,14);gml_Object_obj_controller_Alarm_0(m,m);gml_Script_s_update_commentary(m,m);var result=defenseTest.summary();result.high=high;result.far=far;result.outside=outside;result.caught=caught;result.tackled=tackled;return result;})()`);
        assert(interceptions.high && interceptions.far && interceptions.outside && interceptions.caught && interceptions.tackled, JSON.stringify(interceptions));
        assert.equal(interceptions.possession, interceptions.human);
        pass('native interception rejects high, distant and out-of-bounds balls; return tackle transfers possession once');
        const catchResult = await ev(`(function(){defenseTest.setup();var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],r=GetWithArray(108).find(function(p){return p.gmlposition===4}),shadow=GetWithArray(112)[0];
            RetroDefense.snap(m);r.x=1300;r.y=300;r.gmlnearest_opp=-4;r.gmlballdist=0;r.gmltackling=-4;r.gmlskill=10;r.gmlintheclear=true;
            b.x=r.x;b.y=r.y;b.gmlxthrow=1000;b.gmlythrow=300;b.gmlholder=-4;b.gmlstate=3;b.gmlheight=20;shadow.gmlbounce_x=r.x;shadow.gmlbounce_y=r.y;
            gml_Script_s_check_ball_collision(r,r);return {caught:b.gmlholder===r.id,state:b.gmlstate};})()`);
        assert.deepEqual(catchResult, { caught: true, state: 5 });
        pass('a valid offensive reception uses the original catch system');
        const fumble = await ev(`(function(){defenseTest.setup();var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(109)[0],rb=GetWithArray(108).find(function(p){return p.gmlposition===2});
            RetroDefense.snap(m);m.gmlsnaps=24;p.gmlinum=1;p.gmlstrength=8;rb.gmlskill=3;rb.gmlstiff_arm=0;rb.x=1300;rb.y=300;p.x=1300;p.y=300;
            gml_Script_s_receive_ball(rb,rb);RetroDefense.tackle(m,p,rb,14);var dropped=b.gmlholder===-4&&b.gmlfumble_time>0&&!m._liveDefense.ended;
            b.gmlstate=13;b.gmlheight=1;b.gmldropped_time=0;b.gmlxthrow=1000;b.gmlythrow=300;b.x=p.x;b.y=p.y;p.gmlballdist=0;p.gmltackling=-4;p.gmlnearest_opp=-4;
            gml_Script_s_check_ball_collision(p,p);var recovered=b.gmlholder===p.id&&b.gmlstate===10;gml_Object_obj_controller_Alarm_0(m,m);gml_Script_s_update_commentary(m,m);
            var result=defenseTest.summary();result.dropped=dropped;result.recovered=recovered;return result;})()`);
        assert(fumble.dropped && fumble.recovered); assert.equal(fumble.possession, fumble.human);
        pass('rating-based fumble uses native loose-ball recovery and turnover rules');
        const broken = await ev(`(function(){defenseTest.setup();var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(109)[0],rb=GetWithArray(108).find(function(p){return p.gmlposition===2});
            RetroDefense.snap(m);rb.x=1300;rb.y=300;p.x=1300;p.y=300;rb.gmlstiff_arm=1;gml_Script_s_receive_ball(rb,rb);
            var stopped=RetroDefense.tackle(m,p,rb,14);return {stopped:stopped,arm:rb.gmlstiff_arm,fallen:!!p.gmldead,live:!b.gmlis_dead};})()`);
        assert.deepEqual(broken, { stopped: false, arm: 0, fallen: true, live: true });
        pass('a stiff arm consumes its native allowance and leaves the play live');
        const scoring = await ev(`(function(){defenseTest.setup({scrim:48});var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],rb=GetWithArray(108).find(function(p){return p.gmlposition===2});
            RetroDefense.snap(m);var before=m.gmlteam_score[Number(m.gmlpossession)],tds=m.gmltouchdowns;
            rb.x=m.gmldrivedir===1?2302:298;rb.y=300;gml_Script_s_receive_ball(rb,rb);b.x=rb.x;b.y=300;b.gmlheight=20;
            gml_Script_s_check_ball_position(b,b);gml_Object_obj_controller_Alarm_0(m,m);
            return {points:m.gmlteam_score[Number(m.gmlpossession)]-before,userTouchdowns:m.gmltouchdowns-tds,stage:m.gmlcomm_stage,message:instance_exists(79)};})()`);
        assert.equal(scoring.points, 6); assert.equal(scoring.userTouchdowns, 0); assert.equal(scoring.stage, 10); assert.equal(scoring.message, false);
        pass('CPU touchdown credits the opposing score without awarding user touchdown stats or a PAT prompt');
        const defensiveTD = await ev(`(function(){defenseTest.setup();var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(109)[0],human=Number(m.gmlhuman_team),before=m.gmlteam_score[human];
            RetroDefense.snap(m);p.x=m.gmldrivedir===1?298:2302;p.y=300;gml_Script_s_receive_ball(p,p);b.gmlstate=9;b.x=p.x;b.y=p.y;b.gmlheight=20;
            gml_Script_s_check_ball_position(b,b);gml_Object_obj_controller_Alarm_0(m,m);
            return {points:m.gmlteam_score[human]-before,possession:Number(m.gmlpossession),human:human};})()`);
        assert.equal(defensiveTD.points, 6); assert.equal(defensiveTD.possession, defensiveTD.human);
        pass('defensive return touchdown credits six points and possession to the human team');
        const safety = await ev(`(function(){defenseTest.setup({scrim:-49});var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],qb=GetWithArray(b.gmlholder)[0],p=GetWithArray(109)[0],human=Number(m.gmlhuman_team),before=m.gmlteam_score[human];
            RetroDefense.snap(m);qb.x=m.gmldrivedir===1?298:2302;qb.y=300;p.x=qb.x;p.y=qb.y;RetroDefense.tackle(m,p,qb,14);var state=b.gmlstate;gml_Object_obj_controller_Alarm_0(m,m);return {state:state,points:m.gmlteam_score[human]-before};})()`);
        assert.equal(safety.state, 12); assert.equal(safety.points, 2);
        pass('safety in the opposing end zone awards the native two points');
        const reset = await ev(`(function(){defenseTest.setup();var m=GetWithArray(105)[0],old=m._liveDefense;old.contact[123]=99;old.cooldown[123]=99;old.joystick={x:1,y:1};old.ended=true;m.alarm[0]=30;RetroDefense.reset(m);var cancelled=m.alarm[0]===-1;
            defenseTest.setup();var fresh=m._liveDefense;return {newBall:fresh.ballId!==old.ballId,clean:!fresh.ended&&!fresh.snapped&&Object.keys(fresh.contact).length===0&&Object.keys(fresh.cooldown).length===0&&fresh.joystick===null,oldGone:GetWithArray(old.selected).length===0,cancelled:cancelled};})()`);
        assert(reset.newBall && reset.clean && reset.oldGone && reset.cancelled);
        pass('play reset destroys old player references and clears contacts, cooldowns, pointer and ending state');
        assert.equal(await ev('(function(){var m=GetWithArray(105)[0];RetroDefense.snap(m);for(var i=0;i<100;i++){RetroDefense.switchPlayer(m);RetroDefense.dive(m);}return !!GetWithArray(m._liveDefense.selected)[0]&&m._liveDefense.tackleEvents<=1;})()'), true);
        pass('rapid switching and tackle inputs leave a valid player and no duplicate ending');
        const thirdDown = await ev(`(function(){defenseTest.setup({down:3});var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],qb=GetWithArray(b.gmlholder)[0],p=GetWithArray(109)[0];
            RetroDefense.snap(m);qb.x=m.gmlx_scrim;qb.y=300;p.x=qb.x;p.y=qb.y;RetroDefense.tackle(m,p,qb,14);gml_Object_obj_controller_Alarm_0(m,m);
            return {down:m.gmldown,state:m.gmlstate,stage:m.gmlcomm_stage,live:!!m._liveDefense};})()`);
        assert.equal(thirdDown.down, 1); assert.equal(thirdDown.state, 1); assert.equal(thirdDown.stage, 5); assert.equal(thirdDown.live, false);
        pass('third-down stop routes the CPU fourth-down decision to native special teams');
        const fieldGoal = await ev('(function(){defenseTest.setup({down:4,scrim:45});var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0];return {live:RetroDefense.cpuFieldGoal(m),kicking:m.gmlkicking,state:m.gmlstate,ball:b.gmlstate};})()');
        assert.deepEqual(fieldGoal,{live:true,kicking:1,state:2,ball:0});
        pass('CPU fourth-down field goal enters the native on-field kicking sequence');
        const turnover = await ev('(function(){defenseTest.setup();var m=GetWithArray(105)[0];m.gmldown=5;gml_Script_s_set_up_play(m,m,true);return defenseTest.summary();})()');
        assert.equal(turnover.state, 1);
        await ev('(function(){var m=GetWithArray(105)[0];for(var i=0;i<8&&Number(m.gmlpossession)!==Number(m.gmlhuman_team);i++)gml_Script_s_update_commentary(m,m);return true;})()');
        assert.equal(await ev('Number(GetWithArray(105)[0].gmlpossession)===Number(GetWithArray(105)[0].gmlhuman_team)'), true);
        pass('native turnover-on-downs gives possession to the correct team');
        const clock = await ev('(function(){defenseTest.setup();var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0];RetroDefense.snap(m);b.gmlstate=5;m.gmlgametimer=g_pBuiltIn.get_current_time()-1000;gml_Script_s_update_game_timer(m,m);gml_Script_s_update_game_clock(m,m);return m.gmlminutes*60+m.gmlseconds;})()');
        assert(clock < 120 && clock >= 118); pass('live defense uses the native game clock');
        const quarter = await ev('(function(){defenseTest.setup();var m=GetWithArray(105)[0];m.gmlquarter=1;m.gmlminutes=0;m.gmlseconds=0;gml_Script_s_action_result(m,m,9);for(var i=0;i<8&&m.gmlquarter===1;i++)gml_Script_s_update_commentary(m,m);return {quarter:m.gmlquarter,score:m.gmlteam_score.slice()};})()');
        assert.equal(quarter.quarter, 2); pass('quarter expiration follows the original transition code');
        const halftime = await ev('(function(){defenseTest.setup();var m=GetWithArray(105)[0];m.gmlquarter=2;m.gmlminutes=0;m.gmlseconds=0;gml_Script_s_action_result(m,m,9);for(var i=0;i<8&&m.gmlquarter===2;i++)gml_Script_s_update_commentary(m,m);return {quarter:m.gmlquarter,live:!!m._liveDefense};})()');
        assert.equal(halftime.quarter, 3); assert.equal(halftime.live, false); pass('halftime clears live control and advances to the third quarter');
        // Real touch input goes through GameMaker's existing mouse/touch bridge.
        await ev('defenseTest.setup();true');
        let rect = await ev('(function(){var r=document.getElementById("canvas").getBoundingClientRect();return {x:r.left,y:r.top,w:r.width,h:r.height};})()');
        const point = (x, y) => ({ x: rect.x + rect.w * x / 480, y: rect.y + rect.h * y / 270 });
        await game.send('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: [point(435, 253)] });
        await game.sleep(100);
        await game.send('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] });
        assert.equal(await ev('GetWithArray(105)[0]._liveDefense.snapped'), true);
        await game.until('!device_mouse_check_button(0,1) && !device_mouse_check_button(1,1) && !device_mouse_check_button(2,1)');
        // The first touch can resize the canvas; use its current screen bounds.
        rect = await ev('(function(){var r=document.getElementById("canvas").getBoundingClientRect();return {x:r.left,y:r.top,w:r.width,h:r.height};})()');
        const touchBefore = await ev('(function(){var m=defenseTest.isolate(),p=GetWithArray(m._liveDefense.selected)[0];GetWithArray(109).forEach(function(d){d.x=500+d.gmlinum*20;});p.x=1300;p.y=230;return {id:p.id,x:p.x};})()');
        await game.send('Input.dispatchTouchEvent', { type: 'touchStart', touchPoints: [point(200, 170)] });
        // Chromium's compatibility mouse may first become held on a move.
        // Establish the stick anchor before testing displacement from it.
        await game.send('Input.dispatchTouchEvent', { type: 'touchMove', touchPoints: [point(200, 170)] });
        await game.until('!!GetWithArray(105)[0]._liveDefense.joystick');
        await game.send('Input.dispatchTouchEvent', { type: 'touchMove', touchPoints: [point(240, 170)] });
        await game.sleep(220);
        const touchState = await ev('(function(){var m=GetWithArray(105)[0],p=GetWithArray(m._liveDefense.selected)[0];return {selected:p.id,x:p.x,hspeed:p.hspeed,input:m._liveDefense.input,stick:m._liveDefense.joystick,state:m.gmlstate,snapped:m._liveDefense.snapped,devices:[0,1,2].map(function(i){return {held:device_mouse_check_button(i,1),x:device_mouse_x_to_gui(i),y:device_mouse_y_to_gui(i)}})};})()');
        await game.send('Input.dispatchTouchEvent', { type: 'touchEnd', touchPoints: [] });
        assert((await ev(`GetWithArray(${touchBefore.id})[0].x`)) > touchBefore.x, JSON.stringify(touchState));
        pass('real touch Snap and virtual-stick drag move the defender');
        const gamepad = await ev(`(function(){defenseTest.setup();var m=GetWithArray(105)[0],selected=m._liveDefense.selected,oldGet=GetWithArray,oldPressed=gamepad_button_check_pressed,oldPad=global.gmlgamepad,oldGP=global.gmlgp;
            var gp={gmlslot:0,gmlaxisl_h:0.6,gmlaxisl_v:-0.8};
            try{GetWithArray=function(index){return index===-999?[gp]:oldGet(index);};global.gmlgp=-999;global.gmlgamepad=true;
                gamepad_button_check_pressed=function(slot,button){return button===32771||button===global.gmlgp_select;};RetroDefense.step(m);
                return {switched:m._liveDefense.selected!==selected,snapped:m._liveDefense.snapped,x:m._liveDefense.input.x,y:m._liveDefense.input.y};
            }finally{GetWithArray=oldGet;gamepad_button_check_pressed=oldPressed;global.gmlgamepad=oldPad;global.gmlgp=oldGP;}})()`);
        assert.deepEqual(gamepad, { switched: true, snapped: true, x: .6, y: -.8 });
        pass('gamepad input adapter reads native axes, switching and Snap buttons (mocked device)');
        const browserPad = await ev(`(function(){defenseTest.setup();var m=GetWithArray(105)[0],saved=[gamepad_get_device_count,gamepad_is_connected,gamepad_axis_value,gamepad_button_check_pressed,global.gmlgamepad];
            try{global.gmlgamepad=false;gamepad_get_device_count=function(){return 1;};gamepad_is_connected=function(slot){return slot===0;};gamepad_axis_value=function(slot,axis){return axis===32785?0.8:0.6;};gamepad_button_check_pressed=function(slot,button){return button===32769;};RetroDefense.step(m);return {snapped:m._liveDefense.snapped,x:m._liveDefense.input.x,y:m._liveDefense.input.y};
            }finally{gamepad_get_device_count=saved[0];gamepad_is_connected=saved[1];gamepad_axis_value=saved[2];gamepad_button_check_pressed=saved[3];global.gmlgamepad=saved[4];}})()`);
        assert.deepEqual(browserPad, { snapped: true, x: .8, y: .6 });
        pass('browser gamepad fallback works while the original GML pad manager remains disabled (mocked device)');
        const natural = await ev('(function(){defenseTest.setup({offense:true});var m=GetWithArray(105)[0];gml_Script_s_destroy_match_objects(m,m);m.gmlpossession=1-Number(m.gmlhuman_team);m.gmlstate=1;m.gmlcomm_stage=3;m.gmlcomm_proceed=true;gml_Script_s_obj_controller_step(m,m);gml_Script_s_obj_controller_step(m,m);return {state:m.gmlstate,live:!!m._liveDefense,players:GetWithArray(107).length};})()');
        assert.deepEqual(natural, { state: 2, live: true, players: 22 });
        pass('ordinary opponent commentary transitions naturally into live defensive control');
        const pursuitBefore = await ev(`(function(){defenseTest.setup();var m=defenseTest.isolate(),b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(109)[0],rb=GetWithArray(108).find(function(p){return p.gmlposition===2});
            RetroDefense.snap(m);rb.x=1300;rb.y=300;rb.gmlstiff_arm=0;p.x=1300+m.gmldrivedir*120;p.y=300;gml_Script_s_receive_ball(rb,rb);return {id:p.id,carrier:rb.id,distance:point_distance(p.x,p.y,rb.x,rb.y)};})()`);
        await game.sleep(350);
        assert((await ev(`(function(){var p=GetWithArray(${pursuitBefore.id})[0],r=GetWithArray(${pursuitBefore.carrier})[0];return point_distance(p.x,p.y,r.x,r.y);})()`)) < pursuitBefore.distance);
        pass('an uncontrolled defender actually closes on a running ball carrier');
        // Compare offense with all defense hooks inert, using the same native seed.
        const regression = await ev(`(function(){var hooks={},names=['step','destination','updateBall','skipHuman','opponentOffense','skipNativeTackle','bounds','draw','marker'];
            function snapshot(){defenseTest.setup({offense:true});var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0];
                var players=GetWithArray(107).map(function(p){return {offense:p.gmloffense,inum:p.gmlinum,position:p.gmlposition,x:p.x,y:p.y,accel:p.gmlmy_accel};});
                b.gmldirec=m.gmldrivedir===1?0:180;b.gmlvelocity=8;b.gmlzvel=2.4;b.gmlheight=1;gml_Script_s_throw_ball(b,b);
                for(var i=0;i<20;i++)gml_Script_s_update_ball(b,b);return {players:players,ball:{x:b.x,y:b.y,height:b.gmlheight,state:b.gmlstate,velocity:b.gmlvelocity},live:!!m._liveDefense};}
            names.forEach(function(n){hooks[n]=RetroDefense[n];RetroDefense[n]=function(){return false;};});
            var baseline=snapshot();names.forEach(function(n){RetroDefense[n]=hooks[n];});var current=snapshot();return {baseline:baseline,current:current};})()`);
        assert.deepEqual(regression.current, regression.baseline);
        assert.equal(regression.current.ball.state, 3); assert.equal(regression.current.live, false);
        pass('seeded offensive formations and a native thrown ball match the inert-hook baseline exactly');
        const disabled = await ev('(function(){var c=GetWithArray(98)[0],m=GetWithArray(105)[0];c.gmlsim_action=true;m.gmlpossession=1-Number(m.gmlhuman_team);var sim=RetroDefense.shouldPlay(m);c.gmlsim_action=false;c.gmlqb_mode=true;var qb=RetroDefense.shouldPlay(m);c.gmlqb_mode=false;return {sim:sim,qb:qb};})()');
        assert.deepEqual(disabled, { sim: false, qb: false });
        pass('simulation and quarterback career modes retain their existing possession behavior');
        // Let a real CPU play run without synthetic outcome injection.
        await ev('defenseTest.setup();RetroDefense.snap(GetWithArray(105)[0]);true');
        await game.until('GetWithArray(global.gmlmaster_ball)[0] && GetWithArray(global.gmlmaster_ball)[0].gmlis_dead', 15000);
        pass('uncontrolled defenders and CPU offense produce a real play outcome');
        await ev('(function(){var m=GetWithArray(105)[0];gml_Script_s_destroy_match_objects(m,m);m.gmlquarter=3;m.gmlminutes=0;m.gmlseconds=0;gml_Script_s_action_result(m,m,9);for(var i=0;i<8&&m.gmlquarter===3;i++)gml_Script_s_update_commentary(m,m);m.gmlminutes=0;m.gmlseconds=0;m.gmlteam_score[Number(m.gmlhuman_team)]=m.gmlteam_score[1-Number(m.gmlhuman_team)]+7;gml_Script_s_action_result(m,m,9);return true;})()');
        await game.until('GetWithArray(105)[0] && GetWithArray(105)[0].gmlcomm_stage===13 && GetWithArray(32).length>0');
        await ev('GetWithArray(32).slice().forEach(function(b){gml_Script_btn_kick_off(b,b);});true');
        await game.until('room_get_name(g_pBuiltIn.room)!=="rm_match" && GetWithArray(105).length===0', 15000);
        assert.equal(await ev('GetWithArray(105).length'), 0);
        const finalResult = await ev('(function(){var c=GetWithArray(98)[0],f=gml_Script_s_get_human_fixture_by_week(c,c,c.gmlweek);return {result:ds_map_find_value(f,"human_win"),scores:c.gmltscore.slice(),human:Number(c.gmlplayerteamindex),room:room_get_name(g_pBuiltIn.room)};})()');
        assert.equal(finalResult.result, 'win'); assert.equal(finalResult.scores[finalResult.human]-finalResult.scores[1-finalResult.human], 7);
        pass('end-of-game records the final result, opens a native postgame screen and destroys the controller');
        await ev('room_goto(YYASSET_REF(0x03000011));true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_match"&&GetWithArray(105).length===1');
        assert.equal(await ev('!!GetWithArray(105)[0]._liveDefense'), false);
        pass('a new match starts without stale defensive player or AI state');
        console.log('Runtime errors:', JSON.stringify(game.errors));
        assert.deepEqual(game.errors, []); assert.deepEqual(game.external, []);
        console.log(`${passed} browser checks passed; no external requests or runtime errors.`);
    } finally { await game.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });
