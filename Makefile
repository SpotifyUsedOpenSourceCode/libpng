# Sample makefile for pngcrush using gcc and GNU make.
# Glenn Randers-Pehrson
# Last modified:  19 February 2005
#
# Invoke this makefile from a shell prompt in the usual way; for example:
#
#	make -f makefile.gcc
#
# This makefile builds a statically linked executable.

# macros --------------------------------------------------------------------

GAS_VERSION := $(shell as --version | grep "GNU assembler" | sed -e 's/GNU assembler //' -e 's/ .*//')

# uncomment these 2 lines only if you are using an external copy of zlib:
#ZINC = ../../zlib
#ZLIB = ../../zlib

CC = gcc
LD = gcc
RM = rm -f
#CFLAGS = -I. -O -Wall
#CFLAGS = -I. -O3 -fomit-frame-pointer -Wall -DPNG_USE_PNGGCCRD
CFLAGS = -I. -O3 -fomit-frame-pointer -Wall -DPNG_USE_PNGGCCRD \
         -DGAS_VERSION="\"${GAS_VERSION}\""
#CFLAGS = -I${ZINC} -I. -O3 -fomit-frame-pointer -Wall -DPNG_USE_PNGGCCRD \
#         -DGAS_VERSION="\"${GAS_VERSION}\""
# [note that -Wall is a gcc-specific compilation flag ("all warnings on")]
LDFLAGS =
O = .o
E =

PNGCRUSH  = pngcrush

LIBS = -lm
#LIBS = -L${ZLIB} -lz -lm
#LIBS = ${ZLIB}/libz.a -lm

# uncomment these 4 lines only if you are NOT using an external copy of zlib:
ZHDR = zlib.h
ZOBJS  = adler32$(O) compress$(O) crc32$(O) deflate$(O) gzio$(O) \
	 infback$(O) inffast$(O) inflate$(O) inftrees$(O) \
	 trees$(O) uncompr$(O) zutil$(O)

OBJS  = pngcrush$(O) png$(O) pngerror$(O) pngget$(O) pngmem$(O) \
	pngpread$(O) pngread$(O) pngrio$(O) pngrtran$(O) pngrutil$(O) \
	pngset$(O) pngtrans$(O) pngwio$(O) pngwrite$(O) pnggccrd$(O) \
	pngwtran$(O) pngwutil$(O) $(ZOBJS)

EXES = $(PNGCRUSH)$(E)


# implicit make rules -------------------------------------------------------

.c$(O): png.h pngconf.h pngcrush.h cexcept.h $(ZHDR)
	$(CC) -c $(CFLAGS) $<


# dependencies --------------------------------------------------------------

all:  $(EXES)


pngcrush$(O): pngcrush.c png.h pngconf.h pngcrush.h cexcept.h $(ZHDR)
	$(CC) -c $(CFLAGS) $<

$(PNGCRUSH)$(E): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

# maintenance ---------------------------------------------------------------

clean:
	$(RM) $(EXES) $(OBJS)
