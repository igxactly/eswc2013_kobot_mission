#include "common.h"

int robotID = -1; // robot id
int firstMove = 1;

Target t, z;

// program handler
int stopFlag; 

// 백보드, 3축 센서, 적외선 센서
int fdBackBoard;
int fdInfra;
// Backboard Command 관련
int command;
int response;

// 카메라, 오버레이
int fdCamera;
int fdOverlay2;

struct pxa_video_buf* vidbuf;
VideoCopy bufCopy;
VideoCopy bufTmp;

struct pxa_video_buf vidbuf_overlay;
int len_vidbuf;


// Initialize Camera and Sensors
void initDevices(void) {
	struct pxacam_setting camset;
	
	printf("-----Initializing Device Started-----\n");	
	
	// Backboard uart init
	fdBackBoard = openSerial();
	printf("Initializing BackBoard complete!\n");	
		
	// 적외선 센서 init
	fdInfra = open("/dev/FOUR_ADC", O_NOCTTY);
		
		
	// Camera init
	fdCamera = camera_open(NULL,0);
	ASSERT(fdCamera);

	system("echo b > /proc/invert/tb"); //LCD DriverIC top-bottom invert ctrl

	memset(&camset,0,sizeof(camset));
	camset.mode = CAM_MODE_VIDEO;
	camset.format = pxavid_ycbcr422;

	
	camset.width = MAX_X;
	camset.height = MAX_Y;

	camera_config(fdCamera,&camset);
	camera_start(fdCamera);

	fdOverlay2 = overlay2_open(NULL,pxavid_ycbcr422,NULL, MAX_X, MAX_Y, 0 , 0);

	overlay2_getbuf(fdOverlay2, &vidbuf_overlay);
	len_vidbuf = vidbuf_overlay.width * vidbuf_overlay.height;

	printf("Initializing Camera complete!\n");	
	
	// init finish
	printf("-----Initializing Device Finished-----\n");	
}

int openSerial(void){
    char fd_serial[20];
    int fd;
    struct termios oldtio, newtio;

    strcpy(fd_serial, MODEDEVICE); //FFUART
    
    fd = open(fd_serial, O_RDWR | O_NOCTTY );
    if (fd <0) {
        printf("Serial %s  Device Err\n", fd_serial );
        exit(1);
    }
	printf("robot uart ctrl %s\n", MODEDEVICE);
    
    tcgetattr(fd,&oldtio); /* save current port settings */
    bzero(&newtio, sizeof(newtio));
    newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;
    newtio.c_lflag = 0;
    newtio.c_cc[VTIME]    = 0;   /* inter-character timer unused */
    newtio.c_cc[VMIN]     = 1;   /* blocking read until 8 chars received */
    
    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);
    
    return fd;
}

void* videoFrame(void){
	int cnt = 0;
	
	VideoCopy black;
		
	
	while(1){
		vidbuf = camera_get_frame(fdCamera);
		
		memcpy(vidbuf_overlay.ycbcr.y,vidbuf->ycbcr.y,len_vidbuf);
		memcpy(vidbuf_overlay.ycbcr.cb,vidbuf->ycbcr.cb,len_vidbuf/2);
		memcpy(vidbuf_overlay.ycbcr.cr,vidbuf->ycbcr.cr,len_vidbuf/2);
		
		memcpy(bufCopy.ycbcr.y,vidbuf->ycbcr.y,len_vidbuf);
		memcpy(bufCopy.ycbcr.cb,vidbuf->ycbcr.cb,len_vidbuf/2);
		memcpy(bufCopy.ycbcr.cr,vidbuf->ycbcr.cr,len_vidbuf/2);
		
		camera_release_frame(fdCamera,vidbuf);
			
		if(stopFlag == 1)
			break;
		/*
		if(obj.x_point >=0 && obj.x_point <320 && obj.y_point >=0 && obj.y_point < 240){
		 
		  
		  int i, j;
		  for(i  = obj.x_point; i<obj.x_point + 10; i++){
		   for(j = obj.y_point; j<obj.y_point + 10; j++){
		      int index = j*320 + i;
		       
		   
		      vidbuf_overlay.ycbcr.y[index] = 120;
		      vidbuf_overlay.ycbcr.cb[index/2] = 230;
		      vidbuf_overlay.ycbcr.cr[index/2] = 30;
		      
		    
		   }
		  }
		  
		}
		*/
	}
	
	camera_stop(fdCamera);
	camera_close(fdCamera);
}

void checkRole(void) {

}

void initNetwork(void) {

}