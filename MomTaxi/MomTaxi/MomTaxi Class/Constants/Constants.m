//
//  Constants.m
//  MomTaxi
//
//  Created by  on 11. 11. 30..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//


#import "Constants.h"


NETWORK_CONDITION   gNetworkConnention = valueNone;
ACTIVE_MODE         gActiveMode = valueDriver;
DATA_TYPE           gDataType = valueJson;
SERVER_APILIST      gAPIList = valuePhoneCertify;
USER_SEX            gSex = valueMan;
LOCATION_INFO       gLocationInfo;
LOCATION_INFO_PUSH  gLocationInfo_push;


double gDistanceValue = 2;


NSInteger gPushAccept = 1;


UIImage *gImage[10];


BOOL gIsUserCall = NO;
BOOL gIsCallAccept = NO;
BOOL gIsCallRefuse = NO;
BOOL gIsCallMessage = NO;