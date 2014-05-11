#include "module/vision/vision.h"

const int tolerance = 70;

void copyImage()
{
    vidbuf = camera_get_frame(fdCamera);
		
    memcpy(vidbuf_overlay.ycbcr.y,vidbuf->ycbcr.y,len_vidbuf);
    memcpy(vidbuf_overlay.ycbcr.cb,vidbuf->ycbcr.cb,len_vidbuf/2);
    memcpy(vidbuf_overlay.ycbcr.cr,vidbuf->ycbcr.cr,len_vidbuf/2);
    
    memcpy(bufCopy.ycbcr.y,vidbuf->ycbcr.y,len_vidbuf);
    memcpy(bufCopy.ycbcr.cb,vidbuf->ycbcr.cb,len_vidbuf/2);
    memcpy(bufCopy.ycbcr.cr,vidbuf->ycbcr.cr,len_vidbuf/2);
    
    camera_release_frame(fdCamera,vidbuf);
}

Target findTarget(VideoCopy *image, int object_Flag) {
  int x1,x2,y;
  int countRed,countGreen, countBlue;
  int count = 0;
  Target obj;
  
  int end_flag1=0,end_flag2=0;
  int start_x1=0,start_x2=0;
  int end_x1=0,end_x2=0;
  int mid_x;
  int min_y = MAX_Y;
  int noiseCnt =0;
  
  obj.flag=0;
  obj.x_point=0;
  obj.y_point=0;
  
  ColorBoundary color_B = classifyObject(object_Flag);
  
  for(x1=MAX_X/2,x2=MAX_X/2-1;x1<318 && x2>3;x1++,x2--){
//    countRed=0; countGreen=0; countBlue=0;
      for(y=1;y<MAX_Y;y++){

	  HSV hsv = ycbcr2HSV(image, x1, y);

	  if(isColor(hsv, color_B)){	// 파랑이라면
	    noiseCnt++;
	    if(noiseCnt > NOISE_COUNT){
		
		min_y = min(min_y, y);
		if(end_flag1==0){
		    start_x1 = x1;
		    end_flag1=1;
		    break;
		  
		}
		else{
		    end_x1 = x1;
		    break;
		}
	    }
		
	  }
	  else
	    noiseCnt = 0;
      }

      for(y=1;y<MAX_Y;y++){
	  HSV hsv = ycbcr2HSV(image,x2,y);
	  if(isColor(hsv,color_B)){
	      noiseCnt++;
	      if(noiseCnt > NOISE_COUNT){
		  min_y = min(min_y, y);
		  if(end_flag2==0){
			  start_x2 = x2;
			  end_flag2=1;
			  break;
		  } 
		  else 
		  {
		     end_x2 = x2;
		     break;
		  }
		  
	      }
	
	  }
	  else
	    noiseCnt = 0;
      }
  }

  printf("x1 : %d ~ %d\n", start_x1, end_x1);
  printf("x2 : %d ~ %d\n", start_x2, end_x2);
  printf("count : %d\n", count);
  
  if(start_x1 != 0 && end_x1 == 0) start_x1 = 0; // noise 처리, 문법오류, 
  if(start_x2 != 0 && end_x2 == 0 ) start_x2 = 0;
  
  if(start_x1 != 0 && start_x2 == 0) // 화면 왼쪽에만 타겟이 있었을 때
  {
	  mid_x = (start_x1 + end_x1)/2;
	  
	  printf("full mid = %d\n", mid_x);
	  
	  obj.start_x = start_x1;
	  obj.end_x = end_x1;
	  obj.x_point = mid_x;
	  obj.flag = object_Flag;
	  obj.y_point = min_y;
	  
  }
  else if(start_x1 == 0 && start_x2 != 0) // 오른쪽에만
  {
	  mid_x = (start_x2 + end_x2)/2;
	  printf("right mid = %d\n", mid_x);
	  obj.start_x = end_x2;
	  obj.end_x = start_x2;
	  obj.x_point = mid_x;
	  obj.flag = object_Flag;
	  obj.y_point = min_y;
  
  }
  else if(start_x1 != 0 && start_x2 != 0) // 양쪽에 다 있을 경우
  {
	  mid_x = (end_x1 + end_x2)/2;
	  printf("left mid = %d\n", mid_x);
	  obj.start_x = end_x2;
	  obj.end_x = end_x1;
	  obj.x_point = mid_x;
	  obj.flag = object_Flag;
	  obj.y_point = min_y;
	 
  }
  return obj;
}


Target refind(VideoCopy *image, int t_Flag, int x_point) {
  int x,y;
  int count;
  Target obj;
  
  ColorBoundary color_B = classifyObject(t_Flag);
  
  obj.flag = 0;
  obj.x_point = 0;
  obj.y_point = 0;
  
  
  for(x=x_point;x<MAX_X;x++){
    count = 0;
    for(y=1;y<MAX_Y;y++){

	  HSV hsv = ycbcr2HSV(image, x, y);

	  if(isColor(hsv, color_B)){	// 빨강이라면
		count++;
	    
		if(count>NOISE_COUNT){ 
			obj.flag = t_Flag;
			distinguish(&obj, image,x,y,red_B);
			return obj;
		}
	  }
 
	  else
		count= 0;
	    
    }
  }

  printf("not found\n");
  return obj;
}

void distinguish(Target *obj, VideoCopy* image,int tX,int tY,ColorBoundary color_B)
{
  int minY = tY;
  int minX = tX;
  int x,y;
  int count = 0;
  int num = minX;
  
  for(x=minX;x<MAX_X;x++){
	for(y=0;y<MAX_Y;y++){
		HSV hsv = ycbcr2HSV(image, x, y);
		
		if(isColor(hsv, color_B)){
			count++;
			
			if(count>NOISE_COUNT){
				
				num=x;
				minY = min(minY, y - NOISE_COUNT);
				
				break;
			}
		}
		
		else
			count = 0;
	}
  }
  obj->start_x = minX;
  obj->end_x = num;
  obj->x_point = (num+minX)/2;
  obj->y_point = minY;
  printf("obj.x : %d, obj.y : %d, flag : %d\nstart_x : %d, end_x : %d\n",obj->x_point,obj->y_point, obj->flag, obj->start_x, obj->end_x);
}

int toleranceSearch(VideoCopy *image, Target *obj, ColorBoundary color_B)
{
	int x, y;
	int start,end;
	int count = 0;
	int past_y = obj->y_point;
	int flag = 0;
	
//	printf("start : %d, end : %d\n", obj->start_x, obj->end_x);   
	
	start = obj->start_x-tolerance < 1 ? 1 : obj->start_x-tolerance;
	end = obj->end_x+tolerance > MAX_X ? MAX_X : obj->end_x+tolerance;

	printf("start : %d, end : %d\n", start, end);    
	
	int y_Up = obj->y_point + 60; 
	if(y_Up > MAX_Y)
	    y_Up = MAX_Y;
	
	for(x=start;x<end;x++){

		for(y=1;y<y_Up;y++){
			HSV hsv = ycbcr2HSV(image, x, y);

			if(isColor(hsv,color_B)){
				count++;

				if(count>NOISE_COUNT){
					if(flag==0){
						obj->start_x = x;
						flag=1;
					} 
					else 
					    obj->end_x = x;
					
					obj->y_point = min(y,obj->y_point);
					 
					
					break;
				} 
			} else count = 0;
		}
		 y_Up = obj->y_point + 60; 
		if(y_Up > MAX_Y)
		    y_Up = MAX_Y;

	}
	
	obj->x_point = (obj->start_x + obj->end_x) /2;
/*	
	if(obj->flag == MILK)	// case milk, 위치 보정
	{ 
	    HSV hsv = ycbcr2HSV(image, obj->x_point, obj->y_point+20);
	    if(!isColor(hsv, green_B))
	      flag = 0;
	} 
*/	
	if(flag==0){
	  printf("flag == 0, in toleranceSearch \n");
	    
	  if(past_y < 50)
	    return 0;
	  
	//  obj->flag = 0;
	  return -1; 
	}
	
	return 1;
}

int toleranceZoneSearch(VideoCopy *image, Target *obj, ColorBoundary color_B, int * zoneCnt)
{
	int x, y;
	int start,end;
	int count = 0;
	int past_y = obj->y_point;
	int flag = 0;
	
//	printf("start : %d, end : %d\n", obj->start_x, obj->end_x);   
	
	start = obj->start_x-tolerance < 1 ? 1 : obj->start_x-tolerance;
	end = obj->end_x+tolerance > MAX_X ? MAX_X : obj->end_x+tolerance;

	printf("start : %d, end : %d\n", start, end);    
//	printf("obj y point : %d\n", obj->y_point);
	for(x=start;x<end;x++){

		for(y=35;y<MAX_Y;y++){
			HSV hsv = ycbcr2HSV(image, x, y);

			if(isColor(hsv,color_B)){
				count++;

				if(count>NOISE_COUNT){
					if(flag==0){
						obj->start_x = x;
						flag=1;
					} else obj->end_x = x;
					obj->y_point = min(y,obj->y_point);
					
					break;
				} 
			} else count = 0;
		}
	}
	
	obj->x_point = (obj->start_x + obj->end_x) /2;
/*
	// stop Flag
	if(flag ==1)
	{
	    x = obj->x_point;
	    
	    for(y = MAX_Y -1; y>1 ;y--)
	    {
		HSV hsv = ycbcr2HSV(image, x, y);
		
		if(isColor(hsv, color_B))
		{
		    if(y < 100)	// 경험적으로 이정도 수치면 도착지점 바롤 앞에서 멈춤
		    {
		      *zoneCnt++;
		      
		      if(*zoneCnt > 5)
			flag = 0;
		      
		      printf("y < 95, y = %d\n", y);
		    }
		    break;
		}
	    }
	 
	}
*/	printf("y min : %d\n", obj->y_point);
	if(obj->y_point < 40){
	  *zoneCnt++;
	  if(*zoneCnt > 3)
	    flag = 0;
	}
	
	if(flag==0){
	  printf("flag == 0, in toleranceSearch \n");
	    
	  if(past_y < 50)
	    return 0;
	  
	//  obj->flag = 0;
	  return -1; 
	}
	
	return 1;
}

/*
Target findZone(VideoCopy *image,Target obj)
{
	int x, y;
	int count;
	
	ColorBoundary color_B = classifyObject(obj.flag);
	Target zone = {0, 0, 0, 0, 0};

	
	for(x=1;x<MAX_X;x++){
	  count=0;
	  for(y=MAX_Y/3;y<MAX_Y;y++){

		HSV hsv = ycbcr2HSV(image, x, y);

     		if(isColor(hsv, color_B)){
	   			 count++;
	  		  
			if(count>NOISE_COUNT){ 
				zone.flag = obj.flag;
				distinguish(&zone, image,x,y,color_B);
//				printf("x : %d, y : %d, flag : %d\n", zone.x_point, zone.y_point, zone.flag);
				return zone;
			}
		}
		else
		  count=0;
	  }
	}
	//TODO fail case
	printf("zone not fount\n");
	return zone;
}

//TODO 리턴된 오브잭트로 toleranceSearch(image,Object,color_B)
//를 메인에서 지속호출하며 놓을 장소로 이
*/

Target findZone(VideoCopy *image, Target obj)
{
	int x, y;
	int target_count=0,count1=0,count2=0;
	
	ColorBoundary target_B = classifyObject(obj.flag);
	ColorBoundary color_B1,color_B2;

	if(obj.flag == COKE){	// target_B == red_B
		color_B1 = blue_B;
		color_B2 = green_B;
	} else if(obj.flag == PLASTIC ){	// target_B == blue_B
		color_B1 = red_B;
		color_B2 = green_B;
	} else{ // target_B == green_B, MILK
		color_B1 = red_B;
		color_B2 = blue_B;
	}

	Target zone = {0, 0, 0, 0, 0};

	int x1=MAX_X/2,x2=MAX_X/2-1; // <-x1 , ->x2
	int end_flag1=0,end_flag2=0;
	int start_x1=0,start_x2=0;
	int end_x1=0,end_x2=0;
	int mid_x;
	int noiseCnt = 0;

	// noise 처리 안함 해야할까?
	for(x1=MAX_X/2,x2=MAX_X/2-1;x1<318 && x2>3;x1++,x2--){	// 문법 오류? 컴파일 되도록
		for(y=35;y<MAX_Y;y++){	
			HSV hsv = ycbcr2HSV(image,x1,y);
			
			if(isColor(hsv,target_B)){
			  noiseCnt++;
			  if(noiseCnt > NOISE_COUNT){
				target_count++;
				if(end_flag1==0){
					start_x1 = x1;
					end_flag1=1;
				} else end_x1 = x1;
			  }
			}
			else{
			  noiseCnt=0;
			
			  if(isColor(hsv,color_B1))
				  count1++;
			  else if(isColor(hsv,color_B2))
				  count2++;
			}
		}
		for(y=35;y<MAX_Y;y++){
			HSV hsv = ycbcr2HSV(image,x2,y);
			if(isColor(hsv,target_B)){
			  noiseCnt++;
			  if(noiseCnt > NOISE_COUNT){
				target_count++;
				if(end_flag2==0){
					start_x2 = x2;
					end_flag2=1;
				} else end_x2 = x2;
			  }
			}
			else{
			  noiseCnt = 0;
			  
			  if(isColor(hsv,color_B1))
				  count1++;
			  else if(isColor(hsv,color_B2))
				  count2++;
			}
		}
	}

	if(start_x1 != 0 && end_x1 == 0) start_x1 = 0; // noise 처리, 문법오류, 
	if(start_x2 != 0 && end_x2 == 0 ) start_x2 = 0;

	if(start_x1 != 0 && start_x2 == 0) // 화면 왼쪽에만 타겟이 있었을 때
	{
		mid_x = (start_x1 + end_x1)/2;
		
		zone.start_x = start_x1;
		zone.end_x = end_x1;
		zone.x_point = mid_x;
		zone.flag = obj.flag;
		zone.y_point = 319;
		
		return zone;
	}
	else if(start_x1 == 0 && start_x2 != 0) // 오른쪽에만
	{
		mid_x = (start_x2 + end_x2)/2;
		
		zone.start_x = end_x2;
		zone.end_x = start_x2;
		zone.x_point = mid_x;
		zone.flag = obj.flag;
		zone.y_point = 319;
	
		return zone;
	}
	else if(start_x1 != 0 && start_x2 != 0) // 양쪽에 다 있을 경우
	{
		mid_x = (end_x1 + end_x2)/2;
		
		zone.start_x = end_x2;
		zone.end_x = end_x1;
		zone.x_point = mid_x;
		zone.flag = obj.flag;
		zone.y_point = 319;
		
		return zone;
	}
	else if(count1 > 5 || count2 > 5){ // target color not found , found another color
		int temp_flag = count1 > count2 ? 1 : 2;
		if(obj.flag == COKE){ // target = red_B
			// found blue or green
// **************turn left
		
		zone.flag = 6;  
		return zone;  
		  
		} else if(obj.flag == PLASTIC){ // target = blue_B
			// found red or green
			// turn right or left
			if(temp_flag == 1) // red
			{
			    zone.flag = 5;
			    return zone;
			}
// **************turn right
			else // green
// **************turn left
			{
			    zone.flag = 4;
			    return zone;
			}
		} else { // target = green_B
			// found red or blue
// **************turn right
		  if(temp_flag == 1) // red
		    zone.flag = 7;
		  else
		    zone.flag = 8;
		  
		  return zone;
		}
	}
	else{ // 아무 색도 못찾았을 경우 -> 인구
	    zone.flag = 6;
	    return zone;
	}

	// 위의 2중루프에서 알 수 있는 것 = 각 색깔 별 몇 픽셀 있는지

	// if target의 색이 노이즈포함(10정도 이하라면)
	// target이 아닌 색 2색 count의 크기 비교
	// 큰것을 기준으로 회전
	
	// else if target의 색이 노이즈포함 (10정도 이상이라면)
	// 화면 안에 target zone이 있다고 판단
	// 그 존을 화면의 가운데x값(Zone의 중점이 160(MAX_X/2) +-10)에 오도록 회전
	
}

int search_plastic(VideoCopy *image){
    int x,y;
    int count=0;
    /*
    for(x=10; x<MAX_X-10; x++){
      for(y=10; y<MAX_X*1/3; y++){
      HSV hsv = ycbcr2HSV(image,x,y);

      if(isColor(hsv,blue_B))
	count++;
      }
    }
    */
    
    for(x=10; x<MAX_X-10; x++){
      for(y=200; y<209; y++){
      HSV hsv = ycbcr2HSV(image,x,y);

      if(isColor(hsv,blue_B))
	count++;
      }
    }
    
    
    return count;
}

int search_Coke_Zone(VideoCopy *image)
{
    int x,y;
    int count=0;
    
    for(x=10; x<MAX_X-10; x++){
      for(y=20; y<40; y++){
      HSV hsv = ycbcr2HSV(image,x,y);

      if(isColor(hsv,red_B))
	count++;
      }
    }
    
    return count;
}

int search_Second_Plastic(VideoCopy *image)
{
    int x,y;
    int count=0;
    
    for(x=MAX_X - 20; x<MAX_X-10; x++){
      for(y=10; y<230; y++){
      HSV hsv = ycbcr2HSV(image,x,y);

      if(isColor(hsv,blue_B))
	count++;
      }
    }
    
    return count;
}

int search_Second_Milk(VideoCopy *image)
{
    int x,y;
    int count=0;
    
    for(x=10; x<20; x++){
      for(y=10; y<230; y++){
      HSV hsv = ycbcr2HSV(image,x,y);

      if(isColor(hsv,green_B))
	count++;
      }
    }
    
    return count;
}

ColorBoundary classifyObject(int flag){
  switch(flag)
  {
    case 1:
      return red_B;
      break;
    case 2:
      return blue_B;
      break;
    case 3:
      return green_B;
      break;
    default:
      return error_B;
      break;
  }
}

