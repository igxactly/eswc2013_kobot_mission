/*
message protocol:
	one byte per one msg
	
	0	none
	1	robot is waiting
	2	robot is moving
	3-	reserved

	Remaining target count will changed
		when the robot sends or recieves some message.
*/

#ifndef _COMMUNICATION_H_
#define _COMMUNICATION_H_

#include "common.h"

void* receiveMsg(void);

// TODO: Write a function which manipulates target count
		
#endif

