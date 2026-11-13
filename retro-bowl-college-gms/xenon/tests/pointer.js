var before;
function pixels(){return new Uint8Array(native(8,__canvas._id,0,0,480,270));}
function __testFrame(frame){
 var b=Array(17).fill(0);
 if(frame===90){__cursor.x=397;__cursor.y=240;before=pixels();}
 if(frame>=120&&frame<125)b[0]=1;
 __pad(b,[0,0,0,0]);
 if(frame===599){
  if(g_pBuiltIn.get_current_room()!==2)throw Error('Unexpected room');
  var after=pixels(),changed=0;
  for(var i=0;i<after.length;i++)if(after[i]!==before[i])changed++;
  if(changed<10000)throw Error('Continue did not change the screen');
  if(mouse_check_button(1))throw Error('Pointer button stuck after release');
  localStorage.setItem('__port_test','roundtrip');
  if(localStorage.getItem('__port_test')!=='roundtrip')throw Error('Storage failed');
  localStorage.removeItem('__port_test');
  console.log('POINTER TEST PASS: welcome -> career setup; button released; storage roundtrip');
 }
}
