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
        const results = await ev(`(function(){
            var nativeStep=_7F3,nativeRAF=window.requestAnimFrame,nativeNow=performance.now,nativeDate=Date.now,nativeTime=g_pBuiltIn.get_current_time;
            var nativeKeys=keyboard_check,nativePress=keyboard_check_pressed,results=[];
            var simTime=100000,frameTime=0,ticks=0;
            try {
                window.requestAnimFrame=function(){};
                performance.now=function(){return frameTime;};Date.now=function(){return 1000000+frameTime;};
                g_pBuiltIn.get_current_time=function(){return simTime;};
                keyboard_check=keyboard_check_pressed=function(){return false;};
                _7F3=function(dt){ticks++;simTime+=dt;nativeStep(dt);};
                ["scrimmage","flight"].forEach(function(scenario){[60,30,144,240].forEach(function(hz){
                    simTime=100000;frameTime=0;ticks=0;retroFrameClock=null;retroPreviousPose=null;
                    var m=GetWithArray(105)[0];gml_Script_s_msg_clear(m,m);gml_Script_s_destroy_match_objects(m,m);_4F3();
                    m.gmlstate=2;m.gmlcomm_stage=3;m.gmlcomm_proceed=false;m.gmlkicking=0;m.gmlpossession=1-Number(m.gmlhuman_team);
                    m.gmldown=1;m.gmlyards=10;m.gmlscrimmage=-25;m.gmldrivedir=1;m.gmlquarter=1;m.gmlsnaps=0;
                    m.gmlminutes=2;m.gmlseconds=0;m.gmltime_subtract=0;m.alarm[0]=-1;m.alarm[1]=-1;
                    random_set_seed(1234);gml_Script_s_set_up_play(m,m,true);RetroDefense.snap(m);
                    if(scenario==="flight"){
                        var airborne=GetWithArray(global.gmlmaster_ball)[0];airborne.gmlstate=3;airborne.gmlholder=-4;
                        airborne.x=1500;airborne.y=300;airborne.gmlheight=60;airborne.gmlzvel=3;airborne.gmlvelocity=4;airborne.gmldirec=0;
                    }
                    for(var i=0;i<=hz;i++){frameTime=i*1000/hz;_EE3();}
                    var b=GetWithArray(global.gmlmaster_ball)[0];
                    results.push({scenario:scenario,hz:hz,ticks:ticks,players:GetWithArray(107).map(function(p){return {of:p.gmloffense,num:p.gmlinum,x:p.x,y:p.y,vx:p.hspeed,vy:p.vspeed,anim:p.gmlanim};}).sort(function(a,b){return Number(a.of)-Number(b.of)||a.num-b.num;}),
                        ball:{x:b.x,y:b.y,height:b.gmlheight,velocity:b.gmlvelocity,state:b.gmlstate},clock:[m.gmlminutes,m.gmlseconds],down:m.gmldown});
                });});
            } finally {
                _7F3=nativeStep;window.requestAnimFrame=nativeRAF;performance.now=nativeNow;Date.now=nativeDate;g_pBuiltIn.get_current_time=nativeTime;
                keyboard_check=nativeKeys;keyboard_check_pressed=nativePress;retroFrameClock=null;retroPreviousPose=null;
            }
            return results;
        })()`);
        const baselines = new Map();
        for (const result of results) {
            if (!baselines.has(result.scenario)) baselines.set(result.scenario, result);
            const baseline = baselines.get(result.scenario);
            const { hz, ...state } = result;
            const { hz: ignored, ...expected } = baseline;
            assert.equal(result.ticks, 61);
            assert.deepEqual(state, expected, `native simulation at ${hz} Hz`);
            console.log(`PASS: native ${result.scenario} players, ball physics, animation, clock and down match at ${hz} Hz`);
        }
        assert.equal(game.errors.length, 0, JSON.stringify(game.errors));
        console.log('No browser runtime errors.');
    } finally { await game.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });
