const fs=require('fs'),path=require('path');
const base=path.resolve(__dirname,'..'),out=process.argv[2];
if(!out)throw Error('Supply a new output directory');
if(fs.existsSync(out))throw Error('Output already exists; choose a new directory');
const elf=fs.readFileSync(path.join(base,'build/retro-bowl-college.elf32'));
if(elf.toString('hex',0,6)!=='7f454c460102'||elf.readUInt16BE(18)!==20)throw Error('Expected big-endian ELF32 PowerPC');
fs.mkdirSync(out,{recursive:true});
fs.writeFileSync(path.join(out,'xenon.elf'),elf);
const dest=path.join(out,'Apps/RetroBowlCollege/data');
fs.mkdirSync(dest,{recursive:true});
fs.mkdirSync(path.join(dest,'saves'),{recursive:true});
for(const f of ['bootstrap.js','port.js'])fs.copyFileSync(path.join(base,'runtime',f),path.join(dest,f));
fs.cpSync(path.join(base,'data/html5game'),path.join(dest,'html5game'),{recursive:true});
fs.copyFileSync(path.join(base,'README.md'),path.join(out,'README.md'));
console.log('Packaged '+out);

