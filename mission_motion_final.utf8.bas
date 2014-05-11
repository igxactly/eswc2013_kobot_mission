'*******************************************
'******** 메탈파이터 프로그램 **************
'******** MF2-AI2-19관절********************
'*******************************************

DIM I AS BYTE
DIM J AS BYTE
DIM CNT AS BYTE	'몇걸음 앞으로?
DIM RCNT AS BYTE	'몇걸음 오른쪽으로?
DIM LCNT AS BYTE	'몇걸음 왼쪽으로?
DIM TCNT AS BYTE
DIM TMP AS BYTE ' 임시변수
DIM 자세 AS BYTE
DIM Action_mode AS BYTE
DIM A AS BYTE
iDIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER
DIM DELAY_TIME AS BYTE
DIM DELAY_TIME2 AS BYTE
DIM TEMP AS BYTE
DIM 물건집은상태 AS BYTE
DIM 기울기확인횟수 AS BYTE

DIM 넘어진확인 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE

DIM S6 AS BYTE
DIM S7 AS BYTE
DIM S8 AS BYTE

DIM S12 AS BYTE
DIM S13 AS BYTE
DIM S14 AS BYTE

DIM S4 AS BYTE
DIM S22 AS BYTE

DIM 리모콘동작모드 AS BYTE


'**** 기울기센서포트 설정

CONST 앞뒤기울기AD포트 = 2
CONST 좌우기울기AD포트 = 3
CONST 기울기확인시간 = 10  'ms


CONST min = 95			'뒤로넘어졌을때
CONST max = 160			'앞으로넘어졌을때
CONST COUNT_MAX = 30
CONST 하한전압 = 106	'154 '약6V전압

PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

'***** 19 MOTOR *********
DIR G6A,1,0,0,1,1,1			'모터0~5번
DIR G6D,0,1,1,0,0,0			'모터18~23번
DIR G6B,1,0,0,1,1,1			'모터6~11번
DIR G6C,0,1,1,0,0,0			'모터12~17번

'***** 초기선언 *********************************
모터ONOFF = 0
보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
물건집은상태 = 0

리모콘동작모드 = 0 ' 임베디드전용=33 리모콘전용 = 0,



'****초기위치 피드백*****************************
GOSUB MOTOR_ON
GOSUB 자이로INIT
GOSUB 자이로MID
'DELAY 2000

'GOSUB MOTOR_ON

SPEED 5
GOSUB 전원초기자세
GOSUB 기본자세

GOSUB 자이로ON

'GOSUB All_motor_mode2

GOTO MAIN
'************************************************

시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
엔터테이먼트음:
    TEMPO 220
    MUSIC "O28B>4D8C4E<8B>4D<8B>4G<8E>4C"
    RETURN
    '************************************************
게임음:
    TEMPO 210
    MUSIC "O23C5G3#F5G3A5G"
    RETURN
    '************************************************
파이트음:
    TEMPO 210
    MUSIC "O15A>C<A>3D"
    RETURN
    '************************************************
경고음:
    TEMPO 180
    MUSIC "O13A"
    DELAY 300

    RETURN
    '************************************************
싸이렌음:
    TEMPO 180
    MUSIC "O22FC"
    DELAY 10
    RETURN
    '************************************************
모드1:
    TEMPO 200
    MUSIC "O18A>#CE#G#F#D#FB"
    RETURN
축구게임음:
    TEMPO 180
    MUSIC "O28A#GABA"
    RETURN


태권도음:
    TEMPO 190
    MUSIC "O28#C#D#F#G#A#G#F"
    RETURN

모드4:
    TEMPO 220
    MUSIC "O33C6D3C<6$B3A"
    RETURN


장애물게임음:
    TEMPO 200
    MUSIC "O37C<C#BCA"
    RETURN

    '************************************************
MOTOR_FAST_ON:

    MOTOR G6B
    MOTOR G6C
    MOTOR G6A
    MOTOR G6D

    모터ONOFF = 0

    RETURN

    '************************************************
    '************************************************
MOTOR_ON:

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,0,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2,1
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3,1
    MOTORMODE G6D,3,2,2,1,3,1
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,2,2,2,1,1,2
    MOTORMODE G6D,2,2,2,1,1,2
    RETURN
    '************************************************
    '************************************************
HEAD_motor_mode3:
    MOTORMODE G6B,,,, ,,3
    RETURN

HEAD_motor_mode1:
    MOTORMODE G6B,,,, ,,1
    RETURN
    '************************************************
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1, , ,1
    MOTORMODE G6C,1,1,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2, , ,2
    MOTORMODE G6C,2,2,2
    RETURN
    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3
    RETURN
    '************************************************
전원초기자세:
    MOVE G6A,95,  76, 145,  93, 105, 100
    MOVE G6D,95,  76, 145,  93, 105, 100
    MOVE G6B,45,  60,  110, 100, 100, 100
    MOVE G6C,45,  60,  110, 100, 100, 100
    WAIT
    자세 = 0
    RETURN
    '************************************************
안정화자세:
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,45,  52,  110, 100, 100, 100
    MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT
    자세 = 0

    RETURN
    '******************************************	
초기100자세:
    MOVE G6A,100,  100, 100,  100, 100, 100
    MOVE G6D,100,  100, 100,  100, 100, 100
    MOVE G6B,100,  100,  100, 100, 100, 100
    MOVE G6C,100,  100,  100, 100, 100, 100
    WAIT
    자세 = 0
    RETURN
    '************************************************
기본자세:

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,45,  52,  110, 100, 100, 100
    MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT
    자세 = 0
    물건집은상태 = 0
    RETURN
    '******************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,45, 52, 110, 100, 100, 100
    MOVE G6C,45, 52, 110, 100, 100, 100
    WAIT
    자세 = 2
    RETURN
    '******************************************
앉은자세:

    MOVE G6A,100, 143,  28, 145, 100, 100
    MOVE G6D,100, 143,  28, 145, 100, 100
    MOVE G6B,45,  55,  110
    MOVE G6C,45,  55,  110
    WAIT
    자세 = 1

    RETURN
    '******************************************
집고안정화자세:
    SPEED 5
    MOVE G6A,98,  76, 145,  85, 101, 100
    MOVE G6D,98,  76, 145,  85, 101, 100
    WAIT
    자세 = 0

    RETURN
    '************************************************
내려다보기:
    GOSUB 자이로OFF

    SPEED 3
    MOVE G6A,98,  30, 185,  133, 101, 100
    MOVE G6D,98,  30, 185,  133, 101, 100
    MOVE G6B,45,  52,  110, 100, 100, 100
    MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT
    자세 = 3

    RETURN
    '**********************************************
정면보기:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,45,  52,  110, 100, 100, 100
    MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT
    자세 = 0
    물건집은상태 = 0

    GOSUB 자이로ON

    RETURN	
    '**********************************************
집고내려다보기:
    SPEED 3
    MOVE G6A,98,  30, 185,  133, 101, 100
    MOVE G6D,98,  30, 185,  133, 101, 100

    WAIT
    자세 = 0

    RETURN
    '**********************************************
파노라마자세:

    MOVE G6A,100,  76, 140,  88, 100, 100
    MOVE G6D,100,  76, 140,  88, 100, 100
    MOVE G6B,45,  52,  110, 100, 100, 100
    MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT
    RETURN

    '***********************************************
    '**** 자이로감도 설정 ****
    '***********************************************

자이로INIT:
    GYRODIR G6A, 0, 0, 0, 0,1
    GYRODIR G6D, 1, 0, 0, 0,0

    RETURN
    '***********************************************
자이로MAX:

    GYROSENSE G6A,255 , 255,255,255
    GYROSENSE G6D,255 , 255,255,255

    RETURN
    '***********************************************
자이로MID:

    GYROSENSE G6A, 255, 100,100,100
    GYROSENSE G6D, 255, 100,100,100

    RETURN
    '***********************************************
자이로MID3:

    GYROSENSE G6A, 255, 200,200,200
    GYROSENSE G6D, 255, 200,200,200

    RETURN
    '***********************************************
자이로MID2:

    GYROSENSE G6A, 255, 150,150,150
    GYROSENSE G6D, 255, 150,150,150

    RETURN
    '***********************************************
    '***********************************************
자이로MIN:

    GYROSENSE G6A, 50, 50,50,50
    GYROSENSE G6D, 50, 50,50,50

    RETURN
    '***********************************************
자이로ST:


    GYROSENSE G6A,200,70,70,70,
    GYROSENSE G6D,200,70,70,70,


    RETURN

    '***********************************************
자이로ON:


    GYROSET G6A, 2, 1, 1, 1,
    GYROSET G6D, 2, 1, 1, 1,

    자이로ONOFF = 1
    RETURN
    '***********************************************
자이로OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0

    자이로ONOFF = 0
    RETURN

    '************************************************
RX_EXIT:
    IF 리모콘동작모드 = 0 THEN
        ERX 4800, A, RX_EXIT_2

        GOTO RX_EXIT
    ENDIF

RX_EXIT_2:

    ETX 4800, 1
    GOTO MAIN
    '**********************************************
GOSUB_RX_EXIT:
    IF 리모콘동작모드 = 0 THEN
        ERX 4800, A, GOSUB_RX_EXIT2

        GOTO GOSUB_RX_EXIT
    ENDIF
GOSUB_RX_EXIT2:
    RETURN
    '**********************************************
GOSUB_RX_EXIT_REMOCON:

    ERX 4800, A, GOSUB_RX_EXIT_REMOCON2

    GOTO GOSUB_RX_EXIT_REMOCON

GOSUB_RX_EXIT_REMOCON2:
    RETURN
    '**********************************************

전진보행50:

    ERX 4800,CNT,전진보행50

    J = 0
    넘어진확인 = 0
    보행속도 = 11'5
    좌우속도 = 4'8'3

    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,3,3,3,3,2,3
    MOTORMODE G6D,3,3,3,3,2,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 3
        '오른쪽기울기
        MOVE G6A, 90,  71, 152,  91, 105
        MOVE G6D,106,  76, 146,  93,  96
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 10'보행속도
        '왼발들기
        MOVE G6A, 80, 95, 115, 105, 114
        MOVE G6D,114,  76, 146,  93,  96
        MOVE G6B,35
        MOVE G6C,55
        WAIT


        GOTO 전진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 3
        '왼쪽기울기
        MOVE G6D,  90,  71, 152,  91, 105
        MOVE G6A, 106,  76, 146,  93,  96
        MOVE G6C, 45,55
        MOVE G6B, 45,55
        WAIT

        SPEED 10'보행속도
        '오른발들기
        MOVE G6D, 80, 95, 115, 105, 114
        MOVE G6A,114,  76, 146,  93,  96
        MOVE G6C,35
        MOVE G6B,55
        WAIT


        GOTO 전진보행50_3	

    ENDIF


    '*******************************


전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 163, 110, 112
    MOVE G6D,110,  78, 146,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '왼발중심이동
    MOVE G6A,110,  76, 146, 98,  94
    MOVE G6D,90, 93, 155,  69, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '   ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,TMP, 전진보행50_2
    IF TMP <> 26 THEN
        GOTO 전진보행50_2
    ENDIF

    MUSIC "D" '디버깅 코드

전진보행50_1_정지:
    GOSUB Leg_motor_mode3
    '오른발들기10
    SPEED 10
    MOVE G6A,113,  76, 147,  93, 96,100
    MOVE G6D,85, 100, 100, 115, 114,100
    MOVE G6B,55
    MOVE G6C,35
    WAIT

    '왼쪽기울기2
    SPEED 6
    MOVE G6A, 104,  76, 146,  93,  98,100		
    MOVE G6D,  85,  71, 152,  91, 105,100
    MOVE G6B,45,55
    MOVE G6C,45,55
    WAIT	

    SPEED 3
    MOVE G6A,95,  76, 145,  93, 100, 100
    MOVE G6D,95,  76, 145,  93, 100, 100
    WAIT

    SPEED 2
    GOSUB 기본자세
    ETX 4800, 1	' 완료 사인
    'GOSUB Leg_motor_mode1
    GOTO RX_EXIT

전진보행50_2:
    IF J < CNT THEN
    ELSE
        GOTO 전진보행50_1_정지
    ENDIF

    '오른발들기10
    MOVE G6A,112,  77, 146,  93, 94,100
    MOVE G6D,90, 100, 105, 110, 114,100
    MOVE G6B,55
    MOVE G6C,35
    WAIT


    '**********


전진보행50_3:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,85,  44, 163, 110, 112
    MOVE G6A,110,  78, 146,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '오른발중심이동
    MOVE G6D,110,  76, 146, 98,  94
    MOVE G6A, 90, 93, 155,  69, 112
    WAIT

    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,TMP, 전진보행50_4
    IF TMP <> 26 THEN
        GOTO 전진보행50_4
    ENDIF

    MUSIC "D" '디버깅 코드

전진보행50_3_정지:
    GOSUB Leg_motor_mode3
    '왼발들기
    SPEED 10
    MOVE G6D,113,  76, 147,  93,  96,100
    MOVE G6A, 85, 100, 100, 115, 114,100
    MOVE G6B,35
    MOVE G6C,55
    WAIT

    '오른쪽기울기2
    SPEED 6
    MOVE G6D, 104,  76, 146,  93,  98,100		
    MOVE G6A,  85,  71, 152,  91, 105,100
    MOVE G6B,45,55
    MOVE G6C,45,55
    WAIT

    SPEED 3
    MOVE G6A,95,  76, 145,  93, 100, 100
    MOVE G6D,95,  76, 145,  93, 100, 100
    WAIT

    SPEED 2
    GOSUB 기본자세
    ETX 4800, 1	' 완료 사인
    'GOSUB Leg_motor_mode1
    GOTO RX_EXIT


전진보행50_4:
    IF J < CNT THEN	
    ELSE
        GOTO 전진보행50_3_정지
    ENDIF

    '왼발들기10
    MOVE G6A, 90, 100, 105, 110, 114,100
    MOVE G6D,112,  77, 146,  93,  94,100
    MOVE G6B, 35
    MOVE G6C,55
    WAIT


    GOTO 전진보행50_1
    '************************************************



한발자국전진:
    J = 0
    넘어진확인 = 0
    보행속도 = 11'5
    좌우속도 = 4'8'3

    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,3,3,3,3,2,3
    MOTORMODE G6D,3,3,3,3,2,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    보행순서 = 1

    SPEED 3
    '오른쪽기울기
    MOVE G6A, 90,  71, 152,  91, 105
    MOVE G6D,106,  76, 146,  93,  96
    MOVE G6B,45,55
    MOVE G6C,45,55
    WAIT

    SPEED 10'보행속도
    '왼발들기
    MOVE G6A, 80, 95, 115, 105, 114
    MOVE G6D,114,  76, 146,  93,  96
    MOVE G6B,35
    MOVE G6C,55
    WAIT

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 163, 110, 112
    MOVE G6D,110,  78, 146,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '왼발중심이동
    MOVE G6A,110,  76, 146, 98,  94
    MOVE G6D,90, 93, 155,  69, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    GOSUB Leg_motor_mode3
    '오른발들기10
    SPEED 10
    MOVE G6A,113,  76, 147,  93, 96,100
    MOVE G6D,85, 100, 100, 115, 114,100
    MOVE G6B,55
    MOVE G6C,35
    WAIT

    '왼쪽기울기2
    SPEED 6
    MOVE G6A, 104,  76, 146,  93,  98,100		
    MOVE G6D,  85,  71, 152,  91, 105,100
    MOVE G6B,45,55
    MOVE G6C,45,55
    WAIT	

    SPEED 3
    MOVE G6A,95,  76, 145,  93, 100, 100
    MOVE G6D,95,  76, 145,  93, 100, 100
    WAIT

    SPEED 2
    GOSUB 기본자세
    RETURN


    '************************************************

오른쪽전진보행50:
    넘어진확인 = 0
    J = 0
    보행속도 = 12
    좌우속도 = 4

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        '오른쪽기울기
        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 12'보행속도
        '왼발들기
        MOVE G6A, 80, 100, 100, 115, 112,95
        MOVE G6D,111,  76, 146,  93,  96,100
        MOVE G6B,35
        MOVE G6C,55
        WAIT


        GOTO 오른쪽전진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 4
        '왼쪽기울기
        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 145,  93,  96
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 12
        '오른발들기
        MOVE G6D, 80, 100, 100, 115, 112,110
        MOVE G6A,113,  76, 146,  93,  96,105
        MOVE G6C,35
        MOVE G6B,55
        WAIT


        GOTO 오른쪽전진보행50_3	

    ENDIF


    '*******************************


오른쪽전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 86,  58, 145, 120, 112
    MOVE G6D,110,  77, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,110,  77, 146, 93,  96
    MOVE G6D,80, 100, 145,  69, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    ETX 4800,J
    GOSUB 앞뒤기울기측정

    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 오른쪽전진보행50_2
    IF A = 11 THEN	'▲
        GOTO 전진보행50_2
    ELSEIF A = 13 THEN	'▶
        GOTO 오른쪽전진보행50_2
    ELSEIF A = 14 THEN	'◀
        GOTO 왼쪽전진보행50_2
    ELSE
        GOSUB Leg_motor_mode3
        '오른발들기10
        SPEED 10
        MOVE G6A,112,  76, 147,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 112,100
        MOVE G6B,55
        MOVE G6C,35
        WAIT


        '왼쪽기울기2
        SPEED 6
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT	

        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

오른쪽전진보행50_2:
    SPEED 10
    '오른발들기10
    MOVE G6A,112,  77, 146,  93, 94,105
    MOVE G6D,80, 95, 115, 105, 112,110
    MOVE G6B,55
    MOVE G6C,35
    WAIT

    '**********


오른쪽전진보행50_3:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D, 86,  50, 155, 110, 112
    MOVE G6A,110,  77, 146,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '오른발중심이동
    MOVE G6D,112,  77, 148, 93,  96
    MOVE G6A,80, 90, 155,  69, 112
    WAIT

    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 오른쪽전진보행50_4
    IF A = 11 THEN	'▲
        GOTO 전진보행50_4
    ELSEIF A = 13 THEN	'▶
        GOTO 오른쪽전진보행50_4
    ELSEIF A = 14 THEN	'◀
        GOTO 왼쪽전진보행50_4
    ELSE
        GOSUB Leg_motor_mode3
        '왼발들기
        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 112,100
        MOVE G6D,112,  76, 147,  93,  96,100
        MOVE G6B,35
        MOVE G6C,45
        WAIT

        SPEED 6
        '오른쪽기울기2
        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT	
        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

오른쪽전진보행50_4:
    SPEED 10
    '왼발들기10
    MOVE G6A, 80, 95, 115, 105, 112,95
    MOVE G6D,112,  77, 146,  93,  94,100
    MOVE G6B,35
    MOVE G6C,55
    WAIT

    GOTO 오른쪽전진보행50_1
    '*******************************
    '**********************************************

왼쪽전진보행50:
    넘어진확인 = 0
    J = 0
    보행속도 = 12
    좌우속도 = 4


    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        '오른쪽기울기
        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 12
        '왼발들기
        MOVE G6A, 80, 100, 100, 115, 114,110
        MOVE G6D,113,  76, 146,  93,  96,105
        MOVE G6B,35
        MOVE G6C,55
        WAIT


        GOTO 왼쪽전진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 4
        '왼쪽기울기
        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 145,  93,  96
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 12
        '오른발들기
        MOVE G6D, 80, 100, 100, 115, 114,95
        MOVE G6A,111,  76, 146,  93,  96,100
        MOVE G6C,35
        MOVE G6B,55
        WAIT


        GOTO 왼쪽전진보행50_3	

    ENDIF


    '*******************************


왼쪽전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 86,  50, 155, 115, 112
    MOVE G6D,110,  77, 148,  93,  96
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,110,  77, 148, 93,  96
    MOVE G6D,80, 90, 165,  60, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    ETX 4800,J
    GOSUB 앞뒤기울기측정

    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 왼쪽전진보행50_2
    IF A = 11 THEN	'▲
        GOTO 전진보행50_2
    ELSEIF A = 13 THEN	'▶
        GOTO 오른쪽전진보행50_2
    ELSEIF A = 14 THEN	'◀
        GOTO 왼쪽전진보행50_2
    ELSE
        GOSUB Leg_motor_mode3

        '오른발들기10
        SPEED 10
        MOVE G6A,112,  76, 147,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 114,100
        MOVE G6B,55
        MOVE G6C,35
        WAIT
        HIGHSPEED SETOFF

        '왼쪽기울기2
        SPEED 6
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT	

        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

왼쪽전진보행50_2:
    SPEED 10
    '오른발들기10
    MOVE G6A,112,  77, 147,  93, 94,100
    MOVE G6D,80, 95, 115, 105, 112,95
    MOVE G6B,55
    MOVE G6C,35
    WAIT
    '**********

왼쪽전진보행50_3:

    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D, 86,  50, 155, 115, 112
    MOVE G6A,110,  77, 147,  93,  96
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '오른발중심이동
    MOVE G6D,110,  77, 147, 93,  96
    MOVE G6A,85, 100, 146,  69, 112
    WAIT

    'SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    ETX 4800,J
    GOSUB 앞뒤기울기측정

    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 왼쪽전진보행50_4
    IF A = 11 THEN	'▲
        GOTO 전진보행50_4
    ELSEIF A = 13 THEN	'▶
        GOTO 오른쪽전진보행50_4
    ELSEIF A = 14 THEN	'◀
        GOTO 왼쪽전진보행50_4
    ELSE
        GOSUB Leg_motor_mode3
        '왼발들기
        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 114,100
        MOVE G6D,112,  76, 147,  93,  96,100
        MOVE G6B,35
        MOVE G6C,55
        WAIT
        HIGHSPEED SETOFF


        '오른쪽기울기2
        SPEED 6
        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT	
        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

왼쪽전진보행50_4:
    SPEED 8
    '왼발들기10
    MOVE G6A, 80, 95, 115, 105, 112,105
    MOVE G6D,112,  77, 148,  93,  94,110
    MOVE G6B, 35
    MOVE G6C,55
    WAIT

    GOTO 왼쪽전진보행50_1
    '*******************************

    '******************************************



    '******************************************
안정화멈춤:
    HIGHSPEED SETOFF
    SPEED 10
    GOSUB 안정화자세
    SPEED 15
    GOSUB 기본자세
    GOSUB Leg_motor_mode1
    RETURN

    '******************************************
    '**********************************************
    '************************************************
오른쪽옆으로20:

    GOSUB Leg_motor_mode1
    SPEED 12
    MOVE G6D, 93,  90, 120, 105, 104, 100
    MOVE G6A,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세

    GOTO RX_EXIT
    '**********************************************

왼쪽옆으로20:

    GOSUB Leg_motor_mode1
    SPEED 12
    MOVE G6A, 93,  90, 120, 105, 104, 100
    MOVE G6D,103,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 8

    GOSUB 기본자세
    GOTO RX_EXIT

    '**********************************************

오른쪽옆으로70:
    ERX 4800,RCNT,오른쪽옆으로70
    J = 0
    GOSUB Leg_motor_mode2

오른쪽옆으로70_반복:
    SPEED 9
    MOVE G6D, 80,  90, 120, 105, 120, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,45,  55
    MOVE G6C,45,  55
    WAIT

    SPEED 9
    MOVE G6D, 102,  76, 146, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    WAIT

    DELAY 500

    J = J + 1

    IF J < RCNT THEN
        ERX 4800, TMP, 오른쪽옆으로70_반복
        IF TMP <> 26 THEN
            GOTO 오른쪽옆으로70_반복	
        ENDIF

        MUSIC "F" ' 디버깅 소리

        GOSUB 기본자세
        ETX 4800, 1	' 완료 사인
        GOTO RX_EXIT

    ELSE
        GOSUB 기본자세
        ETX 4800, 1	' 완료 사인
    ENDIF

    GOTO RX_EXIT
    '*************
오른쪽옆으로_중심따라_70:
    GOSUB Leg_motor_mode2

    SPEED 6
    MOVE G6D, 80,  90, 120, 105, 120, 120
    MOVE G6A,100,  76, 146,  93, 107, 80
    MOVE G6B,45,  55
    MOVE G6C,45,  55
    WAIT

    SPEED 6
    MOVE G6D, 102,  76, 146, 93, 100, 130
    MOVE G6A,83,  78, 140,  96, 115,
    MOVE G6B,85,  65
    MOVE G6C,85,  65
    WAIT

    SPEED 6
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6B,35,  55
    MOVE G6C,35,  55
    WAIT

    ' DELAY 500

    RETURN
오른쪽옆으로_70:
    GOSUB Leg_motor_mode2

    SPEED 9
    MOVE G6D, 80,  90, 120, 105, 120, 100
    MOVE G6A,100,  76, 146,  93, 107, 100
    MOVE G6B,45,  55
    MOVE G6C,45,  55
    WAIT

    SPEED 9
    MOVE G6D, 102,  76, 146, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6A,98,  76, 146,  93, 100, 100
    WAIT

    ' DELAY 500

    RETURN
왼쪽옆으로70:
    ERX 4800,LCNT,왼쪽옆으로70
    J=0
    GOSUB Leg_motor_mode2

왼쪽옆으로70_반복:
    SPEED 9
    MOVE G6A, 80,  90, 12
    '*************0, 105, 120, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,45,  55
    MOVE G6C,45,  55
    WAIT

    SPEED 9
    MOVE G6A, 102,  76, 146, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 9
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    DELAY 500

    J = J + 1

    IF J < LCNT THEN
        ERX 4800, TMP, 왼쪽옆으로70_반복
        IF TMP <> 26 THEN
            GOTO 왼쪽옆으로70_반복
        ENDIF	

        MUSIC "F" ' 디버깅 소리

        GOSUB 기본자세
        ETX 4800, 1	' 완료 사인
        GOTO RX_EXIT

    ELSE
        GOSUB 기본자세
        ETX 4800, 1	' 완료 사인
    ENDIF

    GOTO RX_EXIT
    '*************
왼쪽옆으로_중심따라_70:
    GOSUB Leg_motor_mode2

    SPEED 6
    MOVE G6A, 80,  90, 120, 105, 120, 110
    MOVE G6D,100,  76, 146,  93, 107, 80
    MOVE G6B,45,  55
    MOVE G6C,45,  55
    WAIT

    SPEED 6
    MOVE G6A, 102,  76, 146, 93, 100, 115
    MOVE G6D,83,  78, 140,  96, 115, 70
    MOVE G6B,85,  65
    MOVE G6C,85,  65
    WAIT

    SPEED 6
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    MOVE G6B,35,  55
    MOVE G6C,35,  55
    WAIT

    RETURN

    '************************************************

왼쪽옆으로_70:
    GOSUB Leg_motor_mode2

    SPEED 9
    MOVE G6A, 80,  90, 120, 105, 120, 100	
    MOVE G6D,100,  76, 146,  93, 107, 100	
    MOVE G6B,45,  55
    MOVE G6C,45,  55
    WAIT

    SPEED 9
    MOVE G6A, 102,  76, 146, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 9
    MOVE G6A,98,  76, 146,  93, 100, 100
    MOVE G6D,98,  76, 146,  93, 100, 100
    WAIT

    DELAY 500

    RETURN

    '************************************************

집고오른쪽옆으로20:
    GOSUB Leg_motor_mode1

    SPEED 12
    MOVE G6D, 93,  90, 120, 97, 104, 100
    MOVE G6A,103,  76, 145,  85, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 85, 100, 100
    MOVE G6A,90,  80, 140,  87, 107, 100
    WAIT

    SPEED 15
    MOVE G6D,98,  76, 145,  85, 100, 100
    MOVE G6A,98,  76, 145,  85, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOTO RX_EXIT
    '**********************************************

집고왼쪽옆으로20:

    GOSUB Leg_motor_mode1
    SPEED 12
    MOVE G6A, 93,  90, 120, 97, 104, 100
    MOVE G6D,103,  76, 145,  85, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 85, 100, 100
    MOVE G6D,90,  80, 140,  87, 107, 100
    WAIT

    SPEED 15
    MOVE G6A,98,  76, 145,  85, 100, 100
    MOVE G6D,98,  76, 145,  85, 100, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT

    '**********************************************

집고오른쪽옆으로70:
    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6D, 90,  90, 120, 92, 110, 100
    MOVE G6A,100,  76, 146,  85, 107, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  76, 147, 85, 100, 100
    MOVE G6A,83,  76, 140,  92, 115, 100
    WAIT

    SPEED 10
    MOVE G6D,98,  76, 146,  85, 100, 100
    MOVE G6A,98,  76, 146,  85, 100, 100
    WAIT

    SPEED 15
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOTO RX_EXIT
    '*************

집고왼쪽옆으로70:

    GOSUB Leg_motor_mode2
    SPEED 10
    MOVE G6A, 90,  90, 120, 97, 110, 100	
    MOVE G6D,100,  76, 146,  85, 107, 100	
    WAIT

    SPEED 12
    MOVE G6A, 102,  76, 147, 85, 100, 100
    MOVE G6D,83,  76, 140,  92, 115, 100
    WAIT

    SPEED 10
    MOVE G6A,98,  76, 146,  85, 100, 100
    MOVE G6D,98,  76, 146,  85, 100, 100
    WAIT

    SPEED 15	
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOTO RX_EXIT
    '************************************************
천천히왼쪽옆으로50:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 5
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6A, 80,  80, 140, 95, 114, 100
    MOVE G6D,108,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 70,  72, 160,  82, 128,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6A,92,  76, 145,  93, 108, 100
    MOVE G6D,92,  76, 145,  93, 108, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 70,  72, 160,  82, 120,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6D, 85,  80, 130, 100, 110, 100
    MOVE G6A,112,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 152,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,97,  76, 145,  93, 98, 100
    MOVE G6D,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
    '************************************************
천천히오른쪽옆으로50:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 5
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D, 80,  80, 140, 95, 114, 100
    MOVE G6A,108,  76, 146,  93, 98, 100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 70,  72, 160,  82, 128,  100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D,92,  76, 145,  93, 108, 100
    MOVE G6A,92,  76, 145,  93, 108, 100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 70,  72, 160,  82, 120,  100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6A, 85,  80, 130, 100, 110, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,97,  76, 145,  93, 98, 100
    MOVE G6D,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
    '**************************************************
오른발공차기:
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3
    SPEED 3

    MOVE G6A,110,  77, 145,  93,  92, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,	
    WAIT
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,115,  70, 145,  103,  95	
    MOVE G6D, 75,  85, 122,  105, 114
    WAIT


    HIGHSPEED SETON

    SPEED 15
    MOVE G6A,115,  75, 145,  80,  95	
    MOVE G6D, 83,  20, 17
    2, 155 114
    MOVE G6C,15
    MOVE G6B,75
    WAIT


    DELAY 400
    HIGHSPEED SETOFF


    SPEED 10
    MOVE G6A,113,  72, 145,  97,  95
    MOVE G6D, 83,  58, 122,  130, 114
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,113,  77, 145,  95,  95	
    MOVE G6D, 80,  80, 142,  95, 114
    MOVE G6C,45,  55,  110, , , ,
    MOVE G6B,45,  55,  110, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,110,  77, 145,  93,  93, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    DELAY 400

    RETURN
    '******************************************


    '*****************************************************************
    ' 전진달리기50
    '*****************************************************************


전진달리기50_직진:
    J = 0
    넘어진확인 = 0
    보행속도 = 15
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101, 100
        MOVE G6D,101,  78, 145,  93, 98  , 100
        WAIT

        GOTO 전진달리기50_직진1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101 , 101
        MOVE G6A,101,  78, 145,  93, 98 , 100
        WAIT

        GOTO 전진달리기50_직진4
    ENDIF


    '**********************
전진달리기50_직진_GOTO:
    ERX 4800,A, 전진달리기50_직진1

    IF A = 2 THEN
        GOTO 전진달리기50_직진1
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1
    ELSE
        GOTO 전진달리기50_멈춤_오른발에서_멈출때
    ENDIF

전진달리기50_직진1:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  91,  102 , 100
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50_직진2:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104,100
    MOVE G6D,104,  80, 146,  89,  100,100
    WAIT
    J = J + 1

전진달리기50_직진3:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 103,  100,100
    MOVE G6D, 95, 88, 160,  68, 102,100
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF



    '*********************************
    '    ERX 4800,A, 전진달리기50_직진4

    '    IF A = 2 THEN
    '        GOTO 전진달리기50_직진4
    '    ELSEIF A = 1 THEN
    '        GOTO 전진달리기50_좌회전A4
    '    ELSEIF A = 3 THEN
    '        GOTO 전진달리기50_우회전A4
    '    ELSE
    '        GOTO 전진달리기50_멈춤_왼발에서_멈출때
    '    ENDIF

전진달리기50_직진4:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  91,  102  , 100
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50_직진5:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104,100
    MOVE G6A,104,  80, 146,  89,  100,100
    WAIT

    J = J + 1

전진달리기50_직진6:
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 103,  100,100
    MOVE G6A, 95, 88, 160,  68, 102,100
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF


    GOTO 전진달리기50_직진_GOTO

전진달리기50_멈춤:

    ' SPEED 9
    '  MOVE G6A,93,  77, 135,  89, 107, 100
    ' MOVE G6D,93,  77, 135,  89,107, 100
    ' MOVE G6C, 80,60,90
    ' MOVE G6B,80,60,90


    '    HIGHSPEED SETOFF



    ' GOSUB 안정화자세
    '     SPEED 5
    '    GOSUB 기본자세

    '   DELAY 400

    '   GOSUB Leg_motor_mode1
    '   GOTO RX_EXIT

전진달리기50_멈춤_오른발에서_멈출때:

    '    MOVE G6D,103,  70, 145, 88,  100,100
    '    MOVE G6A, 95,78, 140,  85, 102,100
    '	WAIT
    '	DELAY 200

    '    SPEED 15
    '    MOVE G6D,103,  70, 145, 88,  100,110
    '    MOVE G6A, 88, 52, 150,  95, 102,95
    '    WAIT

    '	SPEED 15
    '    MOVE G6D,103,  70, 145, 88,  100,100
    '    MOVE G6A, 95, 50, 143,  102, 102,100
    '    WAIT

    '    SPEED 5
    '    GOSUB 기본자세

    SPEED 보행속도
    MOVE G6D,103,  70, 145, 95,  100,100
    MOVE G6A, 95, 88, 160,  60, 102,100
    WAIT

    'DELAY 600

    HIGHSPEED SETOFF

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '오른발중심이동
    MOVE G6D,110,  76, 146, 98,  94
    MOVE G6A, 90, 93, 155,  69, 112
    WAIT
	
	GOSUB Leg_motor_mode3
       '왼발들기
        SPEED 10
        MOVE G6D,113,  76, 147,  93,  96,100
        MOVE G6A, 85, 100, 100, 115, 114,100
        MOVE G6B,45, 65
        MOVE G6C,45, 65
        WAIT

        '오른쪽기울기2
        SPEED 6
        MOVE G6D, 104,  76, 146,  93,  98,100		
        MOVE G6A,  85,  71, 152,  91, 105,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT

    SPEED 3
    GOSUB 기본자세

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

전진달리기50_멈춤_왼발에서_멈출때:

    '    MOVE G6A,103,  70, 145, 88,  100,100
    '    MOVE G6D, 95, 78, 140,  85, 102,100
    '	WAIT
    '    DELAY 200

    SPEED 9
    MOVE G6A,103,  70, 145, 88,  100,100
    MOVE G6D, 95, 65, 150,  88, 102,100
    WAIT

    SPEED 5
    GOSUB 기본자세
    DELAY 400

    HIGHSPEED SETOFF
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
전진달리기50_좌회전A:
    J = 0
    넘어진확인 = 0
    보행속도 = 12
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101, 100
        MOVE G6D,101,  78, 145,  93, 98  , 100
        WAIT

        GOTO 전진달리기50_좌회전A1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101 , 100
        MOVE G6A,101,  78, 145,  93, 98 , 100
        WAIT

        GOTO 전진달리기50_좌회전A4
    ENDIF


    '**********************
전진달리기50_좌회전A_GOTO:
    ERX 4800,A, 전진달리기50_좌회전A1

    IF A = 2 THEN
        GOTO 전진달리기50_직진1
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1
    ELSE
        GOTO 전진달리기50_멈춤_오른발에서_멈출때
    ENDIF


전진달리기50_좌회전A1:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  91,  102 , 100
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50_좌회전A2:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104,100
    MOVE G6D,104,  80, 146,  89,  100,100
    WAIT
    J = J + 1

전진달리기50_좌회전A3:
    SPEED 보행속도
    MOVE G6A,103,  70, 145, 103,  100,108
    MOVE G6D, 95, 88, 160,  68, 102,106
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    '*********************************
    ERX 4800,A, 전진달리기50_좌회전A4

    IF A = 2 THEN
        GOTO 전진달리기50_직진4
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4
    ELSE
        GOTO 전진달리기50_멈춤_왼발에서_멈출때
    ENDIF

전진달리기50_좌회전A4:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  91,  102  , 100
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50_좌회전A5:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104,100
    MOVE G6A,104,  80, 146,  89,  100,100
    WAIT

    J = J + 1

전진달리기50_좌회전A6:
    SPEED 보행속도
    MOVE G6D,103,  70, 144, 103,  100,92
    MOVE G6A, 95, 88, 159,  68, 102,94
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF


    GOTO 전진달리기50_좌회전A_GOTO
    '******************************************
전진달리기50_우회전A:
    J = 0
    넘어진확인 = 0
    보행속도 = 12
    SPEED 15
    HIGHSPEED SETON

    MOTORMODE G6A,3,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101,100
        MOVE G6D,101,  78, 145,  93, 98 ,100
        WAIT

        GOTO 전진달리기50_우회전A1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101 , 100
        MOVE G6A,101,  78, 145,  93, 98 , 100
        WAIT

        GOTO 전진달리기50_우회전A4
    ENDIF


    '**********************
전진달리기50_우회전A_GOTO:
    ERX 4800,A, 전진달리기50_우회전A1

    IF A = 2 THEN
        GOTO 전진달리기50_직진1
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A1
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A1
    ELSE
        GOTO 전진달리기50_멈춤_오른발에서_멈출때
    ENDIF


전진달리기50_우회전A1:
    SPEED 보행속도
    MOVE G6A,95,  95, 100, 120, 104  , 100
    MOVE G6D,104,  78, 146,  91,  102 , 100
    MOVE G6B, 25
    MOVE G6C,65
    WAIT


전진달리기50_우회전A2:
    SPEED 보행속도
    MOVE G6A,95,  75, 122, 120, 104,100
    MOVE G6D,104,  80, 146,  89,  100,100
    WAIT
    J = J + 1

전진달리기50_우회전A3:
    SPEED 보행속도
    MOVE G6A,103,  70, 144, 103,  100,94
    MOVE G6D, 95, 88, 159,  68, 102,96
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF



    '*********************************
    ERX 4800,A, 전진달리기50_우회전A4

    IF A = 2 THEN
        GOTO 전진달리기50_직진4
    ELSEIF A = 1 THEN
        GOTO 전진달리기50_좌회전A4
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A4
    ELSE
        GOTO 전진달리기50_멈춤_왼발에서_멈출때
    ENDIF

전진달리기50_우회전A4:
    SPEED 보행속도
    MOVE G6D,95,  95, 100, 120, 104  , 100
    MOVE G6A,104,  78, 146,  91,  102  , 100
    MOVE G6C, 25
    MOVE G6B,65
    WAIT


전진달리기50_우회전A5:
    SPEED 보행속도
    MOVE G6D,95,  75, 122, 120, 104,100
    MOVE G6A,104,  80, 146,  89,  100,100
    WAIT

    J = J + 1

전진달리기50_우회전A6:
    SPEED 보행속도
    MOVE G6D,103,  70, 145, 103,  100,106
    MOVE G6A, 95, 88, 160,  68, 102,104
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF


    GOTO 전진달리기50_우회전A_GOTO
    '**************************************************
왼발앞모으기:
    GOSUB 자이로OFF


    SPEED 6
    MOVE G6B,125,  65,  120
    MOVE G6C,125,  65,  120
    WAIT

    SPEED 6
    MOVE G6A,100,  22, 188,  155, 100
    MOVE G6D,100,  22, 188,  155, 100
    ' MOVE G6B,45,  52,  110, 100, 100, 100
    ' MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT

    SPEED 6
    MOVE G6B,125,  65,  120
    MOVE G6C,125,  65,  120
    WAIT

    MOVE G6B,125,  48,  125
    MOVE G6C,125,  10,  125  '15->10
    WAIT

    SPEED 6
    MOVE G6B,125,  55,  120
    MOVE G6C,125,  55,  120
    WAIT


    GOSUB 안정화자세
    DELAY 400
    GOSUB 자이로ON
    RETURN

    '**************************************************
플라스틱모으기:
    
    SPEED 15
    MOVE G6B,137,  85,  120
    MOVE G6C,137,  85,  120
    WAIT

	GOSUB 자이로OFF

    SPEED 6
    MOVE G6A,100,  20, 188,  155, 100
    MOVE G6D,100,  20, 188,  155, 100
    WAIT

    ' SPEED 5
    ' MOVE G6B,137,  65,  120
    ' MOVE G6C,137,  65,  120
    '  WAIT

    MOVE G6B,130,  35,  125
    MOVE G6C,130,  35,  125
    WAIT

    SPEED 6
    MOVE G6B,125,  55,  120
    MOVE G6C,125,  55,  120
    WAIT


    GOSUB 안정화자세
    DELAY 400
    GOSUB 자이로ON
    RETURN
    '**************************************************
    '******************************************
캔차기:
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3
    SPEED 3

    MOVE G6A,110,  77, 145,  93,  92, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,	
    WAIT
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,115,  70, 145,  103,  95	
    MOVE G6D, 75,  85, 122,  105, 114
    WAIT


    HIGHSPEED SETON

    SPEED 3
    MOVE G6A,115,  75, 145,  80,  95	
    MOVE G6D, 83,  30, 142,  135, 114
    MOVE G6C,15
    MOVE G6B,75
    WAIT


    DELAY 200
    HIGHSPEED SETOFF


    SPEED 10
    MOVE G6A,113,  72, 145,  97,  95
    MOVE G6D, 83,  58, 122,  130, 114
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,113,  77, 145,  95,  95	
    MOVE G6D, 80,  80, 142,  95, 114
    MOVE G6C,45,  55,  110, , , ,
    MOVE G6B,45,  55,  110, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,110,  77, 145,  93,  93, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    DELAY 400

    RETURN
    '**************************************************
오른발공차기2:
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3
    SPEED 3

    MOVE G6A,110,  77, 145,  93,  92, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,	
    WAIT
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,115,  70, 145,  103,  95	
    MOVE G6D, 75,  85, 122,  105, 114
    WAIT

    SPEED 8
    MOVE G6A,115,  70, 145,  103,  95	
    MOVE G6D, 75,  85, 92,  105, 114
    WAIT
    HIGHSPEED SETON

    DELAY 100

    SPEED 15
    MOVE G6A,115,  75, 145,  80,  95	
    MOVE G6D, 83,  20, 172,  155, 114
    MOVE G6C,15
    MOVE G6B,75
    WAIT


    DELAY 200
    HIGHSPEED SETOFF


    SPEED 10
    MOVE G6A,113,  72, 145,  97,  95
    MOVE G6D, 83,  58, 122,  130, 114
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,113,  77, 145,  95,  95	
    MOVE G6D, 80,  80, 142,  95, 114
    MOVE G6C,45,  55,  110, , , ,
    MOVE G6B,45,  55,  110, , , ,
    WAIT	

    SPEED 8
    MOVE G6A,110,  77, 145,  93,  93, 100	
    MOVE G6D, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    DELAY 400

    RETURN


    '******************************************
왼발공차기:
    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3
    SPEED 3

    MOVE G6D,110,  77, 145,  93,  92, 100	
    MOVE G6A, 80,  71, 152,  91, 114, 100
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,	
    WAIT
    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6D,115,  70, 145,  103,  95	
    MOVE G6A, 75,  85, 122,  105, 114
    WAIT


    HIGHSPEED SETON

    SPEED 5
    MOVE G6D,115,  75, 145,  80,  95	
    MOVE G6A, 83,  20, 172,  155, 114
    MOVE G6B,15
    MOVE G6C,75
    WAIT


    DELAY 400
    HIGHSPEED SETOFF


    SPEED 10
    MOVE G6D,113,  72, 145,  97,  95
    MOVE G6A, 83,  58, 122,  130, 114
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,	
    WAIT	

    SPEED 8
    MOVE G6D,113,  77, 145,  95,  95	
    MOVE G6A, 80,  80, 142,  95, 114
    MOVE G6C,45,  55,  110, , , ,
    MOVE G6B,45,  55,  110, , , ,	
    WAIT	

    SPEED 8
    MOVE G6D,110,  77, 145,  93,  93, 100	
    MOVE G6A, 80,  71, 152,  91, 114, 100
    WAIT


    SPEED 3
    GOSUB 기본자세	
    GOSUB Leg_motor_mode1
    DELAY 400

    RETURN

    '******************************************
집고왼쪽골반턴40:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A, 90,  71, 152,  85, 105, 100
    MOVE G6D,105,  76, 146,  87,  98, 100
    WAIT


    SPEED 10
    MOVE G6A, 80,  90, 115,  107, 115, 120
    MOVE G6D,110,  80, 148,  80,  98, 120
    WAIT

    SPEED 10
    MOVE G6A, 97,  76, 146,  85, 105, 120
    MOVE G6D,97,  76, 146,  90,  105, 120
    WAIT

    SPEED 8
    MOVE G6D, 80,  72, 145,  94, 115, 120
    MOVE G6A,108,  78, 147,  82,  98, 120
    WAIT

    SPEED 10
    MOVE G6D, 80,  90, 115,  103, 115, 120
    MOVE G6A,110,  80, 148,  82,  98, 120
    WAIT

    SPEED 8
    MOVE G6D, 80,  95, 115,  102, 114, 100
    MOVE G6A,112,  78, 147,  82,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,97,  76, 145,  84, 98, 99
    MOVE G6D,97,  76, 145,  84, 98, 99
    WAIT
    SPEED 8
    GOSUB 집고안정화자세
    GOSUB Leg_motor_mode1	
    GOTO RX_EXIT
    '**********************************************

집고오른쪽골반턴40:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D, 90,  71, 152,  88, 105, 100
    MOVE G6A,105,  76, 146,  87,  98, 100

    WAIT


    SPEED 10
    MOVE G6D, 80,  90, 115,  107, 115, 120
    MOVE G6A,110,  80, 148,  80,  98, 120
    WAIT

    SPEED 10
    MOVE G6D, 97,  76, 146,  90, 105, 120
    MOVE G6A,97,  76, 146,  85,  105, 120
    WAIT

    SPEED 8
    MOVE G6A, 80,  72, 145,  94, 115, 120
    MOVE G6D,108,  78, 147,  82,  98, 120
    WAIT

    SPEED 10
    MOVE G6A, 80,  90, 115,  103, 115, 120
    MOVE G6D,110,  80, 148,  82,  98, 120
    WAIT

    SPEED 8
    MOVE G6A, 80,  95, 115,  102, 114, 100
    MOVE G6D,112,  78, 147,  82,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,97,  76, 145,  83, 98, 99
    MOVE G6D,97,  76, 145,  83, 98, 99

    WAIT
    SPEED 8	
    GOSUB 집고안정화자세
    GOSUB Leg_motor_mode1	
    GOTO RX_EXIT
    '**********************************************
    '**********************************************
왼쪽골반턴40:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A, 90,  71, 152,  89, 105, 100
    MOVE G6D,105,  76, 146,  91,  98, 100
    MOVE G6B,45,  65
    MOVE G6C,45,  65
    WAIT


    SPEED 10
    MOVE G6A, 80,  90, 115,  108, 115, 120
    MOVE G6D,110,  80, 148,  86,  98, 120
    WAIT

    SPEED 10
    MOVE G6A, 97,  76, 146,  89, 105, 120
    MOVE G6D,97,  76, 146,  89,  105, 120
    WAIT

    SPEED 8
    MOVE G6D, 80,  72, 145,  98, 115, 120
    MOVE G6A,108,  78, 147,  91,  98, 120
    WAIT

    SPEED 10
    MOVE G6D, 80,  90, 115,  108, 115, 120
    MOVE G6A,110,  80, 148,  91,  98, 120
    WAIT

    SPEED 8
    MOVE G6D, 80,  95, 115,  103, 114, 100
    MOVE G6A,112,  78, 147,  91,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 7
    MOVE G6A,97,  76, 145,  91, 98, 99
    MOVE G6D,97,  76, 145,  91, 98, 99
    MOVE G6B,45,  65
    MOVE G6C,45,  65
    WAIT
    SPEED 8
    GOSUB 기본자세
    GOSUB Leg_motor_mode1	
    GOTO RX_EXIT
    '**********************************************
왼쪽골반턴60:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A, 90,  71, 152,  91, 105, 100
    MOVE G6D,105,  76, 146,  93,  98, 100
    MOVE G6C,45,  65
    MOVE G6B,45,  65
    WAIT


    SPEED 10
    MOVE G6A, 80,  90, 115,  110, 115, 125
    MOVE G6D,110,  80, 148, 88,  98, 125
    WAIT

    SPEED 10
    MOVE G6A, 97,  76, 146,  91, 105, 125
    MOVE G6D,97,  76, 146,  91,  105, 125
    WAIT

    SPEED 8
    MOVE G6D, 80,  72, 145,  100, 115, 125
    MOVE G6A,108,  78, 147,  93,  98, 125
    WAIT

    SPEED 10
    MOVE G6D, 80,  90, 115,  110, 115, 125
    MOVE G6A,110,  80, 148,  93,  98, 125
    WAIT

    SPEED 8
    MOVE G6D, 80,  95, 115,  105, 114, 100
    MOVE G6A,112,  78, 147,  93,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6D,97,  76, 145,  93, 98, 99
    MOVE G6A,97,  76, 145,  93, 98, 99
    MOVE G6C,45,  65
    MOVE G6B,45,  65
    WAIT
    SPEED 8	
    GOSUB 기본자세
    GOSUB Leg_motor_mode1	
    GOTO RX_EXIT
    '**********************************************
    '**********************************************
젓히고_왼쪽골반턴20:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A, 90,  71, 148,  91, 105, 100
    MOVE G6D,105,  76, 142,  93,  98, 100
    MOVE G6B,45,  65
    MOVE G6C,45,  65
    WAIT


    SPEED 10
    MOVE G6A, 80,  90, 115,  110, 115, 110
    MOVE G6D,110,  85, 138,  88,  98, 110
    WAIT

    SPEED 10
    MOVE G6A, 97,  76, 140,  91, 105, 110
    MOVE G6D,97,  76, 140,  91,  105, 110
    WAIT

    SPEED 8
    MOVE G6D, 80,  72, 145,  100, 115, 110
    MOVE G6A,108,  78, 147,  88,  98, 110
    WAIT

    SPEED 10
    MOVE G6D, 80,  90, 115,  110, 115, 110
    MOVE G6A,110,  80, 148,  82,  98, 110
    WAIT

    SPEED 8
    MOVE G6D, 80,  95, 115,  105, 114, 100
    MOVE G6A,112,  78, 147,  88,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 7
    MOVE G6A,97,  76, 145,  93, 98, 99
    MOVE G6D,97,  76, 145,  93, 98, 99
    MOVE G6B,45,  65
    MOVE G6C,45,  65
    WAIT
    SPEED 8
    GOSUB 파노라마자세
    GOSUB Leg_motor_mode1	
    GOTO RX_EXIT
    '**********************************************

오른쪽골반턴40:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D, 90,  71, 152,  89, 105, 100
    MOVE G6A,105,  76, 146,  91,  98, 100
    MOVE G6B,45,  65
    MOVE G6C,45,  65
    WAIT


    SPEED 10
    MOVE G6D, 80,  90, 115,  108, 115, 120
    MOVE G6A,110,  80, 148, 86,  98, 120
    WAIT

    SPEED 10
    MOVE G6D, 97,  76, 146,  89, 105, 120
    MOVE G6A,97,  76, 146,  89,  105, 120
    WAIT

    SPEED 8
    MOVE G6A, 80,  72, 145,  98, 115, 120
    MOVE G6D,108,  78, 147,  91,  98, 120
    WAIT

    SPEED 10
    MOVE G6A, 80,  90, 115,  108, 115, 120
    MOVE G6D,110,  80, 148,  91,  98, 120
    WAIT

    SPEED 8
    MOVE G6A, 80,  95, 115,  103, 114, 100
    MOVE G6D,112,  78, 147,  91,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,97,  76, 145,  91, 98, 99
    MOVE G6D,97,  76, 145,  91, 98, 99
    MOVE G6B,45,  65
    MOVE G6C,45,  65
    WAIT
    SPEED 8	
    GOSUB 기본자세
    GOSUB Leg_motor_mode1	
    GOTO RX_EXIT
    '**********************************************

오른쪽골반턴60:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D, 90,  71, 152,  91, 105, 100
    MOVE G6A,105,  76, 146,  93,  98, 100
    MOVE G6B,45,  65
    MOVE G6C,45,  65
    WAIT


    SPEED 10
    MOVE G6D, 80,  90, 115,  110, 115, 125
    MOVE G6A,110,  80, 148, 88,  98, 125
    WAIT

    SPEED 10
    MOVE G6D, 97,  76, 146,  91, 105, 125
    MOVE G6A,97,  76, 146,  91,  105, 125
    WAIT

    SPEED 8
    MOVE G6A, 80,  72, 145,  100, 115, 125
    MOVE G6D,108,  78, 147,  93,  98, 125
    WAIT

    SPEED 10
    MOVE G6A, 80,  90, 115,  110, 115, 125
    MOVE G6D,110,  80, 148,  93,  98, 125
    WAIT

    SPEED 8
    MOVE G6A, 80,  95, 115,  105, 114, 100
    MOVE G6D,112,  78, 147,  93,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,97,  76, 145,  93, 98, 99
    MOVE G6D,97,  76, 145,  93, 98, 99
    MOVE G6B,45,  65
    MOVE G6C,45,  65
    WAIT
    SPEED 8	
    GOSUB 기본자세
    GOSUB Leg_motor_mode1	
    GOTO RX_EXIT
    '**********************************************

    '**********************************************
왼쪽골반턴90:

    TCNT=0

왼쪽골반턴90_2:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A, 90,  71, 152,  97, 105, 100
    MOVE G6D,105,  76, 146,  89,  98, 100
    '  MOVE G6B,45,  55
    '  MOVE G6C,45,  55
    WAIT


    SPEED 10
    MOVE G6A, 80,  90, 115,  104, 115, 125
    MOVE G6D,110,  80, 148,  87,  98, 125
    WAIT

    SPEED 10
    MOVE G6A, 97,  76, 146,  89, 105, 125
    MOVE G6D,97,  76, 146,  89,  105, 125
    WAIT

    SPEED 8
    MOVE G6D, 80,  72, 145,  96, 115, 125
    MOVE G6A,108,  78, 147,  89,  98, 125
    WAIT

    SPEED 10
    MOVE G6D, 80,  90, 115,  104, 115, 125
    MOVE G6A,110,  80, 148,  99,  98, 125
    WAIT

    SPEED 8
    MOVE G6D, 80,  95, 115,  101, 114, 100
    MOVE G6A,112,  78, 147,  89,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,97,  76, 145,  89, 98, 99
    MOVE G6D,97,  76, 145,  89, 98, 99
    'MOVE G6B,45,  50
    'MOVE G6C,45,  50
    WAIT


    TCNT=TCNT+1

    IF TCNT <2 THEN
        GOTO 왼쪽골반턴90_2

    ENDIF

    GOSUB 안정화자세

    GOSUB Leg_motor_mode1	
    RETURN

    '**********************************************
왼쪽골반턴45:
  GOSUB Leg_motor_mode3
   SPEED 5
    MOVE G6A, 90,  71, 152,  97, 105, 100
    MOVE G6D,105,  76, 146,  89,  98, 100
    '  MOVE G6B,45,  55
    '  MOVE G6C,45,  55
    WAIT


    SPEED 10
    MOVE G6A, 80,  90, 115,  104, 115, 125
    MOVE G6D,110,  80, 148,  87,  98, 125
    WAIT

    SPEED 10
    MOVE G6A, 97,  76, 146,  89, 105, 125
    MOVE G6D,97,  76, 146,  89,  105, 125
    WAIT

    SPEED 8
    MOVE G6D, 80,  72, 145,  96, 115, 125
    MOVE G6A,108,  78, 147,  89,  98, 125
    WAIT

    SPEED 10
    MOVE G6D, 80,  90, 115,  104, 115, 125
    MOVE G6A,110,  80, 148,  99,  98, 125
    WAIT

    SPEED 8
    MOVE G6D, 80,  95, 115,  101, 114, 100
    MOVE G6A,112,  78, 147,  89,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,97,  76, 145,  89, 98, 99
    MOVE G6D,97,  76, 145,  89, 98, 99
    'MOVE G6B,45,  50
    'MOVE G6C,45,  50
    WAIT
    
   GOSUB 안정화자세

    GOSUB Leg_motor_mode1	
    RETURN
    '**********************************************
오른쪽골반턴45:
  	GOSUB Leg_motor_mode3
   SPEED 5
    MOVE G6D, 90,  71, 152,  97, 105, 100
    MOVE G6A,105,  76, 146,  89,  98, 100
    '  MOVE G6B,45,  55
    '  MOVE G6C,45,  55
    WAIT


    SPEED 10
    MOVE G6D, 80,  90, 115,  104, 115, 125
    MOVE G6A,110,  80, 148,  87,  98, 125
    WAIT

    SPEED 10
    MOVE G6D, 97,  76, 146,  89, 105, 125
    MOVE G6A,97,  76, 146,  89,  105, 125
    WAIT

    SPEED 8
    MOVE G6A, 80,  72, 145,  96, 115, 125
    MOVE G6D,108,  78, 147,  89,  98, 125
    WAIT

    SPEED 10
    MOVE G6A, 80,  90, 115,  104, 115, 125
    MOVE G6D,110,  80, 148,  99,  98, 125
    WAIT

    SPEED 8
    MOVE G6A, 80,  95, 115,  101, 114, 100
    MOVE G6D,112,  78, 147,  89,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6D,97,  76, 145,  89, 98, 99
    MOVE G6A,97,  76, 145,  89, 98, 99
    'MOVE G6B,45,  50
    'MOVE G6C,45,  50
    WAIT
    
   GOSUB 안정화자세

    GOSUB Leg_motor_mode1	
    RETURN
    '**********************************************

오른쪽골반턴90:

    TCNT=0

오른쪽골반턴90_2:
    GOSUB Leg_motor_mode3
   SPEED 5
    MOVE G6D, 90,  71, 152,  97, 105, 100
    MOVE G6A,105,  76, 146,  89,  98, 100
    '  MOVE G6B,45,  55
    '  MOVE G6C,45,  55
    WAIT


    SPEED 10
    MOVE G6D, 80,  90, 115,  104, 115, 125
    MOVE G6A,110,  80, 148,  87,  98, 125
    WAIT

    SPEED 10
    MOVE G6D, 97,  76, 146,  89, 105, 125
    MOVE G6A,97,  76, 146,  89,  105, 125
    WAIT

    SPEED 8
    MOVE G6A, 80,  72, 145,  96, 115, 125
    MOVE G6D,108,  78, 147,  89,  98, 125
    WAIT

    SPEED 10
    MOVE G6A, 80,  90, 115,  104, 115, 125
    MOVE G6D,110,  80, 148,  99,  98, 125
    WAIT

    SPEED 8
    MOVE G6A, 80,  95, 115,  101, 114, 100
    MOVE G6D,112,  78, 147,  89,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6D,97,  76, 145,  89, 98, 99
    MOVE G6A,97,  76, 145,  89, 98, 99
    'MOVE G6B,45,  50
    'MOVE G6C,45,  50
    WAIT


    TCNT=TCNT+1

    IF TCNT <2 THEN
        GOTO 오른쪽골반턴90_2

    ENDIF

    GOSUB 안정화자세

    GOSUB Leg_motor_mode1	
    RETURN

    '**********************************************
집고왼쪽골반턴180:

    TCNT=0

집고왼쪽골반턴180_2:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A, 90,  71, 152,  86, 105, 100
    MOVE G6D,105,  76, 146,  88,  98, 100
    '  MOVE G6B,45,  55
    '  MOVE G6C,45,  55
    WAIT


    SPEED 10
    MOVE G6A, 80,  90, 115,  105, 115, 120
    MOVE G6D,110,  80, 148,  86,  98, 120
    WAIT

    SPEED 10
    MOVE G6A, 97,  76, 146,  88, 105, 120
    MOVE G6D,97,  76, 146,  88,  105, 120
    WAIT

    SPEED 8
    MOVE G6D, 80,  72, 145,  95, 115, 120
    MOVE G6A,108,  78, 147,  88,  98, 120
    WAIT

    SPEED 10
    MOVE G6D, 80,  90, 115,  105, 115, 120
    MOVE G6A,110,  80, 148,  88,  98, 120
    WAIT

    SPEED 8
    MOVE G6D, 80,  95, 115,  100, 114, 100
    MOVE G6A,112,  78, 147,  88,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,97,  76, 145,  88, 98, 99
    MOVE G6D,97,  76, 145,  88, 98, 99
    'MOVE G6B,45,  50
    'MOVE G6C,45,  50
    WAIT


    TCNT=TCNT+1

    IF TCNT <5 THEN
        GOTO 집고왼쪽골반턴180_2

    ENDIF

    GOSUB 집고안정화자세

    GOSUB Leg_motor_mode1	
    RETURN


    '**********************************************
    '**********************************************
플라스틱집고왼쪽골반턴180:

    TCNT=0

플라스틱집고왼쪽골반턴180_2:
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A, 90,  71, 152,  86, 105, 100
    MOVE G6D,105,  76, 146,  88,  98, 100
    '  MOVE G6B,45,  55
    '  MOVE G6C,45,  55
    WAIT


    SPEED 10
    MOVE G6A, 80,  90, 115,  102, 115, 120
    MOVE G6D,110,  80, 148,  84,  98, 120
    WAIT

    SPEED 10
    MOVE G6A, 97,  76, 146,  85, 105, 120
    MOVE G6D,97,  76, 146,  85,  105, 120
    WAIT

    SPEED 8
    MOVE G6D, 80,  72, 145,  92, 115, 120
    MOVE G6A,108,  78, 147,  85,  98, 120
    WAIT

    SPEED 10
    MOVE G6D, 80,  90, 115,  102, 115, 120
    MOVE G6A,110,  80, 148,  85,  98, 120
    WAIT

    SPEED 8
    MOVE G6D, 80,  95, 115,  97, 114, 100
    MOVE G6A,112,  78, 147,  85,  98, 100
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 8
    MOVE G6A,97,  76, 145,  85, 98, 99
    MOVE G6D,97,  76, 145,  85, 98, 99
    'MOVE G6B,45,  50
    'MOVE G6C,45,  50
    WAIT


    TCNT=TCNT+1

    IF TCNT <5 THEN
        GOTO 플라스틱집고왼쪽골반턴180_2

    ENDIF

    GOSUB 집고안정화자세

    GOSUB Leg_motor_mode1	
    RETURN


    '**********************************************

뒤로일어나기:
    GOSUB 자이로OFF
    GOSUB All_motor_Reset
    HIGHSPEED SETOFF
    PTP SETON
    PTP ALLON


    SPEED 15
    MOVE G6B,45,  60,  140
    MOVE G6C,45,  60,  140
    WAIT

    SPEED 15
    MOVE G6B,120,  130,  140
    MOVE G6C,120,  130,  140
    WAIT

    SPEED 15
    MOVE G6B, 185, 110,  55
    MOVE G6C, 185, 110,  55
    WAIT


    SPEED 15
    MOVE G6A,  70, 150,  27, 150, 190,120
    MOVE G6D,  70, 150,  27, 150, 190,120
    MOVE G6B, 185, 60,  55
    MOVE G6C, 185, 60,  55
    WAIT



    SPEED 15	
    MOVE G6B,  100, 40, 120
    MOVE G6C,  100, 40, 120
    WAIT


    SPEED 10	
    MOVE G6A,  100, 150,  25, 140, 98,100
    MOVE G6D,  100, 150,  25, 140, 98,100
    MOVE G6B,  100, 45, 120
    MOVE G6C,  100, 45, 120
    WAIT

    DELAY 200
뒤로일어나기_NO:
    S4 = MOTORIN(4)
    S22 = MOTORIN(22)

    IF S4 < 102 AND S22 < 102 THEN GOTO 뒤로일어나기_GOGO
    SPEED 8	
    MOVE G6A,  100, 150,  25, 140, 98,100
    MOVE G6D,  100, 150,  25, 140, 98,100
    WAIT

    SPEED 8	
    MOVE G6A,  100, 135,  57, 125, 98,100
    MOVE G6D,  100, 135,  57, 125, 98,100
    WAIT

    GOTO 뒤로일어나기_NO

뒤로일어나기_GOGO:

    GOSUB Leg_motor_mode2
    SPEED 8
    GOSUB 기본자세
    DELAY 500
    'GOSUB All_motor_mode2
    GOSUB 자이로ON
    'GOSUB All_motor_Reset
    넘어진확인 = 1
    RETURN

    '************************************************

앞으로일어나기:
    GOSUB 자이로OFF
    GOSUB All_motor_Reset
    HIGHSPEED SETOFF
    PTP SETON
    PTP ALLON

    SPEED 15
    MOVE G6A,100, 20,  70, 140, 100,
    MOVE G6D,100, 20,  70, 140, 100,
    MOVE G6B,  165,  130,  55, , , 100
    MOVE G6C,  165,  130,  55, , ,
    WAIT


    SPEED 12
    MOVE G6A,100, 136,  35, 90, 100,
    MOVE G6D,100, 136,  35, 90, 100,
    MOVE G6B,  165,  155,  130, , , 100
    MOVE G6C,  165,  155,  130, , ,
    WAIT

    SPEED 12
    MOVE G6A,100, 150,  80, 30, 100,
    MOVE G6D,100, 150,  80, 30, 100,
    MOVE G6B,  170,  155,  130, , , 100
    MOVE G6C,  170,  155,  130, , ,
    WAIT


    SPEED 6
    MOVE G6A,100, 150,  90, 15, 100,
    MOVE G6D,100, 150,  90, 15, 100,
    WAIT


    SPEED 6
    MOVE G6A,100, 120,  90, 100, 100,
    MOVE G6D,100, 120,  90, 100, 100,
    MOVE G6B,80,  60,  70
    MOVE G6C,80,  60,  70
    WAIT

    DELAY 100
    GOSUB Leg_motor_mode2
    SPEED 8
    GOSUB 기본자세
    넘어진확인 = 1
    DELAY 500
    'GOSUB All_motor_mode2
    GOSUB 자이로ON
    RETURN

    '******************************************


    '******************************************
    '************************************************
앞뒤기울기측정:

    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN GOSUB 기울기앞
    IF A > MAX THEN GOSUB 기울기뒤

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN  GOSUB 뒤로일어나기
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN GOSUB 앞으로일어나기
    RETURN
    '**************************************************
좌우기울기측정:

    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
        RETURN

    ENDIF
    RETURN
    '**************************************************

앞뒤기울기값_TX:
    A = AD(앞뒤기울기AD포트)	'기울기 앞뒤

    ETX 4800, A
    DELAY 20

    RETURN

    '**************************************************
좌우기울기값_TX:
    A = AD(좌우기울기AD포트)	'기울기 앞뒤

    ETX 4800, A
    DELAY 20

    RETURN

    '**************************************
LED_ON_OFF2:

    OUT 52,1
    DELAY 150

    OUT 52,0
    DELAY 150
    RETURN
    '**************************************
LED_ON_OFF:

    OUT 52,1
    DELAY 150
    OUT 52,0
    DELAY 150

    OUT 52,1
    DELAY 150
    OUT 52,0
    DELAY 150
    RETURN
    '**************************************
MF눈LED켜기:
    OUT 52,0
    RETURN
    '**************************************
MF눈LED끄기:
    OUT 52,1
    RETURN
    '******************************************

    '******************************************
플라스틱잡기:
    GOSUB All_motor_mode3
    SPEED 8
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    MOVE G6B,100,  50,  110
    MOVE G6C,100,  50,  110
    WAIT

    SPEED 3
    MOVE G6A,100, 143,  28, 135, 190, 100
    MOVE G6D,100, 143,  28, 135, 190, 100
    MOVE G6B,135,  50,  130
    MOVE G6C,135,  50,  130
    WAIT

    SPEED 8
    MOVE G6A,100, 143,  28, 90, 190, 100
    MOVE G6D,100, 143,  28, 90, 190, 100
    MOVE G6B,123,  40,  130
    MOVE G6C,123,  40,  130
    WAIT

    SPEED 8
    MOVE G6B,123,  30,  130
    MOVE G6C,123,  30,  130
    WAIT
    DELAY 500


    SPEED 12
    MOVE G6A,100, 143,  28, 135, 190, 100
    MOVE G6D,100, 143,  28, 135, 190, 100
    MOVE G6B,130,  25,  130
    MOVE G6C,130,  25,  130
    WAIT

    SPEED 8
    MOVE G6A,100, 143,  28, 142, 100, 100
    MOVE G6D,100, 143,  28, 142, 100, 100
    MOVE G6B,120,  25,  130
    MOVE G6C,120,  25,  130
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    WAIT


    RETURN

    '************************************************
물건집기:

    GOSUB 자이로OFF

    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  25, 188,  145, 100
    MOVE G6D,100,  25, 188,  145, 100
    MOVE G6B,105,  55,  120
    MOVE G6C,105,  55,  120
    WAIT

    MOVE G6B,115,  30,  125'30->27
    MOVE G6C,115,  30,  125
    WAIT

    SPEED 4
    MOVE G6A,100,  33, 170,  155, 100
    MOVE G6D,100,  33, 170,  155, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  50, 150,  130, 100
    MOVE G6D,100,  50, 150,  130, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    '   MOVE G6B,85,  27,  125
    '  MOVE G6C,85,  27,  125
    WAIT

    MOVE G6B, ,  ,  80
    MOVE G6C, ,  ,  80
    WAIT

    MOVE G6B ,60 , 40,80,
    MOVE G6C ,60, 40, 80,
    WAIT

    DELAY 400

    GOSUB All_motor_Reset
    물건집은상태 = 1

    GOSUB 자이로ON

    RETURN
    '************************************************
물건집기2:

    GOSUB 자이로OFF

    GOSUB All_motor_mode3
    SPEED 5
    MOVE G6A,100,  25, 188,  155, 100
    MOVE G6D,100,  25, 188,  155, 100
    MOVE G6B,125,  55,  120
    MOVE G6C,125,  55,  120
    WAIT

    MOVE G6B,125,  30,  125'30->27
    MOVE G6C,125,  30,  125
    WAIT

    SPEED 4
    MOVE G6A,100,  33, 170,  155, 100
    MOVE G6D,100,  33, 170,  155, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  50, 150,  130, 100
    MOVE G6D,100,  50, 150,  130, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    '   MOVE G6B,85,  27,  125
    '  MOVE G6C,85,  27,  125
    WAIT

    MOVE G6B,180,  30,  105'30->27
    MOVE G6C,180,  30,  105
    WAIT

    DELAY 400

    GOSUB All_motor_Reset
    물건집은상태 = 1

    GOSUB 자이로ON

    RETURN
    '************************************************
    '************************************************
물건놓기:
    ' MOVE G6B,105,  55,  120
    ' MOVE G6C,105,  55,  120
    GOSUB 자이로OFF
    MOVE G6B ,60, 40,70,
    MOVE G6C,60, 40, 70,
    WAIT

    SPEED 6
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    '    MOVE G6B,85,  27,  125
    '    MOVE G6C,85,  27,  125
    WAIT

    SPEED 5
    MOVE G6A,100,  50, 150,  130, 100
    MOVE G6D,100,  50, 150,  130, 100
    WAIT

    SPEED 4
    MOVE G6A,100,  33, 170,  155, 100
    MOVE G6D,100,  33, 170,  155, 100
    WAIT

    MOVE G6B,125,  30,  125'30->27
    MOVE G6C,125,  30,  125
    WAIT

    SPEED 5
    MOVE G6A,100,  25, 188,  155, 100
    MOVE G6D,100,  25, 188,  155, 100
    MOVE G6B,125,  55,  120
    MOVE G6C,125,  55,  120
    WAIT

    GOSUB 안정화자세

    RETURN
    '************************************************

물건모으기:
    GOSUB 자이로OFF

    SPEED 5
    MOVE G6A,100,  15, 188,  155, 100 '25->15
    MOVE G6D,100,  15, 188,  155, 100
    MOVE G6B,45,  52,  110, 100, 100, 100
    MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT

    SPEED 5
    MOVE G6B,125,  55,  120
    MOVE G6C,125,  55,  120
    WAIT

    SPEED 5
    MOVE G6B,125,  30,  125'30->27
    MOVE G6C,125,  30,  125
    WAIT

    SPEED 5
    MOVE G6B,125,  55,  120
    MOVE G6C,125,  55,  120
    WAIT


    GOSUB 안정화자세
    DELAY 400
    GOSUB 자이로ON
    RETURN

    '******************************************
캔밀기:
    GOSUB 자이로OFF

    SPEED 5
    MOVE G6A,100,  25, 188,  155, 100
    MOVE G6D,100,  25, 188,  155, 100
    MOVE G6B,100,  40,  122
    MOVE G6C,100,  40,  125
    WAIT

    SPEED 10
    MOVE G6B,125,  45,  120
    MOVE G6C,125,  45,  120
    WAIT

    DELAY 400
    GOSUB 자이로ON
    RETURN

    '******************************************
캔집기:
    GOSUB 자이로OFF

    SPEED 5
    MOVE G6A,100,  25, 188,  155, 100
    MOVE G6D,100,  25, 188,  155, 100
    MOVE G6B,110,  55,  120
    MOVE G6C,110,  55,  120
    WAIT

    SPEED 5
    MOVE G6B,105,  42,  122
    MOVE G6C,105,  42,  125
    WAIT

    SPEED 5
    MOVE G6A,98,  76, 145,  85, 101, 100
    MOVE G6D,98,  76, 145,  85, 101, 100
    MOVE G6B,60,  42,  85
    MOVE G6C,60,  42,  85
    WAIT

    DELAY 400
    GOSUB 자이로ON
    RETURN

    '******************************************
전진종종걸음:
    J = 0
    넘어진확인 = 0
    GOSUB 자이로ON
    SPEED 10
    HIGHSPEED SETON
    'GOSUB All_motor_mode3
    MOTORMODE G6A,3,2,2,2,2,1
    MOTORMODE G6D,3,2,2,2,2,1
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101,100
        MOVE G6D,101,  77, 145,  93, 98,100
        MOVE G6B, 45,  55
        MOVE G6C,45,  55
        WAIT

        GOTO 전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101,100
        MOVE G6A,101,  77, 145,  93, 98,100
        MOVE G6B, 45,  55
        MOVE G6C,45,  55
        WAIT

        GOTO 전진종종걸음_4
    ENDIF


    '**********************

전진종종걸음_1:
    MOVE G6A,95,  85, 135, 100, 104,100
    MOVE G6D,104,  77, 146,  91,  102,100
    MOVE G6B, 25
    MOVE G6C,50
    WAIT
    J = J + 1
    ETX 4800,J

전진종종걸음_2:
    MOVE G6A,95,  85, 130, 103, 104,100
    MOVE G6D,104,  79, 146,  89,  100,100
    WAIT

전진종종걸음_3:
    MOVE G6A,103,   85, 130, 103,  100,115
    MOVE G6D, 95,  79, 146,  89, 102,98
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진종종걸음_4
    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤

    '*********************************

전진종종걸음_4:
    MOVE G6D,95,  85, 135, 100, 104,100
    MOVE G6A,104,  77, 146,  91,  102,100
    MOVE G6C, 30
    MOVE G6B,65
    WAIT
    J = J + 1
    ETX 4800,J

전진종종걸음_5:
    MOVE G6D,95,  85, 130, 103, 104,100
    MOVE G6A,104,  79, 146,  89,  100,100
    WAIT

전진종종걸음_6:
    MOVE G6D,103,   85, 130, 103,  100,115
    MOVE G6A, 95,  79, 146,  89, 102,98
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진종종걸음_1
    IF A <> A_old THEN  GOTO 전진종종걸음_멈춤


    GOTO 전진종종걸음_1


전진종종걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************

    '******************************************
플라스틱집고달리기:
    J = 0
    넘어진확인 = 0
    SPEED 15
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 140,  80, 101
        MOVE G6D,101,  77, 140,  80, 98
        WAIT

        GOTO 플라스틱집고달리기_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 140,  80, 101
        MOVE G6A,101,  77, 140,  80, 98
        WAIT

        GOTO 플라스틱집고달리기_4
    ENDIF


    '**********************

플라스틱집고달리기_1:
    MOVE G6A,95,  95, 115, 90, 104
    MOVE G6D,104,  77, 140,  82,  102
    WAIT
    DELAY 5

플라스틱집고달리기_2:
    MOVE G6D,104,  79, 140,  79,  100
    MOVE G6A,95,  85, 125, 90, 104
    WAIT
    DELAY 5
    J = J + 1
    ETX 4800,J

플라스틱집고달리기_3:
    MOVE G6A,103,   85, 125, 90,  100
    MOVE G6D, 97,  79, 140,  77, 102
    WAIT
    DELAY 5

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 플라스틱집고달리기_4
    IF A <> A_old THEN  GOTO 플라스틱집고달리기_멈춤

    '*********************************

플라스틱집고달리기_4:
    MOVE G6D,95,  95, 115, 90, 104
    MOVE G6A,104,  77, 140,  82,  102
    WAIT


플라스틱집고달리기_5:
    MOVE G6D,95,  85, 125, 90, 104
    MOVE G6A,104,  79, 140,  77,  100
    WAIT
    J = J + 1
    ETX 4800,J
플라스틱집고달리기_6:
    MOVE G6D,103,   85, 125, 90,  100
    MOVE G6A, 97,  79, 140,  77, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 플라스틱집고달리기_1
    IF A <> A_old THEN  GOTO 플라스틱집고달리기_멈춤


    GOTO 플라스틱집고달리기_1


플라스틱집고달리기_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 140,  85, 96, 100
    MOVE G6D,98,  76, 140,  85, 96, 100
    SPEED 10
    MOVE G6A,100,  76, 140,  80, 100
    MOVE G6D,100,  76, 140,  80, 100
    WAIT

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '******************************************
집고달리기:
    J = 0
    넘어진확인 = 0
    SPEED 15
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 140,  85, 101
        MOVE G6D,101,  77, 140,  85, 98
        WAIT

        GOTO 집고달리기_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 140,  85, 101
        MOVE G6A,101,  77, 140,  85, 98
        WAIT

        GOTO 집고달리기_4
    ENDIF


    '**********************

집고달리기_1:
    MOVE G6A,95,  95, 115, 95, 104
    MOVE G6D,104,  77, 140,  87,  102
    WAIT
    DELAY 5

집고달리기_2:
    MOVE G6D,104,  79, 140,  82,  100
    MOVE G6A,95,  85, 125, 95, 104
    WAIT
    DELAY 5
    J = J + 1
    ETX 4800,J

집고달리기_3:
    MOVE G6A,103,   85, 125, 95,  100
    MOVE G6D, 97,  79, 140,  82, 102
    WAIT
    DELAY 5

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고달리기_4
    IF A <> A_old THEN  GOTO 집고달리기_멈춤

    '*********************************

집고달리기_4:
    MOVE G6D,95,  95, 115, 95, 104
    MOVE G6A,104,  77, 140,  87,  102
    WAIT


집고달리기_5:
    MOVE G6D,95,  85, 125, 95, 104
    MOVE G6A,104,  79, 140,  82,  100
    WAIT
    J = J + 1
    ETX 4800,J
집고달리기_6:
    MOVE G6D,103,   85, 125, 95,  100
    MOVE G6A, 97,  79, 140,  82, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고달리기_1
    IF A <> A_old THEN  GOTO 집고달리기_멈춤


    GOTO 집고달리기_1


집고달리기_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 140,  85, 101, 100
    MOVE G6D,98,  76, 140,  85, 101, 100
    SPEED 10
    MOVE G6A,100,  76, 140,  85, 100
    MOVE G6D,100,  76, 140,  85, 100
    WAIT

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '******************************************
집고후진걸음:
    J = 0
    넘어진확인 = 0
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  85, 101
        MOVE G6D,101,  77, 145,  85, 98
        WAIT

        GOTO 집고후진걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  85, 101
        MOVE G6A,101,  77, 145,  85, 98
        WAIT

        GOTO 집고후진걸음_4
    ENDIF


    '**********************

집고후진걸음_1:
    MOVE G6D,104,  77, 146,  83,  102
    MOVE G6A,95,  95, 120, 92, 104
    WAIT


집고후진걸음_2:
    MOVE G6A,95,  90, 135, 82, 104
    MOVE G6D,104,  77, 146,  83,  100
    WAIT
    J = J + 1
    ETX 4800,J

집고후진걸음_3:
    MOVE G6A, 103,  79, 146,  81, 100
    MOVE G6D,95,   65, 146, 95,  102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고후진걸음_4
    IF A <> A_old THEN  GOTO 집고후진걸음_멈춤

    '*********************************

집고후진걸음_4:
    MOVE G6D,95,  95, 120, 92, 104
    MOVE G6A,104,  77, 146,  83,  102
    WAIT


집고후진걸음_5:
    MOVE G6A,104,  77, 146,  83,  100
    MOVE G6D,95,  90, 135, 82, 104
    WAIT
    J = J + 1
    ETX 4800,J

집고후진걸음_6:
    MOVE G6D, 103,  79, 146,  81, 100
    MOVE G6A,95,   65, 146, 95,  102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고후진걸음_1
    IF A <> A_old THEN  GOTO 집고후진걸음_멈춤


    GOTO 집고후진걸음_1


집고후진걸음_멈춤:
    HIGHSPEED SETOFF
    SPEED 15
    MOVE G6A,98,  76, 145,  85, 101, 100
    MOVE G6D,98,  76, 145,  85, 101, 100
    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    DELAY 400


    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '******************************************
    '*********************************************	
전진앉아보행:
    GOSUB All_motor_mode3
    SPEED 9

전진앉아보행_1:

    MOVE G6A,114, 143,  28, 142,  96, 100
    MOVE G6D, 87, 135,  28, 155, 110, 100
    WAIT
    J = J + 1
    ETX 4800,J

    MOVE G6D,98, 126,  28, 160, 102, 100
    MOVE G6A,98, 160,  28, 125, 102, 100
    WAIT

    ERX 4800, A, 전진앉아보행_2
    SPEED 6
    'IF  물건집은상태 = 0 THEN
    '  GOSUB 앉은자세
    ' ELSE
    MOVE G6A,100, 140,  28, 142, 100, 100
    MOVE G6D,100, 140,  28, 142, 100, 100
    WAIT
    자세 = 1
    ' ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT

전진앉아보행_2:
    MOVE G6D,113, 143,  28, 142,  96, 100
    MOVE G6A, 87, 135,  28, 155, 110, 100
    WAIT

    J = J + 1
    ETX 4800,J

    MOVE G6A,98, 126,  28, 160, 102, 100
    MOVE G6D,98, 160,  28, 125, 102, 100
    WAIT

    ERX 4800, A, 전진앉아보행_1
    SPEED 6
    'IF  물건집은상태 = 0 THEN
    '   GOSUB 앉은자세
    ' ELSE
    MOVE G6A,100, 140,  28, 142, 100, 100
    MOVE G6D,100, 140,  28, 142, 100, 100
    WAIT
    자세 = 1
    'ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT


    GOTO 전진앉아보행_1
    '*****************************
후진앉아보행:
    GOSUB All_motor_mode3
    SPEED 8

후진앉아보행_1:

    MOVE G6D,113, 140,  28, 142,  96, 100
    MOVE G6A, 87, 140,  28, 140, 110, 100
    WAIT

    MOVE G6A,98, 155,  28, 125, 102, 100
    MOVE G6D,98, 121,  28, 160, 102, 100
    WAIT

    ERX 4800, A, 후진앉아보행_2
    SPEED 6
    IF  물건집은상태 = 0 THEN
        GOSUB 앉은자세
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        자세 = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT

후진앉아보행_2:
    MOVE G6A,113, 140,  28, 142,  96, 100
    MOVE G6D, 87, 140,  28, 140, 110, 100
    WAIT


    MOVE G6D,98, 155,  28, 125, 102, 100
    MOVE G6A,98, 121,  28, 160, 102, 100
    WAIT

    ERX 4800, A, 후진앉아보행_1
    SPEED 6
    IF  물건집은상태 = 0 THEN
        GOSUB 앉은자세
    ELSE
        MOVE G6A,100, 140,  28, 142, 100, 100
        MOVE G6D,100, 140,  28, 142, 100, 100
        WAIT
        자세 = 1
    ENDIF
    GOSUB All_motor_Reset
    GOTO RX_EXIT


    GOTO 후진앉아보행_1
    '*****************************		

    '**********************************************
오른쪽보기:
    SPEED 15
    MOVE G6B,, ,  , , , 145
    WAIT

    SPEED 5
    RETURN

가운데보기:
    SPEED 15
    MOVE G6B,, , , , , 100
    WAIT

    SPEED 5 	
    RETURN

왼쪽보기:

    SPEED 15
    MOVE G6B,,  ,  , , , 55
    WAIT

    SPEED 5
    RETURN

오른쪽보기_80:
    SPEED 15
    MOVE G6B,, ,  , , , 180
    WAIT

    SPEED 5
    RETURN

왼쪽보기_80:
    SPEED 15
    MOVE G6B,,  ,  , , , 20
    WAIT

    SPEED 5
    RETURN
    '**********************************************

모터ONOFF_LED:
    IF 모터ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    RETURN
    '**********************************************
LOW_Voltage:

    B = AD(6)

    IF B < 하한전압 THEN
        GOSUB 경고음

    ENDIF

    RETURN
    '**********************************************

    '**********************************************
머리모터제어:

    ERX 4800,A ,머리모터제어
    IF A >= 10 AND A <= 190 THEN
        GOSUB HEAD_motor_mode3
        SPEED 15
        SERVO 11, A
        DELAY 500
        GOSUB HEAD_motor_mode1
        GOTO MAIN
    ELSE
        GOSUB 경고음
    ENDIF

    RETURN
    '**********************************************
앉아서집기:

    GOSUB 자이로OFF

    GOSUB All_motor_mode3
    SPEED 10

    MOVE G6A,100, 143,  28, 145, 100, 100
    MOVE G6D,100, 143,  28, 145, 100, 100
    MOVE G6B,25,  55,  110
    MOVE G6C,25,  55,  110
    WAIT

    MOVE G6B,90,  55,  120
    MOVE G6C,90,  55,  120
    WAIT

    MOVE G6B,90,  28,  125
    MOVE G6C,90,  28,  125
    WAIT



    GOSUB All_motor_Reset
    물건집은상태 = 1
    자세 = 1

    RETURN

    '**********************************************	
일어나기:

    SPEED 8
    MOVE G6A,100,  76, 145,  90, 100, 100
    MOVE G6D,100,  76, 145,  90, 100, 100
    WAIT

    SPEED 4
    MOVE G6B,120,  28,  125
    MOVE G6C,120,  28,  125
    WAIT

    '**********************************************	
팔벌리고앉기:
    GOSUB 자이로OFF

    GOSUB All_motor_mode3
    SPEED 10
    MOVE G6A,100, 143,  28, 145, 100, 100
    MOVE G6D,100, 143,  28, 145, 100, 100
    MOVE G6B,25,  55,  110
    MOVE G6C,25,  55,  110
    WAIT

    MOVE G6B,80,  40,  120
    MOVE G6C,80,  40,  120
    WAIT

    '**********************************************	
집고_전진보행50:
    J = 0
    넘어진확인 = 0
    보행속도 = 12'5
    좌우속도 = 5'8'3

    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,3,3,3,3,2,3
    MOTORMODE G6D,3,3,3,3,2,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        '오른쪽기울기
        MOVE G6A, 90,  71, 150,  85, 105
        MOVE G6D,106,  76, 144,  85,  96
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT

        SPEED 11'보행속도
        '왼발들기
        MOVE G6A, 80, 95, 115, 100, 114
        MOVE G6D,114,  81, 144,  85,  96
        '        MOVE G6B,35
        '        MOVE G6C,55
        WAIT


        GOTO 집고_전진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 4
        '왼쪽기울기
        MOVE G6D,  90,  71, 150,  86, 105
        MOVE G6A, 106,  76, 144,  85,  96
        '        MOVE G6C, 45,55
        '        MOVE G6B, 45,55
        WAIT

        SPEED 11'보행속도
        '오른발들기
        MOVE G6D, 80, 95, 113, 100, 114
        MOVE G6A,114,  81, 144,  85,  96
        '   MOVE G6C,35
        '  MOVE G6B,55
        WAIT


        GOTO 집고_전진보행50_3	

    ENDIF


    '*******************************


집고_전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 161, 105, 112
    MOVE G6D,110,  78, 144,  85,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '왼발중심이동
    MOVE G6A,110,  76, 144, 93,  94
    MOVE G6D,90, 93, 153,  64, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고_전진보행50_2

    IF A = 47 THEN	'▲
        GOTO 집고_전진보행50_2
    ELSEIF A = 49 THEN	'▶
        GOTO 집고_오른쪽전진보행50_2
    ELSEIF A = 48 THEN	'◀
        GOTO 집고_왼쪽전진보행50_2
    ELSE
        GOSUB Leg_motor_mode3
        '오른발들기10
        SPEED 11
        MOVE G6A,113,  76, 145,  93, 91,100
        MOVE G6D,85, 100, 98, 115, 109,100
        '        MOVE G6B,55
        '        MOVE G6C,35
        WAIT

        '왼쪽기울기2
        SPEED 7
        MOVE G6A, 104,  76, 144,  93,  93,100		
        MOVE G6D,  85,  71, 150,  91, 100,100
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT	

        SPEED 3
        MOVE G6A,95,  76, 143,  93, 95, 100
        MOVE G6D,95,  76, 143,  93, 95, 100
        WAIT

        SPEED 3
        GOSUB 집고안정화자세
        'GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF



집고_전진보행50_2:
    '오른발들기10
    MOVE G6A,112,  77, 144,  93, 89,100
    MOVE G6D,90, 100, 103, 110, 109,100
    '    MOVE G6B,55
    '    MOVE G6C,35
    WAIT


    '**********


집고_전진보행50_3:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,85,  44, 161, 105, 112
    MOVE G6A,110,  78, 144,  85,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '오른발중심이동
    MOVE G6D,110,  76, 144, 93,  94
    MOVE G6A, 90, 93, 153,  64, 112
    WAIT

    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고_전진보행50_4
    IF A = 47 THEN	'▲
        GOTO 집고_전진보행50_4
    ELSEIF A = 49 THEN	'▶
        GOTO 집고_오른쪽전진보행50_4
    ELSEIF A = 48 THEN	'◀
        GOTO 집고_왼쪽전진보행50_4
    ELSE
        GOSUB Leg_motor_mode3
        '왼발들기
        SPEED 11
        MOVE G6D,113,  76, 145,  93,  91,100
        MOVE G6A, 85, 100, 98, 115, 109,100
        '        MOVE G6B,35
        '        MOVE G6C,55
        WAIT

        '오른쪽기울기2
        SPEED 7
        MOVE G6D, 104,  76, 144,  93,  93,100		
        MOVE G6A,  85,  71, 150,  91, 100,100
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT

        SPEED 4
        MOVE G6A,95,  76, 143,  93, 95, 100
        MOVE G6D,95,  76, 143,  93, 95, 100
        WAIT

        SPEED 3
        GOSUB 집고안정화자세
        'GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

집고_전진보행50_4:

    '왼발들기10
    MOVE G6A, 90, 100, 103, 110, 109,100
    MOVE G6D,112,  77, 144,  93,  89,100
    '    MOVE G6B, 35
    '    MOVE G6C,55
    WAIT


    GOTO 집고_전진보행50_1
    '************************************************

집고_오른쪽전진보행50:
    넘어진확인 = 0
    J = 0
    보행속도 = 13
    좌우속도 = 5

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 5
        '오른쪽기울기
        MOVE G6A, 90,  71, 149,  91, 105
        MOVE G6D,106,  76, 143,  93,  96
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT

        SPEED 13'보행속도
        '왼발들기
        MOVE G6A, 80, 95, 112, 105, 114
        MOVE G6D,114,  76, 143,  93,  96
        '        MOVE G6B,35
        '        MOVE G6C,55
        WAIT


        GOTO 집고_오른쪽전진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 5
        '왼쪽기울기
        MOVE G6D,  90,  71, 149,  91, 105
        MOVE G6A, 106,  76, 143,  93,  96
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT

        SPEED 13
        '오른발들기
        MOVE G6D, 80, 95, 112, 105, 114
        MOVE G6A,114,  76, 143,  93,  96
        '        MOVE G6C,35
        '        MOVE G6B,55
        WAIT


        GOTO 집고_오른쪽전진보행50_3	

    ENDIF


    '*******************************


집고_오른쪽전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 160, 110, 112
    MOVE G6D,110,  78, 143,  90,  94
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,110,  76, 143, 98,  94
    MOVE G6D,90, 93, 152,  69, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정

    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고_오른쪽전진보행50_2
    IF A = 47 THEN	'▲
        GOTO 집고_전진보행50_2
    ELSEIF A = 49 THEN	'▶
        GOTO 집고_오른쪽전진보행50_2
    ELSEIF A = 48 THEN	'◀
        GOTO 집고_왼쪽전진보행50_2
    ELSE
        GOSUB Leg_motor_mode3
        '오른발들기10
        SPEED 11
        MOVE G6A,113,  76, 144,  93, 96,100
        MOVE G6D,85, 100, 97, 115, 114,100
        '        MOVE G6B,55
        '        MOVE G6C,35
        WAIT


        '왼쪽기울기2
        SPEED 7
        MOVE G6A, 104,  76, 143,  93,  98,100		
        MOVE G6D,  85,  71, 149,  91, 105,100
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT	

        SPEED 4
        MOVE G6A,95,  76, 142,  93, 100, 100
        MOVE G6D,95,  76, 142,  93, 100, 100
        WAIT
        GOSUB 집고안정화자세
        GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

집고_오른쪽전진보행50_2:
    SPEED 11
    '오른발들기10
    MOVE G6A,112,  77, 143,  93, 94,100
    MOVE G6D,90, 100, 102, 110, 114,100
    '    MOVE G6B,55
    '    MOVE G6C,35
    WAIT

    '**********


집고_오른쪽전진보행50_3:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,85,  44, 160, 110, 112
    MOVE G6A,110,  78, 143,  90,  94, 110
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '오른발중심이동
    MOVE G6D,110,  76, 143, 98,  94
    MOVE G6A, 90, 93, 152,  69, 112, 100
    WAIT

    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고_오른쪽전진보행50_4
    IF A = 47 THEN	'▲
        GOTO 집고_전진보행50_4
    ELSEIF A = 49 THEN	'▶
        GOTO 집고_오른쪽전진보행50_4
    ELSEIF A = 48 THEN	'◀
        GOTO 집고_왼쪽전진보행50_4
    ELSE
        GOSUB Leg_motor_mode3
        '왼발들기
        SPEED 11
        MOVE G6D,113,  76, 143,  93,  96,100
        MOVE G6A, 85, 100, 97, 115, 114,100
        '        MOVE G6B,35
        '        MOVE G6C,45
        WAIT

        SPEED 7
        '오른쪽기울기2
        MOVE G6D, 104,  76, 143,  93,  98,100		
        MOVE G6A,  85,  71, 149,  91, 105,100
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT	
        SPEED 4
        MOVE G6A,95,  76, 142,  93, 100, 100
        MOVE G6D,95,  76, 142,  93, 100, 100
        WAIT
        GOSUB 집고안정화자세
        GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

집고_오른쪽전진보행50_4:
    SPEED 11
    '왼발들기10
    MOVE G6A, 90, 100, 102, 110, 114,100
    MOVE G6D,112,  77, 143,  93,  94,100
    '    MOVE G6B,35
    '    MOVE G6C,55
    WAIT

    GOTO 집고_오른쪽전진보행50_1
    '*******************************
    '**********************************************

집고_왼쪽전진보행50:
    넘어진확인 = 0
    J = 0
    보행속도 = 13
    좌우속도 = 5


    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 5
        '오른쪽기울기
        MOVE G6A, 90,  71, 149,  91, 105
        MOVE G6D,106,  76, 143,  93,  96
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT

        SPEED 13
        '왼발들기
        MOVE G6A, 80, 95, 112, 105, 114
        MOVE G6D,114,  76, 143,  93,  96
        '        MOVE G6B,35
        '        MOVE G6C,55
        WAIT


        GOTO 집고_왼쪽전진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 5
        '왼쪽기울기
        MOVE G6D,  90,  71, 149,  91, 105
        MOVE G6A, 106,  76, 143,  93,  96
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT

        SPEED 13
        '오른발들기
        MOVE G6D, 80, 95, 112, 105, 114
        MOVE G6A,114,  76, 143,  93,  96
        '        MOVE G6C,35
        '        MOVE G6B,55
        WAIT


        GOTO 집고_왼쪽전진보행50_3	

    ENDIF


    '*******************************


집고_왼쪽전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 160, 110, 112, 110
    MOVE G6D,110,  78, 143,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '왼발중심이동
    MOVE G6A,110,  76, 143, 98,  94, 100
    MOVE G6D,90, 93, 152,  69, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정

    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고_왼쪽전진보행50_2
    IF A = 47 THEN	'▲
        GOTO 집고_전진보행50_2
    ELSEIF A = 49 THEN	'▶
        GOTO 집고_오른쪽전진보행50_2
    ELSEIF A = 48 THEN	'◀
        GOTO 집고_왼쪽전진보행50_2
    ELSE
        GOSUB Leg_motor_mode3

        '오른발들기10
        SPEED 11
        MOVE G6A,113,  76, 143,  93, 96,100
        MOVE G6D,85, 100, 97, 115, 114,100
        '        MOVE G6B,55
        '        MOVE G6C,35
        WAIT
        HIGHSPEED SETOFF

        '왼쪽기울기2
        SPEED 7
        MOVE G6A, 104,  76, 143,  93,  98,100		
        MOVE G6D,  85,  71, 149,  91, 105,100
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT	

        SPEED 4
        MOVE G6A,95,  76, 142,  93, 100, 100
        MOVE G6D,95,  76, 142,  93, 100, 100
        WAIT
        GOSUB 집고안정화자세
        GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

집고_왼쪽전진보행50_2:
    SPEED 11
    '오른발들기10
    MOVE G6A,112,  77, 143,  93, 94,100
    MOVE G6D,90, 100, 102, 110, 114,100
    '    MOVE G6B,55
    '    MOVE G6C,35
    WAIT
    '**********

집고_왼쪽전진보행50_3:

    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,85,  44, 160, 110, 112
    MOVE G6A,110,  78, 143,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode3
    '오른발중심이동
    MOVE G6D,110,  76, 143, 98,  94
    MOVE G6A, 90, 93, 152,  69, 112
    WAIT

    'SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정

    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 집고_왼쪽전진보행50_4
    IF A = 47 THEN	'▲
        GOTO 집고_전진보행50_4
    ELSEIF A = 49 THEN	'▶
        GOTO 집고_오른쪽전진보행50_4
    ELSEIF A = 48 THEN	'◀
        GOTO 집고_왼쪽전진보행50_4
    ELSE
        GOSUB Leg_motor_mode3
        '왼발들기
        SPEED 11
        MOVE G6D,113,  76, 143,  93,  96,100
        MOVE G6A, 85, 100, 97, 115, 114,100
        '        MOVE G6B,35
        '        MOVE G6C,55
        WAIT
        HIGHSPEED SETOFF


        '오른쪽기울기2
        SPEED 7
        MOVE G6D, 104,  76, 143,  93,  98,100		
        MOVE G6A,  85,  71, 149,  91, 105,100
        '        MOVE G6B,45,55
        '        MOVE G6C,45,55
        WAIT	
        SPEED 4
        MOVE G6A,95,  76, 142,  93, 100, 100
        MOVE G6D,95,  76, 142,  93, 100, 100
        WAIT
        GOSUB 집고안정화자세
        GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

집고_왼쪽전진보행50_4:
    SPEED 9
    '왼발들기10
    MOVE G6A, 90, 100, 102, 110, 114,100
    MOVE G6D,112,  77, 143,  93,  94,100
    '    MOVE G6B, 35
    '    MOVE G6C,55
    WAIT

    GOTO 집고_왼쪽전진보행50_1
    '*******************************
    '************************************************

    '**********************************************
실시간_전진보행50:
    J = 0
    넘어진확인 = 0
    보행속도 = 11'5
    좌우속도 = 4'8'3

    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,3,3,3,3,2,3
    MOTORMODE G6D,3,3,3,3,2,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 3
        '오른쪽기울기
        MOVE G6A, 90,  71, 152,  91, 105
        MOVE G6D,106,  76, 146,  93,  96
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 10'보행속도
        '왼발들기
        MOVE G6A, 80, 95, 115, 105, 114
        MOVE G6D,114,  76, 146,  93,  96
        MOVE G6B,35
        MOVE G6C,55
        WAIT


        GOTO 실시간_전진보행50_1	
    ELSE
        보행순서 = 0
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
        SPEED 3
        '왼쪽기울기
        MOVE G6D,  90,  71, 152,  91, 105
        MOVE G6A, 106,  76, 146,  93,  96
        MOVE G6C, 45,55
        MOVE G6B, 45,55
        WAIT

        SPEED 10'보행속도
        '오른발들기
        MOVE G6D, 80, 95, 115, 105, 114
        MOVE G6A,114,  76, 146,  93,  96
        MOVE G6C,35
        MOVE G6B,55
        WAIT


        GOTO 실시간_전진보행50_3	

    ENDIF


    '*******************************


실시간_전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 163, 110, 112
    MOVE G6D,110,  78, 146,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '왼발중심이동
    MOVE G6A,110,  76, 146, 98,  94
    MOVE G6D,90, 93, 155,  69, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    ' ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 실시간_전진보행50_2

    IF A = 44 THEN	'▲
        GOTO 실시간_전진보행50_2
    ELSEIF A = 45 THEN	'▶
        GOTO 실시간_오른쪽전진보행50_2
    ELSEIF A = 46 THEN	'◀
        GOTO 실시간_왼쪽전진보행50_2
    ELSE
        GOSUB Leg_motor_mode3
        '오른발들기10
        SPEED 10
        MOVE G6A,113,  76, 147,  93, 96,100
        MOVE G6D,85, 100, 100, 115, 114,100
        MOVE G6B,55
        MOVE G6C,35
        WAIT

        '왼쪽기울기2
        SPEED 6
        MOVE G6A, 104,  76, 146,  93,  98,100		
        MOVE G6D,  85,  71, 152,  91, 105,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT	

        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT

        SPEED 2
        GOSUB 기본자세
        'GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF



실시간_전진보행50_2:
    '오른발들기10
    MOVE G6A,112,  77, 146,  93, 94,100
    MOVE G6D,90, 100, 105, 110, 114,100
    MOVE G6B,55
    MOVE G6C,35
    WAIT


    '**********


실시간_전진보행50_3:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,85,  44, 163, 110, 112
    MOVE G6A,110,  78, 146,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '오른발중심이동
    MOVE G6D,110,  76, 146, 98,  94
    MOVE G6A, 90, 93, 155,  69, 112
    WAIT

    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    ' ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 실시간_전진보행50_4
    IF A = 44 THEN	'▲
        GOTO 실시간_전진보행50_4
    ELSEIF A = 46 THEN	'▶
        GOTO 실시간_왼쪽전진보행50_4
    ELSEIF A = 45 THEN	'◀
        GOTO 실시간_오른쪽전진보행50_4
    ELSE
        GOSUB Leg_motor_mode3
        '왼발들기
        SPEED 10
        MOVE G6D,113,  76, 147,  93,  96,100
        MOVE G6A, 85, 100, 100, 115, 114,100
        MOVE G6B,35
        MOVE G6C,55
        WAIT

        '오른쪽기울기2
        SPEED 6
        MOVE G6D, 104,  76, 146,  93,  98,100		
        MOVE G6A,  85,  71, 152,  91, 105,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT

        SPEED 2
        GOSUB 기본자세
        'GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

실시간_전진보행50_4:

    '왼발들기10
    MOVE G6A, 90, 100, 105, 110, 114,100
    MOVE G6D,112,  77, 146,  93,  94,100
    MOVE G6B, 35
    MOVE G6C,55
    WAIT


    GOTO 실시간_전진보행50_1
    '************************************************

    '**********************************************


실시간_왼쪽전진보행50:
    J = 0
    넘어진확인 = 0
    보행속도 = 11'5
    좌우속도 = 4'8'3

    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,3,3,3,3,2,3
    MOTORMODE G6D,3,3,3,3,2,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 3
        '오른쪽기울기
        MOVE G6A, 90,  71, 152,  91, 105
        MOVE G6D,106,  76, 146,  93,  96
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 10'보행속도
        '왼발들기
        MOVE G6A, 80, 95, 115, 105, 114
        MOVE G6D,114,  76, 146,  93,  96
        MOVE G6B,35
        MOVE G6C,55
        WAIT


        GOTO 실시간_왼쪽전진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 3
        '왼쪽기울기
        MOVE G6D,  90,  71, 152,  91, 105
        MOVE G6A, 106,  76, 146,  93,  96
        MOVE G6C, 45,55
        MOVE G6B, 45,55
        WAIT

        SPEED 10'보행속도
        '오른발들기
        MOVE G6D, 80, 95, 115, 105, 114
        MOVE G6A,114,  76, 146,  93,  96
        MOVE G6C,35
        MOVE G6B,55
        WAIT


        GOTO 실시간_왼쪽전진보행50_3	

    ENDIF


    '*******************************


실시간_왼쪽전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 163, 110, 112, 110
    MOVE G6D,110,  78, 146,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '왼발중심이동
    MOVE G6A,110,  76, 146, 98,  94, 100
    MOVE G6D,90, 93, 155,  69, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 실시간_왼쪽전진보행50_2

    IF A = 44 THEN	'▲
        GOTO 실시간_전진보행50_2
    ELSEIF A = 45 THEN	'▶
        GOTO 실시간_오른쪽전진보행50_2
    ELSEIF A = 46 THEN	'◀
        GOTO 실시간_왼쪽전진보행50_2
    ELSE
        GOSUB Leg_motor_mode3
        '오른발들기10
        SPEED 10
        MOVE G6A,113,  76, 147,  93, 96,100
        MOVE G6D,85, 100, 100, 115, 114,100
        MOVE G6B,55
        MOVE G6C,35
        WAIT

        '왼쪽기울기2
        SPEED 6
        MOVE G6A, 104,  76, 146,  93,  98,100		
        MOVE G6D,  85,  71, 152,  91, 105,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT	

        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT

        SPEED 2
        GOSUB 기본자세
        'GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF



실시간_왼쪽전진보행50_2:
    '오른발들기10
    MOVE G6A,112,  77, 146,  93, 94,100
    MOVE G6D,90, 100, 105, 110, 114,100
    MOVE G6B,55
    MOVE G6C,35
    WAIT


    '**********


실시간_왼쪽전진보행50_3:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,85,  44, 163, 110, 112
    MOVE G6A,110,  78, 146,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '오른발중심이동
    MOVE G6D,110,  76, 146, 98,  94
    MOVE G6A, 90, 93, 155,  69, 112
    WAIT

    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 실시간_왼쪽전진보행50_4
    IF A = 44 THEN	'▲
        GOTO 실시간_전진보행50_4
    ELSEIF A = 45 THEN	'▶
        GOTO 실시간_오른쪽전진보행50_4
    ELSEIF A = 46 THEN	'◀
        GOTO 실시간_왼쪽전진보행50_4
    ELSE
        GOSUB Leg_motor_mode3
        '왼발들기
        SPEED 10
        MOVE G6D,113,  76, 147,  93,  96,100
        MOVE G6A, 85, 100, 100, 115, 114,100
        MOVE G6B,35
        MOVE G6C,55
        WAIT

        '오른쪽기울기2
        SPEED 6
        MOVE G6D, 104,  76, 146,  93,  98,100		
        MOVE G6A,  85,  71, 152,  91, 105,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT

        SPEED 2
        GOSUB 기본자세
        'GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

실시간_왼쪽전진보행50_4:

    '왼발들기10
    MOVE G6A, 90, 100, 105, 110, 114,100
    MOVE G6D,112,  77, 146,  93,  94,100
    MOVE G6B, 35
    MOVE G6C,55
    WAIT


    GOTO 실시간_왼쪽전진보행50_1

    '**********************************
실시간_오른쪽전진보행50:
    J = 0
    넘어진확인 = 0
    보행속도 = 11'5
    좌우속도 = 4'8'3

    'GOSUB Leg_motor_mode3
    MOTORMODE G6A,3,3,3,3,2,3
    MOTORMODE G6D,3,3,3,3,2,3
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 3
        '오른쪽기울기
        MOVE G6A, 90,  71, 152,  91, 105
        MOVE G6D,106,  76, 146,  93,  96
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 10'보행속도
        '왼발들기
        MOVE G6A, 80, 95, 115, 105, 114
        MOVE G6D,114,  76, 146,  93,  96
        MOVE G6B,35
        MOVE G6C,55
        WAIT


        GOTO 실시간_오른쪽전진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 3
        '왼쪽기울기
        MOVE G6D,  90,  71, 152,  91, 105
        MOVE G6A, 106,  76, 146,  93,  96
        MOVE G6C, 45,55
        MOVE G6B, 45,55
        WAIT

        SPEED 10'보행속도
        '오른발들기
        MOVE G6D, 80, 95, 115, 105, 114
        MOVE G6A,114,  76, 146,  93,  96
        MOVE G6C,35
        MOVE G6B,55
        WAIT


        GOTO 실시간_오른쪽전진보행50_3	

    ENDIF


    '*******************************


실시간_오른쪽전진보행50_1:

    SPEED 보행속도
    '왼발뻣어착지
    MOVE G6A, 85,  44, 163, 110, 112
    MOVE G6D,110,  78, 146,  90,  94
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '왼발중심이동
    MOVE G6A,110,  76, 146, 98,  94
    MOVE G6D,90, 93, 155,  69, 112
    WAIT


    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 실시간_오른쪽전진보행50_2

    IF A = 44 THEN	'▲
        GOTO 실시간_전진보행50_2
    ELSEIF A = 45 THEN	'▶
        GOTO 실시간_오른쪽전진보행50_2
    ELSEIF A = 46 THEN	'◀
        GOTO 실시간_왼쪽전진보행50_2
    ELSE
        GOSUB Leg_motor_mode3
        '오른발들기10
        SPEED 10
        MOVE G6A,113,  76, 147,  93, 96,100
        MOVE G6D,85, 100, 100, 115, 114,100
        MOVE G6B,55
        MOVE G6C,35
        WAIT

        '왼쪽기울기2
        SPEED 6
        MOVE G6A, 104,  76, 146,  93,  98,100		
        MOVE G6D,  85,  71, 152,  91, 105,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT	

        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT

        SPEED 2
        GOSUB 기본자세
        'GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF



실시간_오른쪽전진보행50_2:
    '오른발들기10
    MOVE G6A,112,  77, 146,  93, 94,100
    MOVE G6D,90, 100, 105, 110, 114,100
    MOVE G6B,55
    MOVE G6C,35
    WAIT


    '**********


실시간_오른쪽전진보행50_3:


    SPEED 보행속도
    '오른발뻣어착지
    MOVE G6D,85,  44, 163, 110, 112
    MOVE G6A,110,  78, 146,  90,  94, 110
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode2
    '오른발중심이동
    MOVE G6D,110,  76, 146, 98,  94
    MOVE G6A, 90, 93, 155,  69, 112, 100
    WAIT

    SPEED 보행속도
    GOSUB Leg_motor_mode2

    J = J + 1
    '    ETX 4800,J
    GOSUB 앞뒤기울기측정


    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 실시간_오른쪽전진보행50_4
    IF A = 44 THEN	'▲
        GOTO 실시간_전진보행50_4
    ELSEIF A = 45 THEN	'▶
        GOTO 실시간_오른쪽전진보행50_4
    ELSEIF A = 46 THEN	'◀
        GOTO 실시간_왼쪽전진보행50_4
    ELSE
        GOSUB Leg_motor_mode3
        '왼발들기
        SPEED 10
        MOVE G6D,113,  76, 147,  93,  96,100
        MOVE G6A, 85, 100, 100, 115, 114,100
        MOVE G6B,35
        MOVE G6C,55
        WAIT

        '오른쪽기울기2
        SPEED 6
        MOVE G6D, 104,  76, 146,  93,  98,100		
        MOVE G6A,  85,  71, 152,  91, 105,100
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        SPEED 3
        MOVE G6A,95,  76, 145,  93, 100, 100
        MOVE G6D,95,  76, 145,  93, 100, 100
        WAIT

        SPEED 2
        GOSUB 기본자세
        'GOSUB Leg_motor_mode1
        GOTO RX_EXIT
    ENDIF

실시간_오른쪽전진보행50_4:

    '왼발들기10
    MOVE G6A, 90, 100, 105, 110, 114,100
    MOVE G6D,112,  77, 146,  93,  94,100
    MOVE G6B, 35
    MOVE G6C,55
    WAIT


    GOTO 실시간_오른쪽전진보행50_1
    '*******************************
    '************************************************
    '******************************************
전진종종걸음_플라스틱:
    J = 0
    넘어진확인 = 0
    GOSUB 자이로MID
    GOSUB 자이로ON
    SPEED 10
    HIGHSPEED SETON
    'GOSUB All_motor_mode3
    MOTORMODE G6A,3,2,2,2,2,1
    MOTORMODE G6D,3,2,2,2,2,1
    MOTORMODE G6B,3,3,3, , ,3
    MOTORMODE G6C,3,3,3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B, 45,  55
        MOVE G6C,45,  55
        WAIT

        GOTO 전진종종걸음_1_플라스틱
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B, 45,  55
        MOVE G6C,45,  55
        WAIT

        GOTO 전진종종걸음_4_플라스틱
    ENDIF


    '**********************

전진종종걸음_1_플라스틱:
    SPEED 10
    MOVE G6A,95,  87, 120, 100, 104,100
    MOVE G6D,104,  77, 146,  91,  102,100
    MOVE G6B, 25
    MOVE G6C,65
    WAIT
    J = J + 1


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF
    ERX 4800,A, 전진종종걸음_3_플라스틱
    IF A > 0 THEN  GOTO 전진종종걸음_멈춤_플라스틱


전진종종걸음_3_플라스틱:
    SPEED 10
    MOVE G6A,103,   85, 130, 103,  100
    MOVE G6D, 95,  89, 146,  80, 102
    WAIT


    '*********************************

전진종종걸음_4_플라스틱:
    SPEED 10
    MOVE G6D,95,  87, 120, 100, 104,100
    MOVE G6A,104,  77, 146,  91,  102,100
    MOVE G6C, 25
    MOVE G6B,65
    WAIT
    J = J + 1




전진종종걸음_6_플라스틱:
    SPEED 10
    MOVE G6D,103,   85, 130, 103,  100
    MOVE G6A, 95,  89, 146,  80, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 전진종종걸음_1_플라스틱
    IF A > 0 THEN  GOTO 전진종종걸음_멈춤_플라스틱


    GOTO 전진종종걸음_1_플라스틱


전진종종걸음_멈춤_플라스틱:
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세

    DELAY 400

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '************************************************
후진보행50:
    넘어진확인 = 0
    J = 0
    보행속도 = 12'6
    좌우속도 = 6'3
    좌우속도2 = 4'2
    GOSUB Leg_motor_mode3



    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        '오른쪽기울기
        MOVE G6A, 88,  71, 152,  88, 110
        MOVE G6D,104,  76, 146,  90,  96
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT

        'HIGHSPEED SETON
        SPEED 8'보행속도
        '왼발들기
        MOVE G6A, 80, 95, 115, 102, 114
        MOVE G6D,113,  76, 146,  90,  96
        MOVE G6B,35
        MOVE G6C,55
        WAIT

        GOTO 후진보행50_1	
    ELSE
        보행순서 = 0

        SPEED 4
        '왼쪽기울기
        MOVE G6D,  88,  71, 152,  88, 110
        MOVE G6A, 104,  76, 146,  90,  96
        MOVE G6C, 45,55
        MOVE G6B, 45,55
        WAIT

        'HIGHSPEED SETON
        SPEED 8'보행속도
        '오른발들기
        MOVE G6D, 80, 95, 115, 102, 114
        MOVE G6A,113,  76, 146,  90,  96
        MOVE G6C,35
        MOVE G6B,55
        WAIT

        GOTO 후진보행50_2

    ENDIF


후진보행50_1:
    SPEED 보행속도
    GOSUB Leg_motor_mode2
    '오른발중심이동
    MOVE G6D,108,  76, 146, 93,  95
    MOVE G6A, 90, 93, 155,  64, 110,101
    WAIT

    SPEED 좌우속도2
    GOSUB Leg_motor_mode3
    '오른발뻣어착지
    MOVE G6D,88,  46, 158, 107, 114,97
    MOVE G6A,110,  76, 146,  90,  95
    WAIT

    J = J + 1
    ETX 4800,J

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 보행속도
    '오른발들기10
    MOVE G6A,113,  76, 146,  90, 95
    MOVE G6D,80, 100, 105, 105, 114
    MOVE G6B,55
    MOVE G6C,35
    WAIT

    ERX 4800,A, 후진보행50_2
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '왼쪽기울기2
        MOVE G6A, 106,  77, 148,  88,  96,97		
        MOVE G6D,  88,  72, 154,  88, 106
        MOVE G6B,45,55
        MOVE G6C,45,55
        WAIT	

        SPEED 3
        MOVE G6A,95,  76, 145,  90, 100, 100
        MOVE G6D,95,  76, 145,  90, 100, 100
        WAIT
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        ' GOSUB 자이로OFF
        GOTO RX_EXIT
    ENDIF
    '**********

후진보행50_2:
    SPEED 보행속도
    GOSUB Leg_motor_mode2
    '왼발중심이동
    MOVE G6A,108,  76, 146, 93,  95
    MOVE G6D,90, 93, 155,  64, 110,101
    WAIT

    SPEED 좌우속도2
    GOSUB Leg_motor_mode3
    '왼발뻣어착지
    MOVE G6A, 88,  46, 158, 107, 114,96
    MOVE G6D,110,  76, 146,  90,  95
    WAIT

    J = J + 1
    ETX 4800,J

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 보행속도
    '왼발들기10
    MOVE G6A, 80, 100, 105, 110, 114
    MOVE G6D,113,  76, 146,  93,  95
    MOVE G6B, 35
    MOVE G6C,55
    WAIT

    ERX 4800,A, 후진보행50_1
    IF A <> A_old THEN
        HIGHSPEED SETOFF
        GOSUB Leg_motor_mode3
        SPEED 5

        '왼쪽기울기2
        MOVE G6D, 106,  77, 148,  88,  96,96		
        MOVE G6A,  88,  72, 154,  86, 106
        MOVE G6C, 45,55
        MOVE G6B, 45,55
        WAIT	

        SPEED 3
        MOVE G6A,95,  76, 145,  90, 100, 100
        MOVE G6D,95,  76, 145,  90, 100, 100
        WAIT
        GOSUB 기본자세
        GOSUB Leg_motor_mode1
        ' GOSUB 자이로OFF
        GOTO RX_EXIT
    ENDIF  	

    GOTO 후진보행50_1
    '**********************************************
IRC왼쪽1_천천히왼쪽옆으로50:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6A, 80,  80, 140, 95, 114, 100
    MOVE G6D,108,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 70,  72, 160,  82, 128,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6A,92,  76, 145,  93, 108, 100
    MOVE G6D,92,  76, 145,  93, 108, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 70,  72, 160,  82, 120,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6D, 85,  80, 130, 100, 110, 100
    MOVE G6A,112,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 152,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,97,  76, 145,  93, 98, 100
    MOVE G6D,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
IRC오른쪽1_천천히오른쪽옆으로50:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D, 80,  80, 140, 95, 114, 100
    MOVE G6A,108,  76, 146,  93, 98, 100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 70,  72, 160,  82, 128,  100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D,92,  76, 145,  93, 108, 100
    MOVE G6A,92,  76, 145,  93, 108, 100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 70,  72, 160,  82, 120,  100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6A, 85,  80, 130, 100, 110, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,97,  76, 145,  93, 98, 100
    MOVE G6D,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
    '**************************

IRC왼쪽2_천천히왼쪽옆으로50_수정:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6A, 80,  80, 140, 95, 114, 100
    MOVE G6D,108,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 70,  75, 150,  82, 128,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6A,92,  76, 145,  93, 108, 98
    MOVE G6D,92,  76, 145,  93, 108, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 70,  75, 150,  82, 120,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6D, 85,  80, 130, 100, 110, 100
    MOVE G6A,112,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 145,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,97,  76, 145,  93, 98, 100
    MOVE G6D,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
IRC오른쪽2_천천히오른쪽옆으로50_수정:


    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D, 80,  80, 140, 95, 114, 100
    MOVE G6A,108,  76, 146,  93, 98, 100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 70,  75, 150,  82, 128,  100
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6D,92,  76, 145,  93, 108, 98
    MOVE G6A,92,  76, 145,  93, 108, 100
    MOVE G6C,45,  60,  110
    MOVE G6B,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 70,  75, 150,  82, 120,  100
    MOVE G6C,45,  60,  110, , , ,
    MOVE G6B,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6A, 85,  80, 130, 100, 110, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 145,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6D,97,  76, 145,  93, 98, 100
    MOVE G6A,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세


    GOTO RX_EXIT

    '**********************************************
IRC왼쪽3_천천히왼쪽옆으로50_앞으로안가게:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6A, 80,  80, 140, 95, 114, 101
    MOVE G6D,108,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 70,  80, 145,  82, 128,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6A,92,  80, 145,  93, 108, 100
    MOVE G6D,92,  76, 145,  93, 108, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 70,  75, 150,  82, 120,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6D, 85,  82, 130, 98, 110, 100
    MOVE G6A,112,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 145,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,97,  76, 145,  93, 98, 100
    MOVE G6D,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
IRC오른쪽3_천천히오른쪽옆으로50_앞으로안가게:


    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D, 80,  80, 140, 95, 114, 101
    MOVE G6A,108,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  100
    MOVE G6D, 70,  80, 145,  82, 128,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6D,92,  80, 145,  93, 108, 100
    MOVE G6A,92,  76, 145,  93, 108, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  100
    MOVE G6A, 70,  75, 150,  82, 120,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6A, 85,  82, 130, 98, 110, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 145,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6D,97,  76, 145,  93, 98, 100
    MOVE G6A,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
IRC왼쪽4_천천히왼쪽옆으로50_조금만:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6A, 80,  80, 140, 95, 114, 101
    MOVE G6D,108,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D,108,  76, 146,  93, 98, 100
    MOVE G6A, 80,  70, 150,  90, 113,  102
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6A,92,  80, 145,  93, 108, 102
    MOVE G6D,92,  76, 145,  93, 108, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6A,108,  76, 146,  93, 98, 100
    MOVE G6D, 80,  70, 150,  90, 113,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6D, 85,  82, 130, 98, 110, 100
    MOVE G6A,112,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 145,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,97,  76, 145,  93, 98, 100
    MOVE G6D,97,  76, 145,  93, 98, 100
    WAIT

    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
IRC오른쪽4_천천히오른쪽옆으로50_조금만:


    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D, 80,  80, 140, 95, 114, 101
    MOVE G6A,108,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6A,108,  76, 146,  93, 98, 100
    MOVE G6D, 80,  70, 150,  90, 113,  102
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6D,92,  80, 145,  93, 108, 102
    MOVE G6A,92,  76, 145,  93, 108, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6D,108,  76, 146,  93, 98, 100
    MOVE G6A, 80,  70, 150,  90, 113,  100
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6A, 85,  82, 130, 98, 110, 100
    MOVE G6D,112,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 145,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6D,97,  76, 145,  93, 98, 100
    MOVE G6A,97,  76, 145,  93, 98, 100
    WAIT

    GOSUB 기본자세

    GOTO RX_EXIT

    '************************************************
우유팩던지기:
    GOSUB All_motor_mode3


    SPEED 5
    MOVE G6A,100,  72, 110,  145, 100
    MOVE G6D,100,  72, 110,  145, 100
    MOVE G6B,75,40,80
    MOVE G6C,75,40,80
    WAIT

    SPEED 12
    MOVE G6A,100,  72, 138,  100, 100
    MOVE G6D,100,  72, 138,  100, 100
    MOVE G6B,135,40,110
    MOVE G6C,135,40,110
    WAIT

    SPEED 10
    MOVE G6B,100,  60,  120
    MOVE G6C,100,  60,  120
    WAIT

    SPEED 4
    MOVE G6A,100,  74, 145,  93, 100
    MOVE G6D,100,  74, 145,  93, 100
    MOVE G6B,45,  55,  110
    MOVE G6C,45,  55,  110
    WAIT

    GOSUB All_motor_Reset
    RETURN
    '************************************************
우유팩던지기2:
    GOSUB All_motor_mode3


    SPEED 5
    MOVE G6A,100,  76, 115,  118, 100
    MOVE G6D,100,  76, 115,  118, 100
    MOVE G6B,180,  30,  105'30->27
    MOVE G6C,180,  30,  105
    WAIT

    SPEED 12
    MOVE G6A,100,  74, 145,  105, 100
    MOVE G6D,100,  74, 145,  105, 100
    MOVE G6B,155,40,110
    MOVE G6C,155,40,110
    WAIT

    SPEED 4
    MOVE G6A,100,  76, 145,  93, 100
    MOVE G6D,100,  76, 145,  93, 100
    MOVE G6B,45,  55,  110
    MOVE G6C,45,  55,  110
    WAIT

    GOSUB All_motor_Reset
    RETURN
    '************************************************
캔쓰러뜨리기:
    GOSUB All_motor_mode3
    GOSUB 자이로OFF

    SPEED 5
    MOVE G6A,100,  92, 108,  155, 100
    MOVE G6D,100,  12, 188,  155, 100
    ' MOVE G6A,100,  25, 188,  155, 100
    ' MOVE G6D,100,  25, 188,  155, 100
    MOVE G6B,85,  82,  110, 100, 100, 100
    MOVE G6C,45,  52,  110, 100, 100, 100
    WAIT

    SPEED 5
    MOVE G6A,100,  92, 108,  155, 100
    MOVE G6D,100,  12, 188,  155, 100
    WAIT

    SPEED 6
    MOVE G6A,100,  92, 108,  155, 100
    MOVE G6D,100,  12, 188,  155, 100
    ' MOVE G6A,100,  25, 188,  155, 100
    ' MOVE G6D,100,  25, 188,  155, 100
    MOVE G6B,115,  20,  120
    MOVE G6C,45,  52,  110,
    WAIT

    GOSUB 안정화자세
    GOSUB 자이로ON
    GOSUB All_motor_Reset
    RETURN
    '**********************************************
왼쪽3_천천히왼쪽옆으로50_앞으로안가게:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, '60
    MOVE G6D,108,  76, 146,  93,  92, '60
    MOVE G6B,50,  65,  110
    MOVE G6C,50,  65,  110
    WAIT

    SPEED 5
    MOVE G6A, 80,  80, 140, 95, 114, 87
    MOVE G6D,108,  76, 146,  93, 98, 100
    MOVE G6B,50,  65,  110
    MOVE G6C,50,  65,  110
    WAIT


    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  87
    MOVE G6A, 70,  80, 145,  82, 128,  90
    MOVE G6B,50,  65,  110
    MOVE G6C,50,  65,  110
    WAIT

    SPEED 5
    MOVE G6A,92,  80, 145,  93, 108, 92
    MOVE G6D,92,  76, 145,  93, 108, 92
    MOVE G6B,50,  65,  110
    MOVE G6C,50,  65,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  92
    MOVE G6D, 70,  75, 150,  82, 120,  95
    MOVE G6B,50,  65,  110
    MOVE G6C,50,  65,  110
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6D, 85,  82, 130, 98, 110,92
    MOVE G6A,112,  76, 146,  93, 98, 95
    MOVE G6B,50,  65,  110
    MOVE G6C,50,  65,  110
    WAIT

    SPEED 4
    MOVE G6A, 106,  76, 146,  93,  96,92		
    MOVE G6D,  88,  71, 145,  91, 106,92
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,97,  76, 145,  93, 98, 100
    MOVE G6D,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**********************************************
오른쪽3_천천히오른쪽옆으로50_앞으로안가게:


    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6D, 88,  71, 152,  91, 110, '60
    MOVE G6A,108,  76, 146,  93,  92, '60
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D, 80,  80, 140, 95, 114, 87
    MOVE G6A,108,  76, 146,  93, 98, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6A,110,  92, 124,  97,  93,  87
    MOVE G6D, 70,  80, 145,  82, 128,  90
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6D,92,  80, 145,  93, 108, 92
    MOVE G6A,92,  76, 145,  93, 108, 92
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT	
    '***********************
    SPEED 5
    MOVE G6D,110,  92, 124,  97,  93,  92
    MOVE G6A, 70,  75, 150,  82, 120,  95
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6A, 85,  82, 130, 98, 110, 92
    MOVE G6D,112,  76, 146,  93, 98, 95
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6D, 106,  76, 146,  93,  96,92		
    MOVE G6A,  88,  71, 145,  91, 106,92
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT	
    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6D,97,  76, 145,  93, 98, 100
    MOVE G6A,97,  76, 145,  93, 98, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**************************************************

IRC왼쪽3_중심회전_개조:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6A, 88,  71, 152,  91, 110, 100
    MOVE G6D,108,  76, 146,  93,  92, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6A, 80,  80, 140, 95, 114, 95
    MOVE G6D,108,  76, 146,  93, 98, 95
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6D,110,  92, 124,  97,  95,  93
    MOVE G6A, 73,  72, 155,  90, 125,  90
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6A,90,  77, 145,  95, 107, 95
    MOVE G6D,85,  77, 145,  95, 115, 90
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT
    '***********************
    SPEED 5
    MOVE G6A,110,  92, 124,  97,  95,  92
    MOVE G6D, 73,  70, 155,  90, 125,  93
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6D, 80,  76, 140, 95, 114, 95
    MOVE G6A,108,  76, 146,  93, 98, 95
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6A, 106,  76, 146,  93,  96,100
    MOVE G6D,  88,  76, 145,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6A,97,  76, 145,  93, 100, 100
    MOVE G6D,97,  76, 145,  93, 100, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**************************************************

IRC오른쪽3_중심회전_개조:

    GOSUB Leg_motor_mode3
    GOSUB Arm_motor_mode3

    SPEED 3
    MOVE G6D, 88,  71, 152,  91, 110, 100
    MOVE G6A,108,  76, 146,  93,  92, 100
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 5
    MOVE G6D, 80,  80, 140, 95, 114, 95
    MOVE G6A,108,  76, 146,  93, 98, 95
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT


    SPEED 5
    MOVE G6A,110,  92, 124,  97,  95,  93
    MOVE G6D, 73,  72, 155,  90, 125,  90
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    SPEED 5
    MOVE G6D,90,  77, 145,  95, 107, 95
    MOVE G6A,85,  77, 145,  95, 115, 90
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT
    '***********************
    SPEED 5
    MOVE G6D,110,  92, 124,  97,  95,  92
    MOVE G6A, 73,  70, 155,  90, 125,  93
    MOVE G6B,45,  60,  110, , , ,
    MOVE G6C,45,  60,  110, , , ,
    WAIT

    GOSUB Leg_motor_mode5
    SPEED 6
    MOVE G6A, 80,  76, 140, 95, 114, 95
    MOVE G6D,108,  76, 146,  93, 98, 95
    MOVE G6B,45,  60,  110
    MOVE G6C,45,  60,  110
    WAIT

    SPEED 4
    MOVE G6D, 106,  76, 146,  93,  96,100
    MOVE G6A,  88,  76, 145,  91, 106,100
    MOVE G6B,45,50
    MOVE G6C,45,50
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 3
    MOVE G6D,97,  76, 145,  93, 100, 100
    MOVE G6A,97,  76, 145,  93, 100, 100
    WAIT
    GOSUB 기본자세

    GOTO RX_EXIT

    '**************************************************


MAIN: '라벨설정

    'GOSUB LOW_Voltage
    GOSUB 앞뒤기울기측정
    GOSUB 모터ONOFF_LED

    ERX 4800,A,MAIN

    A_old = A

    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************

    IF A = 1 THEN
        GOTO 전진달리기50_좌회전A
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 2 THEN
        GOTO 전진달리기50_직진
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 3 THEN
        GOTO 전진달리기50_우회전A
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 4 THEN
        GOSUB 물건집기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 5 THEN
        'GOSUB 플라스틱잡기
        GOSUB 캔집기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 6 THEN

        'GOSUB 물건놓기
        GOSUB 왼발앞모으기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 7 THEN

        GOSUB IRC왼쪽3_천천히왼쪽옆으로50_앞으로안가게
        ' GOSUB 왼쪽옆으로_중심따라_70
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 8 THEN
        IF 자세 = 3 THEN
            GOSUB 정면보기
        ELSE
            GOSUB 내려다보기
        ENDIF

        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 9 THEN

        GOSUB IRC오른쪽3_천천히오른쪽옆으로50_앞으로안가게
        ' 집고내려다보기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 10 THEN '0
        GOSUB 물건모으기
        'GOTO 플라스틱집고달리기
        ' GOSUB 플라스틱모으기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 11 THEN ' ▲
        GOSUB 플라스틱모으기

        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 12 THEN ' ▼
        GOTO 젓히고_왼쪽골반턴20
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 13 THEN '▶
        '        GOSUB 캔모으기
        GOTO 집고_오른쪽전진보행50
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 14 THEN ' ◀
        GOTO 집고_왼쪽전진보행50
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 15 THEN ' A

        GOSUB 왼쪽골반턴40
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 16 THEN ' POWER
        GOSUB IRC오른쪽3_중심회전_개조
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 17 THEN ' C
        GOSUB 집고왼쪽골반턴40
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 18 THEN ' E
        GOSUB 왼발공차기
        ' GOSUB 오른발공차기2


        GOTO RX_EXIT

        '*******************************************


    ELSEIF A = 19 THEN ' P2
        GOSUB IRC왼쪽3_중심회전_개조
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 20 THEN ' B	

        GOSUB 오른쪽골반턴40
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 21 THEN ' △
        GOSUB  왼쪽골반턴90
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 22 THEN ' *	

        GOSUB IRC왼쪽4_천천히왼쪽옆으로50_조금만
        'GOSUB 왼쪽옆으로20
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 23 THEN ' G
        GOSUB 오른발공차기
        'GOSUB 캔차기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 24 THEN ' #

        GOSUB IRC오른쪽4_천천히오른쪽옆으로50_조금만

        'GOSUB 오른쪽옆으로20
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 25 THEN ' P1
        '        GOSUB 캔모으기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 26 THEN ' ■
        GOSUB 기본자세
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 27 THEN ' D

        GOSUB 집고오른쪽골반턴40
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 28 THEN ' ◁
        GOTO 오른쪽골반턴40
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 29 THEN ' □
        'GOSUB 캔쓰러뜨리기
        GOSUB 오른쪽골반턴90
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 30 THEN ' ▷
        GOTO 오른쪽골반턴60
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 31 THEN ' ▽
        GOSUB 한발자국전진
        GOTO RX_EXIT

        '*******************************************

    ELSEIF A = 32 THEN ' F
        GOSUB 우유팩던지기
        GOTO RX_EXIT

        '*******************************************
        '여기서서부터 리모콘 밖

    ELSEIF A = 40 THEN
        GOSUB 왼쪽보기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 41 THEN
        GOSUB 가운데보기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 42 THEN
        GOSUB 오른쪽보기
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 43 THEN ' ▼
        GOTO 후진보행50
        GOTO RX_EXIT
        '*******************************************
    ELSEIF A = 44 THEN ' ▲

        GOTO 실시간_전진보행50
        'GOTO RX_EXIT
        'GOTO 발차기전진보행50
        '보행 코드는 함수 종료시 함수 내에서 RX_EXIT 호출


        '*******************************************
    ELSEIF A = 45 THEN '▶

        GOTO 실시간_오른쪽전진보행50
        'GOTO RX_EXIT
        '보행 코드는 함수 종료시 함수 내에서 RX_EXIT 호출
        '*******************************************
    ELSEIF A = 46 THEN ' ◀
        'GOSUB 왼쪽옆으로70
        GOTO 실시간_왼쪽전진보행50
        'GOTO RX_EXIT
        '보행 코드는 함수 종료시 함수 내에서 RX_EXIT 호출
        '*******************************************
        '*******************************************
    ELSEIF A = 47 THEN ' △

        GOTO 집고_전진보행50
        'GOTO RX_EXIT
        '보행 코드는 함수 종료시 함수 내에서 RX_EXIT 호출
        '*******************************************
    ELSEIF A = 48 THEN ' ◁

        GOTO 집고_왼쪽전진보행50
        'GOTO RX_EXIT
        '보행 코드는 함수 종료시 함수 내에서 RX_EXIT 호출

    ELSEIF A = 49 THEN ' ▷

        GOTO 집고_오른쪽전진보행50
        'GOTO RX_EXIT
        '보행 코드는 함수 종료시 함수 내에서 RX_EXIT 호출
        '*******************************************
        '*******************************************
    ELSEIF A = 50 THEN ' ▽
        GOSUB 한발자국전진
        GOTO RX_EXIT

    ELSEIF A = 51 THEN
        GOSUB 왼쪽보기_80
        GOTO RX_EXIT

    ELSEIF A = 52 THEN
        GOSUB 오른쪽보기_80
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 60 THEN
        MUSIC "D"
        DELAY 200
        GOTO RX_EXIT
    ELSEIF A = 61 THEN
        MUSIC "G"
        DELAY 200
        GOTO RX_EXIT

        '*******************************************
    ELSEIF A = 62 THEN
        GOSUB 왼쪽골반턴60
        GOTO RX_EXIT

    ELSEIF A = 63 THEN
        GOSUB 왼쪽골반턴90
        GOTO RX_EXIT

    ELSEIF A = 64 THEN
        GOSUB 오른쪽골반턴60
        GOTO RX_EXIT

    ELSEIF A = 65 THEN
        GOSUB 오른쪽골반턴90
        GOTO RX_EXIT
   	ELSEIF A = 66 THEN
    	GOSUB 왼쪽골반턴45
        GOTO RX_EXIT
    ELSEIF A = 67 THEN
    	GOSUB 오른쪽골반턴45
        GOTO RX_EXIT
    ENDIF

    GOTO MAIN