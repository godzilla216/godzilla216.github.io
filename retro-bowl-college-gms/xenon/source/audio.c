#include "audio.h"
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define STB_VORBIS_NO_STDIO
#include "../vendor/stb_vorbis.c"
Sound sounds[128];static int sound_count=1,next_handle=1;
typedef struct {int handle,id,loop;double pos,gain,rate;} Voice;
static Voice voices[64];
int sound_decode(const unsigned char *data,int size){if(sound_count>=128)return 0;Sound *s=&sounds[sound_count];s->frames=stb_vorbis_decode_memory(data,size,&s->channels,&s->rate,&s->samples);return s->frames>0?sound_count++:0;}
int sound_play(int id,double offset,int loop,double gain,double rate){if(id<1||id>=sound_count)return 0;for(int i=0;i<64;i++)if(!voices[i].handle){voices[i]=(Voice){next_handle++,id,loop,offset*sounds[id].rate,gain,rate};return voices[i].handle;}return 0;}
void sound_update(int handle,double gain,double rate,int loop){for(int i=0;i<64;i++)if(voices[i].handle==handle){voices[i].gain=gain;voices[i].rate=rate;voices[i].loop=loop;return;}}
void sound_stop(int handle){for(int i=0;i<64;i++)if(voices[i].handle==handle)voices[i].handle=0;}
void sound_mix(uint8_t *pcm,int frames){for(int f=0;f<frames;f++){double l=0,r=0;for(int i=0;i<64;i++){Voice *v=&voices[i];if(!v->handle)continue;Sound *s=&sounds[v->id];if(v->pos>=s->frames){if(v->loop)v->pos=fmod(v->pos,s->frames);else{v->handle=0;continue;}}int index=(int)v->pos*s->channels;l+=s->samples[index]*v->gain;r+=s->samples[index+(s->channels>1?1:0)]*v->gain;v->pos+=(double)s->rate/48000*v->rate;}int il=fmax(-32768,fmin(32767,l)),ir=fmax(-32768,fmin(32767,r));pcm[f*4]=il;pcm[f*4+1]=il>>8;pcm[f*4+2]=ir;pcm[f*4+3]=ir>>8;}}
