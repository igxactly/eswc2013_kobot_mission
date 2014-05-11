#include "module/motion/motion.h"

#define UNDEFINED_CMD	-1

#define GRAB_MILK	4
#define PUT_TARGET	32

#define SEEDOWN		8

#define STOP		26

#define RIGHTONESTEP	9
#define LEFTONESTEP	7
#define RIGHT_SHORT_STEP 24
#define LEFT_SHORT_STEP	22

#define TURN_LEFT	15
#define TURN_RIGHT	20
#define TURN_LEFT_60	62
#define TURN_RIGHT_60	64
#define TURN_LEFT_90	63
#define TURN_RIGHT_90	65
#define TURN_LEFT_45	66
#define TURN_RIGHT_45	67

#define TURN_LEFT_GRABBING 	17
#define TURN_RIGHT_GRABBING	27

#define GATHERED_TOUCH		11
#define GATEREDD_MILK		10
#define GATHERED_PLASTIC	6		

#define LEFT_KICK		18
#define RIGHT_KICK		23

#define ROTATEONRIGHT		19
#define	ROTATEONLEFT		16

#define	GO_PLASTIC		2
#define GO_PLASTIC_LEFT		1
#define GO_PLASTIC_RIGHT	3

// 플라스틱 집고 옮기기 필요한 것
#define MOVE_STRAIGHT_GRABBING_PLASTIC	90
#define MOVE_RIGHT_GRABBING_PLASTIC	91
#define MOVE_LEFT_GRABBING_PLASTIC	92
#define TURN_LEFT_GRABBING_PLASTIC 	93
#define TURN_RIGHT_GRABBING_PLASTIC	94
#define GRAB_PLASTIC			95

// 리모컨 밖
#define LEFTSEE		40
#define RIGHTSEE	42
#define FRONTSEE	41
#define GO_BACKWARD	43
#define MOVE_STRAIGHT	44
#define MOVE_RIGHT	45
#define MOVE_LEFT	46
#define MOVE_STRAIGHT_GRABBING	47
#define MOVE_RIGHT_GRABBING	49
#define MOVE_LEFT_GRABBING	48
#define FRONTONESTEP	50
#define LEFTSEE_80	51
#define RIGHTSEE_80	52

#define MUSIC_D		60
#define MUSIC_G		61

void motion(int cmd)
{
  switch(cmd){
    case MOVE_STRAIGHT:
    case MOVE_RIGHT:
    case MOVE_LEFT:
    case MOVE_LEFT_GRABBING:
    case MOVE_RIGHT_GRABBING:
    case MOVE_STRAIGHT_GRABBING:
    case TURN_LEFT_GRABBING:
    case TURN_RIGHT_GRABBING:
    case STOP:
      
    case LEFT_SHORT_STEP:
    case RIGHT_SHORT_STEP:
    case GATHERED_TOUCH:
    case GATHERED_PLASTIC:
    case GATEREDD_MILK:
      
      
    case LEFT_KICK:
    case RIGHT_KICK:
    case SEEDOWN:
         
    case LEFTSEE:
    case RIGHTSEE:
    case FRONTSEE:
    case LEFTSEE_80:
    case RIGHTSEE_80:
      
    case FRONTONESTEP:
    case LEFTONESTEP:
    case RIGHTONESTEP:
    
    case GRAB_MILK:
    case PUT_TARGET:
      
    case TURN_LEFT:
    case TURN_RIGHT:
    case TURN_LEFT_60:	
    case TURN_RIGHT_60:	
    case TURN_LEFT_90:	
    case TURN_RIGHT_90:
    case TURN_LEFT_45:
    case TURN_RIGHT_45:
      
    case ROTATEONRIGHT:
    case ROTATEONLEFT:
      
    case GO_BACKWARD:
      
    case GO_PLASTIC:
    case GO_PLASTIC_LEFT:
    case GO_PLASTIC_RIGHT:
      
    case MOVE_STRAIGHT_GRABBING_PLASTIC:	
    case MOVE_RIGHT_GRABBING_PLASTIC:	
    case MOVE_LEFT_GRABBING_PLASTIC:	
    case TURN_LEFT_GRABBING_PLASTIC :	
    case TURN_RIGHT_GRABBING_PLASTIC:	
    case GRAB_PLASTIC:
      
    case MUSIC_D:
    case MUSIC_G:
	writeCommand(cmd);
	break;
  }  
}

int writeCommand(int cmd)
{
  write(fdBackBoard, &cmd, 1);
  
  return 0;
}

void confirm_Response(){
	while(1)     
	{         
		if(read(fdBackBoard, &response, 1) > 0)	// 읽는데 성공하면 루프 탈출
		{
		//	printf("response message : %d\n", response);
			break;
		}
	} 
}


void moveStop(){
  command = STOP;	// stop
  motion(command);
  command = UNDEFINED_CMD;
  
  confirm_Response();
  
}

void moveLeft(){
  command = MOVE_LEFT;
  motion(command);
  command = UNDEFINED_CMD;
}
void moveRight(){
  command = STOP;	
  motion(MOVE_RIGHT);
  command = UNDEFINED_CMD;
}
void moveStraight(){
  command = MOVE_STRAIGHT;
  motion(command);
  command = UNDEFINED_CMD;
}

void moveStraightGrabbing()
{
  command = MOVE_STRAIGHT_GRABBING;
  motion(command);
  command = UNDEFINED_CMD;
}

void moveLeftGrabbing()
{
  command = MOVE_LEFT_GRABBING;
  motion(command);
  command = UNDEFINED_CMD;
}

void moveRightGrabbing()
{
  command = MOVE_RIGHT_GRABBING;
  motion(command);
  command = UNDEFINED_CMD;
}

void seeDown()
{
  command = SEEDOWN;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response();
}

void seeUp()
{
  command = SEEDOWN;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response();
}

void rightOneStep()
{
  command = RIGHTONESTEP;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void leftOneStep(){
  command = LEFTONESTEP;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void frontOneStep()
{
  command = FRONTONESTEP;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void grabMilk()
{
  command = GRAB_MILK;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn180()
{
  int i;
  for(i=0; i<5; i++){
    command = TURN_RIGHT;
    motion(command);
    command = UNDEFINED_CMD;
    confirm_Response(); 
  }
}

void turn180_Grabbing()
{
  int i;
  for(i=0; i<5; i++){
    command = TURN_RIGHT_GRABBING;
    motion(command);
    command = UNDEFINED_CMD;
    confirm_Response();
  }
}

void go_Backward()
{
  command = GO_BACKWARD;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void putTarget()
{
  command = PUT_TARGET;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Left()
{
  command = TURN_LEFT;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Right()
{
  command = TURN_RIGHT;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Left_60()
{
  command = TURN_LEFT_60;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Right_60()
{
  command = TURN_RIGHT_60;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Left_90()
{
  command = TURN_LEFT_90;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Right_90()
{
  command = TURN_RIGHT_90;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Left_45()
{
  command = TURN_LEFT_45;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Right_45()
{
  command = TURN_RIGHT_45;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Left_Grabbing()
{
  command = TURN_LEFT_GRABBING;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Right_Grabbing()
{
  command = TURN_RIGHT_GRABBING;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void gathered_Touch(int flag)
{
  if(flag == PLASTIC)
      command = GATHERED_PLASTIC;
  else if(flag == MILK)
      command = GATEREDD_MILK;
  else
      command = GATHERED_TOUCH;
  
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void left_Short_Step()
{
  command = LEFT_SHORT_STEP;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}
void right_Short_Step()
{
  command = RIGHT_SHORT_STEP;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}
void left_Kick()
{
  command = LEFT_KICK;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}
void right_Kick()
{
  command = RIGHT_KICK;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void rotateOnLeft()
{
  command = ROTATEONLEFT;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}
void rotateOnRight()
{
  command = ROTATEONRIGHT;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void leftSee()
{
  command = LEFTSEE;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void rightSee()
{
  command = RIGHTSEE;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void leftSee_80()
{
  command = LEFTSEE_80;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void rightSee_80()
{
  command = RIGHTSEE_80;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void frontSee()
{
  command = FRONTSEE;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void music_D()
{
  command = MUSIC_D;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void music_G()
{
  command = MUSIC_G;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void go_Plastic()
{
  command = GO_PLASTIC;
  motion(command);
  command = UNDEFINED_CMD;
//  confirm_Response(); 
}

void go_Plastic_Left()
{
  command = GO_PLASTIC_LEFT;
  motion(command);
  command = UNDEFINED_CMD;
//  confirm_Response(); 
}

void go_Plastic_Right()
{
  command = GO_PLASTIC_RIGHT;
  motion(command);
  command = UNDEFINED_CMD;
//  confirm_Response(); 
}

void moveStraightGrabbing_Plastic()
{
  command = MOVE_STRAIGHT_GRABBING_PLASTIC;
  motion(command);
  command = UNDEFINED_CMD;
}

void moveLeftGrabbing_Plastic()
{
  command = MOVE_LEFT_GRABBING_PLASTIC;
  motion(command);
  command = UNDEFINED_CMD;
}

void moveRightGrabbing_Plastic()
{
  command = MOVE_RIGHT_GRABBING_PLASTIC;
  motion(command);
  command = UNDEFINED_CMD;
}

void turn_Left_Grabbing_Plastic()
{
  command = TURN_LEFT_GRABBING_PLASTIC;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void turn_Right_Grabbing_Plastic()
{
  command = TURN_RIGHT_GRABBING_PLASTIC;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}

void grabPlastic()
{
  command = GRAB_PLASTIC;
  motion(command);
  command = UNDEFINED_CMD;
  confirm_Response(); 
}