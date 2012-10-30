//
//  AppRequestController.h
//  MomTaxi
//
//  Created by  on 11. 12. 2..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "DefineClass.h"


typedef enum {
    noneRequest = 0,
    callRequest,
    cancelRequest,
    taxiInfoRequest,
    apnsRequest,
    deviceRequest,
    buyPoint,
    updateLocation,
    certifyPhone,
    acceptCall,
    taxiMode,
    RedeModeStart,
    showUserInfo,
} CONNECTMODE;


@interface AppRequestController : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    NSMutableData *mReceivedData;
    NSURLResponse *mResponse;
    CONNECTMODE mRequestIndex;
}
@property (nonatomic, strong) NSMutableData *mReceivedData;
@property (nonatomic, strong) NSURLResponse *mResponse;
@property CONNECTMODE mRequestIndex;
- (void)connectionDidFinishLoadingForPassenger:(NSInteger)ID result:(NSString*)string json:(NSDictionary*)dictionary;
- (void)connectionDidFinishLoadingForDriver:(NSInteger)ID result:(NSString*)string json:(NSDictionary*)dictionary;

- (void)certifyPhone:(NSString*)dataType phone:(NSString*)number;
- (void)callTaxiRequest:(NSString*)dataType phone:(NSString*)number locationX:(NSString*)x locationY:(NSString*)y car:(NSString*)phone;
- (void)cancelTaxiCall:(NSString*)dataType phone:(NSString*)number;
- (void)getListTaxiInfo:(NSString*)dataType locationX:(double)X locationY:(double)Y distance:(double)km;
- (void)RegisterAPNs:(NSString*)dataType phone:(NSString*)number accept:(NSInteger)apns;
- (void)RegisterDeviceToken:(NSString*)dataType phone:(NSString*)number device:(NSString*)token;
- (void)BuyCoupon:(NSString*)dataType taxi:(NSString*)phone buy:(NSString*)point money:(NSString*)price;
- (void)updateMyLocation:(NSString*)dataType user:(NSString*)phone locationX:(double)X locationY:(double)Y;
- (void)acceptCall:(NSString*)dataType user:(NSString*)phone1 taxi:(NSString*)phone2;
- (void)modeChange:(NSString*)dataType taxi:(NSString*)phone wait:(NSString*)mode;
- (void)rideModeStart:(NSString*)dataType user:(NSString*)phone1 taix:(NSString*)phone2 locationX:(NSString*)X locationY:(NSString*)Y;
- (void)rideModeEnd:(NSString*)dataType ID:(NSString*)idx locationX:(NSString*)X locationY:(NSString*)Y;
- (void)getInfo:(NSString*)dataType;
- (void)getImage:(NSString*)path list:(NSString*)index;

@end
