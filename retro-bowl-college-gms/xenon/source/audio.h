#ifndef RETRO_AUDIO_H
#define RETRO_AUDIO_H
#include <stdint.h>
typedef struct {short *samples;int channels,rate,frames;} Sound;
extern Sound sounds[128];
int sound_decode(const unsigned char *data,int size);
int sound_play(int id,double offset,int loop,double gain,double rate);
void sound_update(int handle,double gain,double rate,int loop);
void sound_stop(int handle);
void sound_mix(uint8_t *pcm,int frames);
#endif
