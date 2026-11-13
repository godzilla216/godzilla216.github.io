// Native palette replacement replaces the single game shader on Canvas2D.
shader_get_uniform=function(shader,name){return name;};
shader_set_uniform_f=function(name,r,g,b){native(11,name,r,g,b);};
shader_set=function(shader){native(10,1);};
shader_reset=function(){native(10,0);};
shader_is_compiled=function(){return true;};
shaders_are_supported=function(){return true;};
window.PokiSDK_loadState=0;window.PokiSDK_OK=true;
window.PokiSDK={init:function(){return Promise.resolve();},gameLoadingFinished:function(){},gameplayStart:function(){},gameplayStop:function(){},commercialBreak:function(){return Promise.resolve();},rewardedBreak:function(){return Promise.resolve(false);},setDebug:function(){},happyTime:function(){},gameLoadingStart:function(){},gameLoadingProgress:function(){},getURLParam:function(){return null;}};
JSON_game.Options.loadingBarCallback="";
JSON_game.Options.WebGL=0; // Native Canvas2D renderer and palette shader replacement.
// The HTML5 export omits parts of the native controller UI. Drive its complete
// mouse input path instead: left stick/D-pad pointer, A or RT hold/release.
var __cursor={x:240,y:135,down:false};
__pad=function(buttons,axes){
 function axis(v){return Math.abs(v)<.18?0:(v-Math.sign(v)*.18)/.82;}
 __cursor.x=Math.max(0,Math.min(479,__cursor.x+axis(axes[0])*5+(buttons[15]-buttons[14])*3));
 __cursor.y=Math.max(0,Math.min(269,__cursor.y+axis(axes[1])*5+(buttons[13]-buttons[12])*3));
 var down=buttons[0]>.5||buttons[7]>.5;
 function send(type){var e={type:type,button:0,buttons:down?1:0,which:1,clientX:__cursor.x,clientY:__cursor.y,pageX:__cursor.x,pageY:__cursor.y};__canvas.dispatchEvent(e);document.dispatchEvent(e);window.dispatchEvent(e);}
 send('mousemove');if(down!==__cursor.down)send(down?'mousedown':'mouseup');
 __cursor.down=down;
};
var __gameFrame=__frame;
__frame=function(){__gameFrame();var c=__canvas.getContext('2d');c.save();c.resetTransform();c.globalAlpha=1;c.globalCompositeOperation='source-over';c.fillStyle='#000000';c.fillRect(__cursor.x-3,__cursor.y-1,9,3);c.fillRect(__cursor.x,__cursor.y-4,3,9);c.fillStyle='#ffffff';c.fillRect(__cursor.x-2,__cursor.y,7,1);c.fillRect(__cursor.x+1,__cursor.y-3,1,7);c.restore();};
GameMaker_Init();
