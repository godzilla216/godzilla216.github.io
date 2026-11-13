#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <errno.h>
#include "quickjs.h"
#include "raster.h"
#include "audio.h"
static const char *root;
static double tick_ms;
static int main_surface;
static char *read_file(const char *name,size_t *len){FILE *f=fopen(name,"rb");if(!f)return NULL;fseek(f,0,SEEK_END);long n=ftell(f);rewind(f);if(n<0||n>32000000){fclose(f);return NULL;}char *p=malloc(n+1);if(!p){fclose(f);return NULL;}*len=fread(p,1,n,f);if(*len!=(size_t)n||ferror(f)){free(p);fclose(f);return NULL;}p[*len]=0;fclose(f);return p;}
static void asset_path(char *out,size_t size,const char *relative){while(*relative=='/')relative++;snprintf(out,size,"%s/%s",root,relative);char *q=strchr(out,'?');if(q)*q=0;}
static double num(JSContext *c,JSValueConst v){double n=0;JS_ToFloat64(c,&n,v);return n;}
static void array_doubles(JSContext *c,JSValueConst v,double *out,int n){for(int i=0;i<n;i++){JSValue a=JS_GetPropertyUint32(c,v,i);out[i]=num(c,a);JS_FreeValue(c,a);}}
static JSValue native(JSContext *ctx,JSValueConst self,int argc,JSValueConst *v){
 int op=(int)num(ctx,v[0]);char file[2048];const char *s;double m[6],clip[4];
 switch(op){
 case 0:s=JS_ToCString(ctx,v[1]);printf("%s\n",s?s:"");fflush(stdout);JS_FreeCString(ctx,s);return JS_UNDEFINED;
 case 1:s=JS_ToCString(ctx,v[1]);asset_path(file,sizeof(file),s);JS_FreeCString(ctx,s);{size_t len;char *data=read_file(file,&len);if(!data)return JS_NULL;JSValue r=JS_NewStringLen(ctx,data,len);free(data);return r;}
 case 2:s=JS_ToCString(ctx,v[1]);asset_path(file,sizeof(file),s);JS_FreeCString(ctx,s);{const char *data=JS_ToCString(ctx,v[2]);FILE *f=fopen(file,"wb");if(f){fwrite(data,1,strlen(data),f);fclose(f);}JS_FreeCString(ctx,data);return JS_NewBool(ctx,f!=NULL);}
 case 3:return JS_NewInt32(ctx,surface_new(num(ctx,v[1]),num(ctx,v[2])));
 case 4:return JS_NewBool(ctx,surface_resize(num(ctx,v[1]),num(ctx,v[2]),num(ctx,v[3])));
 case 5:s=JS_ToCString(ctx,v[1]);asset_path(file,sizeof(file),s);JS_FreeCString(ctx,s);{int id=surface_image(file);JSValue r=JS_NewArray(ctx);JS_SetPropertyUint32(ctx,r,0,JS_NewInt32(ctx,id));JS_SetPropertyUint32(ctx,r,1,JS_NewInt32(ctx,surfaces[id].w));JS_SetPropertyUint32(ctx,r,2,JS_NewInt32(ctx,surfaces[id].h));return r;}
 case 6:array_doubles(ctx,v[9],m,6);array_doubles(ctx,v[10],clip,4);{uint32_t color;JS_ToUint32(ctx,&color,v[6]);raster_rect(num(ctx,v[1]),num(ctx,v[2]),num(ctx,v[3]),num(ctx,v[4]),num(ctx,v[5]),color,num(ctx,v[7]),num(ctx,v[8]),m,clip);}return JS_UNDEFINED;
 case 7:array_doubles(ctx,v[13],m,6);array_doubles(ctx,v[14],clip,4);raster_blit(num(ctx,v[1]),num(ctx,v[2]),num(ctx,v[3]),num(ctx,v[4]),num(ctx,v[5]),num(ctx,v[6]),num(ctx,v[7]),num(ctx,v[8]),num(ctx,v[9]),num(ctx,v[10]),num(ctx,v[11]),num(ctx,v[12]),m,clip);return JS_UNDEFINED;
 case 8:{int id=num(ctx,v[1]),x=num(ctx,v[2]),y=num(ctx,v[3]),w=num(ctx,v[4]),h=num(ctx,v[5]);if(w<0||h<0||w*h>16000000)return JS_NULL;uint8_t *pixels=calloc((size_t)w*h,4);Surface *sf=&surfaces[id];for(int yy=0;yy<h;yy++)for(int xx=0;xx<w;xx++){if(x+xx<0||y+yy<0||x+xx>=sf->w||y+yy>=sf->h)continue;uint32_t p=sf->pixels[(y+yy)*sf->w+x+xx];for(int c=0;c<4;c++)pixels[((size_t)yy*w+xx)*4+c]=p>>(24-c*8);}JSValue r=JS_NewArrayBufferCopy(ctx,pixels,(size_t)w*h*4);free(pixels);return r;}
 case 9:{int id=num(ctx,v[1]),x=num(ctx,v[2]),y=num(ctx,v[3]),w=num(ctx,v[4]),h=num(ctx,v[5]);size_t len;uint8_t *pixels=JS_GetArrayBuffer(ctx,&len,v[6]);Surface *sf=&surfaces[id];if(!pixels||len<(size_t)w*h*4)return JS_UNDEFINED;for(int yy=0;yy<h;yy++)for(int xx=0;xx<w;xx++){if(x+xx<0||y+yy<0||x+xx>=sf->w||y+yy>=sf->h)continue;uint8_t *p=pixels+((size_t)yy*w+xx)*4;sf->pixels[(y+yy)*sf->w+x+xx]=(uint32_t)p[0]<<24|(uint32_t)p[1]<<16|(uint32_t)p[2]<<8|p[3];}return JS_UNDEFINED;}
 case 10:palette_active=num(ctx,v[1]);return JS_UNDEFINED;
 case 11:s=JS_ToCString(ctx,v[1]);palette_set(s,num(ctx,v[2]),num(ctx,v[3]),num(ctx,v[4]));JS_FreeCString(ctx,s);return JS_UNDEFINED;
 case 12:main_surface=num(ctx,v[1]);return JS_UNDEFINED;
 case 13:return JS_NewFloat64(ctx,tick_ms);
 case 14:s=JS_ToCString(ctx,v[1]);asset_path(file,sizeof(file),s);JS_FreeCString(ctx,s);{size_t len;char *data=read_file(file,&len);if(!data)return JS_NULL;JSValue r=JS_NewArrayBufferCopy(ctx,(uint8_t*)data,len);free(data);return r;}
 case 15:{size_t len;uint8_t *data=JS_GetArrayBuffer(ctx,&len,v[1]);int id=data?sound_decode(data,len):0;JSValue r=JS_NewArray(ctx);JS_SetPropertyUint32(ctx,r,0,JS_NewInt32(ctx,id));JS_SetPropertyUint32(ctx,r,1,JS_NewInt32(ctx,sounds[id].channels));JS_SetPropertyUint32(ctx,r,2,JS_NewInt32(ctx,sounds[id].rate));JS_SetPropertyUint32(ctx,r,3,JS_NewInt32(ctx,sounds[id].frames));return r;}
 case 16:return JS_NewInt32(ctx,sound_play(num(ctx,v[1]),num(ctx,v[2]),num(ctx,v[3]),num(ctx,v[4]),num(ctx,v[5])));
 case 17:sound_update(num(ctx,v[1]),num(ctx,v[2]),num(ctx,v[3]),num(ctx,v[4]));return JS_UNDEFINED;
 case 18:sound_stop(num(ctx,v[1]));return JS_UNDEFINED;
 default:return JS_ThrowTypeError(ctx,"Unknown native operation %d",op);
 }
}
static int error(JSContext *ctx){JSValue e=JS_GetException(ctx),stack=JS_GetPropertyStr(ctx,e,"stack");const char *s=JS_ToCString(ctx,e),*t=JS_ToCString(ctx,stack);fprintf(stderr,"JS ERROR: %s\n%s\n",s?s:"",t?t:"");JS_FreeCString(ctx,s);JS_FreeCString(ctx,t);JS_FreeValue(ctx,stack);JS_FreeValue(ctx,e);return 0;}
static int eval(JSContext *ctx,const char *text,const char *name){JSValue r=JS_Eval(ctx,text,strlen(text),name,JS_EVAL_TYPE_GLOBAL);if(JS_IsException(r))return error(ctx);JS_FreeValue(ctx,r);return 1;}
static int script(JSContext *ctx,const char *name){
 char file[2048];asset_path(file,sizeof(file),name);size_t len;
 printf("[READ] %s\n",name);fflush(stdout);
 char *p=read_file(file,&len);if(!p){fprintf(stderr,"Cannot read %s (errno %d)\n",file,errno);return 0;}
 printf("[PARSE] %s (%zu bytes); please wait\n",name,len);fflush(stdout);
 JSValue compiled=JS_Eval(ctx,p,len,name,JS_EVAL_TYPE_GLOBAL|JS_EVAL_FLAG_COMPILE_ONLY);free(p);
 if(JS_IsException(compiled))return error(ctx);
 printf("[EXECUTE] %s\n",name);fflush(stdout);
 JSValue result=JS_EvalFunction(ctx,compiled);
 if(JS_IsException(result))return error(ctx);
 JS_FreeValue(ctx,result);printf("[DONE] %s\n",name);fflush(stdout);return 1;
}
#ifdef XENON
extern const char *platform_init(void);
extern int platform_tick(double *now,char *input,size_t cap);
extern void platform_present(Surface *surface);
extern void platform_error(void);
#endif
int main(int argc,char **argv){
#ifdef XENON
 root=platform_init();int frames=0x7fffffff;
#else
 root=argc>1?argv[1]:"data";int frames=argc>2?atoi(argv[2]):180;setvbuf(stdout,NULL,_IOLBF,0);
#endif
 printf("[BOOT 2] Checking save directory\n");fflush(stdout);
 char savepath[2048];asset_path(savepath,sizeof(savepath),"saves");struct stat save_stat;
 if(stat(savepath,&save_stat)!=0&&mkdir(savepath,0777)!=0)fprintf(stderr,"Cannot create save directory (errno %d)\n",errno);
 printf("[BOOT 3] Creating JavaScript runtime\n");fflush(stdout);
 JSRuntime *rt=JS_NewRuntime();if(!rt){fprintf(stderr,"Cannot allocate JS runtime\n");return 1;}JS_SetMemoryLimit(rt,340*1024*1024);JS_SetMaxStackSize(rt,4*1024*1024);
 printf("[BOOT 4] Creating JavaScript context\n");fflush(stdout);
 JSContext *ctx=JS_NewContext(rt);if(!ctx){fprintf(stderr,"Cannot allocate JS context\n");JS_FreeRuntime(rt);return 1;}
 printf("[BOOT 5] Loading scripts\n");fflush(stdout);
 JSValue global=JS_GetGlobalObject(ctx);JS_SetPropertyStr(ctx,global,"native",JS_NewCFunction(ctx,native,"native",1));JS_FreeValue(ctx,global);
 int ok=script(ctx,"bootstrap.js")&&script(ctx,"html5game/RetroBowl.js")&&script(ctx,"port.js");
#ifndef XENON
 if(ok&&argc>3)ok=script(ctx,argv[3]);
#endif
 for(int frame=0;ok&&frame<frames;frame++){
 char input[2048];
#ifdef XENON
 if(!platform_tick(&tick_ms,input,sizeof(input)))break;
 if(!eval(ctx,input,"controller")){ok=0;break;}
#else
 tick_ms=frame*1000./60;
 snprintf(input,sizeof(input),"if(typeof __testFrame==='function')__testFrame(%d);",frame);
 if(!eval(ctx,input,"test-input")){ok=0;break;}
#endif
 if(!eval(ctx,"__frame()","frame")){ok=0;break;}
 JSContext *job;int result;while((result=JS_ExecutePendingJob(rt,&job))>0){}if(result<0){error(job);ok=0;break;}
#ifdef XENON
 if(main_surface)platform_present(&surfaces[main_surface]);
#else
 if(frame%60==0)printf("Frame %d\n",frame);
 uint8_t pcm[800*4];sound_mix(pcm,800);
#endif
 }
#ifndef XENON
 if(main_surface)surface_dump(main_surface,"build/frame.ppm");
 ok=eval(ctx,"console.log('ROOM', typeof g_pBuiltIn!=='undefined'?g_pBuiltIn.get_current_room():'uninitialized')","status")&&ok;
 JS_FreeContext(ctx);JS_FreeRuntime(rt);return ok?0:1;
#else
 platform_error();return 0;
#endif
}


