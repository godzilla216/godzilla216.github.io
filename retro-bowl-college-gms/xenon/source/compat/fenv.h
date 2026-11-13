#ifndef RBC_XENON_FENV_H
#define RBC_XENON_FENV_H
/* PowerPC FPSCR RN bits; newlib in devkitXenon lacks fenv.h. */
#define FE_TONEAREST 0
#define FE_TOWARDZERO 1
#define FE_UPWARD 2
#define FE_DOWNWARD 3
static inline int fesetround(int mode) {
    union { double d; unsigned int words[2]; } fpscr;
    if (mode < 0 || mode > 3) return -1;
    __asm__ volatile("mffs %0" : "=f"(fpscr.d));
    fpscr.words[1] = (fpscr.words[1] & ~3u) | (unsigned int)mode;
    __asm__ volatile("mtfsf 255,%0" : : "f"(fpscr.d));
    return 0;
}
#endif
