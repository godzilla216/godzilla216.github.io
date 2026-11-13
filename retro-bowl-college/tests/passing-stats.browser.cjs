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
        await ev(`window.passTest={
            maps:{},
            setup:function(dir,pos){
                var c=GetWithArray(98)[0],m=GetWithArray(105)[0];
                if(!this.roster)this.roster=ds_list_create();
                c.gmlroster=this.roster;m.gmlteam_roster[Number(m.gmlhuman_team)]=this.roster;
                gml_Script_s_msg_clear(m,m);gml_Script_s_destroy_match_objects(m,m);
                m.gmlstate=2;m.gmlcomm_stage=3;m.gmlcomm_proceed=false;m.gmlkicking=0;
                m.gmlpossession=Number(m.gmlhuman_team);m.gmldown=1;m.gmlyards=10;m.gmlscrimmage=40;
                m.gmldrivedir=dir;m.gmlminutes=2;m.gmlseconds=0;m.alarm[0]=-1;m.alarm[1]=-1;
                var automatic=RetroPlaybook.isAutomatic();RetroPlaybook.setAutomatic(false);
                try{gml_Script_s_set_up_play(m,m,true);RetroPlaybook.choose(m,'pass');m._playbook.waitRelease=false;}
                finally{RetroPlaybook.setAutomatic(automatic);}
                c.gmlroster=this.roster;
                var players=GetWithArray(108),self=this;
                players.forEach(function(p){p.gmlpmap=-4;});
                [1,2,3,4].forEach(function(position){
                    var p=players.find(function(p){return p.gmlposition===position;})||(position===3&&players.find(function(p){return p.gmlte_blocking;}));
                    if(!p)throw Error('Missing role '+position+': '+JSON.stringify(players.map(function(p){return [p.gmlposition,p.gmlte_blocking];})));
                    if(position===3){p.gmlposition=3;p.gmlte_blocking=false;}
                    if(!self.maps[position]){
                        var map=gml_Script_s_create_player(c,c,position,0,3,4);
                        ds_map_set(map,'position',position);ds_map_set(map,'condition',100);
                        ds_map_set(map,'backup',false);ds_map_set(map,'resting',false);
                        self.maps[position]=map;
                    }
                    if(ds_list_find_index(c.gmlroster,self.maps[position])<0)ds_list_add(c.gmlroster,self.maps[position]);
                    p.gmlpmap=self.maps[position];
                });
                gml_Script_s_reset_match_stats(c,c,false);
                var qb=players.find(function(p){return p.gmlposition===1;}),b=GetWithArray(global.gmlmaster_ball)[0];
                if(pos===2){
                    RetroHalfbackPass.afterSetup(m,true);
                    b.gmlstate=1;
                    for(var i=0;i<16;i++)RetroHalfbackPass.updateBall(b);
                    m._halfbackPass.waitRelease=false;
                }else if(pos!==1){
                    var p=players.find(function(p){return p.gmlposition===pos;});
                    qb.gmlposition=4;p.gmlposition=1;gml_Script_s_receive_ball(p,p);b.gmlstate=18;
                }else{gml_Script_s_receive_ball(qb,qb);b.gmlstate=18;}
                m.gmlrunning_play=false;
                this.passer=GetWithArray(b.gmlholder)[0];
                this.receiver=players.find(function(p){return p.gmlpmap===self.maps[4]&&p.id!==self.passer.id;})||players.find(function(p){return p.gmlpmap===self.maps[3]&&p.id!==self.passer.id;});
                this.qb=qb;
                GetWithArray(109).forEach(function(p){p.x=2200;p.y=440;});
            },
            throw:function(){
                var b=GetWithArray(global.gmlmaster_ball)[0];b.gmldirec=0;b.gmlvelocity=8;b.gmlzvel=2.8;
                gml_Script_s_throw_ball(b,b);
            },
            catch:function(){
                var m=GetWithArray(105)[0],p=this.receiver,b=GetWithArray(global.gmlmaster_ball)[0],shadow=GetWithArray(112)[0];
                p.x=m.gmlx_scrim+m.gmldrivedir*200;p.y=300;p.gmlnearest_opp=-4;p.gmlballdist=0;
                p.gmltackling=-4;p.gmlskill=10;p.gmlintheclear=true;p.gmldead=0;gml_Script_s_set_anim(p,p,0);
                b.x=p.x;b.y=p.y;b.gmlheight=20;b.gmldropped_time=0;shadow.gmlbounce_x=p.x;shadow.gmlbounce_y=p.y;
                gml_Script_s_check_ball_collision(p,p);return b.gmlholder===p.id;
            },
            stats:function(pos,scope){
                var map=this.maps[pos],prefix=(scope||'stat')+(pos===1?'_':'_pass_');
                return ['attempts','complete','yards','longest','touchdowns','int','sacks'].map(function(f){return Number(ds_map_find_value(map,prefix+f))||0;});
            }
        };true`);
        for (const dir of [1, -1]) for (const pos of [1, 2, 3, 4]) {
            const result = await ev(`(function(){
                passTest.setup(${dir},${pos});var initial=passTest.stats(${pos});passTest.throw();var caught=passTest.catch();
                var b=GetWithArray(global.gmlmaster_ball)[0],m=GetWithArray(105)[0];
                b.gmlstate=6;b.gmlxdead=m.gmlx_scrim+m.gmldrivedir*200;
                gml_Script_s_update_yard_gain(b,b);
                return {initial:initial,receiverRole:passTest.receiver.gmlposition,ball:[b.gmlstate,b.gmlholder],caught:caught,passing:passTest.stats(${pos}),
                    receiving:['stat_attempts','stat_yards','stat_touchdowns'].map(function(f){return ds_map_find_value(passTest.passer.gmlpmap,f);}),
                    receiver:['stat_attempts','stat_yards','stat_touchdowns'].map(function(f){return ds_map_find_value(passTest.receiver.gmlpmap,f);}),
                    qb:passTest.stats(1)};
            })()`);
            assert.equal(result.caught, true,JSON.stringify(result));
            assert.deepEqual(result.initial, [0, 0, 0, 0, 0, 0, 0], 'scripted exchanges do not add passing stats');
            assert.deepEqual(result.passing, [1, 1, 10, 10, 1, 0, 0]);
            assert.deepEqual(result.receiver, [1, 10, 1],JSON.stringify(result));
            if (pos !== 1) {
                assert.deepEqual(result.receiving, [0, 0, 0]);
                assert.deepEqual(result.qb, [0, 0, 0, 0, 0, 0, 0]);
            }
            console.log('PASS: attempts, completion, yards and TD stay with roster position ' + pos + ', direction ' + dir);
        }
        for (const pos of [2, 3]) {
            const result = await ev(`(function(){
                passTest.setup(1,${pos});passTest.throw();
                var b=GetWithArray(global.gmlmaster_ball)[0];
                for(var i=0;i<250&&!gml_Script_s_is_ball_dead(b,b);i++)gml_Object_obj_ball_Step_0(b,b);
                return {state:b.gmlstate,stats:passTest.stats(${pos})};
            })()`);
            assert.equal(result.state, 7);
            assert.deepEqual(result.stats, [1, 0, 0, 0, 0, 0, 0]);
            const interception = await ev(`(function(){
                passTest.setup(1,${pos});passTest.throw();
                var b=GetWithArray(global.gmlmaster_ball)[0],m=GetWithArray(105)[0],p=GetWithArray(109)[0],shadow=GetWithArray(112)[0];
                p.x=m.gmlx_scrim+150;p.y=300;p.gmlballdist=0;p.gmldead=0;p.gmlnearest_opp=-4;p.gmlintheclear=true;
                gml_Script_s_set_anim(p,p,0);b.x=p.x;b.y=p.y;b.gmlheight=20;b.gmldropped_time=0;
                shadow.gmlbounce_x=p.x;shadow.gmlbounce_y=p.y;
                var rand=random,irand=irandom;try{random=function(){return 0;};irandom=function(){return 0;};gml_Script_s_check_ball_collision(p,p);}finally{random=rand;irandom=irand;}
                return {holder:b.gmlholder,defender:p.id,stats:passTest.stats(${pos}),qb:passTest.stats(1)};
            })()`);
            assert.equal(interception.holder, interception.defender);
            assert.deepEqual(interception.stats, [1, 0, 0, 0, 0, 1, 0]);
            assert.deepEqual(interception.qb, [0, 0, 0, 0, 0, 0, 0]);
            console.log('PASS: incomplete and intercepted passes for roster position ' + pos);
        }
        const edges = await ev(`(function(){
            passTest.setup(1,2);
            var b=GetWithArray(global.gmlmaster_ball)[0],m=GetWithArray(105)[0];
            b.x=passTest.passer.x=m.gmlx_scrim-60;b.y=passTest.passer.y;
            gml_Script_s_set_ball_down(b,b);var sack=passTest.stats(2);
            passTest.setup(-1,3);passTest.throw();passTest.catch();
            b=GetWithArray(global.gmlmaster_ball)[0];m=GetWithArray(105)[0];
            var p=passTest.receiver;p.x=m.gmlx_scrim+100;p.gmlmin_x=p.x;p.gmlmax_x=p.x;
            b.x=p.x;b.gmlstate=4;gml_Script_s_update_yard_gain(b,b);
            return {sack:sack,loss:passTest.stats(3)};
        })()`);
        assert.deepEqual(edges.sack, [0, 0, 0, 0, 0, 0, 1]);
        assert.deepEqual(edges.loss, [1, 1, -5, 0, 0, 0, 0]);
        console.log('PASS: sacks do not count as attempts and completed passes can lose yards');
        const lifecycle = await ev(`(function(){
            passTest.setup(1,2);passTest.throw();passTest.catch();
            var b=GetWithArray(global.gmlmaster_ball)[0],m=GetWithArray(105)[0],c=GetWithArray(98)[0],map=passTest.maps[2];
            b.gmlstate=6;b.gmlxdead=m.gmlx_scrim+200;gml_Script_s_update_yard_gain(b,b);
            ['season','career'].forEach(function(scope){['attempts','complete','yards','longest','touchdowns','int','sacks'].forEach(function(f){ds_map_set(map,scope+'_pass_'+f,0);});});
            gml_Script_s_update_stats(m,m);
            var season=passTest.stats(2,'season'),career=passTest.stats(2,'career');
            var saved=ds_map_write(map),copy=ds_map_create();ds_map_read(copy,saved);
            var persisted=ds_map_find_value(copy,'career_pass_touchdowns');ds_map_destroy(copy);
            gml_Script_s_reset_match_stats(c,c,false);var cleared=passTest.stats(2),kept=passTest.stats(2,'season');
            gml_Script_s_reset_match_stats(c,c,true);
            passTest.saved=ds_map_write(map);room_goto(asset_get_index('rm_home'));
            return {season:season,career:career,persisted:persisted,cleared:cleared,kept:kept,newSeason:passTest.stats(2,'season'),lifetime:passTest.stats(2,'career')};
        })()`);
        assert.deepEqual(lifecycle.season, [1, 1, 10, 10, 1, 0, 0]);
        assert.deepEqual(lifecycle.career, lifecycle.season);
        assert.equal(lifecycle.persisted, 1);
        assert.deepEqual(lifecycle.cleared, [0, 0, 0, 0, 0, 0, 0]);
        assert.deepEqual(lifecycle.kept, lifecycle.season);
        assert.deepEqual(lifecycle.newSeason, lifecycle.cleared);
        assert.deepEqual(lifecycle.lifetime, lifecycle.career);
        console.log('PASS: native postgame tally, save serialization, match reset and season rollover');
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_home"');
        await ev(`(function(){var c=GetWithArray(98)[0],map=ds_map_create();ds_map_read(map,passTest.saved);
            if(!ds_exists(c.gmlroster,2))c.gmlroster=ds_list_create();ds_list_add(c.gmlroster,map);
            c.gmlplayer_profile=map;c.gmlstat_view=1;c.gmlco_stats_tab=0;room_goto(asset_get_index('rm_stats_player'));return true;})()`);
        await game.until('room_get_name(g_pBuiltIn.room)==="rm_stats_player"');
        await game.until(`GetWithArray(20).some(function(b){return b.visible&&b.gmltext===gml_Script_s_str(b,b,'ui_Passing');})`);
        const button = await ev(`(function(){var b=GetWithArray(20).find(function(b){return b.visible&&b.gmltext===gml_Script_s_str(b,b,'ui_Passing');});return b&&{id:b.id,x:b.x,y:b.y};})()`);
        assert(button, 'Passing tab is visible on the RB stats screen');
        const point = await ev(`(function(){var rect=document.getElementById('canvas').getBoundingClientRect();return {x:rect.left+${button.x + 30}/display_get_gui_width()*rect.width,y:rect.top+${button.y + 12}/display_get_gui_height()*rect.height};})()`);
        await game.send('Input.dispatchMouseEvent', { type: 'mousePressed', ...point, button: 'left', clickCount: 1 });
        await game.sleep(80);
        await game.send('Input.dispatchMouseEvent', { type: 'mouseReleased', ...point, button: 'left', clickCount: 1 });
        await game.until('GetWithArray(98)[0].gmlstat_view===3&&GetWithArray(asset_get_index("obj_stats_player")).length===3');
        const panels = await ev(`(function(){return GetWithArray(asset_get_index('obj_stats_player')).map(function(p){var lines=[];for(var i=0;i<ds_list_size(p.gmllines);i++)lines.push(ds_list_find_value(p.gmllines,i));return {type:p.gmlstat_type,lines:lines};});})()`);
        assert(panels.every(p => p.lines[0] === 'shad_Passing'));
        assert(panels.find(p => p.type === 2).lines.some(line => /1 \(100%\)/.test(line)));
        if (process.argv.includes('--screenshots')) await game.screenshot(require('node:path').join(require('node:os').tmpdir(), 'passing-stats.png'));
        assert.equal(game.errors.length, 0, JSON.stringify(game.errors));
        console.log('PASS: Passing tab displays separate game, season and career panels without runtime errors');
    } finally { await game.close(); }
}
main().catch(error => { console.error(error); process.exitCode = 1; });
