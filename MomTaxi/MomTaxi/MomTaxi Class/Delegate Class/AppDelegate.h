//
//  AppDelegate.h
//  MomTaxi
//
//  Created by  on 11. 11. 7..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "DefineClass.h"
#import "Reachability.h"
#import "PaymentController.h"
#import "AppRequestController.h"
#import "EncodeFromLocationInfo.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>
{
    UINavigationController *navigationController;
    UITabBarController *tabbarController;
    UIImageView *loadingImageView;
    UIView *gTabView;
    UIButton *gTabButton[4];
    NSInteger gTabIndexNow;
    NSInteger gTabIndexPre;
    BOOL gIsChangeMode;
    
    Reachability *gClassReachability;
    PaymentController *gClassPayment;
    AppRequestController *gClassRequest;
    EncodeFromLocationInfo *gClassEncode;
    
    CLLocationManager *gLocationManager;
    CLLocationCoordinate2D gCurrentUserCoordinate;
    CLLocation *gLocation;
    NSMutableArray *gLocationArray;
    NSMutableArray *gImageArray;
    NSArray *gAPNsArray;
    
    UIAlertView *mAlertView;
}
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UITabBarController *tabbarController;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UIView *gTabView;
@property NSInteger gTabIndexNow;
@property NSInteger gTabIndexPre;
@property BOOL gIsChangeMode;
@property (nonatomic, strong) Reachability *gClassReachability;
@property (nonatomic, strong) PaymentController *gClassPayment;
@property (nonatomic, strong) AppRequestController *gClassRequest;
@property (nonatomic, strong) EncodeFromLocationInfo *gClassEncode;

@property (nonatomic, strong) CLLocationManager *gLocationManager;
@property (nonatomic, strong) CLLocation *gLocation;
@property (nonatomic, strong) NSMutableArray *gLocationArray;
@property (nonatomic, strong) NSMutableArray *gImageArray;
@property (nonatomic, strong) NSArray *gAPNsArray;

@property (nonatomic, strong) UIAlertView *mAlertView;
- (UIRemoteNotificationType)isConfirmPush;
- (void)setPushNotification;
- (void)deletePushNotification;
- (void)reportNetworkProfile;
- (void)reachabilityChanged:(NSNotification* )note;
- (void)updateNetworkProfile:(Reachability*)curReach;
- (void)shwoAlertView;
- (void)initDriverToInterface;
- (void)initCustomerToInterface;
- (void)initTabButtonForPassenger;
- (void)initTabButtonForDriver;
- (void)actionPassengerTab:(id)sender;
- (void)actionDriverTab:(id)sender;
- (void)selectedTabButton:(NSInteger)index;
- (void)removeUserInfoToDriver;
- (void)removeUserInfoToPassenger;
- (void)buyCouponConnect:(NSInteger)index;
- (void)initLocationInfo;
- (void)startUpdatingCurrentLocation;
- (void)stopUpdatingCurrentLocation;
- (void)cancelCallForDriver;
- (void)showMessage;
- (NSString*)readDataOfUser:(NSString*)file;
@end
