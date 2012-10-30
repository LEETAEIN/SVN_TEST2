//
//  AppDelegate.m
//  MomTaxi
//
//  Created by  on 11. 11. 7..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PassengerRegisterController.h"
#import "DriverRegisterController.h"
#import "MapViewController.h"
#import "ListViewController.h"
#import "RideModeController.h"
#import "OptionController.h"
#import "WaitModeForController.h"
#import "HistoryAffirmForController.h"
#import "AlertViewContoller.h"


@implementation AppDelegate
@synthesize window = _window;
@synthesize tabbarController;
@synthesize navigationController;
@synthesize loadingImageView;
@synthesize gTabView;
@synthesize gTabIndexNow;
@synthesize gTabIndexPre;
@synthesize gClassReachability;
@synthesize gClassPayment;
@synthesize gClassRequest;
@synthesize gClassEncode;
@synthesize gIsChangeMode;
@synthesize gLocationManager;
@synthesize gLocation;
@synthesize gLocationArray;
@synthesize gImageArray;
@synthesize gAPNsArray;
@synthesize mAlertView;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];

    /*
     * Loading image 3 sec
     */
    self.loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.window.frame.size.width, self.window.frame.size.height)];
    [self.loadingImageView setImage:[UIImage imageNamed:@"Default.png"]];
    [self.window addSubview:self.loadingImageView];
    [self.window setBackgroundColor:[UIColor clearColor]];

    /*
     * for Register  Modal Controller
     */
    self.navigationController = [[UINavigationController alloc] init];
    [self.navigationController.navigationBar setHidden:YES];

    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    /*
     * selected mode (passenger, driver)
     */
    self.gIsChangeMode = NO;
    [self performSelector:@selector(shwoAlertView) withObject:nil afterDelay:(NSTimeInterval)0.5f];
    
    /*
     * IAP
     */
    self.gClassPayment = [[PaymentController alloc] init];
    [self reportNetworkProfile];
    
    self.gClassRequest = [[AppRequestController alloc] init];
    /*
     * APNs
     */
    [self setPushNotification];
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo != nil)
    {
        [self application:application didFinishLaunchingWithOptions:userInfo];
    }

    self.gClassEncode = [[EncodeFromLocationInfo alloc] init];
    self.gLocationArray = [[NSMutableArray alloc] init];
    self.gImageArray = [[NSMutableArray alloc] init];

    return YES;
}


- (void)initLocationInfo
{
    self.gLocationManager = [[CLLocationManager alloc] init];
    [self.gLocationManager setDelegate:self];
    [self.gLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.gLocationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.gLocationManager startUpdatingLocation];
}


- (void)startUpdatingCurrentLocation
{
    switch([CLLocationManager authorizationStatus])
    {
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // 예외처리
            break;
        }
        default:
        {   
            self.gLocationManager = [[CLLocationManager alloc] init];
            gCurrentUserCoordinate = kCLLocationCoordinate2DInvalid;
            [self.gLocationManager setDelegate:self];
            [self.gLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [self.gLocationManager setPurpose:@"엄마택시에서 고객님의 위치 정보를 수집합니다."];
            [self.gLocationManager setDistanceFilter:2000];
            [self.gLocationManager startUpdatingLocation];
            break;
        }
    }
}


- (void)stopUpdatingCurrentLocation
{
    [self.gLocationManager stopUpdatingLocation];
    [self.gLocationManager setDelegate:nil];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.gLocation = newLocation;
    NSString *locationString = [NSString stringWithFormat:@"φ:%.6f, λ:%.6f", self.gLocation.coordinate.latitude, self.gLocation.coordinate.longitude];
    NSLog(@"locationManager :: %@", locationString);
    
    gLocationInfo.s_locationX = self.gLocation.coordinate.latitude;
    gLocationInfo.s_locationY = self.gLocation.coordinate.longitude;

    gCurrentUserCoordinate = [newLocation coordinate];
    [self stopUpdatingCurrentLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopUpdatingCurrentLocation];
    gCurrentUserCoordinate = kCLLocationCoordinate2DInvalid;
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        return;
    }
    else
    {
        UIAlertView *alert = 
        [[UIAlertView alloc] initWithTitle:@"위치 정보 업데이트 실패" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma network for reachability
- (void)reportNetworkProfile
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    gClassReachability = [Reachability reachabilityWithHostName: @"www.apple.com"];
    [gClassReachability startNotifier];    
}


- (void)reachabilityChanged:(NSNotification* )note
{
	Reachability *reach = [note object];
	NSParameterAssert([reach isKindOfClass: [Reachability class]]);
	[self updateNetworkProfile:reach];
}


- (void)updateNetworkProfile:(Reachability*)curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
        {
            gNetworkConnention = valueNone;
            break;
        }
        case ReachableViaWiFi:
        {
            gNetworkConnention = valueWifi;
            break;
        }
        case ReachableViaWWAN:
        {
            gNetworkConnention = valueWan;
            break;
        }
    }
}


#pragma user info manager
- (void)removeUserInfoToDriver
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfDivide"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfNumber"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfSex"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfSerial"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfCompany"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfPush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)removeUserInfoToPassenger
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfDivide"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfNumber"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KeyOfPush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mode setting for alertview
- (void)shwoAlertView 
{
    NSString *info = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfDivide"]];

    self.tabbarController = [[UITabBarController alloc] init];
    if([info isEqualToString:@"driver"] == YES)
    {
        [self initDriverToInterface];
        [self.tabbarController setSelectedIndex:0];
        [self selectedTabButton:0];
        [self.loadingImageView setHidden:YES];
    }
    else if([info isEqualToString:@"passenger"] == YES)
    {
        [self.window setRootViewController:self.navigationController];
        [self initCustomerToInterface];
        [self.tabbarController setSelectedIndex:0];
        [self selectedTabButton:0];
        [self.loadingImageView setHidden:YES];
    }
    else
    {
#if 0
        AlertViewContoller *alert = 
        [[AlertViewContoller alloc] initWithImage:[UIImage imageNamed:@"BG_ALERTVIEW.png"] title:@"회원가입이 필요한 서비스입니다." content:@"사용자를 선택하여 주세요." submit:nil modelnum:nil];
        alert.mTag = 0;
#else
        UIAlertView *alert = 
        [[UIAlertView alloc] initWithTitle:@"회원가입이 필요한 서비스입니다." message:@"사용자를 선택하여 주세요." delegate:self cancelButtonTitle:@"택시손님" otherButtonTitles:@"기사님", nil];
        [alert setTag:999];
#endif
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 888)
    {
        switch(buttonIndex)
        {
            case 0:
            {
                [self.gClassRequest cancelTaxiCall:gDefineDataType[valueJson] phone:gUS_NUM];
                gIsUserCall = NO;
                gIsCallMessage = NO;
                break;
            }
            case 1:
            {
                [self.gClassRequest acceptCall:gDefineDataType[valueJson] user:gUS_NUM taxi:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"]];                
                gIsUserCall = YES;
                break;
            }
        }
    }
    else if(alertView.tag == 777)
    {
        [self.gClassRequest cancelTaxiCall:gDefineDataType[valueJson] phone:gUS_NUM];
    }
    else
    {
        self.tabbarController = [[UITabBarController alloc] init];
        UINavigationController *controller = nil;
        switch(buttonIndex)
        {
            case 0x00:
            {
                PassengerRegisterController *modalView = [[PassengerRegisterController alloc] initWithNibName:@"PassengerRegisterController" bundle:nil];
                controller = [[UINavigationController alloc] initWithRootViewController:modalView];
                [self.navigationController presentModalViewController:controller animated:YES];
                break;
            }
            case 0x01:
            {
                DriverRegisterController *modalView = [[DriverRegisterController alloc] initWithNibName:@"DriverRegisterController" bundle:nil];
                controller = [[UINavigationController alloc] initWithRootViewController:modalView];
                [self.navigationController presentModalViewController:controller animated:YES];
                break;
            }
        }
        
        gActiveMode = buttonIndex;
    }
}


- (void)initDriverToInterface
{
    WaitModeForController *waitTab = [[WaitModeForController alloc] initWithNibName:@"WaitModeForController" bundle:nil];
    HistoryAffirmForController *historyTab = [[HistoryAffirmForController alloc] initWithNibName:@"HistoryAffirmForController" bundle:nil];
    
    UINavigationController *waitNavigation = [[UINavigationController alloc] initWithRootViewController:waitTab];
    UINavigationController *historyNavigation = [[UINavigationController alloc] initWithRootViewController:historyTab];
    
    waitNavigation.tabBarItem.title = @"대기모드";
    historyNavigation.tabBarItem.title = @"이용내역 확인하기";
    
    self.tabbarController.viewControllers = [NSArray arrayWithObjects:waitNavigation, historyNavigation, nil];
    [self.window setRootViewController:self.tabbarController]; 
    
    [self initTabButtonForDriver];
}


- (void)initTabButtonForDriver
{
    NSInteger count = [self.tabbarController.viewControllers count];
    
    gTabView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kTabBarLocationY, kMainFrameWidth, kTabBarFrameHeight)];
    [gTabView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat x = 0.0f;
    for(NSInteger i = 0; i < count; i++)
    {
        gTabButton[i] = [[UIButton alloc] initWithFrame:CGRectMake(x, 0.0f, kMainFrameWidth / count, kTabBarFrameHeight)];
        NSString *nomalFileName = [NSString stringWithFormat:@"BTN_TAB%02d_D_NOMAL.png", i];
        NSString *selectFileName = [NSString stringWithFormat:@"BTN_TAB%02d_D_ACTIVE.png", i];
        [gTabButton[i] setImage:[UIImage imageNamed:nomalFileName] forState:UIControlStateNormal];
        [gTabButton[i] setImage:[UIImage imageNamed:selectFileName] forState:UIControlStateHighlighted];
        [gTabButton[i] setImage:[UIImage imageNamed:selectFileName] forState:UIControlStateSelected];
        [gTabButton[i] setTag:i];
        [gTabButton[i] addTarget:self action:@selector(actionDriverTab:) forControlEvents:UIControlEventTouchUpInside];
        [gTabView addSubview:gTabButton[i]];
        x += (kMainFrameWidth / count);
    }
    
    [self.window addSubview:gTabView];
    
    self.gTabIndexNow = self.gTabIndexPre = 0;
    [self actionPassengerTab:gTabButton[0]];
}


- (void)actionDriverTab:(id)sender
{
    UIButton *button = (UIButton*)sender;
    self.gTabIndexNow = button.tag;
    
    if(self.gTabIndexPre == self.gTabIndexNow)
    {
        UINavigationController *controller = [self.tabbarController.viewControllers objectAtIndex:self.gTabIndexNow];
        [controller popToRootViewControllerAnimated:YES];
    }
    else
    {
        NSInteger count = [self.tabbarController.viewControllers count];
        for(NSInteger i = 0; i < count; i++)
        {
            [gTabButton[i] setSelected:NO];
        }
        
        switch(button.tag)
        {
            case 0:
                [gTabButton[0] setSelected:YES];
                break;
            case 1:
                [gTabButton[1] setSelected:YES];
                break;
        }
        
        [self.tabbarController setSelectedIndex:button.tag];
    }
    
    self.gTabIndexPre = button.tag;
}


- (void)initCustomerToInterface
{
    MapViewController *mapTab = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    ListViewController *listTab = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    RideModeController *modeTab = [[RideModeController alloc] initWithNibName:@"RideModeController" bundle:nil];
    OptionController *optionTab = [[OptionController alloc] initWithNibName:@"OptionController" bundle:nil];
    
    UINavigationController *mapNavigation = [[UINavigationController alloc] initWithRootViewController:mapTab];
    UINavigationController *listNavigation = [[UINavigationController alloc] initWithRootViewController:listTab];
    UINavigationController *modeNavigation = [[UINavigationController alloc] initWithRootViewController:modeTab];
    UINavigationController *optionNavigation = [[UINavigationController alloc] initWithRootViewController:optionTab];

    self.tabbarController.viewControllers = [NSArray arrayWithObjects:mapNavigation, listNavigation, modeNavigation, optionNavigation, nil];
    [self.window setRootViewController:self.tabbarController];

    [self initTabButtonForPassenger];
}


- (void)initTabButtonForPassenger
{
    NSInteger count = [self.tabbarController.viewControllers count];

    gTabView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kTabBarLocationY, kMainFrameWidth, kTabBarFrameHeight)];
    [gTabView setBackgroundColor:[UIColor clearColor]];

    CGFloat x = 0.0f;
    for(NSInteger i = 0; i < count; i++)
    {
        gTabButton[i] = [[UIButton alloc] initWithFrame:CGRectMake(x, 0.0f, kMainFrameWidth / count, kTabBarFrameHeight)];
        NSString *nomalFileName = [NSString stringWithFormat:@"BTN_TAB%02d_P_NOMAL.png", i];
        NSString *selectFileName = [NSString stringWithFormat:@"BTN_TAB%02d_P_ACTIVE.png", i];
        [gTabButton[i] setImage:[UIImage imageNamed:nomalFileName] forState:UIControlStateNormal];
        [gTabButton[i] setImage:[UIImage imageNamed:selectFileName] forState:UIControlStateHighlighted];
        [gTabButton[i] setImage:[UIImage imageNamed:selectFileName] forState:UIControlStateSelected];
        [gTabButton[i] setTag:i];
        [gTabButton[i] addTarget:self action:@selector(actionPassengerTab:) forControlEvents:UIControlEventTouchUpInside];
        [gTabView addSubview:gTabButton[i]];
        x += (kMainFrameWidth / count);
    }

    [self.window addSubview:gTabView];
    
    self.gTabIndexNow = self.gTabIndexPre = 0;
    [self actionPassengerTab:gTabButton[0]];
}


- (void)actionPassengerTab:(id)sender
{
    UIButton *button = (UIButton*)sender;
    self.gTabIndexNow = button.tag;
    
    if(self.gTabIndexNow == self.gTabIndexPre)
    {
        UINavigationController *controller = [self.tabbarController.viewControllers objectAtIndex:self.gTabIndexNow];
        [controller popToRootViewControllerAnimated:YES];
    }
    else
    {
        NSInteger count = [self.tabbarController.viewControllers count];
        for(NSInteger i = 0; i < count; i++)
        {
            [gTabButton[i] setSelected:NO];
        }

        switch(button.tag)
        {
            case 0:
                [gTabButton[0] setSelected:YES];
                break;
            case 1:
                [gTabButton[1] setSelected:YES];
                break;
            case 2:
                [gTabButton[2] setSelected:YES];
                break;
            case 3:
                [gTabButton[3] setSelected:YES];
                break;
        }
        
        [self.tabbarController setSelectedIndex:button.tag];
    }
    
    self.gTabIndexPre = button.tag;
}


- (void)selectedTabButton:(NSInteger)index
{
    [gTabButton[index] setSelected:YES];
}


#pragma push notification
- (UIRemoteNotificationType)isConfirmPush
{
    UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    return  enabledTypes;
}


- (void)setPushNotification
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)deletePushNotification
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSMutableString *deviceID = [NSMutableString string];
    const unsigned char *ptr = (const unsigned char *)[deviceToken bytes];
    for(NSInteger i = 0; i < 32; i++) [deviceID appendFormat:@"%02x", ptr[i]];
    NSLog(@"APNS Device Token: %@", deviceID);
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if(token != nil || [token length] > 0x00)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deviceToken"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}


- (void)buyCouponConnect:(NSInteger)index
{
    [self.gClassPayment buyCoupon:index];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{   
    gIsUserCall = NO;
    gIsCallRefuse = NO;
    switch(gActiveMode)
    {
        case valueDriver:
        {
            [self.gClassRequest getInfo:@"json"];
            [self performSelector:@selector(showMessage) withObject:nil afterDelay:5.0f];
            
            break;
        }
        case valuePassenger:
        {
            break;
        }
    }
}

- (void)showMessage
{
    if(gIsCallMessage == NO)
    {
        self.mAlertView = [[UIAlertView alloc] initWithTitle:@"콜이 왔습니다." message:@"한번의 콜을 받으실때마다'\n'100점의 포인트가 청구됩니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        [self.mAlertView setTag:888];
        [self.mAlertView show];
        
        gIsCallMessage = YES;
        
        [self performSelector:@selector(cancelCallForDriver) withObject:nil afterDelay:kIntervalTimer * 4.0f];
    }
}


- (void)cancelCallForDriver
{
    if(gIsCallAccept == NO && gIsCallRefuse == NO)
    {
        [self.mAlertView dismissWithClickedButtonIndex:0x00 animated:NO];
        
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"알림" message:@"시간 초과로 인하여 콜이 취소되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView setTag:777];
        [alertView show];
        
        gIsUserCall = NO;
    }
}



- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSString *info = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfDivide"]];
    if([info isEqualToString:@"driver"] == YES || [info isEqualToString:@"passenger"] == YES)
    {
        [self initLocationInfo];
    }
    else {
    }
}


- (NSString*)readDataOfUser:(NSString*)file
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:@"txt"];
    NSString *text = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return text;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationWillTerminate:(UIApplication *)application {
}
@end
