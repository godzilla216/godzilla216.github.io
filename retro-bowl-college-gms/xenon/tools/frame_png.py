import pathlib, struct, zlib
p=pathlib.Path('build/frame.ppm').read_bytes()
h,d=p.split(b'255\n',1)
w,y=map(int,h.split()[1:3])
def chunk(t,b): return struct.pack('>I',len(b))+t+b+struct.pack('>I',zlib.crc32(t+b))
pathlib.Path('build/frame.png').write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',w,y,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(b''.join(b'\0'+d[i*w*3:(i+1)*w*3] for i in range(y))))+chunk(b'IEND',b''))
