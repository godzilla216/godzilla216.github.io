const assert=require('node:assert/strict');
const {openGame}=require('./browser-harness.cjs');
async function main(){
    const game=await openGame(),ev=game.evaluate;
    const q=async(type)=>game.send('Input.dispatchKeyEvent',{type,key:'q',code:'KeyQ',windowsVirtualKeyCode:81});
    async function pressQ(hold=100){await q('keyDown');await game.sleep(hold);await q('keyUp');}
    try{
        await ev('(function(){var c=GetWithArray(98)[0];gml_Script_s_msg_clear(c,c);gml_Script_btn_click_Details_Continue(c,c);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_home"');
        await ev('(function(){var c=GetWithArray(98)[0];c.gmlintro=0;c.gmltimeout_message_done=true;c.gmlbullet_throw_message_done=true;c.gmlstage=2;gml_Script_s_play(c,c,1);return true;})()');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_pre_match"');
        await ev('gml_Script_btn_click_Continue(GetWithArray(100400)[0],GetWithArray(98)[0]);true');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_match"&&GetWithArray(105).length===1');
        await ev(`window.pitchTest={freeze:true,roll:0,launches:0,seen:null,trace:[],moveOnDrop:false,
            nativeDestination:gml_Script_s_get_destination,nativeUpdate:RetroLateral.updateBall,nativeCollision:RetroLateral.collision,
            nativeRandom:random,nativeRange:random_range,nativeInterception:RetroDefense.recordInterception,interceptions:0,
            stat:function(p,key){return p.gmlpmap>=0&&ds_map_exists(p.gmlpmap,key)?ds_map_find_value(p.gmlpmap,key):0;},
            setup:function(dir,mode){
                var m=GetWithArray(105)[0];gml_Script_s_msg_clear(m,m);gml_Script_s_destroy_match_objects(m,m);
                m.gmlstate=2;m.gmlcomm_stage=3;m.gmlcomm_proceed=false;m.gmlkicking=0;m.gmlpossession=Number(m.gmlhuman_team);
                m.gmldown=1;m.gmlyards=10;m.gmlscrimmage=-10;m.gmldrivedir=dir;m.gmlminutes=2;m.gmlseconds=0;m.gmltime_subtract=0;m.alarm[0]=-1;m.alarm[1]=-1;
                RetroPlaybook.setAutomatic(true);
                var hb=RetroHalfbackPass.afterSetup,jet=RetroJetSweep.afterSetup,philly=RetroPhillySpecial.afterSetup;
                try{RetroHalfbackPass.afterSetup=RetroHalfbackPass.reset;RetroJetSweep.afterSetup=RetroJetSweep.reset;RetroPhillySpecial.afterSetup=RetroPhillySpecial.reset;gml_Script_s_set_up_play(m,m,true);}
                finally{RetroHalfbackPass.afterSetup=hb;RetroJetSweep.afterSetup=jet;RetroPhillySpecial.afterSetup=philly;}
                this.freeze=true;this.launches=0;this.seen=null;this.trace=[];this.interceptions=0;this.moveOnDrop=false;this.moveOnLaunch=false;
                var offense=GetWithArray(108),from=offense.find(function(p){return p.gmlposition===2;}),target=offense.find(function(p){return p.gmlposition===4;}),forward=offense.find(function(p){return p.id!==target.id&&p.id!==from.id;});
                var x=dir===1?1200:1400;
                GetWithArray(107).forEach(function(p){if(path_exists(p.gmlmy_route))path_delete(p.gmlmy_route);p.gmlmy_route=-1;p.hspeed=0;p.vspeed=0;p.gmldead=false;p.gmltackling=-4;gml_Script_s_set_anim(p,p,0);p.x=x+dir*(p.gmloffense?400:800);p.y=430;});
                from.x=x;from.y=300;target.x=x-dir*80;target.y=300;forward.x=x+dir*10;forward.y=300;
                if(mode==='none')target.x=x-dir*141;
                if(mode==='lateral')target.x=x,target.y=380;
                var b=GetWithArray(global.gmlmaster_ball)[0];b.gmlholder=from.id;b.gmllast_touched_by=from.id;b.gmlstate=5;b.gmlis_dead=false;b.x=x;b.y=300;b.gmlheight=8;b.gmlvelocity=0;b.gmlzvel=0;m.gmlrunning_play=true;
                this.from=from.id;this.target=target.id;
                return {from:from.id,target:target.id,forward:forward.id,tracked:from.gmlpmap>=0&&ds_map_exists(from.gmlpmap,'stat_fumbles'),fumbles:this.stat(from,'stat_fumbles'),attempts:this.stat(from,'stat_attempts'),completions:this.stat(target,'stat_complete')};
            },
            summary:function(){var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0],s=m._lateralPitch;
                return {phase:s&&s.phase,frame:s&&s.frame,state:b.gmlstate,holder:b.gmlholder,dead:b.gmlis_dead,
                    from:s&&s.from,target:s&&s.target,fumbles:this.stat(GetWithArray(this.from)[0],'stat_fumbles'),
                    attempts:this.stat(GetWithArray(this.from)[0],'stat_attempts'),completions:this.stat(GetWithArray(this.target)[0],'stat_complete'),
                    launches:this.launches,last:m._lastLateral,interceptions:this.interceptions,fumbleTime:b.gmlfumble_time};}
        };
        gml_Script_s_get_destination=function(p,o){if(pitchTest.freeze){p.gmljforce=0;return;}return pitchTest.nativeDestination(p,o);};
        random=function(n){return n===1?pitchTest.roll:pitchTest.nativeRandom(n);};
        random_range=function(a,b){return a===-6&&b===6?0:pitchTest.nativeRange(a,b);};
        RetroDefense.recordInterception=function(p){pitchTest.interceptions++;return pitchTest.nativeInterception(p);};
        RetroLateral.updateBall=function(b){var result=pitchTest.nativeUpdate(b),m=GetWithArray(105)[0],s=m._lateralPitch;if(s){if(s!==pitchTest.seen){pitchTest.launches++;pitchTest.seen=s;if(pitchTest.moveOnLaunch)GetWithArray(s.target)[0].x-=m.gmldrivedir*300;}if(s.phase==='flight')pitchTest.trace.push({x:b.x,y:b.y,originX:b.gmlxthrow,originY:b.gmlythrow,holder:b.gmlholder});}return result;};
        RetroLateral.collision=function(p){var result=pitchTest.nativeCollision(p),s=GetWithArray(105)[0]._lateralPitch;if(s&&s.phase==='loose'&&pitchTest.moveOnDrop&&p.id===s.target){p.x+=500;pitchTest.moveOnDrop=false;}return result;};true`);
        for(const dir of [1,-1]){
            for(const mode of ['behind','lateral']){
                const before=await ev(`pitchTest.roll=0;pitchTest.setup(${dir},'${mode}')`);
                await pressQ(450);
                await game.until('pitchTest.summary().phase==="caught"');
                const result=await ev('pitchTest.summary()');
                assert.equal(result.target,before.target);assert.equal(result.holder,before.target);assert.equal(result.state,5);
                assert.equal(result.fumbles,before.fumbles);assert.equal(result.attempts,before.attempts);assert.equal(result.completions,before.completions);
                assert.equal(result.launches,1,'holding Q cannot repeatedly pitch');assert.equal(result.interceptions,0);
                const trace=await ev('pitchTest.trace');assert(trace.length>=3);
                assert(trace.every(p=>p.holder===-4&&(p.x-p.originX)*dir<=1e-6&&Math.hypot(p.x-p.originX,p.y-p.originY)<=140.001));
                const start=await ev(`pitchTest.freeze=false;GetWithArray(${before.target})[0].x`);
                await game.until(`(GetWithArray(${before.target})[0].x-${start})*${dir}>5`);
                console.log('PASS: actual Q '+mode+' pitch, finite airborne travel, nearest target and running control: '+dir);
            }
            const noTarget=await ev(`pitchTest.setup(${dir},'none')`);await pressQ();
            assert.equal(await ev('pitchTest.summary().launches'),0);assert.equal(await ev('pitchTest.summary().holder'),noTarget.from);
            console.log('PASS: closer forward players and targets beyond seven yards are rejected: '+dir);

            const failed=await ev(`pitchTest.roll=0.999999;var before=pitchTest.setup(${dir},'behind');pitchTest.moveOnDrop=true;before`);
            await pressQ();await game.until('pitchTest.summary().phase==="loose"');await game.sleep(180);
            const loose=await ev('pitchTest.summary()');
            assert.equal(loose.state,13);assert.equal(loose.dead,false);assert.equal(loose.holder,-4);assert.equal(loose.fumbles,failed.fumbles+(failed.tracked?1:0));assert.equal(loose.interceptions,0);assert(loose.fumbleTime>0);
            const recovered=await ev(`(function(){var b=GetWithArray(global.gmlmaster_ball)[0],p=GetWithArray(${dir===1?'108':'109'}).find(function(p){return ${dir===1?'p.gmlposition===5':'true'};});
                p.x=b.x;p.y=b.y;p.gmltackling=-4;p.gmldead=false;gml_Script_s_set_anim(p,p,0);b.gmlheight=1;gml_Script_s_check_ball_collision(p,p);return {id:p.id,state:b.gmlstate,holder:b.gmlholder};})()`);
            assert.equal(recovered.holder,recovered.id);assert.equal(recovered.state,dir===1?5:10);
            assert.equal(await ev('pitchTest.summary().fumbles'),failed.fumbles+(failed.tracked?1:0),'recovering does not add another fumble');
            assert.equal(await ev('pitchTest.summary().interceptions'),0);
            console.log('PASS: failed catch is a live fumble, charged once, recoverable by '+(dir===1?'a teammate (including a lineman)':'the defense without an interception')+': '+dir);

            const moving=await ev(`pitchTest.roll=0;var before=pitchTest.setup(${dir},'behind');pitchTest.moveOnLaunch=true;before`);
            await pressQ();
            await game.until('pitchTest.summary().phase==="loose"');
            assert.equal(await ev('pitchTest.summary().state'),13);
            assert.equal(await ev('pitchTest.summary().fumbles'),moving.fumbles+(moving.tracked?1:0));
            assert.equal(await ev('pitchTest.trace.every(function(p){return Math.hypot(p.x-p.originX,p.y-p.originY)<=140.001;})'),true);
            console.log('PASS: pitch does not home onto an escaping receiver; uncaught ball becomes a fumble: '+dir);

            for(const recovery of ['air','ground']){
                const pursuit=await ev(`(function(){
                    pitchTest.setup(${dir},'behind');pitchTest.roll=0;
                    var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0],returner=GetWithArray(109)[0];
                    RetroLateral.pitch(m,b);
                    for(var i=0;i<${recovery==='air'?3:30};i++)pitchTest.nativeUpdate(b);
                    returner.x=b.x;returner.y=b.y;b.gmlheight=1;pitchTest.nativeCollision(returner);
                    var chasers=GetWithArray(108),rows=[];
                    chasers.forEach(function(p,i){
                        p.x=returner.x+m.gmldrivedir*(220+i*24);p.y=300;p.hspeed=0;p.vspeed=0;
                        p.gmltackling=-4;p.gmldead=false;p.gmlballdist=point_distance(p.x,p.y,returner.x,returner.y);
                        gml_Script_s_set_anim(p,p,0);p.gmljdir=m.gmldrivedir===1?0:180;
                        pitchTest.nativeDestination(p,p);
                        rows.push({position:p.gmlposition,force:p.gmljforce,toward:lengthdir_x(1,p.gmljdir)*m.gmldrivedir,canRun:gml_Script_s_can_run(p,p)});
                    });
                    pitchTest.nativeDestination(returner,returner);
                    return {state:b.gmlstate,dead:b.gmlis_dead,rows:rows,returnForce:returner.gmljforce};
                })()`);
                assert.equal(pursuit.state,10);assert.equal(pursuit.dead,false);
                assert(pursuit.rows.some(p=>p.position===1),'include the quarterback');
                assert(pursuit.rows.every(p=>p.force>0&&p.toward<-.9&&p.canRun),JSON.stringify(pursuit));
                assert(pursuit.returnForce>0,'the returner can run after recovery');
                // Let real native movement and contact resolve the return against a nearby chaser.
                await ev(`(function(){var b=GetWithArray(global.gmlmaster_ball)[0],r=GetWithArray(b.gmlholder)[0],p=GetWithArray(108).find(function(p){return p.gmlposition===2;});
                    p.x=r.x+${dir}*35;p.y=r.y;p.gmlnearest_opp=r.id;p.gmlnearest_opp_dist=35;
                    r.gmlstiff_arm=0;r.gmlmy_tackle_limit=0;pitchTest.freeze=false;return true;})()`);
                await game.until('GetWithArray(global.gmlmaster_ball)[0].gmlis_dead||GetWithArray(GetWithArray(global.gmlmaster_ball)[0].gmlholder)[0].gmlanim===4');
                assert.equal(await ev('GetWithArray(GetWithArray(global.gmlmaster_ball)[0].gmlholder)[0].gmlanim'),4,'the return ends with a tackle rather than a score');
                console.log('PASS: '+recovery+' pitch turnover sends every offensive position toward the returner and permits a native tackle: '+dir);
            }
        }
        const gates=await ev(`(function(){pitchTest.setup(1,'behind');var m=GetWithArray(105)[0],b=GetWithArray(global.gmlmaster_ball)[0],result=[];
            for(var state of [0,1,3,4,7,13]){b.gmlstate=state;result.push(RetroLateral.pitch(m,b));}
            b.gmlstate=5;m.gmlpossession=1-Number(m.gmlhuman_team);result.push(RetroLateral.pitch(m,b));m.gmlpossession=Number(m.gmlhuman_team);
            m._playbook={selecting:true};result.push(RetroLateral.pitch(m,b));m._playbook=null;
            gml_Script_s_destroy_match_objects(m,m);result.push(m._lateralPitch===null);return result;})()`);
        assert.deepEqual(gates,[false,false,false,false,false,false,false,false,true]);
        assert.equal(game.errors.length,0,JSON.stringify(game.errors));
        console.log('PASS: pre-snap, loose/dead balls, CPU/defense, play selection and cleanup gates; no runtime errors');
    }finally{await game.close();}
}
main().catch(error=>{console.error(error);process.exitCode=1;});
