//
//  DefineClass.m
//  DongYangSteel
//
//  Created by  on 11. 11. 14..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "DefineClass.h"


NSString *gDefineDataType[2] = {
    @"json",
    @"xml", 
};


NSString *gSMS[3];


NSString *gUS_NUM;
NSString *gTAXI_NUM;
NSString *gTAXI_SERIAL;
NSString *gTAXI_COMPANY;

NSString *gUS_IDX;


NSString *gDefineAPI[100] = {
    @"http://momtaxi.rcsoft.co.kr/api/mom_phone_verify.php?",
    @"http://momtaxi.rcsoft.co.kr/api/mom_user_regist.php?",            // 02. 손님 사용자 등록 + 기사님 사용자 등록
    @"http://momtaxi.rcsoft.co.kr/api/mom_change_user_type.php?",       // 03. 기사 <-> 손님 변경
    @"http://momtaxi.rcsoft.co.kr/api/mom_call_list_taxi.php?",         // 기사님 내 콜내역 불러오기
    @"http://momtaxi.rcsoft.co.kr/api/mom_use_list_user.php?",          // 사용자의 택시이용 기록
    @"http://momtaxi.rcsoft.co.kr/api/mom_eval_taxi.php?",              // 택시 평가하기
    @"http://momtaxi.rcsoft.co.kr/api/mom_get_taxi_list.php?",          // 일정 거리내 대기중이고 푸쉬를 허용했으며 긱번호가 있는 택시 목록
    @"http://momtaxi.rcsoft.co.kr/api/mom_taxi_call.php?",              // 택시에 콜하기
    @"http://momtaxi.rcsoft.co.kr/api/mom_taxi_cancel_call.php?",       // 택시에 콜하기 취소
    @"http://momtaxi.rcsoft.co.kr/api/mom_user_get_info.php?",          // 사용자 정보 얻기
    @"http://momtaxi.rcsoft.co.kr/api/mom_user_machine_regist.php?",    // 푸쉬를 위한 기기 고유번호 저장
    @"http://momtaxi.rcsoft.co.kr/api/mom_user_push_regist.php?",       // 푸쉬 허용여부 저장
    @"http://momtaxi.rcsoft.co.kr/api/mom_add_point_taxi.php?",         // 포인트 충전하기
    @"http://momtaxi.rcsoft.co.kr/api/mom_update_my_location.php?",     // 위치정보 업데이트
    @"http://momtaxi.rcsoft.co.kr/api/mom_user_update.php?",            // 사용자 정보 수정
    @"http://momtaxi.rcsoft.co.kr/api/mom_taxi_get_call.php?",          // 택시가 콜요청에 응하기
    @"http://momtaxi.rcsoft.co.kr/api/mom_taxt_change_mode.php?",       // 택시 대기/운행 모드 변경
    @"http://momtaxi.rcsoft.co.kr/api/mom_taxi_start.php?",             // 승차 모드 클릭시 승차모드 세팅
    @"http://momtaxi.rcsoft.co.kr/api/mom_taxi_end.php?",               // 하차 모드 세팅
    @"http://momtaxi.rcsoft.co.kr/api/mom_taxi_get_call_user.php?",      // 콜한 사용자 정보 보기
};




/********************************************************************************************************************************/
/********************************************************************************************************************************/
/******************************************* 현재 모드/상황 확인을 위한 상수 모음 ******************************************************/
/********************************************************************************************************************************/
/********************************************************************************************************************************/

// 01. 손님 핸드폰 인증 + 기사님 핸드폰 인증
// 02. 손님 사용자 등록 + 기사님 사용자 등록
// 03. 푸시 허용여부 저장
// 04. 푸시 기기 저장
// 05. 나의 좌표 전송(손님)
// 06. 기사님 좌표 받기(손님)
// 07. 나의 좌표 전송(기사님)
// 08. 손님 좌표 받기(기사님)
// 09. 택시 부르기(콜)


NSString *gTerm1 = @"";

