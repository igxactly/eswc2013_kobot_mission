CC=/usr/local/arm-linux-4.1.1/bin/arm-iwmmxt-linux-gnueabi-gcc
CFLAGS += -mcpu=iwmmxt -mtune=iwmmxt -mabi=aapcs-linux  \
		-I./ -I./lib -DDEBUG_BUILD
LFLAGS +=  -lm -pthread
BUILDDIR = bin/

SRC = main.c \
		common.c \
		lib/overlay2.c \
		lib/camera.c \
		module/vision/color.c \
		module/vision/search.c \
		module/communication/communication.c \
		module/ai/ai.c \
		module/motion/motion.c 
		

OBJ = ${SRC:.c=.o}

OUT = mission

all: $(OUT)

$(OUT): $(OBJ)
	mkdir -p $(BUILDDIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BUILDDIR)$(OUT) $(OBJ) $(LIBS) $(LFLAGS)

clean: 
	rm -f $(BUILDDIR)$(OUT) \
		*.o \
		*.?~ \
		lib/*.o \
		lib/*.?~ \
		module/communication/*.o \
		module/communication/*.?~ \
		module/motion/*.o \
		module/motion/*.?~ \
		module/ai/*.o \
		module/ai/*.?~ \
		module/vision/*.o \
		module/vision/*.?~
