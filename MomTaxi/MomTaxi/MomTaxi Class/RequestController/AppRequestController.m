//
//  AppRequestController.m
//  MomTaxi
//
//  Created by  on 11. 12. 2..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "AppRequestController.h"
#import "Constants.h"
#import "DefineClass.h"
#import "MapViewController.h"
#import "AppDelegate.h"


@implementation AppRequestController
@synthesize mReceivedData;
@synthesize mResponse;
@synthesize mRequestIndex;


#define kDriverCode     2
#define kPassengerCode  1


- (id)init
{
    if (self = [super init]) {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
    
    return self;
}


- (void)certifyPhone:(NSString*)dataType phone:(NSString*)number
{
    /*
     *인증번호 받기
     */
    
    mRequestIndex = certifyPhone;
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@", dataType, number];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valuePhoneCertify], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)callTaxiRequest:(NSString*)dataType phone:(NSString*)number locationX:(NSString*)x locationY:(NSString*)y car:(NSString*)phone
{
    /*
     *택시에 콜하기
     */
    
    mRequestIndex = callRequest;
    gTAXI_NUM = phone;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *geoX = [delegate.gClassEncode encryptInfo:[x doubleValue]];
    NSString *geoY = [delegate.gClassEncode encryptInfo:[y doubleValue]];
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@&geox=%@&geoy=%@&taxi_number=%@", dataType, number, geoX, geoY, phone];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueCallTaxi], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)cancelTaxiCall:(NSString*)dataType phone:(NSString*)number
{
    /*
     *택시에 콜 취소하기
     */
    
    mRequestIndex = cancelRequest;

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크 연결에 문제가 발생하였습니다.\n잠시 후 다시 시도하여 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    if(gIsCallAccept == NO && gIsCallRefuse == YES)
    {
        // 손님
        if([gUS_NUM isKindOfClass:[NSNull class]] == YES)
        {
            [alertView show];
            return;
        }
        if([gUS_NUM rangeOfString:@"null"].location != NSNotFound)
        {
            [alertView show];
            return;
        }
        if([gUS_NUM length] < 10)
        {
            [alertView show];
            return;
        }
        
        number = gUS_NUM;
    }
    else
    {
        // 기사님
        number = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"]];
        if([number isKindOfClass:[NSNull class]] == YES)
        {
            [alertView show];
            return;
        }
        if([number rangeOfString:@"null"].location != NSNotFound)
        {
            [alertView show];
            return;
        }
        if([number length] < 10)
        {
            [alertView show];
            return;
        }
    }

    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@", dataType, number];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueCallCancel], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)getListTaxiInfo:(NSString*)dataType locationX:(double)X locationY:(double)Y distance:(double)km
{
    /*
     * 일정 거리내 대기중이고 푸쉬를 허용했으며 긱번호가 있는 택시 목록
     */
    
    mRequestIndex = taxiInfoRequest;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *geoX = [delegate.gClassEncode encryptInfo:X];
    NSString *geoY = [delegate.gClassEncode encryptInfo:Y];

    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&geox=%@&geoy=%@&dist=%f&page_rows=10&page=10", dataType, geoX, geoY, km * 1000];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueTaxiList], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)RegisterAPNs:(NSString*)dataType phone:(NSString*)number accept:(NSInteger)apns
{
    /*
     *푸쉬 허용여부 저장
     */
    
    mRequestIndex = apnsRequest;
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@&us_push=%d", dataType, number, apns];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueAPNs], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[apiAddress dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}



- (void)RegisterDeviceToken:(NSString*)dataType phone:(NSString*)number device:(NSString*)token
{
    /*
     *푸쉬를 위한 기기 고유번호 저장
     */
    
    mRequestIndex = deviceRequest;
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@&us_push_regnum=%@&us_push_os=iOS", dataType, number, token];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueDeviceToken], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[apiAddress dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)BuyCoupon:(NSString*)dataType taxi:(NSString*)phone buy:(NSString*)point money:(NSString*)price
{
    /*
     *포인트 충전하기
     */
    
    mRequestIndex = buyPoint;
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&taxi_number=%@&add_point=%@&pay_amount=%@", dataType, phone, point, price];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueBuy], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[apiAddress dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)updateMyLocation:(NSString*)dataType user:(NSString*)phone locationX:(double)X locationY:(double)Y
{
    /*
     *위치정보 업데이트
     */
    
    mRequestIndex = updateLocation;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *geoX = [delegate.gClassEncode encryptInfo:X];
    NSString *geoY = [delegate.gClassEncode encryptInfo:Y];

    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@&us_x_pos=%@&us_y_pos=%@", dataType, phone, geoX, geoY];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueUpdateLocation], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)acceptCall:(NSString*)dataType user:(NSString*)phone1 taxi:(NSString*)phone2
{
    /*
     *택시가 콜요청에 응하기
     */
    
    mRequestIndex = acceptCall;
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&taxi_number=%@&us_number=%@", dataType, phone2, phone1];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueAcceptCall], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)getInfo:(NSString*)dataType
{
    /*
     *콜한 사용자 정보 보기
     */
    
    mRequestIndex = showUserInfo;
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&taxi_number=%@", dataType, [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"]];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueShowUser], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)modeChange:(NSString*)dataType taxi:(NSString*)phone wait:(NSString*)mode
{
    /*
     *택시 대기/운행 모드 변경
     */
    
    mRequestIndex = taxiMode;
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@&us_mode=%@", dataType, phone, mode];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueModeTaxi], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)rideModeStart:(NSString*)dataType user:(NSString*)phone1 taix:(NSString*)phone2 locationX:(NSString*)X locationY:(NSString*)Y
{
    /*
     *승차 모드 클릭시 승차모드 세팅
     */
    
    mRequestIndex = RedeModeStart;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *geoX = [delegate.gClassEncode encryptInfo:[X doubleValue]];
    NSString *geoY = [delegate.gClassEncode encryptInfo:[Y doubleValue]];
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@&taxi_number=%@&geox_start=%@&geoy_start=%@", dataType, phone1, phone2, geoX, geoY];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueRideStart], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}


- (void)rideModeEnd:(NSString*)dataType ID:(NSString*)idx locationX:(NSString*)X locationY:(NSString*)Y
{
    /*
     *하차 모드 세팅
     */
    
    mRequestIndex = RedeModeStart;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *geoX = [delegate.gClassEncode encryptInfo:[X doubleValue]];
    NSString *geoY = [delegate.gClassEncode encryptInfo:[Y doubleValue]];
    
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&uu_idx=%@&geox_end=%@&geoy_end=%@", dataType, idx, geoX, geoY];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueRideEnd], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
}






- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
	[self.mReceivedData setLength:0];
    self.mResponse = aResponse;	
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.mReceivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([[error  localizedDescription] rangeOfString:@"The request timed out"].location != NSNotFound)
    {
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"연결시간 초과" message:@"접속이 지연 되고 있습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    mRequestIndex = noneRequest;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receive = [[NSString alloc] initWithData:self.mReceivedData encoding:NSUTF8StringEncoding];
    NSData *data = [receive dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    NSString *result = [dictionary objectForKey:@"result"];
    NSLog(@"AppRequestController connectionDidFinishLoading == %d : %@", (NSInteger)mRequestIndex, receive);
    NSLog(@"AppRequestController connectionDidFinishLoading == %@", dictionary);
    
    if((NSInteger)mRequestIndex == certifyPhone)
    {
        // 인증번호 받기
    }
    
    NSString *type = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfDivide"]];
    if([type isEqualToString:@"passenger"] == YES)
    {
        gActiveMode = valuePassenger;
    }
    else
    {
        gActiveMode = valueDriver;
    }
    
    switch((NSInteger)gActiveMode)
    {
        case valueDriver:
        {
            [self connectionDidFinishLoadingForDriver:mRequestIndex result:result json:dictionary];
            break;
        }
        case valuePassenger:
        {
            [self connectionDidFinishLoadingForPassenger:mRequestIndex result:result json:dictionary];
            break;
        }
    }
}


- (void)connectionDidFinishLoadingForPassenger:(NSInteger)ID result:(NSString*)string json:(NSDictionary*)dictionary
{
    UIAlertView *alertView = nil;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([string rangeOfString:@"error"].location != NSNotFound)
    {
        switch(ID)
        {
            case callRequest:
            {
                // 택시에 콜하기
                
                if([[dictionary objectForKey:@"result_text"] length] > 0x00)
                {
                    gTAXI_NUM = @"";
                    gTAXI_COMPANY = @"";
                    gTAXI_SERIAL = @"";
                    alertView = 
                    [[UIAlertView alloc] initWithTitle:@"알림" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                    [alertView show];
                }
                break;
            }
            case certifyPhone:      // 인증번호 받기
            case cancelRequest:     // 택시에 콜 취소하기
            case taxiInfoRequest:   // 일정 거리내 대기중이고 푸쉬를 허용했으며 긱번호가 있는 택시 목록
            case apnsRequest:       // 푸쉬 허용여부 저장
            case deviceRequest:     // 푸쉬를 위한 기기 고유번호 저장
            case buyPoint:          // 포인트 충전하기
            case updateLocation:    // 위치정보 업데이트
            case taxiMode:          // 택시 대기/운행 모드 변경
            case RedeModeStart:     // 승차모드
            default:
            {
                if([[dictionary objectForKey:@"result_text"] length] == 0x00 || [dictionary objectForKey:@"result_text"] == nil) {
                    return;
                }
                
                alertView = 
                [[UIAlertView alloc] initWithTitle:@"알림" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                [alertView show]; 
                break;
            }
        }
    }
    else
    {
        switch(ID)
        {
            case cancelRequest:
            {
                // 택시에 콜 취소하기
                gIsCallAccept = NO;
                gIsCallRefuse = YES;
                break;
            }
            case taxiInfoRequest:
            {
                // 일정 거리내 대기중이고 푸쉬를 허용했으며 긱번호가 있는 택시 목록
                NSArray *array = [dictionary objectForKey:@"list"];
                NSInteger count = [[dictionary objectForKey:@"total_count"] integerValue];
                
                [delegate.gLocationArray removeAllObjects];
                [delegate.gImageArray removeAllObjects];
                for(NSInteger i = 0; i < count; i++)
                {
                    NSDictionary *listDic = [array objectAtIndex:i];
                    NSArray *tempArray = [dictionary objectForKey:@"list"];
                    NSDictionary *tempDictionary = [tempArray objectAtIndex:i];

                    NSString *us_aver = [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"us_aver"]];
                    
                    [listDic setValue:us_aver forKey:@"us_aver"];

                    [delegate.gLocationArray addObject:listDic];
                    
                    NSString *path = [listDic objectForKey:@"us_filename"];
                    if([path rangeOfString:@".jpg"].location != NSNotFound)
                    {
                        [self getImage:path list:[listDic objectForKey:@"us_name"]];
                    }
                }
                break;
            }
            case RedeModeStart:
            {
                // 승차모드
                gUS_IDX = [dictionary objectForKey:@"uu_idx"];
                break;
            }
            case deviceRequest:
            {
                // 푸쉬를 위한 기기 고유번호 저장
                [self RegisterAPNs:gDefineDataType[valueJson] phone:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"] accept:gPushAccept];
                return;
            }
            case buyPoint:          // 포인트 충전하기
            case updateLocation:    // 위치정보 업데이트
            case taxiMode:          // 택시 대기/운행 모드 변경
            case certifyPhone:      // 인증번호 받기
            case callRequest:       // 택시에 콜하기
            case apnsRequest:       // 푸쉬 허용여부 저장
            default:
            {
                break;
            }
        }
    }
    
    mRequestIndex = noneRequest;
}


- (void)connectionDidFinishLoadingForDriver:(NSInteger)ID result:(NSString*)string json:(NSDictionary*)dictionary
{
    UIAlertView *alertView = nil;
    if([string rangeOfString:@"error"].location != NSNotFound)
    {
        switch(ID)
        {
            case acceptCall:
            {
                // 택시가 콜요청에 응하기
                [self cancelTaxiCall:gDefineDataType[valueJson] phone:gUS_NUM];
                break;
            }
            case certifyPhone:      // 인증번호 받기
            case cancelRequest:     // 택시에 콜 취소하기
            case apnsRequest:       // 푸쉬 허용여부 저장
            case deviceRequest:     // 푸쉬를 위한 기기 고유번호 저장
            case buyPoint:          // 포인트 충전하기
            case updateLocation:    // 위치정보 업데이트
            case taxiMode:          // 택시 대기/운행 모드 변경
            case showUserInfo:      // 콜한 사용자 정보 보기
            default:
            {
                if([[dictionary objectForKey:@"result_text"] length] == 0x00 || [dictionary objectForKey:@"result_text"] == nil) {
                    return;
                }
                
                alertView = 
                [[UIAlertView alloc] initWithTitle:@"알림" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                [alertView show]; 
                break;
            }
        }
    }
    else
    {
        switch(ID)
        {
            case cancelRequest:
            {
                // 택시에 콜 취소하기
                gIsCallAccept = NO;
                gIsCallRefuse = YES;
                gIsCallMessage = NO;
                [self cancelTaxiCall:gDefineDataType[valueJson] phone:gUS_NUM];
                break;
            }
            case acceptCall:
            {
                // 택시가 콜요청에 응하기
                gIsCallAccept = YES;
                [self getInfo:@"json"];
                break;
            }
            case showUserInfo:      // 콜한 사용자 정보 보기
            {
                gUS_NUM = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"us_number"]];
                
                /*
                 택시 취소 인자 값 변경
                 */
                
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
#if 0
                gLocationInfo_push.s_locationX_push = [[dictionary objectForKey:@"us_x_pos"] doubleValue];
                gLocationInfo_push.s_locationY_push = [[dictionary objectForKey:@"us_y_pos"] doubleValue];
#else
                NSString *us_x_pos = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"us_x_pos"]];
                NSString *us_y_pos = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"us_y_pos"]];
                
                if([us_x_pos length] == 30) gLocationInfo_push.s_locationX_push = [delegate.gClassEncode decryptInfo:us_x_pos type:YES];
                if([us_y_pos length] == 30) gLocationInfo_push.s_locationY_push = [delegate.gClassEncode decryptInfo:us_y_pos type:NO];
#endif
                break;
            }
            case deviceRequest:
            {
                // 푸쉬를 위한 기기 고유번호 저장
                [self RegisterAPNs:gDefineDataType[valueJson] phone:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"] accept:gPushAccept];
                return;
            }
            case apnsRequest:       // 푸쉬 허용여부 저장
            case buyPoint:          // 포인트 충전하기
            case updateLocation:    // 위치정보 업데이트
            case certifyPhone:      // 인증번호 받기 
            case taxiMode:          // 택시 대기/운행 모드 변경
            default:
            {
                break;
            }
        }
    }
    
    mRequestIndex = noneRequest;
}


- (void)getImage:(NSString*)path list:(NSString*)index
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:image, @"image", index, @"index", nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.gImageArray addObject:dictionary];
}



@end
