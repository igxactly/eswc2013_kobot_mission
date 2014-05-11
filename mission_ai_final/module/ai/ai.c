#include "ai.h"


/*
 * 우유 : 첫 물체 가져다 놓고, 회전을 아직 못해봄 - 발목 풀림
 * 	  오른쪽에서 시작했을때, 90도 90도 사이 딜레이 수정
 * 
 * 
 * 플라스틱 : 첫 물체 가져다 놓고, 그 자리에서 무조건 180도 회전
 * 		그 후 의무보행 3초 직진
 * 		찬영이 아이디어 적용
 * 
 * 
 * 
 */
int thr_id, status;
pthread_t p_threads;
int infraStopFlag;
int infraFlag;

int majorStep = 1; // 0_get 1_put
int minorStep = 1;
int step = 1;
int firstStep = 1;


// 이 두개만 바꿔주면 시작 임무가 바뀐다
int goal = MILK;
//int goal = PLASTIC;

// 우유 로직 전용 변수
int redZoneCnt, blueZoneCnt;
int greenZoneCnt;

// 플라스틱 로직 전용 변수
int plastic_Start_Pos;	// 2 이면 사이드에서 시작 1이면 중앙에서 시작
int turnCnt = 0;	// 음수 이면 내 몸은 왼쪽에서 시작


int minX=110, maxX=210;
int detail_minX = 120, detail_maxX = 200;
int detail_minX_Outside = 90, detail_maxX_Outside = 230;
int straight_Cnt = 4;
int side_Cnt = 6;
int detail_Y = 30;



void* doMission(void) {

	confirm_Response();	// 맨 처음에 리모컨 입력 받아야 프로그램 시작
	music_G();
	
	int i;
	int milk_Num = 0;
	int plastic_Num = 0;
	int type;
	int firstCount = 0;	
	
	
	if(goal == MILK)
	{
	    while (stopFlag == 0) {
		  switch (step) {
		  case 1:	// 우유팩만 탐색
			  // 우유팩만 찾으면 됨
			  
			  t = findTarget(&bufCopy, MILK);
			  if(t.flag != MILK)
			  {
			    
			      step--;
			      
			  }
			  
			  
			  break;
		  case 2:	// 우유팩에 접근	  
			  approach2Milk(&bufCopy, t);
			
			  break;
		  case 3:	// 우유팩 줍기
			  
			  // 우유팩을 위한 겟타겟
//			  t.flag = MILK;
			  getTarget(t);
			  
			  // 180도 돌 것인가?
			  if(milk_Num == 1)
			  {
			      turn180_Grabbing();
			      usleep(200000);
			  }
			    
			  break;
		  case 4:	// 중간까지 나오기
			  if(milk_Num == 0)
			    go_MiddlePos(20);
			  else if(milk_Num == 1)
			    go_MiddlePos(15);
			  
			  break;	
		  case 5:	// 목표장소 탐색
			  // 고동완이 만들 목적지 탐색 비교 함수 필요
			  // 목적지를 찾을 수 있게 좀 나와야함
			  // findZone implementation
//			  t.flag = MILK;
			  z = zone_Search_Handler(&bufCopy, t);

			  
			  break;
		  case 6:	// 우유팩 장소에 접근
			  // 우유팩 존에 다가갈 함수 필요
		    
			  approach2Zone(&bufCopy, z);
			  
			  break;
			  
		  case 7:	// 던지기
			  // 우유팩 던지는것 필요
			  putTarget();	
			  usleep(200000);
			  milk_Num++;
//				stopFlag = 1;	
			  // 물건 놓았으면 적외선 감지 끝
//				terminate_infra();
			  break;
			  
		  case 8:
			  if(milk_Num == 2){
			      stopFlag = 1;
			      break;
			  }
			  
			  // 방향보정 + 180도 돌기
			  milk_Turning();
			  
			  break;
		
		  default:
			  break;
		  }
		    
		  step++;
		  
		  if(step >= 14)
		    step = 1;
	    
		
	    }	
	}
	
	/*
	else if(goal == PLASTIC)
	{
	  while (stopFlag == 0) {
		switch (step) {
		    case 1:	// 플라스틱 탐색
			    t = findTarget(&bufCopy, PLASTIC);
			                                    
			    // 두번째 탐색에대한 추가적인 코드 필요
			    
			    break;
		    case 2:	// 플라스틱에 접근	 
		      
			    approach2Milk(&bufCopy, t);
			  
			    break;
		    case 3:	// 중간까지는 일직선으로 차기
//			    transfer_To_MiddleLand(3, t);
			
			    break;
		    case 4:	// 목적지 쪽으로 차기
			    
			    //t.flag = COKE;
//			    searchZone_n_Kick(&bufCopy, t);
//			    plastic_Num++;
			    break;
			    
		    case 5:
//			    if(plastic_Num == 1)	// 일단 하나만
//			      stopFlag == 1;
		    default:
			    break;
		    }
		      
		    step++;
		    
		    if(step >= 9)
		      step = 1;
	    }
	}
	*/
	
	/*
	// 밀고가기 빠른걸음1_세부동작많음
	else if(goal == PLASTIC)
	{
	    while(stopFlag == 0){
		switch (step) {
		    case 1:	
			    t.flag = PLASTIC;
			    //shortQuickSteps(NULL, 3); // type, sec
			     for(i=0; i<3; i++)
			    {
				shortQuickSteps(NULL, 2);
				set_Position2(NULL, PLASTIC);
			    }
			    
			    break;
		    case 2:
			    rotate_To_Zone(&bufCopy, t); 
			    set_Position2(NULL, PLASTIC);
			   
			    break;
		    case 3:	
			    if(abs(turnCnt) > 1){		// 정면이 아닐경우
				shortQuickSteps(NULL, 2);
				set_Position2(NULL, PLASTIC);
			    
				rotate_To_Zone(&bufCopy, t); 
			    	set_Position2(NULL, PLASTIC);
			    }
			    break;
		    case 4:	
			    shortQuickSteps(PLASTIC, NULL);
			    set_Position2(PLASTIC, PLASTIC);
			    
			    left_Kick();
			    
			    
			    plastic_Num++;
			    
			    break;    
		    case 5:	
			    
			    break;
		    case 6:	// 몸 돌리기
			    
			    if(plastic_Num == 2)
			    {
			      stopFlag = 1;
			      break;
			      
			    }
			    
			    plastic_Turning();
			    
			    while(1){}
			    
			    break;
		    case 7:	// 재탐색 
			    
			    break;
		    default:
			    break;
		    }
		      
		step++;
		
		if(step >= 10)
		  step = 1;
	    }
	  
	}*/
	
	// 밀고가기 빠른걸음2_세부동작 없애자
	else if(goal == PLASTIC)
	{
	    while(stopFlag == 0){
		switch (step) {
		    case 1:	
			    t.flag = PLASTIC;
			    //shortQuickSteps(NULL, 3); // type, sec
			    if(plastic_Num == 0){
				for(i=0; i<5; i++)
				{
				    shortQuickSteps(NULL, 1.15);
				    gathered_Touch(NULL);
				    //set_Position3(NULL, PLASTIC);
				}
			    }
			    else if(plastic_Num == 1)
			    {
				for(i=0; i<4; i++)
				{
				    shortQuickSteps(NULL, 1.15);
				    gathered_Touch(NULL);
				    //set_Position3(NULL, PLASTIC);
				}
			    }
			   
			    break;
		    case 2:
			    rotate_To_Zone(&bufCopy, t); 
			    set_Position3(NULL, PLASTIC);
			   
			    break;
		    case 3:	
			    /*
			    if(abs(turnCnt) > 1){		// 정면이 아닐경우
				shortQuickSteps(NULL, 2);
				set_Position2(NULL, PLASTIC);
			    
				rotate_To_Zone(&bufCopy, t); 
			    	set_Position2(NULL, PLASTIC);
			    }*/
			    /*
			    for(i=0; i<1; i++)
			    {
				shortQuickSteps(NULL, 1.8);
				set_Position3(NULL, PLASTIC);
			    }
			    */
			    break;
		    case 4:	
			    shortQuickSteps(NULL, 1.15);
			    //set_Position2(PLASTIC, PLASTIC);
			    gathered_Touch(NULL);
			    shortQuickSteps(NULL, 1.15);
			    //set_Position2(PLASTIC, PLASTIC);
			    gathered_Touch(PLASTIC);
			    left_Kick();
			   
			    plastic_Num++;
			    
			    break;    
		    case 5:	
			    
			    break;
		    case 6:	// 몸 돌리기
			    
			    if(plastic_Num == 2)
			    {
			      stopFlag = 1;
			      break;
			      
			    }
			    
			    plastic_Turning();
			    //plastic_Turning2();
			    //plastic_Turning3();
			    
			    
			    break;
		    case 7:	// 재탐색 
			    usleep(500000);
			    find_Second_Plastic();
		      
			    
			    break;
		    default:
			    break;
		    }
		      
		step++;
		
		if(step >= 10)
		  step = 1;
	    }
	  
	}
	
	/*
	// 밀고가기 안정적인거( 아직 작성 안함 )
	else if(goal == PLASTIC)
	{
	    while(stopFlag == 0){
		switch (step) {
		    case 1:	
			    t.flag = PLASTIC;
			    shortQuickSteps(NULL, 4); // type, sec
			
			    break;
		    case 2:	 
			    for(i=0; i<3; i++)
			    {
				gathered_Touch(NULL);
				shortQuickSteps(NULL, 3);
			    }
			    
			    break;
		    case 3:	
			    rotate_To_Zone(&bufCopy, t); 
			    set_Position(NULL, PLASTIC);
			    
			    break;
		    case 4:	
			    shortQuickSteps(NULL, 3);
			    gathered_Touch(NULL);
			    break;    
		    case 5:	// 목적지 접근
			    shortQuickSteps(PLASTIC, NULL);
			    plastic_Num++;
			    break;
		    case 6:	// 몸 돌리기
			    if(plastic_Num == 1)
			      //stopFlag = 1;
			      while(1){}
			      
			    break;
		    case 7:	// 재탐색 
			    
			    break;
		    default:
			    break;
		    }
		      
		step++;
		
		if(step >= 10)
		  step = 1;
	    }
	  
	}
	*/
	/*
	else if(goal == PLASTIC)
	{
	    while (stopFlag == 0) {
		  switch (step) {
		  case 1:	
			  t = findTarget(&bufCopy, PLASTIC);
			  
			  break;
		  case 2:		  
			  approach2Milk(&bufCopy, t);
			
			  break;
		  case 3:	
			  getTarget_Plastic(t);
			  
			  if(plastic_Num == 1)
			  {
			      turn180_Grabbing();
			      usleep(200000);
			  }
			    
			  break;
		  case 4:	// 중간까지 나오기
			  if(plastic_Num == 0)
			    go_MiddlePos(20);
			  else if(plastic_Num == 1)
			    go_MiddlePos(15);
			  
			  break;	
		  case 5:	// 목표장소 탐색
			  // 고동완이 만들 목적지 탐색 비교 함수 필요
			  // 목적지를 찾을 수 있게 좀 나와야함
			  // findZone implementation
//			  t.flag = MILK;
			  z = zone_Search_Handler_Plastic(&bufCopy, t);
			  
			  
			  break;
		  case 6:	// 우유팩 장소에 접근
			  // 우유팩 존에 다가갈 함수 필요
		    
			  approach2Zone_Plastic(&bufCopy, z);
			  
			  break;
			  
		  case 7:	// 던지기
			  // 우유팩 던지는것 필요
			  moveStop();
			  usleep(200000);
			  plastic_Num++;
//				stopFlag = 1;	
			  // 물건 놓았으면 적외선 감지 끝
//				terminate_infra();
			  break;
			  
		  case 8:
			  if(plastic_Num == 2){
			      stopFlag = 1;
			      break;
			  }
			  // 방향보정 + 180도 돌기
			  
			  plastic_Turning();
			  break;
		
		  default:
			  break;
		  }
		    
		  step++;
		  
		  if(step >= 14)
		    step = 1;
	    
		
	    }	
	}
	*/
  
}

Target search_Milk()
{
    const int maxB = 200;
    const int minB = 120;
  
    Target t;
    
    t = findTarget(&bufCopy, MILK);
    
    if(t.flag > 0)
    {
	while(1)
	{
	    printf("x_point = %d\n", t.x_point); 
	  
	    int refind_Pos_X = t.start_x;
	    
	    if(t.flag == 0)
	      break;
	    
	    if(t.x_point < maxB && t.x_point > minB)
	    {
	      break;
	    }
	    
	    else if(t.x_point >= maxB)
	    {
		leftOneStep();
		refind_Pos_X -= 30;
		if(refind_Pos_X < 1)
		  refind_Pos_X = 1;
	      
	    }
	    
	    else if(t.x_point <= minB)
	    {
		rightOneStep();
		refind_Pos_X += 15;
		if(refind_Pos_X >318)
		  refind_Pos_X = 319;
	    }
	    
	    // usleep(100000);
	    
	    //t = refind(&bufCopy, t.flag, refind_Pos_X);
	    t = findTarget(&bufCopy, MILK);
	}
	
    }
    
    return t;
}

int approach2Milk(VideoCopy *image, Target obj) {
  
  ColorBoundary color_B = classifyObject(obj.flag);
  
  
  int isFind;
  int cnt = 0;

  
  while(1)
  {
	// search
	isFind = toleranceSearch(image, &obj, color_B);
	
	//printf("isFind : %d\n", isFind);
	printf("y : %d\n", obj.y_point);
	
	if(isFind <= 0)	// stop_Signal
	{
	    cnt++;
	    if(cnt > 0)
	      break;
	}
	
//	if(obj.y_point < 20)
//	  break;
	
	// command -> robot
	else{
//	  printf("pass command\nx_mid : %d\n", obj.x_point);
	  
	  int wPix = (MAX_X/2 - obj.x_point);
//	  printf("wPix : %d\n", wPix);
	
	  int direction = wPix < 0 ? 0 : 1;	
	  wPix = abs(wPix);
	
	  if(wPix > 60){ 
	    if(direction == 0)
	      moveLeft();
	    else if(direction == 1)
	      moveRight();
	  }
	  else{	
	    moveStraight();
	  }
	}
  }
  
  moveStop();
  printf("approach complete. isFind : %d\n", isFind);
  usleep(200000);

  
}

Target zone_Search_Handler(VideoCopy *image, Target obj)
{
    Target zone;
    
    redZoneCnt = blueZoneCnt = greenZoneCnt = 0;
    
    while(1){
	zone = findZone(image, obj);
	  
	printf("obj flag : %d\n", zone.flag);
	
	if(zone.flag == MILK)
	{
	    if(zone.x_point < 50)
		turn_Right_Grabbing();
	    else if(zone.x_point > 270)
		turn_Left_Grabbing();
	    
	    break;
	}
	
	else if(zone.flag == 7)	// red
	{
	    turn_Right_Grabbing();
	    usleep(200000);
	    
	    redZoneCnt++;
	    
	}
	else if(zone.flag == 8)	// blue
	{
	    turn_Right_Grabbing();
	    usleep(200000);
	    
	    blueZoneCnt++;
	}
	
	else if(zone.flag > 3)
	{
	    printf("zone not found\n"); 
	    right_Kick();
	    usleep(200000);
	}
    }
    
    if(redZoneCnt > 0){
	moveStraightGrabbing();
	
	usleep(15000000);	
	    
	moveStop();
	usleep(200000);
    }
  /*  
    else if(blueZoneCnt > 0){
	moveStraightGrabbing();
	
	usleep(5000000);	
	    
	moveStop();
	usleep(200000);
    }
  */  
    
//     while(1){
	zone = findZone(image, obj);
      
	printf("obj flag : %d\n", zone.flag);
	
	if(zone.flag == MILK)
	{
	  
	    if(zone.x_point < 50)
		turn_Right_Grabbing();
	    else if(zone.x_point > 270)
		turn_Left_Grabbing();
	    
//	    break;
	    
	}
	
	else if(zone.flag == 7)	// red
	{
	    turn_Right_Grabbing();
	    usleep(200000);
	    
	    redZoneCnt++;
	}
	else if(zone.flag == 8)	// blue
	{
	    turn_Right_Grabbing();
	    usleep(200000);
	    
	    blueZoneCnt++;
	}
	
	else if(zone.flag > 3)
	{
	    printf("zone not found\n"); 
//	    turn_Left_Grabbing();
	    usleep(200000);
	}
    
//    }
    
    return zone;
}

void approach2Zone(VideoCopy *image, Target obj)
{
    ColorBoundary color_B = classifyObject(obj.flag);
   
    int zoneCnt = 0;
    int isFind;
    int cnt = 0;
    int first_Flag = 1;
    while(1)
    {
	//search
      isFind = toleranceZoneSearch(image, &obj, color_B, &zoneCnt);
      printf("zone find : %d\n" , isFind);
      
      if(isFind <=0)
      {
//	cnt++;
//	moveStraightGrabbing();
//	if(cnt > 2)
	    break;
      }
	
      
      else
      {
	 int wPix = (MAX_X/2 - obj.x_point);
	  printf("wPix : %d\n", wPix);
	
	  int direction = wPix < 0 ? 0 : 1;	
//	  int direction = wPix < 0 ? 1 : 0;	
	  wPix = abs(wPix);
	
	  if(wPix > 60){ 
	    if(direction == 0)
	      moveLeftGrabbing();
	    else if(direction == 1)
	      moveRightGrabbing();
	  }
	  else{	
	    moveStraightGrabbing();
	  }
	  
	  first_Flag = 0 ;	// 디버깅용 코드
      }
    }
    
    if(first_Flag == 1){	// 디버깅용 코드
      moveStop();
      usleep(200000);
      putTarget();
      left_Kick();
    
    }
    
    if(redZoneCnt > 0)
    {
	usleep(7000000);	// 경험적 의무걸음
    }
    
    else
    {
	usleep(6000000);
    }
    moveStop();
}


void getAwayFromTargets(void) {
    
}


// go and pick
void getTarget(Target target) {
  ColorBoundary color_B = classifyObject(target.flag);
  
  printf("\n--------------------see down------------------\n\n");
  
  
//  while(1){
		printf("see down\n");
		// 내려다 보기
		seeDown();
		
		usleep(200000);	// delay 1sec, camera buffer update
		 

		// 내려다 본 결과로 판단
		int frontCnt=0;
		int LR_Cnt=0;
		
	
		Target obj = findTarget(&bufCopy, target.flag);
		
		printf("x : %d, y : %d, flag : %d\n", obj.x_point, obj.y_point, obj.flag);
		
		printf("see up\n");
		// 몸을 다시 일으키고
		seeUp();
		usleep(200000);
		if(obj.flag == MILK){
		    if(obj.y_point > 5)	
			      frontCnt++;
			      
		    int x = obj.x_point - MAX_X/2;
		    
		    if (x > 60) 
		      LR_Cnt++;
		    else if(x < -60) 
		      LR_Cnt--;
		    
		    printf("%d %d\n", frontCnt, LR_Cnt);
		    
		    
		    if(frontCnt ==0 && LR_Cnt ==0)	// 보정할거 없으면 탈출
			    //break;
		    
		    // 위치 보정
		    if(LR_Cnt > 0){
			    leftOneStep();
		    }
		    else if(LR_Cnt < 0){
			    rightOneStep();
		    }

		    if(frontCnt >0){
			    frontOneStep();
		    }
			    
		    usleep(1000000);
		    // 다시 내려다보기, 루프 반복
		}
//	}
	printf("\n-------------!grab-----------------\n\n");
	
//	frontOneStep();
//	usleep(200000);
	
	gathered_Touch(MILK);
	usleep(200000);
	
	grabMilk();
	usleep(200000);
}

void go_MiddlePos(int sec)
{
    moveStraightGrabbing();
    
    sec = sec* 1000000;
    usleep(sec);
    
    moveStop();
}

void zoneHandler(int* minorStep, Target obj)
{
    if (obj.flag == 0)
    {
	(*minorStep)--;
	
	moveStraightGrabbing();
	
	usleep(3000000);	//delay 3sec
	
	moveStop();
    }
}

// go and throw
void putObject(void) {

      putTarget();
}

void generate_Infra()
{
      infraStopFlag = 0;
      
      thr_id = pthread_create(&p_threads, NULL, infraredsensor, (void *)NULL);
      if(thr_id < 0)
      {
	perror("infraredsensor create error");
	exit(0);
      }
      
}

void terminate_infra()
{
  infraStopFlag = 1;
  
  pthread_join(p_threads, (void**)&status);
}


void *infraredsensor(void){

    int i, flag;

    static unsigned short rxbuf[2];    


    while(1){

        flag=0;
        
        rxbuf[0]=0;
        rxbuf[1]=0;
        
        
        read(fdInfra, rxbuf, sizeof(rxbuf));
        
	printf("rxbuf[0], rxbuf[1] : %d, %d\n", rxbuf[0], rxbuf[1]);
        if(rxbuf[0]>400 || rxbuf[1]>400){
            for(i=0; i<15; i++){
                rxbuf[0]=0;
                rxbuf[1]=0;
                
                read(fdInfra, rxbuf, sizeof(rxbuf));
		
                if(rxbuf[0]<180 && rxbuf[1]<180){
                    flag = 1;
                    break;
                }
            }
            if(flag == 0)
                infraFlag=1;
        }
        else
            infraFlag = 0;
	
	//printf("infra : %d\n", infraFlag);
	
	if(infraStopFlag == 1)
	  break;
    }
    
    exit(0);
}

void milk_Turning()
{
    // 양수는 오른쪽으로 회전했었다
    // 음수는 왼쪽
    int i;
    
    if(redZoneCnt > 0)
    {	
	/*for(i=0; i <3; i++)
	{
	    turn_Right();
	    usleep(200000);
	}*/
      
	turn_Right_60();
	usleep(200000);
	turn_Right_45();
	usleep(200000);
	
	go_Plastic();
	usleep(3800000);
    }
    
    else if(blueZoneCnt > 0)
    {
      
	for(i=0; i <3; i++)
	{
	    turn_Right_45();
	    usleep(500000);
	}
      
	go_Plastic();
	usleep(3500000);
    }

    else
    {	
	for(i=0; i <2; i++)
	{
	    turn_Right_90();
	    usleep(500000);
	}
	
	go_Plastic();
	usleep(3000000);
    }
    
    // 의무 보행하여 가운데쪽으로 좀 나오자
    //moveStraight();
    //usleep(8000000);	// 15 걸음 의도
    
    moveStop();
    usleep(200000);
    
    /*
    for(i=0; i <2; i++)
    {
	turn_Left();
	usleep(200000);
    }
    
     // 의무 보행하여 가운데쪽으로 좀 나오자
    moveStraight();
	
    usleep(4000000);	// 
    
    moveStop();
    usleep(200000);
    */
    
    // 여기서부터 재탐색
    int isFind = 0;
     
    isFind = left_front_right_search(MILK);

    if(isFind == 0)
    {
	turn_Right();
	usleep(200000);
	turn_Right();
	usleep(200000);
	
	go_Plastic();
	usleep(2000000);
	moveStop();
	usleep(200000);
	
	isFind = left_front_right_search(MILK);
    }
    
    if(isFind == 0)
    {
	turn_Right();
	usleep(200000);
	
	go_Plastic();
	usleep(2000000);
	moveStop();
	usleep(200000);
	
	isFind = left_front_right_search(MILK);
    }
    
}


/******************************************
 * 아래로 플라스틱
 * ***************************************/

void transfer_To_MiddleLand(int repeat_Num, Target target)
{
  ColorBoundary color_B = classifyObject(target.flag);
  
  printf("\n--------------------see down------------------\n\n");
  
  int i;
  
  // 물체 차고 재접근의 루프
  for(i=0; i<repeat_Num; i++){
	set_Position(NOTHING, PLASTIC);
	
	// 이제 물체 차야함
	left_Kick();
	usleep(200000);
	
	// 물체앞까지 의무걸음
        moveStraight();
    
	usleep(5500000);	// 5걸음	
	
	moveStop();
	usleep(200000);
	
  }
  
}

void searchZone_n_Kick(VideoCopy *image, Target target)
{
    int kickCnt = 0;
    int i,j;
    
    
    int sideFlag_Cnt = 3;	// 사이드인지 아닌지 판별할 플래그의 카운트 기준수
    
    while(1)
    {
	int kickFlag = 0;
	
	Target zone = findZone(image, target);
      
	printf("zone flag : %d\n", zone.flag);
	printf("x : %d\n", zone.x_point);
	
	
	if(zone.flag == target.flag)
	{
	    // 가운데 있다고 판단 되면
	    if(zone.x_point < maxX && zone.x_point >minX)
	    {
		kickFlag = 1;
		printf("kickFlag = 1\n");
	    }
	    
	    else if(zone.x_point <=minX)
	    {
		for(i=0; i<1; i++){
		    rotateOnRight();
		    usleep(200000);
		    turnCnt--;
		}
		
	    }
	    else if(zone.x_point >=maxX)
	    {
		for(i=0;i<1; i++){
		    rotateOnLeft();
		    usleep(200000);
		    turnCnt++;
		}	
	    }
	}
	
	else if(zone.flag == 4)	// see left     
	{
	    for(i=0;i<1; i++){
		rotateOnLeft();
		usleep(200000);
		turnCnt++;
	    }	
	}
	else if(zone.flag == 5)	// see right
	{
	    for(i=0; i<1; i++){
		rotateOnRight();
		usleep(200000);
		turnCnt--;
	    }
	}
	
	else if(zone.flag == 6)
	{
	    printf("zone not found\n"); 
	}
	
	// 세부조정
	while(1){
		printf("see down\n");
		// 내려다 보기
		
		seeDown();
		
		usleep(200000);	// delay 1sec, camera buffer update
		 

		// 내려다 본 결과로 판단

		Target obj = findTarget(&bufCopy, target.flag);
		
		printf("x : %d, y : %d, flag : %d\n", obj.x_point, obj.y_point, obj.flag);
		
		printf("see up\n");
		// 몸을 다시 일으키고
		seeUp();
		usleep(200000);
			
			
		// 못 찾았을 경우에 대한 예외처리가 없음 현재는
		if(obj.flag == target.flag){
		  
		   if(obj.x_point < detail_minX)
		  {
		      rightOneStep();
		      usleep(200000);
		  }
		  else if(obj.x_point >detail_maxX)
		  {
		      leftOneStep();
		      usleep(200000);
		  }
		  
		  else if(obj.y_point > detail_Y)	
		  {
		      frontOneStep();
		      usleep(200000);
		  }
		  else
		  {
		      /*
		      if(kickFlag == 0){
			gathered_Touch(4);	// 아무의미없는 인자
			usleep(200000);
		      }
		      */
		      break;
		  }
		}
	}
	
	// 킥 플래그 서 있으면 찬다
	if(kickFlag == 1)
	{
	    gathered_Touch(PLASTIC);
	    usleep(200000);
	    left_Kick();
	    usleep(200000);
	    
	     
	    // 물체앞까지 의무걸음
	    moveStraight();
	
	    usleep(5500000);	
	    
	    moveStop();
	    usleep(200000);
	    
	    kickCnt++;
	    
	    if(plastic_Start_Pos == 2)
	    {
		if(kickCnt >= side_Cnt)
		  break;
	    }
	    else if(plastic_Start_Pos == 1)
	    {
		if(kickCnt >= straight_Cnt)
		  break;
	    }
	     
	}
	
	if(kickCnt == 1)
	{
	  if(abs(turnCnt) >= sideFlag_Cnt)
	  {
	    plastic_Start_Pos = 2;	// 먼 곳에서 시작
	  }
	  else
	  {
	    plastic_Start_Pos = 1;	// 가까운곳, 즉 가운데서 시작
	  }
	}
	
    }


}


// 플라스틱2
void set_Position(int gathered_Type, int obj_Flag)
{
	// 세부조정 루프
	while(1){
		printf("see down\n");
		// 내려다 보기
		seeDown();
		
		usleep(200000);	// delay 1sec, camera buffer update
		 

		// 내려다 본 결과로 판단

		Target obj = findTarget(&bufCopy, obj_Flag);
		
		printf("see up\n");
		// 몸을 다시 일으키고
		seeUp();
		usleep(500000);
			
		printf("x : %d, y : %d, flag : %d\n", obj.x_point, obj.y_point, obj.flag);
		
		
		// 못 찾았을 경우에 대한 예외처리가 없음 현재는
		if(obj.flag == obj_Flag){
		      if(obj.x_point < detail_minX)
		      {
			  rightOneStep();
			  usleep(200000);
		      }
		      else if(obj.x_point > detail_maxX)
		      {
			  leftOneStep();
			  usleep(200000);
		      }
		      else if(obj.y_point > detail_Y)	
		      {    
			  frontOneStep();
			  usleep(200000);
		      }
		      else
		      {
			  gathered_Touch(gathered_Type);
			  usleep(800000);
			  
			  break;
		      }
		}
	}
}

void set_Position2(int gathered_Type, int obj_Flag)
{
	while(1){
	// 세부조정 루프
		printf("see down\n");
		// 내려다 보기
		seeDown();
		
		usleep(200000);	// delay 1sec, camera buffer update
		 

		// 내려다 본 결과로 판단

		Target obj = findTarget(&bufCopy, obj_Flag);
		
		printf("x : %d, y : %d, flag : %d\n", obj.x_point, obj.y_point, obj.flag);
		
		int leftRight = 0, front = 0;
		int up = 0;
		// 못 찾았을 경우에 대한 예외처리가 없음 현재는
		if(obj.flag == obj_Flag){
		      if(obj.x_point < detail_minX_Outside)
		      {
			  printf("see up\n");
			  // 몸을 다시 일으키고
			  seeUp();
			  usleep(200000);
			  up++;
		  
			  rightOneStep();
			  rightOneStep();
			  usleep(200000);
			  leftRight += 2;
		      }
		      
		      else if(obj.x_point < detail_minX)
		      {
			  printf("see up\n");
			  // 몸을 다시 일으키고
			  seeUp();
			  usleep(200000);
			  up++;
			  
			  rightOneStep();
			  usleep(200000);
			  leftRight += 1;
		      }
		      else if(obj.x_point > detail_maxX_Outside)
		      {
			  printf("see up\n");
			  // 몸을 다시 일으키고
			  seeUp();
			  usleep(200000);
			  up++;
			  
			  leftOneStep();
			  leftOneStep();
			  usleep(200000);
			  leftRight += -2;
		      }
		      else if(obj.x_point > detail_maxX)
		      {
			  printf("see up\n");
			  // 몸을 다시 일으키고
			  seeUp();
			  usleep(200000);
			  up++;
			  
			  leftOneStep();
			  usleep(200000);
			  leftRight += -1;
		      }
		      
		      if(obj.y_point > detail_Y)	
		      {   
			  if(up == 0){
			      printf("see up\n");
			      // 몸을 다시 일으키고
			      seeUp();
			      usleep(200000);
			  }
			  
			  frontOneStep();
			  usleep(200000);
			  front++;
		      }
		      
		      
		      if(leftRight == 0 && front == 0){
			  gathered_Touch(gathered_Type);
			  usleep(400000);
			  break;
		      }
		}
		else
		{
		      seeUp();
		      usleep(200000);
		}
	}
}

void set_Position3(int gathered_Type, int obj_Flag)
{
	//while(1){
	// 세부조정 루프
		printf("see down\n");
		// 내려다 보기
		seeDown();
		
		usleep(200000);	// delay 1sec, camera buffer update
		 

		// 내려다 본 결과로 판단

		Target obj = findTarget(&bufCopy, obj_Flag);
		
		printf("x : %d, y : %d, flag : %d\n", obj.x_point, obj.y_point, obj.flag);
		
		int up = 0;
		int leftRight = 0, front = 0;
		// 못 찾았을 경우에 대한 예외처리가 없음 현재는
		if(obj.flag == obj_Flag){
		      if(obj.x_point < detail_minX_Outside)
		      {
			  printf("see up\n");
			  // 몸을 다시 일으키고
			  seeUp();
			  usleep(200000);
			  up++;
		  
	
			  rightOneStep();
			  usleep(200000);
			  leftRight += 2;
		      }
		      
		      else if(obj.x_point > detail_maxX_Outside)
		      {
			  printf("see up\n");
			  // 몸을 다시 일으키고
			  seeUp();
			  usleep(200000);
			  up++;
			  
			
			  leftOneStep();
			  usleep(200000);
			  leftRight += -2;
		      }
		      
		      if(obj.y_point > detail_Y)	
		      {   
			  if(up == 0){
			      printf("see up\n");
			      // 몸을 다시 일으키고
			      seeUp();
			      usleep(200000);
			  }
			  frontOneStep();
			  usleep(200000);
			  front++;
		      }
		      
		      
		      gathered_Touch(gathered_Type);
		      usleep(400000);
		      //break;
		      
		}
		else
		{
		      int isFind = 0;
			
		      // 왼
		      if(isFind == 0){
			  leftSee();
			  usleep(200000);
			  
			  obj = findTarget(&bufCopy, obj_Flag);
			  isFind = 1;
			  if(obj.flag == obj_Flag)
			  {
			      seeUp();
			      usleep(200000);
			      moveStop();
			      usleep(200000);
			      
			      
			      leftOneStep();
			      usleep(200000);
			      leftOneStep();
			      usleep(200000);
			      leftOneStep();
			      usleep(200000);
			      
			      set_Position3(NULL, obj_Flag);
			  }
		      }
		      
		      // 오른
		      if(isFind == 0){
			  rightSee();
			  usleep(200000);
			  
			  obj = findTarget(&bufCopy, obj_Flag);
			  isFind = 3;
			  if(obj.flag == obj_Flag)
			  {
			      seeUp();
			      usleep(200000);
			      moveStop();
			      usleep(200000);
			      
			      
			      rightOneStep();
			      usleep(200000);
			      rightOneStep();
			      usleep(200000);
			      rightOneStep();
			      usleep(200000);
			      
			      set_Position3(NULL, obj_Flag);
			  }
		      }
		      
		      // 뒤로
		      if(isFind == 0)
		      {
			  seeUp();
			  usleep(200000);
			  moveStop();
			  usleep(200000);
			  
			  go_Backward();
			  usleep(3000000);
			  moveStop();
			  usleep(200000);
			  
			  
			  set_Position3(NULL, obj_Flag);
		      }
		}
	//}
}

int lets_Go(int type, VideoCopy *image)
{
    int stop_Flag = 0;
    clock_t start, last;
    
    start = clock();
    
    // 차면서 앞으로 가기시작
    //go_Plastic();
    moveStraight();
    
    while(stop_Flag == 0)
    {
	// 동완이 함수호출
	int area = search_plastic(image);
    
	if(area < 20)	// 파란색이 안보인다면
	    stop_Flag = 2;	// 안보여서 정지, 예외처리
	
	else if(area > 500)
	{
	    stop_Flag = 3;	// 목적지 도착
	}
	
	if(type == 1)	// 처음부터 중간까지 의무걸음 이라면
	{
	    last = clock();
	    
	    double time = (double)(last - start)/CLOCKS_PER_SEC;
	    
	    if(time > 15)
		stop_Flag = 1;	// 의무걸음 종료

	}
    }
    
    moveStop();
    usleep(200000);
    
    return stop_Flag;
    
}

void rotate_To_Zone(VideoCopy *image, Target target)
{
    int i;
    
    while(1){
	
	
	Target zone = findZone(image, target);
      
	printf("zone flag : %d\n", zone.flag);
	printf("x : %d\n", zone.x_point);
	
	
	if(zone.flag == target.flag)
	{
	    //music_G();
	    // 가운데 있다고 판단 되면
	    if(zone.x_point < maxX && zone.x_point >minX)
	    {
		music_G();
		break;
	    }
	    
	    else if(zone.x_point <=minX)
	    {
		for(i=0; i<1; i++){
		    rotateOnRight();
		    //usleep(200000);
		    turnCnt--;
		}
		
	    }
	    else if(zone.x_point >=maxX)
	    {
		for(i=0;i<1; i++){
		    rotateOnLeft();
		    //usleep(200000);
		    turnCnt++;
		}	
	    }
	}
	
	else if(zone.flag == 4)	// see left     
	{
	    for(i=0;i<2; i++){
		rotateOnLeft();
		//usleep(200000);
		turnCnt++;
	    }	
	}
	else if(zone.flag == 5)	// see right
	{
	    for(i=0; i<2; i++){
		rotateOnRight();
		//usleep(200000);
		turnCnt--;
	    }
	}
	
	else if(zone.flag == 6)
	{
	    music_D();
	    printf("zone not found\n"); 
	}
    }
}

void shortQuickSteps(int type, double sec)
{
    if(type == PLASTIC)
    {
	// 목적지 도달 할때까지 탐색
	// 시야에 안들어올때까지 전진
	go_Plastic();
	
	while(1)
	{
	    // 반복탐색 시야에 안보일 때까지
	    int count = search_plastic(&bufCopy);
    
	    if(count < 20)
	      break;
	}
	
	moveStop();
	usleep(200000);
    }
    
    else
    {
	// 종종 의무걸음
	go_Plastic();
	
	usleep(sec * 1000000);	// sec
	
	moveStop();
	usleep(400000);
    }
  
}


// 플라스틱 집고 옮기기 함수들

Target zone_Search_Handler_Plastic(VideoCopy *image, Target obj)
{
    Target zone;
    
    redZoneCnt = blueZoneCnt = greenZoneCnt = 0;

    while(1){
	zone = findZone(image, obj);
      
	printf("obj flag : %d\n", zone.flag);
	
	if(zone.flag == MILK)
	    break;
	
	else if(zone.flag == 5)	// red
	{
	    turn_Right_Grabbing_Plastic();
	    usleep(200000);
	    turn_Right_Grabbing_Plastic();
	    usleep(200000);
	    
	    redZoneCnt++;
	}
	else if(zone.flag == 4)	// green
	{
	    turn_Left_Grabbing_Plastic();
	    usleep(200000);
	    
	    blueZoneCnt++;
	}
	
	else if(zone.flag > 3)
	{
	    printf("zone not found\n"); 
	    music_G();
	    usleep(200000);
	}
    
    }
   
    return zone;
}

void approach2Zone_Plastic(VideoCopy *image, Target obj)
{
    ColorBoundary color_B = classifyObject(obj.flag);
   
    int zoneCnt = 0;
    int isFind;
    int cnt = 0;
    int first_Flag = 1;
    while(1)
    {
	//search
      isFind = toleranceZoneSearch(image, &obj, color_B, &zoneCnt);
      printf("zone find : %d\n" , isFind);
      
      if(isFind <=0)
      {
//	cnt++;
//	moveStraightGrabbing();
//	if(cnt > 2)
	    break;
      }
	
      
      else
      {
	 int wPix = (MAX_X/2 - obj.x_point);
	  printf("wPix : %d\n", wPix);
	
	  int direction = wPix < 0 ? 0 : 1;	
	  wPix = abs(wPix);
	
	  if(wPix > 60){ 
	    if(direction == 0)
	      moveLeftGrabbing_Plastic();
	    else if(direction == 1)
	      moveRightGrabbing_Plastic();
	  }
	  else{	
	    moveStraightGrabbing_Plastic();
	  }
	  
	  first_Flag = 0 ;	// 디버깅용 코드
      }
    }
    
    if(first_Flag == 1){	// 디버깅용 코드
      moveStop();
      usleep(200000);
      music_D();
    }
    
    usleep(7000000);	// 경험적 의무걸음
    
    moveStop();
}

// go and pick
void getTarget_Plastic(Target target) {
  ColorBoundary color_B = classifyObject(target.flag);
  
  printf("\n--------------------see down------------------\n\n");
  
  
  while(1){
		printf("see down\n");
		// 내려다 보기
		seeDown();
		
		usleep(200000);	// delay 1sec, camera buffer update
		 

		// 내려다 본 결과로 판단
		int frontCnt=0;
		int LR_Cnt=0;
		
	
		Target obj = findTarget(&bufCopy, target.flag);
		
		printf("x : %d, y : %d, flag : %d\n", obj.x_point, obj.y_point, obj.flag);
		
		printf("see up\n");
		// 몸을 다시 일으키고
		seeUp();
		usleep(200000);
		if(obj.flag == PLASTIC){
		    if(obj.y_point > 5)	
			      frontCnt++;
			      
		    int x = obj.x_point - MAX_X/2;
		    
		    if (x > 60) 
		      LR_Cnt++;
		    else if(x < -60) 
		      LR_Cnt--;
		    
		    printf("%d %d\n", frontCnt, LR_Cnt);
		    
		    
		    if(frontCnt ==0 && LR_Cnt ==0)	// 보정할거 없으면 탈출
			    break;
		    
		    // 위치 보정
		    if(LR_Cnt > 0){
			    leftOneStep();
		    }
		    else if(LR_Cnt < 0){
			    rightOneStep();
		    }

		    if(frontCnt >0){
			    frontOneStep();
		    }
			    
		    usleep(200000);
		    // 다시 내려다보기, 루프 반복
		}
	}
	printf("\n-------------!grab-----------------\n\n");
	
//	frontOneStep();
//	usleep(200000);
	
	gathered_Touch(MILK);
	usleep(200000);
	
	grabPlastic();
	usleep(200000);
}

void plastic_Turning()
{
    int i;
    
    if(turnCnt <= -1)	// 내가 왼쪽에서 시작했다고 판단
    {	
	for(i=0; i <4; i++)
	{
	    turn_Right();
	    usleep(200000);
	}
      
//	turn_Right_60();
//	usleep(200000);
	    
	go_Plastic();
	usleep(2700000);	//
	
	moveStop();
	usleep(200000);
    }
    
    else if(turnCnt >= 1)	// 내가 오른쪽에서 시작했다고 판단
    {
	for(i=0; i < 4; i++)
	{
	    turn_Left();
	    usleep(200000);
	}
	
//	turn_Left_60();
//	usleep(200000);
	    
	go_Plastic();
	usleep(2700000);	//
	
	moveStop();
	usleep(200000);
    }

    else
    {	
	music_D();
	
	for(i=0; i < 2; i++)
	{
	    turn_Left_90();
	    usleep(500000);
	}
	
	go_Plastic();
	usleep(3200000);	//
	
	moveStop();
	usleep(200000);
    }
    
    Target second_Plastic;
    int isfind = 0;
    
    // 가운데라면
    if(turnCnt == 0)
    {
	isfind = left_front_right_search(PLASTIC);
	
	if(isfind == 1 || isfind == 5)
	{
	    go_Plastic();
	    usleep(1000000);
	    moveStop();
	    usleep(200000);
	}
	
    }
    
    else if(turnCnt <0)
    {
	isfind = left_front_right_search(PLASTIC);
	
	if(isfind ==0){
	    turn_Left_45();
	    usleep(200000);
	    
	    go_Plastic();
	    usleep(1000000);
	    moveStop();
	    usleep(200000);
	    
	    int isfind2 = left_front_right_search(PLASTIC);;
	    
	    if(isfind2 > 0)
	    {
		isfind = 4;
	    }
	}
    }
    
    else if(turnCnt >0)
    {
	isfind = left_front_right_search(PLASTIC);
	
	if(isfind ==0){
	    turn_Right_45();
	    usleep(200000);
	    
	    go_Plastic();
	    usleep(1000000);
	    moveStop();
	    usleep(200000);
	    
	    int isfind2 = left_front_right_search(PLASTIC);;
	    
	    if(isfind2 > 0)
	    {
		isfind = 4;
	    }
	}
    }
    
    
    if(isfind == 0)
    {
	left_Kick();
    }
}

int plastic_Turning2()
{
    int stop_Flag = 0;
    
    Target redZone;
    
    while(1){
	redZone = findTarget(&bufCopy, COKE);
	
	if(redZone.flag == 0)
	{
	    turn_Left_Grabbing();
	}
	
	else
	{
	    break;
	}
    }
  
    
    redZone = findTarget(&bufCopy, COKE);
    
    ColorBoundary color_B = classifyObject(COKE);
   
    int zoneCnt = 0;
    int isFind;
    int cnt = 0;
    int first_Flag = 1;
    while(1)
    {
	//search
      isFind = toleranceZoneSearch(&bufCopy, &redZone, color_B, &zoneCnt);
      printf("zone find : %d\n" , isFind);
      
      if(isFind <=0)
      {
//	cnt++;
//	moveStraightGrabbing();
//	if(cnt > 2)
	    break;
      }
	
      
      else
      {
	 int wPix = (MAX_X/2 - redZone.x_point);
	  printf("wPix : %d\n", wPix);
	
	  int direction = wPix < 0 ? 0 : 1;		
	  wPix = abs(wPix);
	
	  if(wPix > 60){ 
	    if(direction == 0)
	      go_Plastic_Left();
	    else if(direction == 1)
	      go_Plastic_Right();
	  }
	  else{	
	    go_Plastic();
	  }
	  
	  first_Flag = 0 ;	// 디버깅용 코드
      }
    }
    
    if(first_Flag == 1){	// 디버깅용 코드
      moveStop();
      usleep(200000);
      left_Kick();
    
    }
    
    moveStop();
}

// 플라스틱 가져다 놓고 그냥 무조건 180도 회전
plastic_Turning3()
{
    turn_Left_90();
    usleep(500000);
    turn_Left_90();
    
    go_Plastic();
    usleep(3000000);
    
    
  
}
void find_Second_Plastic()
{
    
    int isFind = 0;
    
    Target second = findTarget(&bufCopy, PLASTIC);
    
    approach2Milk(&bufCopy, second);
    
    second = findTarget(&bufCopy, PLASTIC);
    
    approach2Milk(&bufCopy, second);
    
    // 물체 중심회전
    set_Position3(NULL, PLASTIC);
 
    int i;
    
    if(turnCnt <= 0)	// 파란색, 오른쪽에서 시작
    {
	for(i=0; i<7; i++)
	  rotateOnRight();
    }
    
    else if(turnCnt > 0)	// 빨간색, 왼쪽에서 시작
    {
	for(i=0; i<7; i++)
	  rotateOnLeft();
    }
    
    set_Position3(NULL, PLASTIC);
}

int left_front_right_search(int flag)
{
    int isfind = 0;
    
    Target obj;
    
	if(isfind ==0){
	    obj = findTarget(&bufCopy, flag);
		
	    if(obj.flag == flag)
	    {
		isfind = 3;
		
	    }
	}
	
	if(isfind ==0){
	  
	    leftSee();
	    usleep(200000);
	    
	    obj = findTarget(&bufCopy, flag);
		
	    if(obj.flag == flag)
	    {
		isfind = 2;
		
		turn_Left_45();
		usleep(200000);
		
		//go_Plastic();
		//usleep(1000000);
		//moveStop();
		//usleep(200000);
	    }
	}
	
	if(isfind ==0){
	  
	    leftSee_80();
	    usleep(200000);
	    
	    obj = findTarget(&bufCopy, flag);
		
	    if(obj.flag == flag)
	    {
		isfind = 1;
		
		turn_Left_90();
		usleep(200000);
		
		//go_Plastic();
		//usleep(1000000);
		//moveStop();
		//usleep(200000);
	    }
	}
	
	if(isfind ==0){
	  
	    rightSee();
	    usleep(200000);
	    
	    obj = findTarget(&bufCopy, flag);
		
	    if(obj.flag == flag)
	    {
		isfind = 4;
		
		turn_Right_45();
		usleep(200000);
		
		//go_Plastic();
		//usleep(1000000);
		//moveStop();
		//usleep(200000);
	    }
	}
	if(isfind ==0){
	  
	    rightSee_80();
	    usleep(200000);
	    
	    obj = findTarget(&bufCopy, flag);
		
	    if(obj.flag == flag)
	    {
		isfind = 5;
		
		turn_Right_90();
		usleep(200000);
		
		//go_Plastic();
		//usleep(1000000);
		//moveStop();
		//usleep(200000);
	    }
	}
	
	moveStop();
	usleep(200000);
	
    return isfind;
}