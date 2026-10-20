const test = require('node:test');
const assert = require('node:assert/strict');
const {logic} = require('../html5game/lateral.js');
const player=(id,x,y=300,extra={})=>({id,x,y,gmloffense:true,gmltackling:-4,gmlanim:2,...extra});

test('Q targets the closest eligible teammate behind or level in either direction',()=>{
    for(const dir of [1,-1]){
        const carrier=player(1,1200),behind=player(2,1200-dir*60),lateral=player(3,1200,325);
        const ahead=player(4,1200+dir,300),opponent=player(5,1200,301,{gmloffense:false});
        assert.equal(logic.nearest(carrier,[carrier,behind,lateral,ahead,opponent],dir),lateral);
        assert.equal(logic.nearest(carrier,[carrier,behind,ahead],dir),behind);
        assert.equal(logic.nearest(carrier,[ahead,opponent],dir),null);
    }
});
test('range is seven yards, and dead, tackling, inactive or out-of-bounds players cannot receive',()=>{
    const carrier=player(1,1200),edge=player(2,1060);
    assert.equal(logic.nearest(carrier,[edge],1),edge);
    assert.equal(logic.nearest(carrier,[player(3,1059.99)],1),null);
    for(const change of [{gmldead:true},{gmltackling:99},{marked:true},{active:false},{gmlanim:4},{y:131}]){
        assert.equal(logic.nearest(carrier,[player(2,1190,300,change)],1),null);
    }
    assert.equal(logic.nearest(carrier,[player(2,1190,300,{gmlposition:5})],1).id,2,'linemen are eligible teammates');
});
test('equal-distance ties are stable and the nearest player is recalculated for the current carrier',()=>{
    const a=player(1,1200),b=player(2,1180,310),c=player(3,1180,290);
    assert.equal(logic.nearest(a,[c,b],1),b);
    assert.equal(logic.nearest(b,[a,c],1),c);
});
test('lead and random error cannot make a pitch forward or exceed its finite range',()=>{
    for(const dir of [1,-1])for(const depth of [0,20,100,140])for(const vx of [-5,0,5])for(const vy of [-4,0,4]){
        const from=player(1,1300),target=player(2,1300-dir*depth,330,{hspeed:vx,vspeed:vy});
        const f=logic.trajectory(from,target,dir,6,-6);
        assert((f.x-from.x)*dir<=1e-8);assert(Math.hypot(f.x-from.x,f.y-from.y)<=logic.MAX_RANGE+1e-8);
        assert(f.frames>=8&&f.frames<=22);assert(f.y>=133&&f.y<=467);
        let x=from.x,y=from.y,z=f.height,v=f.velocity,vz=f.zvel;
        for(let i=0;i<f.frames;i++){v*=.986;vz-=.08;x+=Math.cos(f.direction*Math.PI/180)*v;y+=Math.sin(f.direction*Math.PI/180)*v;z+=vz;}
        assert(Math.abs(x-f.x)<1e-8&&Math.abs(y-f.y)<1e-8);assert(Math.abs(z-1)<1e-8);
    }
});
test('catches remain uncertain; distance and pressure hurt, and receiver skill helps',()=>{
    for(const skill of [1,5,10])for(const range of [10,70,140])for(const pressure of [0,1,3]){
        const chance=logic.catchChance(skill,range,pressure);assert(chance>0&&chance<1);
    }
    assert(logic.catchChance(10,70,0)>logic.catchChance(1,70,0));
    assert(logic.catchChance(5,20,0)>logic.catchChance(5,140,0));
    assert(logic.catchChance(5,70,0)>logic.catchChance(5,70,3));
});

function runtime(){
    const fs=require('node:fs'),vm=require('node:vm'),path=require('node:path');
    const from=player(201,1200,300,{gmlpmap:7,gmlposition:2}),target=player(202,1120,300,{gmlposition:4,gmlskill:5});
    const defender=player(301,2000,400,{gmloffense:false,gmlposition:6});
    const m={gmlstate:2,gmlpossession:0,gmlhuman_team:0,gmldrivedir:1,gmlrunning_play:true};
    const b={id:1000,gmlstate:5,gmlholder:from.id,gmlis_dead:false},stats={stat_fumbles:0},messages=[];
    const r={global:{gmlmaster_ball:1000},
        GetWithArray(type){return type===105?[m]:type===98?[{}]:type===108?[from,target]:type===109?[defender]:[b,from,target,defender].filter(p=>p.id===type);},
        RetroPunt:{active:()=>false},RetroJetSweep:{locked:()=>false},RetroHalfbackPass:{ownsPitch:()=>false},RetroPhillySpecial:{locked:()=>false},
        instance_exists:()=>false,gml_Script_s_is_paused_or_just_unpaused:()=>false,keyboard_check_pressed:()=>false,
        random_range:()=>0,random:()=>0,g_pBuiltIn:{get_current_time:()=>1000},path_exists:()=>false,
        gml_Script_s_fieldtxt(){},gml_Script_s_set_anim(p,o,anim){p.gmlanim=anim;},gml_Script_s_sound_throw(){},gml_Script_s_sound_bounce(){},
        ds_map_exists:(map,key)=>key in stats,ds_map_find_value:(map,key)=>stats[key],ds_map_set:(map,key,value)=>stats[key]=value,
        gml_Script_s_receive_ball(p){b.gmlholder=p.id;b.gmlstate=5;b.gmllast_touched_by=p.id;},
        gml_Script_s_create_match_message(p,o,state){messages.push(state);},
        gml_Script_s_update_xdead(){b.gmlxdead=b.x;},gml_Script_s_is_ball_dead(){b.gmlis_dead=[12,20].includes(b.gmlstate);},
        gml_Script_s_update_ball_movement(b){b.gmlvelocity*=.986;b.gmlzvel-=.08;b.x+=Math.cos(b.gmldirec*Math.PI/180)*b.gmlvelocity;b.y+=Math.sin(b.gmldirec*Math.PI/180)*b.gmlvelocity;b.gmlheight+=b.gmlzvel;}
    };
    r.window=r;vm.runInNewContext(fs.readFileSync(path.join(__dirname,'../html5game/lateral.js'),'utf8'),r);
    return {r,api:r.RetroLateral,m,b,from,target,defender,stats,messages};
}
test('an uncaught pitch charges one fumble to a named pitcher and stays recoverable',()=>{
    const f=runtime();assert.equal(f.api.pitch(f.m,f.b),true);
    for(let i=0;i<60;i++)f.api.updateBall(f.b);
    assert.equal(f.b.gmlstate,13);assert.equal(f.b.gmlis_dead,false);assert.equal(f.stats.stat_fumbles,1);
    f.target.x=f.b.x;f.target.y=f.b.y;f.b.gmlheight=1;f.api.collision(f.target);
    assert.equal(f.b.gmlholder,f.target.id);assert.equal(f.b.gmlstate,5);assert.equal(f.stats.stat_fumbles,1);
    assert.deepEqual(f.messages,[]);
});
test('a defender catching the pitch earns a fumble recovery instead of an interception',()=>{
    const f=runtime();f.api.pitch(f.m,f.b);for(let i=0;i<3;i++)f.api.updateBall(f.b);
    f.defender.x=f.b.x;f.defender.y=f.b.y;f.api.collision(f.defender);
    assert.equal(f.b.gmlholder,f.defender.id);assert.equal(f.b.gmlstate,10);assert.equal(f.stats.stat_fumbles,1);
    assert.deepEqual(f.messages,[10]);
});
test('end-line misses remain fumbles with the native safety/touchback result',()=>{
    for(const [x,result] of [[99,12],[2501,20]]){
        const f=runtime();f.api.pitch(f.m,f.b);f.b.x=x;f.api.beforePosition(f.b);
        assert.equal(f.b.gmlstate,result);assert.equal(f.b.gmlis_dead,true);assert.equal(f.stats.stat_fumbles,1);
    }
});
