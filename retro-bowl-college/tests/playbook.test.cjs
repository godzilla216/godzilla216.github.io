const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const source = fs.readFileSync(path.join(__dirname,'../html5game/playbook.js'),'utf8');

function fixture(stored, brokenStorage = false) {
    const m = {gmlstate:2,gmlpossession:0,gmlhuman_team:0,gmldown:1,gmlsnaps:1};
    const c = {}, b = {id:100,gmlstate:0}, writes = [], calls = [];
    const players = [1,2,3,4].map((position,i)=>({id:1000+i,gmlposition:position}));
    const button = {}, label = {};
    const r = {
        localStorage:{getItem(){if(brokenStorage)throw Error('unavailable');return stored;},setItem(...args){if(brokenStorage)throw Error('unavailable');writes.push(args);}},
        global:{gmlmaster_ball:111,gmlc_background:123},
        path_exists(){return false;},gml_Script_s_set_anim(){},
        GetWithArray(type){return type===105?[m]:type===98?[c]:type===111?[b]:type===108?players:type===100302?[button]:type===100311?[label]:players.filter(p=>p.id===type);}
    };
    for (const [name,key] of [['RetroHalfbackPass','_halfbackPass'],['RetroJetSweep','_jetSweep'],['RetroPhillySpecial','_phillySpecial']]) {
        r[name] = {reset(m){m[key]=null;},afterSetup(m,force){calls.push([name,force]);m[key]=force?{phase:'ready'}:null;}};
    }
    r.window=r; vm.runInNewContext(source,r);
    r.gml_Script_s_set_up_play=function(){m.gmlsnaps++;b.id++;r.RetroPlaybook.reset(m);r.RetroPlaybook.afterSetup(m);};
    return {r,m,c,b,players,button,label,writes,calls,api:r.RetroPlaybook};
}

test('automatic calls default ON, retain call order and do not force special plays',()=>{
    const f=fixture(null);f.api.afterSetup(f.m);
    assert.equal(f.api.isAutomatic(),true);assert.equal(f.m._playbook,null);
    assert.deepEqual(f.calls,[['RetroHalfbackPass',undefined],['RetroJetSweep',undefined],['RetroPhillySpecial',undefined]]);
});
test('preference persists independently and tolerates unavailable browser storage',()=>{
    const f=fixture('off');assert.equal(f.api.isAutomatic(),false);
    f.api.setAutomatic(true);assert.deepEqual(f.writes,[['retro-bowl-college.auto-playbook','on']]);
    const broken=fixture(null,true);assert.doesNotThrow(()=>broken.api.setAutomatic(false));
    assert.equal(broken.api.isAutomatic(),false);
});
test('Options refresh shows a native toggle with no editor icon',()=>{
    const f=fixture('off');f.api.updateOption();
    assert.equal(f.label.gmltext,'AUTO PLAYBOOK');assert.equal(f.button.gmltext,'OFF');
    assert.equal(f.button.visible,true);assert.equal(f.button.gmlimage,-4);
    f.button.gmlonClickAction();assert.equal(f.button.gmltext,'ON');
});
test('manual selection gates the ball before choosing and creates only the chosen special',()=>{
    for (const [choice,special] of [['pass',null],['run',null],['halfback','RetroHalfbackPass'],['jet','RetroJetSweep'],['philly','RetroPhillySpecial']]) {
        const f=fixture('off');f.api.afterSetup(f.m);
        assert.equal(f.api.updateBall(f.b),true);assert.equal(f.b.gmlstate,0);
        assert.deepEqual(f.calls,[]);assert.equal(f.m._playbook.selecting,true);
        assert.equal(f.api.choose(f.m,choice),true);
        assert.equal(f.m._playbook.call,choice);assert.equal(f.m._playbook.selecting,false);
        assert.equal(f.m._playbook.waitRelease,true);assert.equal(f.m.gmlsnaps,1,'selecting does not count another snap');
        assert.deepEqual(f.calls,special?[[special,true]]:[]);
        assert.equal(f.api.choose(f.m,'philly'),false,'cannot change a running/confirmed call through choose');
    }
});
test('missing roles disable unsupported plays and invalid choices do not rebuild',()=>{
    const f=fixture('off');f.players.splice(1);f.api.afterSetup(f.m);
    assert.deepEqual(Array.from(f.m._playbook.available),['pass']);
    assert.equal(f.api.choose(f.m,'philly'),false);assert.equal(f.api.choose(f.m,'invalid'),false);
    assert.equal(f.b.id,100);assert.equal(f.m._playbook.selecting,true);
});
test('changing calls restores positions and routes, and cleans up saved paths',()=>{
    const f=fixture('off'),routes=new Set([10]);let next=20;
    f.r.path_exists=id=>routes.has(id);f.r.path_duplicate=()=>{routes.add(next);return next++;};f.r.path_delete=id=>routes.delete(id);
    f.players[3].x=200;f.players[3].gmlmy_route=10;f.api.afterSetup(f.m);
    assert.equal(routes.size,2);
    for(const call of ['jet','philly','pass']){
        f.m._playbook.selecting=true;f.players[3].x=999;
        assert.equal(f.api.choose(f.m,call),true);assert.equal(f.players[3].x,200);
        assert.equal(routes.size,2,'only saved and active route copies remain');
    }
    f.api.reset(f.m);assert.equal(routes.size,1,'native player cleanup owns the active route');
});
test('the playbook button is consumed even if the ball event runs before the controller',()=>{
    const f=fixture('off');f.api.afterSetup(f.m);f.api.choose(f.m,'pass');f.m._playbook.waitRelease=false;
    Object.assign(f.r,{display_get_gui_width:()=>480,display_get_gui_height:()=>270,keyboard_check_pressed:()=>false,
        device_mouse_check_button_pressed:device=>device===0,device_mouse_x_to_gui:()=>240,device_mouse_y_to_gui:()=>59});
    assert.equal(f.api.updateBall(f.b),true);assert.equal(f.m._playbook.selecting,true);assert.equal(f.b.gmlstate,0);
});
test('CPU possessions, special teams and excluded career modes retain their flow',()=>{
    const changes=[f=>f.m.gmlpossession=1,f=>f.m.gmlkicking=1,f=>f.m.gmldown=6,
        ...['gmlsim_action','gmlqb_mode','gmlgamepractice'].map(key=>f=>f.c[key]=true)];
    for(const change of changes){const f=fixture('off');change(f);f.api.afterSetup(f.m);assert.equal(f.m._playbook,null);assert.deepEqual(f.calls,[]);}
});
test('destroyed/new balls and completed plays cannot retain a selection lock',()=>{
    for(const change of [f=>f.b.id++,f=>f.b.gmlis_dead=true,f=>f.m.gmlstate=3]){
        const f=fixture('off');f.api.afterSetup(f.m);change(f);assert.equal(f.api.updateBall(f.b),false);
    }
    const f=fixture('off');f.api.afterSetup(f.m);f.api.reset(f.m);assert.equal(f.api.updateBall(f.b),false);
});
