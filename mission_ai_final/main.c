#include "main.h"

int main(int argc, char* argv[]) {
	// Initialization
	initDevices();
	initNetwork(); // network and role

	usleep(3000000); // delay 3sec

	// Strart linetracing
	int thr_id[4];
	pthread_t p_threads[4];
	
	
	thr_id[0] = pthread_create(&p_threads[0], NULL, videoFrame, (void *)NULL);     
	if (thr_id[0] < 0)     
	{    
		perror("videoFrame create error : ");  
		exit(0);    
	}
	
	usleep(1000000); // delay 3sec

	thr_id[1] = pthread_create(&p_threads[1], NULL, doMission, (void *)NULL);     
	if (thr_id[1] < 0) {
		perror("doMission thread create error : ");  
		exit(0);    
	}
/*
	thr_id[2] = pthread_create(&p_threads[2], NULL, receiveMsg, (void *)NULL);     
	if (thr_id[1] < 0) {
		perror("receive thread create error : ");  
		exit(0);    
	}
*/	
	int status;
	pthread_join(p_threads[0], (void **)&status);
	pthread_join(p_threads[1], (void **)&status);
//	pthread_join(p_threads[2], (void **)&status);
	
	return 0;
}  


