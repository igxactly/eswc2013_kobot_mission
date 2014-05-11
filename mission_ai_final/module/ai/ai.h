#ifndef _AI_H_
#define _AI_H_

#include "common.h"
#include "module/motion/motion.h"
#include "module/vision/vision.h"


#define max(a,b) (((a)>(b))? (a):(b))
#define min(a,b) (((a)<(b))? (a):(b))
#define NOISE_COUNT 2




void* doMission(void);


Target search_Milk();

int approach2Milk(VideoCopy *image, Target obj);

Target zone_Search_Handler(VideoCopy *image, Target obj);
void approach2Zone(VideoCopy *image, Target obj);

void alignDirection();
void getAwayFromTargets(void);

void getTarget(Target target); // go and pick
void putObject(void); // go and throw

void go_MiddlePos(int sec);

void zoneHandler(int* minorStep, Target obj);

void milk_Turning();

// 플라스틱
void transfer_To_MiddleLand(int repeat_Num, Target target);
void searchZone_n_Kick(VideoCopy *image, Target obj);

// 플라스틱2
void set_Position(int gathered_Type, int obj_Flag);
int lets_Go(int type, VideoCopy *image);
void rotate_To_Zone(VideoCopy *image, Target target);
void shortQuickSteps(int type, double sec);

// 플라스틱 집고 옮기기
Target zone_Search_Handler_Plastic(VideoCopy *image, Target obj);
void approach2Zone_Plastic(VideoCopy *image, Target obj);
void getTarget_Plastic(Target target);
void plastic_Turning();
int plastic_Turning2();
void plastic_Turning3();

void set_Position2(int gathered_Type, int obj_Flag);
void set_Position3(int gathered_Type, int obj_Flag);

void find_Second_Plastic();

int left_front_right_search(int flag);

void generate_Infra();
void terminate_infra();
void *infraredsensor(void);

#endif
