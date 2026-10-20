const assert = require('node:assert/strict');

// Run against the real game engine with a simulated controller device. Keep
// each input sequence in one evaluation so animation timing cannot race it.
async function checkControllerAim(game, stateKey, passerId) {
    const results = await game.evaluate(`(function(){
        var m=GetWithArray(105)[0],s=m.${stateKey},b=GetWithArray(global.gmlmaster_ball)[0];
        var saved={pad:global.gmlgamepad,
            invert:gml_Script_s_get_op_invert_throw,released:gamepad_button_check_released,
            paused:gml_Script_s_is_paused_or_just_unpaused};
        var keys=['gmlstate','gmldragx','gmldragy','gmldragdist','gmldirec','gmlvelocity','gmlzvel','gmlxtouch','gmlytouch'];
        var values=keys.map(function(k){return b[k];}),wait=s.waitRelease,result=[];
        var pad=GetWithArray(global.gmlgp)[0];
        var padKeys=['gmlaxisl_force','gmlaxisr_force','gmlaxisl_h','gmlaxisl_v','gmlaxisr_h','gmlaxisr_v'];
        var padValues=padKeys.map(function(k){return pad[k];});
        try {
            global.gmlgamepad=true;
            gamepad_button_check_released=function(){return false;};
            gml_Script_s_is_paused_or_just_unpaused=function(){return false;};
            for(var mode=0;mode<4;mode++){
                gml_Script_s_get_op_invert_throw=function(){return mode;};
                b.gmlstate=18;s.waitRelease=true;
                pad.gmlaxisl_force=pad.gmlaxisr_force=1;
                gml_Script_s_update_ball(b,b);
                var held=b.gmlstate;
                pad.gmlaxisl_force=pad.gmlaxisr_force=0;
                gml_Script_s_update_ball(b,b);
                var neutral=b.gmlstate;
                // The unselected stick must not begin the pass.
                if(mode===3)pad.gmlaxisl_force=1;else pad.gmlaxisr_force=1;
                gml_Script_s_update_ball(b,b);
                var other=b.gmlstate;
                pad.gmlaxisl_force=pad.gmlaxisr_force=0;
                if(mode===3)pad.gmlaxisr_force=1;else pad.gmlaxisl_force=1;
                pad.gmlaxisl_h=pad.gmlaxisr_h=-m.gmldrivedir;
                pad.gmlaxisl_v=pad.gmlaxisr_v=0.5;
                b.gmldragx=0;b.gmldragy=0;b.gmldirec=0;
                for(var i=0;i<5;i++)gml_Script_s_update_ball(b,b);
                result.push({mode:mode,held:held,neutral:neutral,other:other,state:b.gmlstate,
                    holder:b.gmlholder,power:b.gmlvelocity,angle:b.gmldirec});
            }
        } finally {
            global.gmlgamepad=saved.pad;
            padKeys.forEach(function(k,i){pad[k]=padValues[i];});
            gml_Script_s_get_op_invert_throw=saved.invert;gamepad_button_check_released=saved.released;
            gml_Script_s_is_paused_or_just_unpaused=saved.paused;
            keys.forEach(function(k,i){b[k]=values[i];});s.waitRelease=wait;
        }
        return result;
    })()`);
    for (const result of results) {
        assert.equal(result.held, 18, 'held snap cannot begin aiming');
        assert.equal(result.neutral, 18);
        assert.equal(result.other, 18, 'only the configured stick starts aiming');
        assert.equal(result.state, 2, 'controller enters native aiming: ' + JSON.stringify(result));
        assert.equal(result.holder, passerId);
        assert(result.power > 0);
        assert.notEqual(result.angle, 0);
    }
}

async function checkCanceledAim(game, point, passerId, touch) {
    async function input(down) {
        if (touch) await game.send('Input.dispatchTouchEvent', {type:down?'touchStart':'touchEnd',touchPoints:down?[{...point,id:0}]:[]});
        else await game.send('Input.dispatchMouseEvent', {type:down?'mousePressed':'mouseReleased',...point,button:'left',clickCount:1});
    }
    await input(true);
    await game.until('GetWithArray(global.gmlmaster_ball)[0].gmlstate===1');
    await input(false);
    await game.until('GetWithArray(global.gmlmaster_ball)[0].gmlstate===18');
    assert.equal(await game.evaluate('GetWithArray(global.gmlmaster_ball)[0].gmlholder'),passerId);
}

module.exports = { checkControllerAim, checkCanceledAim };
