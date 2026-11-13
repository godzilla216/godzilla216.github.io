#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/iosupport.h>
#include <xenos/xenos.h>
#include <console/console.h>
#include <input/input.h>
#include <usb/usbmain.h>
#include <time/time.h>
#include <ppc/timebase.h>
#include <ppc/cache.h>
#include <xenon_soc/xenon_power.h>
#include <xenon_sound/sound.h>
#include <fat.h>
#include "raster.h"
#include "audio.h"
static volatile uint32_t *framebuffer;
static int width,height,pitch;
static uint64_t start_time,next_tick;
static uint64_t clock_start;
#ifndef RBC_BUILD_EPOCH
#define RBC_BUILD_EPOCH 1792800000
#endif
/* Avoid blocking SMC RTC transactions during FAT writes and QuickJS startup.
 * Calendar time is build time plus elapsed uptime, not the console RTC. */
static uint64_t stable_timebase(void){
 uint32_t hi,lo,again;
 do{__asm__ volatile("mftbu %0":"=r"(hi));__asm__ volatile("mftbl %0":"=r"(lo));__asm__ volatile("mftbu %0":"=r"(again));}while(hi!=again);
 return ((uint64_t)hi<<32)|lo;
}
static int uptime_clock(struct _reent *r,struct timeval *tv,struct timezone *tz){
 (void)r;(void)tz;uint64_t elapsed=stable_timebase()-clock_start;
 tv->tv_sec=RBC_BUILD_EPOCH+elapsed/PPC_TIMEBASE_FREQ;
 tv->tv_usec=(elapsed%PPC_TIMEBASE_FREQ)*1000000/PPC_TIMEBASE_FREQ;return 0;
}
static char root_path[256];
struct ati_info {uint32_t unknown1[4],base,unknown2[8],width,height;} __attribute__((packed));
int bdev_enum(int handle,const char **name);
static int tile_index(int x,int y){return (((y&~31)*pitch+(x&~31)*32)+(((x&3)+((y&1)<<2)+((x&28)<<1)+((y&30)<<5))^((y&8)<<2)));}
const char *platform_init(void){
 setvbuf(stdout,NULL,_IONBF,0);setvbuf(stderr,NULL,_IONBF,0);
 clock_start=stable_timebase();__syscalls.gettod_r=uptime_clock;
 xenon_make_it_faster(XENON_SPEED_FULL);xenos_init(VIDEO_MODE_AUTO);console_init();
 printf("Retro Bowl College - libxenon diagnostic build 2\nCPU timer clock active (no SMC RTC reads).\nInitializing USB storage and controllers...\n");
 usb_init();for(int i=0;i<100;i++){usb_do_poll();mdelay(10);}fatInitDefault();xenon_sound_init();
 const char *device;int handle=-1;int found=0;
 while((handle=bdev_enum(handle,&device))>=0){snprintf(root_path,sizeof(root_path),"%s:/Apps/RetroBowlCollege/data",device);char file[320];snprintf(file,sizeof(file),"%s/bootstrap.js",root_path);FILE *f=fopen(file,"rb");if(f){fclose(f);found=1;break;}}
 if(!found){printf("Missing Apps/RetroBowlCollege/data/bootstrap.js on USB.\n");for(;;){usb_do_poll();mdelay(100);}}
 printf("Loading game from %s\n",root_path);
 volatile struct ati_info *ati=(volatile struct ati_info*)0xec806100ULL;framebuffer=(volatile uint32_t*)(uintptr_t)(ati->base|0x80000000);width=ati->width;height=ati->height;pitch=(width+31)&~31;
 start_time=stable_timebase();next_tick=start_time;printf("[BOOT 1] Platform ready\n");return root_path;
}
int platform_tick(double *now,char *input,size_t cap){
 struct controller_data_s p;memset(&p,0,sizeof(p));usb_do_poll();get_controller_data(&p,0);
 uint64_t time=stable_timebase();if(time<next_tick)udelay((next_tick-time)/(PPC_TIMEBASE_FREQ/1000000));time=stable_timebase();next_tick=time+PPC_TIMEBASE_FREQ/60;*now=(double)(time-start_time)*1000/PPC_TIMEBASE_FREQ;
 snprintf(input,cap,"__pad([%d,%d,%d,%d,%d,%d,%.5f,%.5f,%d,%d,%d,%d,%d,%d,%d,%d,%d],[%.5f,%.5f,%.5f,%.5f]);",!!p.a,!!p.b,!!p.x,!!p.y,!!p.lb,!!p.rb,p.lt/255.,p.rt/255.,!!p.back,!!p.start,!!p.s1_z,!!p.s2_z,!!p.up,!!p.down,!!p.left,!!p.right,!!p.logo,p.s1_x/32768.,-p.s1_y/32768.,p.s2_x/32768.,-p.s2_y/32768.);
 static uint8_t pcm[2048*4];for(int n=0;n<4&&xenon_sound_get_unplayed()<8192&&xenon_sound_get_free()>=sizeof(pcm);n++){sound_mix(pcm,2048);xenon_sound_submit(pcm,sizeof(pcm));}
 return !(p.back&&p.start&&p.lb&&p.rb);
}
void platform_present(Surface *s){if(!s||!s->pixels||!s->w||!s->h)return;double scale=(double)width/s->w;if((double)height/s->h<scale)scale=(double)height/s->h;int w=s->w*scale,h=s->h*scale,left=(width-w)/2,top=(height-h)/2;for(int y=0;y<height;y++)for(int x=0;x<width;x++){uint32_t c=0;if(x>=left&&x<left+w&&y>=top&&y<top+h)c=s->pixels[((y-top)*s->h/h)*s->w+(x-left)*s->w/w];framebuffer[tile_index(x,y)]=((c>>8)&255)<<24|((c>>16)&255)<<16|(c>>24)<<8;}memdcbst((void*)framebuffer,pitch*((height+31)&~31)*4);}
void platform_error(void){printf("Game stopped. Preserve the last error text for diagnosis.\n");for(;;){usb_do_poll();mdelay(100);}}

