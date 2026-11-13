DEVKITXENON ?= /usr/local/xenon
CC_HOST ?= cc
QJS = vendor/quickjs
CORE = source/host.c source/raster.c source/audio.c $(QJS)/quickjs.c $(QJS)/libregexp.c $(QJS)/libunicode.c $(QJS)/cutils.c $(QJS)/libbf.c
COMMON = -O2 -g -I$(QJS) -Isource -DCONFIG_VERSION=\"2024-01-13\" -DCONFIG_BIGNUM -D_GNU_SOURCE -fno-strict-aliasing
PPC = -m32 -maltivec -fno-pic -mpowerpc64 -mhard-float
HEADERS = $(wildcard source/*.h vendor/quickjs/*.h) vendor/stb_image.h vendor/stb_vorbis.c
FAT = build/libfat.a
FAT_SOURCES = $(wildcard vendor/fat-xenon/source/*.c)

.PHONY: host xenon
host: build/retro-host
build/retro-host: $(CORE) $(HEADERS) Makefile
	mkdir -p build
	$(CC_HOST) $(COMMON) $(CORE) -o $@ -lm -lpthread -ldl
xenon: build/retro-bowl-college.elf32
$(FAT): $(FAT_SOURCES) $(wildcard vendor/fat-xenon/source/*.h) Makefile
	mkdir -p build/fat
	set -e; for src in $(FAT_SOURCES); do $(DEVKITXENON)/bin/xenon-gcc $(PPC) -O2 -DLIBXENON -DXENON -Ivendor/fat-xenon/include -I$(DEVKITXENON)/usr/include -c $$src -o build/fat/$$(basename $$src .c).o; done
	$(DEVKITXENON)/bin/xenon-ar rcs $@ build/fat/*.o
build/retro-bowl-college.elf: $(CORE) $(HEADERS) source/platform_xenon.c source/compat/fenv.h $(FAT) Makefile
	mkdir -p build
	$(DEVKITXENON)/bin/xenon-gcc $(COMMON) $(PPC) -DXENON -DRBC_BUILD_EPOCH=$(shell date +%s) -Isource/compat -Ivendor/fat-xenon/libxenon/include -I$(DEVKITXENON)/usr/include $(CORE) source/platform_xenon.c -L$(DEVKITXENON)/usr/lib -L$(DEVKITXENON)/xenon/lib/32 -Wl,-Map,build/retro-bowl-college.map -n -T$(DEVKITXENON)/app.lds -o $@ -Wl,--start-group $(FAT) -lxenon -lm -lc -Wl,--end-group
build/retro-bowl-college.elf32: build/retro-bowl-college.elf
	$(DEVKITXENON)/bin/xenon-objcopy -O elf32-powerpc --adjust-vma 0x80000000 $< $@
	$(DEVKITXENON)/bin/xenon-strip $@


