#include "raster.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define STB_IMAGE_IMPLEMENTATION
#define STBI_ONLY_PNG
#define STBI_NO_SIMD
#include "../vendor/stb_image.h"
Surface surfaces[2048];
static int next_surface=1;
int palette_active;
static const char *parts[]={"Helmet","Logo","Shirt","Sleeve","Pants","Pants_b","Stripe","Socks","Socks_b","Skin","Cleats"};
static double colors[11][3],replacements[11][3];
int surface_resize(int id,int w,int h){
 if(id<1||id>=next_surface||w<0||h<0||w>4096||h>4096)return 0;
 Surface *s=&surfaces[id];uint32_t *pixels=calloc((size_t)(w?w:1)*(h?h:1),4);
 if(!pixels)return 0;
 free(s->pixels);s->w=w;s->h=h;s->pixels=pixels;return 1;
}
int surface_new(int w,int h){if(next_surface>=2048)return 0;int id=next_surface++;return surface_resize(id,w,h)?id:0;}
int surface_image(const char *file){
 int w,h,c;unsigned char *data=stbi_load(file,&w,&h,&c,4);if(!data)return 0;
 int id=surface_new(w,h);if(id)for(int i=0;i<w*h;i++)surfaces[id].pixels[i]=((uint32_t)data[i*4]<<24)|((uint32_t)data[i*4+1]<<16)|((uint32_t)data[i*4+2]<<8)|data[i*4+3];
 stbi_image_free(data);return id;
}
void palette_set(const char *name,double r,double g,double b){
 int replace=strncmp(name,"replace",7)==0;const char *part=name+(replace?7:5);
 for(int i=0;i<11;i++)if(strcmp(parts[i],part)==0){double *v=replace?replacements[i]:colors[i];v[0]=r;v[1]=g;v[2]=b;return;}
}
static uint32_t recolor(uint32_t p){
 if(!palette_active||(p&255)!=255)return p;
 double r=(p>>24)/255.,g=((p>>16)&255)/255.,b=((p>>8)&255)/255.;
 for(int i=0;i<11;i++)if(fabs(r-colors[i][0])<=.010&&fabs(g-colors[i][1])<=.010&&fabs(b-colors[i][2])<=.010){
 uint32_t rr=fmin(255,fmax(0,replacements[i][0]*255+.5)),gg=fmin(255,fmax(0,replacements[i][1]*255+.5)),bb=fmin(255,fmax(0,replacements[i][2]*255+.5));return rr<<24|gg<<16|bb<<8|255;}
 return p;
}
static void pixel(Surface *s,int x,int y,uint32_t p,double alpha,int mode){
 uint32_t *d=&s->pixels[y*s->w+x];int a=(int)((p&255)*alpha+.5);if(a<0)a=0;if(a>255)a=255;
 if(mode==1){*d=(p&0xffffff00)|a;return;}if(!a)return;
 if(a==255){*d=p;return;}
 int da=*d&255,oa=a+(da*(255-a)+127)/255;if(!oa){*d=0;return;}
 uint32_t v=oa;
 for(int shift=8;shift<=24;shift+=8){int sc=(p>>shift)&255,dc=(*d>>shift)&255;v|=(uint32_t)((sc*a+dc*da*(255-a)/255)/oa)<<shift;}
 *d=v;
}
static void draw(int dst,int src,double sx,double sy,double sw,double sh,double dx,double dy,double dw,double dh,uint32_t color,double alpha,int mode,const double *m,const double *clip){
 if(dst<1||dst>=next_surface||dw==0||dh==0)return;Surface *d=&surfaces[dst];if(!d->pixels)return;
 double det=m[0]*m[3]-m[1]*m[2];if(fabs(det)<1e-12)return;
 double xmin=1e20,ymin=1e20,xmax=-1e20,ymax=-1e20;
 for(int i=0;i<4;i++){double x=dx+(i&1?dw:0),y=dy+(i&2?dh:0),xx=m[0]*x+m[2]*y+m[4],yy=m[1]*x+m[3]*y+m[5];xmin=fmin(xmin,xx);xmax=fmax(xmax,xx);ymin=fmin(ymin,yy);ymax=fmax(ymax,yy);}
 int l=fmax(0,fmax(floor(xmin),clip[0])),t=fmax(0,fmax(floor(ymin),clip[1])),r=fmin(d->w,fmin(ceil(xmax),clip[2])),b=fmin(d->h,fmin(ceil(ymax),clip[3]));
 Surface *s=src>0&&src<next_surface?&surfaces[src]:NULL;
 for(int y=t;y<b;y++)for(int x=l;x<r;x++){
 double xx=x+.5-m[4],yy=y+.5-m[5],u=((m[3]*xx-m[2]*yy)/det-dx)/dw,v=((-m[1]*xx+m[0]*yy)/det-dy)/dh;
 if(u<0||v<0||u>=1||v>=1)continue;uint32_t p=color;
 if(s){int ix=floor(sx+u*sw),iy=floor(sy+v*sh);if(ix<0||iy<0||ix>=s->w||iy>=s->h)continue;p=recolor(s->pixels[iy*s->w+ix]);}
 pixel(d,x,y,p,alpha,mode);
 }
}
void raster_rect(int id,double x,double y,double w,double h,uint32_t color,double alpha,int mode,const double *m,const double *clip){draw(id,0,0,0,0,0,x,y,w,h,color,alpha,mode,m,clip);}
void raster_blit(int dst,int src,double sx,double sy,double sw,double sh,double dx,double dy,double dw,double dh,double alpha,int mode,const double *m,const double *clip){draw(dst,src,sx,sy,sw,sh,dx,dy,dw,dh,0,alpha,mode,m,clip);}
void surface_dump(int id,const char *file){Surface *s=&surfaces[id];FILE *f=fopen(file,"wb");if(!f)return;fprintf(f,"P6\n%d %d\n255\n",s->w,s->h);for(int i=0;i<s->w*s->h;i++){uint32_t p=s->pixels[i];fputc(p>>24,f);fputc(p>>16,f);fputc(p>>8,f);}fclose(f);}
