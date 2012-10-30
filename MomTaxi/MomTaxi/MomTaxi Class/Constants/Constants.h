//
//  Constants.h
//  MomTaxi
//
//  Created by  on 11. 11. 30..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//


#define kDebugMode 0


#define kIntervalTimer 15.0f


typedef enum {
    valueNone = 0,
    valueWifi,
    valueWan,
} NETWORK_CONDITION;


typedef enum {
    valueDriver = 0,
    valuePassenger,
} ACTIVE_MODE;


typedef enum {
    valueJson = 0,
    valueXml,
} DATA_TYPE;


typedef enum {
    valueMan = 0,
    valueWoman,
} USER_SEX;


typedef struct {
    double s_locationX;
    double s_locationY;
}LOCATION_INFO;


typedef struct {
    double s_locationX_push;
    double s_locationY_push;
}LOCATION_INFO_PUSH;


typedef enum {
    valuePhoneCertify = 0,      // 휴대폰 인증
    valueRegister,              // 사용자 등록
    valueChangeMode,            // 손님 <-> 기사 변경
    valueDriveCallList,         // 기사님 내 콜내역 불러오기
    valueRideHistoryList,       // 사용자의 택시이용 기록 
    valueDoTaxiScore,           // 택시 평가하기
    valueTaxiList,              // 일정 거리내 대기중이고 푸쉬를 허용했으며 긱번호가 있는 택시 목록
    valueCallTaxi,              // 택시에 콜하기
    valueCallCancel,            // 택시에 콜하기 취소
    valueUserInfo,              // 사용자 정보 얻기
    valueDeviceToken,           // 푸쉬를 위한 기기 고유번호 저장
    valueAPNs,                  // 푸쉬 허용여부 저장
    valueBuy,                   // 포인트 충전하기
    valueUpdateLocation,        // 위치정보 업데이트
    valueUpdateUser,            // 사용자 정보 수정
    valueAcceptCall,            // 택시가 콜요청에 응하기
    valueModeTaxi,              // 택시 대기/운행 모드 변경
    valueRideStart,             // 승차 모드 클릭시 승차모드 세팅
    valueRideEnd,               // 하차 모드 세팅
    valueShowUser,               // 콜한 사용자 정보 보기
} SERVER_APILIST;


extern NETWORK_CONDITION    gNetworkConnention;
extern ACTIVE_MODE          gActiveMode;
extern DATA_TYPE            gDataType;
extern SERVER_APILIST       gAPIList;
extern USER_SEX             gSex;
extern LOCATION_INFO        gLocationInfo;
extern LOCATION_INFO_PUSH   gLocationInfo_push;


#define kMainFrameWidth         320.0f
#define kMianFrameHeight        480.0f
#define kTabBarLocationY        431.0f
#define kTabBarFrameHeight      049.0f
#define kStatusBarHeight        020.0f
#define kTableViewCelHeight     040.0f
#define kTableViewFontSize      012.0f


#define kMyGreenColor [UIColor colorWithRed:114.0f/255.0f green:155.0f/255.0f blue:24.0f/255.0f alpha:1.0f]
#define kMyYellowColor [UIColor colorWithRed:236.0f/255.0f green:180.0f/255.0f blue:9.0f/255.0f alpha:1.0f]
#define kMyBackGroundColor [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]


extern double gDistanceValue;


extern NSInteger gPushAccept;


extern UIImage *gImage[10];


extern BOOL gIsUserCall;
extern BOOL gIsCallAccept;
extern BOOL gIsCallRefuse;
extern BOOL gIsCallMessage;

