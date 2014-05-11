#ifndef _MOTION_H_
#define _MOTION_H_ 

#include "common.h"

/*
int goForward(int dst); // distance FAR/NEAR
int walk(int dir); // direction

// int moveDistance(int dir, );

int turn(int degree);

int grabTarget(Target t);
int throwTarget(); // TODO: Target에 따라?

int stopMovement();
*/


int writeCommand(int cmd);
void motion(int cmd);
void confirm_Response();


void moveStop();
void moveLeft();
void moveRight();
void moveStraight();
void seeDown();
void seeUp();

void rightOneStep();
void leftOneStep();
void frontOneStep();

void grabMilk();
void putTarget();

void turn180();
void turn180_Grabbing();

void go_Backward();


void moveStraightGrabbing();
void moveLeftGrabbing();
void moveRightGrabbing();
void turn_Left_Grabbing();
void turn_Right_Grabbing();
void turn_Left();
void turn_Right();
void turn_Left_60();
void turn_Right_60();
void turn_Left_90();
void turn_Right_90();

void rotateOnLeft();
void rotateOnRight();


void gathered_Touch(int flag);
void left_Short_Step();
void right_Short_Step();

void left_Kick();
void right_Kick();

void rotateOnLeft();
void rotateOnRight();
void leftSee();
void rightSee();
void frontSee();
void music_D();
void music_G();

void go_Plastic();
void go_Plastic_Left();
void go_Plastic_Right();

void moveStraightGrabbing_Plastic();
void moveLeftGrabbing_Plastic();
void moveRightGrabbing_Plastic();
void turn_Left_Grabbing_Plastic();
void turn_Right_Grabbing_Plastic();
void grabPlastic();


#endif





