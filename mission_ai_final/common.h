#ifndef _COMMON_H
#define _COMMON_H

#define _TRUE_ 1
#define _FALSE_ 0

#define MAX_X 320
#define MAX_Y 240

#define BAUDRATE B4800
#define MODEDEVICE "/dev/ttyS2"

#define NOTHING	-1
#define COKE 	1
#define PLASTIC	2
#define MILK	3

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include <time.h>
#include <termios.h>
#include <pthread.h> 
#include <fcntl.h>

#include <sys/signal.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <sys/types.h>

#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <ctype.h>

#include <pxa_lib.h>
#include <pxa_camera_zl.h>

typedef struct{
  struct{
    unsigned char y[MAX_X*MAX_Y]; 
    unsigned char cb[MAX_X*MAX_Y/2];
    unsigned char cr[MAX_X*MAX_Y/2];
  }ycbcr;
} VideoCopy;

typedef struct{
  int flag; // 1=캔, 2=플라스틱, 3=종이, 0=못찾음
  int x_point; // x 중점
  int y_point; // y 중점
  int start_x; // 물체에 대한 시작 x값
  int end_x; // 물체에 대한 끝 x값
} Target;

extern Target t;
extern Target z;

// 백보드, 3축 센서, 적외선 센서
extern int fdBackBoard;
extern int fdInfra;

// Backboard Command 관련
extern int command;
extern int response;


// 카메라, 오버레이
extern int fdCamera;
extern int fdOverlay2;

extern struct pxa_video_buf* vidbuf;
extern VideoCopy bufCopy;
extern VideoCopy bufTmp;
extern struct pxa_video_buf vidbuf_overlay;
extern int len_vidbuf;

// program handler
extern int stopFlag;
extern int majorStep;
extern int minorStep;

extern int robotID; // robot id
extern int firstMove;

// Fuction Prototypes
void initDevices(void); // Initialize Camera and Sensors
int openSerial(void);

void checkRole(void); // Check IP Addr and decide role
void initNetwork(void); // Connect to another robot

void* videoFrame(void);
void *conduct_Mission(void);



#endif
