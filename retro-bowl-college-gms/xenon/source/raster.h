#ifndef RETRO_RASTER_H
#define RETRO_RASTER_H
#include <stdint.h>
typedef struct { int w,h; uint32_t *pixels; } Surface;
extern Surface surfaces[2048];
int surface_new(int w,int h);
int surface_resize(int id,int w,int h);
int surface_image(const char *file);
void raster_rect(int id,double x,double y,double w,double h,uint32_t color,double alpha,int mode,const double *m,const double *clip);
void raster_blit(int dst,int src,double sx,double sy,double sw,double sh,double dx,double dy,double dw,double dh,double alpha,int mode,const double *m,const double *clip);
void palette_set(const char *name,double r,double g,double b);
extern int palette_active;
void surface_dump(int id,const char *file);
#endif
