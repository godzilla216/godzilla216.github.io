const assert = require('node:assert/strict');
const path = require('node:path');
const os = require('node:os');
const { openGame } = require('./browser-harness.cjs');

async function main() {
    const game = await openGame(), ev = game.evaluate;
    const guiPoint = async (x, y) => ev(`(function(){var r=document.querySelector('canvas').getBoundingClientRect();return {x:r.left+${x}/display_get_gui_width()*r.width,y:r.top+${y}/display_get_gui_height()*r.height};})()`);
    async function pointer(type, p, touch) {
        if (touch) await game.send('Input.dispatchTouchEvent', {type:type==='down'?'touchStart':'touchEnd',touchPoints:type==='down'?[{...p,id:0}]:[]});
        else await game.send('Input.dispatchMouseEvent',{type:type==='down'?'mousePressed':'mouseReleased',...p,button:'left',clickCount:1});
    }
    async function tap(p, touch = false) {
        await pointer('down',p,touch); await game.sleep(100); await pointer('up',p,touch); await game.sleep(80);
    }
    async function key(key, code, number) {
        for (const type of ['keyDown','keyUp']) { await game.send('Input.dispatchKeyEvent',{type,key,code,windowsVirtualKeyCode:number}); await game.sleep(80); }
    }
    try {
        assert.equal(await ev('RetroPlaybook.isAutomatic()'),true);
        await ev('room_goto(asset_get_index("rm_options"));true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_options"');
        assert.deepEqual(await ev('[GetWithArray(100311)[0].gmltext,GetWithArray(100302)[0].gmltext,GetWithArray(100302)[0].visible]'),['AUTO PLAYBOOK','ON',true]);
        const optionPoint = await ev('(function(){var b=GetWithArray(100302)[0],r=document.querySelector("canvas").getBoundingClientRect();return {x:r.left+(b.x+b.sprite_width/2)/display_get_gui_width()*r.width,y:r.top+(b.y+b.sprite_height/2)/display_get_gui_height()*r.height};})()');
        await tap(optionPoint);
        assert.equal(await ev('RetroPlaybook.isAutomatic()'),false,'real Options click toggles manual calling');
        await ev('gml_Script_s_update_options(GetWithArray(98)[0],GetWithArray(98)[0]);true');
        assert.deepEqual(await ev('[GetWithArray(100302)[0].visible,GetWithArray(100302)[0].gmltext]'),[true,'OFF']);
        await game.screenshot(path.join(os.tmpdir(),'retro-playbook-options.png'));
        await game.send('Page.reload');
        await game.until('typeof RetroPlaybook!=="undefined"&&typeof GetWithArray==="function"&&GetWithArray(98).length===1&&room_get_name(g_pBuiltIn.room)==="rm_details"',60000);
        assert.equal(await ev('RetroPlaybook.isAutomatic()'),false,'setting survives reload');
        console.log('PASS: Options toggle defaults ON, actual click, refresh and reload persistence');

        await ev('(function(){var c=GetWithArray(98)[0];gml_Script_s_msg_clear(c,c);gml_Script_btn_click_Details_Continue(c,c);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_home"');
        await ev('(function(){var c=GetWithArray(98)[0];c.gmlintro=0;c.gmltimeout_message_done=true;c.gmlbullet_throw_message_done=true;c.gmlstage=2;gml_Script_s_play(c,c,1);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_pre_match"');
        await ev('gml_Script_btn_click_Continue(GetWithArray(100400)[0],GetWithArray(98)[0]);true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_match"&&GetWithArray(105).length===1');
        await ev(`window.playbookTest={
            setup:function(dir,down){
                var m=GetWithArray(105)[0];gml_Script_s_msg_clear(m,m);gml_Script_s_destroy_match_objects(m,m);
                m.gmlstate=2;m.gmlcomm_stage=3;m.gmlcomm_proceed=false;m.gmlkicking=0;
                m.gmlpossession=Number(m.gmlhuman_team);m.gmldown=down||1;m.gmlyards=10;m.gmlscrimmage=-25;
                m.gmldrivedir=dir;m.gmlminutes=2;m.gmlseconds=0;m.gmltime_subtract=0;m.alarm[0]=-1;m.alarm[1]=-1;
                gml_Script_s_set_up_play(m,m,true);
                GetWithArray(109).forEach(function(p){p.x=dir===1?2200:400;p.y=145;});
                return this.info();
            },
            info:function(){var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0],s=m._playbook;
                return {ball:b.id,expected:s&&s.ballId,philly:m._phillySpecial&&m._phillySpecial.phase,selecting:s&&s.selecting,call:s&&s.call,available:s&&s.available,wait:s&&s.waitRelease,
                    specials:[!!m._halfbackPass,!!m._jetSweep,!!m._phillySpecial],state:b.gmlstate,
                    holder:b.gmlholder,seconds:m.gmlseconds,down:m.gmldown,snaps:m.gmlsnaps};}
        };true`);
        const calls = ['pass','run','halfback','jet','philly'];
        for (const dir of [1,-1]) for (const [index,call] of calls.entries()) {
            const before = await ev(`playbookTest.setup(${dir})`);
            assert.equal(before.selecting,true);
            assert.deepEqual(before.available,calls);
            assert.deepEqual(before.specials,[false,false,false],'no random trick before choosing');
            await tap(await guiPoint(10,200));
            assert.equal((await ev('playbookTest.info()')).state,0,'field clicks cannot snap while choosing');
            const card = await ev(`RetroPlaybook.layout().cards[${index}]`);
            await tap(await guiPoint(card.x+card.w/2,card.y+card.h/2),dir===-1);
            assert.equal(await ev('GetWithArray(105)[0]._playbook.selected'),call);
            if (call==='halfback'&&dir===1) await game.screenshot(path.join(os.tmpdir(),'retro-playbook-selector.png'));
            const button = await ev('RetroPlaybook.layout().confirm');
            const confirm = await guiPoint(button.x+button.w/2,button.y+button.h/2);
            await pointer('down',confirm,dir===-1);
            await game.until(`GetWithArray(105)[0]._playbook.call==="${call}"`);
            await game.sleep(150);
            const selected = await ev('playbookTest.info()');
            assert.equal(selected.selecting,false);
            assert.equal(selected.ball,before.ball,'choosing preserves the live formation instances');
            assert.equal(selected.snaps,before.snaps,'choosing does not count an extra snap');
            assert.equal(selected.state,0,'held selection gesture must not snap: '+JSON.stringify(selected));
            assert.equal(selected.seconds,before.seconds,'play selection does not run the clock');
            assert.deepEqual(selected.specials,[call==='halfback',call==='jet',call==='philly']);
            assert.notEqual(await ev('GetWithArray(105)[0].gmltap_msg'),'','show the play instruction before the snap');
            await pointer('up',confirm,dir===-1);
            await game.until('!GetWithArray(105)[0]._playbook.waitRelease');
            if (call==='philly'&&dir===1) {
                for (const replacement of ['pass','philly']) {
                    const reopen = await ev('RetroPlaybook.layout().reopen');
                    await tap(await guiPoint(reopen.x+reopen.w/2,reopen.y+reopen.h/2));
                    await game.until('GetWithArray(105)[0]._playbook.selecting');
                    const card = await ev(`RetroPlaybook.layout().cards.find(function(p){return p.id==='${replacement}';})`);
                    await tap(await guiPoint(card.x+card.w/2,card.y+card.h/2));
                    await tap(confirm);
                    await game.until(`GetWithArray(105)[0]._playbook.call==='${replacement}'&&!GetWithArray(105)[0]._playbook.waitRelease`);
                    if(replacement==='pass') assert.equal(await ev('GetWithArray(108).filter(function(p){return p.gmlposition===1;}).length'),1);
                }
            }
            if (call==='pass') {
                await key('p','KeyP',80);
                assert.equal(await ev('GetWithArray(105)[0]._playbook.selecting'),true,'keyboard reopens the selector');
                await key('1','Digit1',49); await key('Enter','Enter',13);
                await game.until('!GetWithArray(105)[0]._playbook.selecting');
            }
            const snap = await guiPoint(240,140);
            if (call==='pass') {
                const end = await guiPoint(240-dir*75,160);
                await pointer('down',snap,dir===-1);await game.sleep(100);
                if(dir===-1)await game.send('Input.dispatchTouchEvent',{type:'touchMove',touchPoints:[{...end,id:0}]});
                else await game.send('Input.dispatchMouseEvent',{type:'mouseMoved',...end,button:'left',buttons:1});
                await game.until('GetWithArray(global.gmlmaster_ball)[0].gmlstate===2');await game.sleep(80);
                await pointer('up',end,dir===-1);
                await game.until('GetWithArray(global.gmlmaster_ball)[0].gmlstate===3');
            } else await tap(snap,dir===-1);
            if(call==='run') await game.until('GetWithArray(global.gmlmaster_ball)[0].gmlstate===5');
            if(call==='halfback') await game.until('GetWithArray(105)[0]._halfbackPass.phase==="pass"');
            if(call==='jet') await game.until('GetWithArray(105)[0]._jetSweep.phase==="run"',7000);
            if(call==='philly') await game.until('GetWithArray(105)[0]._phillySpecial.phase==="pass"',12000);
            if(call==='run') assert.equal(await ev('GetWithArray(105)[0].gmlrunning_play'),true);
            assert.equal(await ev('GetWithArray(105)[0].gmltap_msg'),'','hide the play instruction after the snap and scripted exchanges');
            console.log('PASS: '+call+' selection, release guard and native play start via '+(dir===1?'mouse':'touch')+' in direction '+dir);
        }
        await ev('playbookTest.setup(1);true');
        const controller = await ev(`(function(){
            var saved=[gamepad_get_device_count,gamepad_is_connected,gamepad_axis_value,gamepad_button_check_pressed,global.gmlgamepad];
            try {
                global.gmlgamepad=false;gamepad_get_device_count=function(){return 1;};gamepad_is_connected=function(){return true;};
                gamepad_axis_value=function(slot,axis){return axis===32785?1:0;};gamepad_button_check_pressed=function(){return false;};
                var m=GetWithArray(105)[0];m._playbook.selected='pass';RetroPlaybook.step(m);
                var selected=m._playbook.selected;
                gamepad_axis_value=function(){return 0;};gamepad_button_check_pressed=function(slot,button){return button===global.gmlgp_select;};
                RetroPlaybook.step(m);return {selected:selected,call:m._playbook.call};
            } finally {
                gamepad_get_device_count=saved[0];gamepad_is_connected=saved[1];gamepad_axis_value=saved[2];
                gamepad_button_check_pressed=saved[3];global.gmlgamepad=saved[4];
            }
        })()`);
        assert.deepEqual(controller,{selected:'run',call:'run'});
        console.log('PASS: controller stick navigation and confirm (simulated device)');

        for (const mode of ['gmlsim_action','gmlqb_mode','gmlgamepractice']) {
            const excluded = await ev(`(function(){playbookTest.setup(1);var c=GetWithArray(98)[0],m=GetWithArray(105)[0];c.${mode}=true;RetroPlaybook.afterSetup(m);c.${mode}=false;return m._playbook;})()`);
            assert.equal(excluded,null);
        }
        assert.equal(await ev('(function(){playbookTest.setup(1);var m=GetWithArray(105)[0];m.gmlpossession=1-Number(m.gmlhuman_team);RetroPlaybook.afterSetup(m);return m._playbook;})()'),null);
        await ev('playbookTest.setup(1,4);gml_Script_s_destroy_match_objects(GetWithArray(105)[0],GetWithArray(105)[0]);gml_Script_s_set_up_play(GetWithArray(105)[0],GetWithArray(105)[0],false);true');
        assert.deepEqual(await ev('GetWithArray(35).map(function(b){return b.gmltext;}).sort()'),['Field Goal','Go for it','Punt'].sort());
        assert.equal(await ev('RetroPunt.start(GetWithArray(105)[0]);GetWithArray(105)[0]._playbook'),null,'punts clear the selector');
        await ev('RetroPlaybook.setAutomatic(true);playbookTest.setup(1);true');
        assert.equal(await ev('GetWithArray(105)[0]._playbook'),null,'automatic calling has no selector');
        assert.equal(game.errors.length,0,JSON.stringify(game.errors));
        console.log('PASS: excluded modes/CPU, fourth-down decisions, punt cleanup and automatic mode');
    } catch (error) {
        console.error('Browser state:',await ev('(function(){return {room:room_get_name(g_pBuiltIn.room),roomId:g_pBuiltIn.room,playbook:typeof RetroPlaybook,masters:GetWithArray(98).length,controllers:GetWithArray(105).length};})()'));
        console.error('Runtime errors:',JSON.stringify(game.errors));
        await game.screenshot(path.join(os.tmpdir(),'retro-playbook-failure.png'));
        throw error;
    } finally { await game.close(); }
}
main().catch(error=>{console.error(error);process.exitCode=1;});
