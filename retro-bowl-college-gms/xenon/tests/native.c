#include <assert.h>
#include <stdint.h>
#include "raster.h"
#include "audio.h"
int main(void){
 double m[]={1,0,0,1,0,0},clip[]={0,0,8,8};
 int dst=surface_new(8,8),src=surface_new(2,2);
 assert(dst&&src);
 raster_rect(dst,0,0,8,8,0xff0000ff,1,0,m,clip);
 assert(surfaces[dst].pixels[0]==0xff0000ff);
 raster_rect(src,0,0,2,2,0x0000ffff,1,0,m,clip);
 raster_blit(dst,src,0,0,2,2,2,2,4,4,1,0,m,clip);
 assert(surfaces[dst].pixels[2*8+2]==0x0000ffff);
 assert(surfaces[dst].pixels[0]==0xff0000ff);
 assert(!surface_resize(dst,4097,1));
 assert(surfaces[dst].w==8);
 uint8_t pcm[32];sound_mix(pcm,8);
 for(int i=0;i<32;i++)assert(pcm[i]==0);
 assert(sound_play(0,0,0,1,1)==0);
 return 0;
}
