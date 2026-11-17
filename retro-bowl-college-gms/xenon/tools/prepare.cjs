const fs=require('fs'),path=require('path');
const base=path.resolve(__dirname,'..'), source=process.argv[2];
if(source){
 if(!fs.existsSync(path.join(source,'html5game/RetroBowl.js')))throw Error('Pass the original HTML5 export directory');
 fs.cpSync(path.join(source,'html5game'),path.join(base,'data/html5game'),{recursive:true});
}
const data=path.join(base,'data');
if(!fs.existsSync(path.join(data,'html5game/RetroBowl.js')))throw Error('Missing original HTML5 export: supply its folder as argument');
for(const name of ['bootstrap.js','port.js'])fs.copyFileSync(path.join(base,'runtime',name),path.join(data,name));
fs.copyFileSync(path.join(base,'../RetroBowlCollege/extensions/Poki/uph_poki.js'),path.join(data,'html5game/uph_poki.js'));
console.log('Prepared '+data);
