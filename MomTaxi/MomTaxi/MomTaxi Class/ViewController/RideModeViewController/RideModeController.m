//
//  RideModeController.m
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "RideModeController.h"
#import "AppDelegate.h"
#import "AnnounceController.h"
#import "KakaoLinkCenter.h"
#import "ProfileController.h"


@implementation RideModeController
@synthesize mTableView;
@synthesize mTimeObject;
@synthesize mDateLabel;
@synthesize mTimeLabel0;
@synthesize mTimeLabel1;
@synthesize mMinLabel0;
@synthesize mMinLabel1;
@synthesize mSecLabel0;
@synthesize mSecLabel1;
@synthesize mIndicator;
@synthesize mTimer;
@synthesize mStartTime;
@synthesize mEndTime;
@synthesize mLocationManager;
@synthesize mLocationStart;
@synthesize mLocationEnd;
@synthesize mDistanceString;
@synthesize mConditionIndex;
@synthesize mAlertTextFeild;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.mTimer = [NSTimer scheduledTimerWithTimeInterval:(CGFloat)1.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.mTimer invalidate];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initSelfController];

    /*
     * 출발 도착 시간 관리
     */
    self.mStartTime = [[NSString alloc] init];
    self.mEndTime = [[NSString alloc] init];
    
    /*
     * 위치정보 업데이트
     */
    [self initLocationInfo];
    
    UIButton *buttonArrived = (UIButton *)[self.view viewWithTag:20];
    [buttonArrived setEnabled:NO];
}


- (void)initLocationInfo
{
    self.mLocationManager = [[CLLocationManager alloc] init];
    [self.mLocationManager setDelegate:self];
    [self.mLocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.mLocationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.mLocationManager startUpdatingLocation];
}


- (void)initSelfController
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:kMyGreenColor];
    [self setTitle:@"승차모드"];
    
    [self.view setBackgroundColor:kMyBackGroundColor];
    [self.mTableView setBackgroundColor:kMyBackGroundColor];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"초기화" style:UIBarButtonItemStyleDone target:self action:@selector(reloadTime)];
    [cancel setTintColor:[UIColor colorWithRed:117.0f/255.0f green:162.0f/255.0f blue:014.0f/255.0f alpha:1.0f]];
    [self.navigationItem setRightBarButtonItem:cancel];
}


- (void)reloadTime
{
    self.mStartTime = @"";
    self.mEndTime = @"";
    self.mDistanceString = @"";
    [self.mTableView reloadData];
    
    UIButton *button1 = (UIButton *)[self.view viewWithTag:10];
    [button1 setEnabled:YES];
    
    UIButton *button2 = (UIButton *)[self.view viewWithTag:20];
    [button2 setEnabled:NO];
}


- (void)onTimer:(NSTimer*)timer
{
    [self.view setNeedsDisplay];
    [self initDateAndTime];
}


- (void)initDateAndTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.mDateLabel setText:dateString];

    [dateFormatter setDateFormat:@"HH"];
    NSString *time0 = [[dateFormatter stringFromDate:date] substringToIndex:1];
    NSString *time1 = [[dateFormatter stringFromDate:date] substringFromIndex:1];
    [self.mTimeLabel0 setText:time0];
    [self.mTimeLabel1 setText:time1];
    
    [dateFormatter setDateFormat:@"mm"];
    NSString *min0 = [[dateFormatter stringFromDate:date] substringToIndex:1];
    NSString *min1 = [[dateFormatter stringFromDate:date] substringFromIndex:1];
    [self.mMinLabel0 setText:min0];
    [self.mMinLabel1 setText:min1];
    
    [dateFormatter setDateFormat:@"ss"];
    NSString *sec0 = [[dateFormatter stringFromDate:date] substringToIndex:1];
    NSString *sec1 = [[dateFormatter stringFromDate:date] substringFromIndex:1];
    [self.mSecLabel0 setText:sec0];
    [self.mSecLabel1 setText:sec1];
    
    self.mTimeObject = [[NSMutableString alloc] initWithFormat:@"%@ %@%@:%@%@:%@%@", dateString, time0, time1, min0, min1, sec0, sec1];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 0x01;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	return 0x03;
}


#define IMG_DIVIDE_ARRAY [NSArray arrayWithObjects:@"이동거리", @"승차시간", @"하차시간", nil]

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 20.0f, 40.0f)];
    [pointLabel setBackgroundColor:[UIColor clearColor]];
    [pointLabel setText:@"▪"];
    [pointLabel setTextColor:kMyGreenColor];
    [pointLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [pointLabel setTextAlignment:(UITextAlignment)UITextAlignmentLeft];
    
    UILabel *divideLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 0.0f, 80.0f, 40.0f)];
    [divideLabel setBackgroundColor:[UIColor clearColor]];
    [divideLabel setText:[IMG_DIVIDE_ARRAY objectAtIndex:indexPath.row]];
    [divideLabel setTextColor:[UIColor blackColor]];
    [divideLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [divideLabel setTextAlignment:(UITextAlignment)UITextAlignmentLeft];
    
    UILabel *contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0f, 0.0f, 150.0f, 40.0f)];
    [contentsLabel setBackgroundColor:[UIColor clearColor]];
    [contentsLabel setTextColor:kMyGreenColor];
    [contentsLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [contentsLabel setTextAlignment:(UITextAlignment)UITextAlignmentRight];
    
    UILabel *uintLabel = [[UILabel alloc] initWithFrame:CGRectMake(250.0f, 0.0f, 30.0f, 40.0f)];
    [uintLabel setBackgroundColor:[UIColor clearColor]];
    [uintLabel setText:@"km"];
    [uintLabel setTextColor:[UIColor darkGrayColor]];
    [uintLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [uintLabel setTextAlignment:(UITextAlignment)UITextAlignmentRight];

    switch(indexPath.row)
    {
        case 0:
        {
            [contentsLabel setFrame:CGRectMake(130.0f, 0.0f, 120.0f, 40.0f)];
            [cell addSubview:uintLabel];
            [contentsLabel setText:self.mDistanceString];
            break;
        }
        case 1:
            [contentsLabel setText:self.mStartTime];
            break;
        case 2:
            [contentsLabel setText:self.mEndTime];
            break;
    }
    
    [cell addSubview:contentsLabel];
    [cell addSubview:divideLabel];
    [cell addSubview:pointLabel];

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)goAndStopAction:(UIButton*)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    if([gTAXI_NUM length] == 0x00 || gTAXI_NUM == nil)
    {
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"알림" message:@"먼저 택시를 콜해야 합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    if([self.mStartTime length] == 0x00)
    {
        self.mConditionIndex = start;
        self.mStartTime = self.mTimeObject;
        [self.mLocationManager startUpdatingLocation];
        
        NSString *myNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"];
        NSString *X = [NSString stringWithFormat:@"%f", self.mLocationStart.coordinate.latitude];
        NSString *Y = [NSString stringWithFormat:@"%f", self.mLocationStart.coordinate.longitude];
        [delegate.gClassRequest rideModeStart:gDefineDataType[valueJson] user:myNumber taix:gTAXI_NUM locationX:X locationY:Y];
        
        UIButton *button1 = (UIButton *)[self.view viewWithTag:10];
        [button1 setEnabled:NO];
        
        UIButton *button2 = (UIButton *)[self.view viewWithTag:20];
        [button2 setEnabled:YES];
    }
    else
    {
        self.mConditionIndex = end;
        [self.mIndicator startAnimating];
        [self performSelector:@selector(stopLocationUpdate) withObject:nil afterDelay:3.0f];
        self.mEndTime = self.mTimeObject;

        NSString *X = [NSString stringWithFormat:@"%f", self.mLocationEnd.coordinate.latitude];
        NSString *Y = [NSString stringWithFormat:@"%f", self.mLocationEnd.coordinate.longitude];
        [delegate.gClassRequest rideModeEnd:gDefineDataType[valueJson] ID:gUS_IDX locationX:X locationY:Y];
        [delegate.gClassRequest cancelTaxiCall:gDefineDataType[valueJson] phone:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"]];
        
        UIButton *button1 = (UIButton *)[self.view viewWithTag:10];
        [button1 setEnabled:NO];
        
        UIButton *button2 = (UIButton *)[self.view viewWithTag:20];
        [button2 setEnabled:NO];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"사용이력보기에서 꼭 기사님을 평가해주세요~!" message:@"평가하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니오", nil];
        [alertView setTag:666];
        [alertView show];
    }
    
    [self.mTableView reloadData];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIAlertView *alertView = nil;
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            alertView = 
            [[UIAlertView alloc] initWithTitle:@"알림" message:@"메세지를 보내기가 완료 되었습니다." delegate:self cancelButtonTitle:@"" otherButtonTitles:@"", nil];
            break;
        case MessageComposeResultFailed:
            alertView = 
            [[UIAlertView alloc] initWithTitle:@"알림" message:@"메세지 보내기에 실패하였습니다.\n잠시 후 가시 시도하여 주세요." delegate:self cancelButtonTitle:@"" otherButtonTitles:@"", nil];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


- (void)addTextFeildAlert:(NSInteger)tag
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"지역명을 입력하세요" message:@"nil" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    self.mAlertTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
    [self.mAlertTextFeild setTag:999];
    
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
    [alert setTransform:myTransform];
    [self.mAlertTextFeild setBackgroundColor:[UIColor whiteColor]];
    [alert addSubview:self.mAlertTextFeild];
    
    if(tag == 0)
    {
        [alert setTag:999];
    }
    else
    {
        [alert setTag:998];
    }
    [alert show];
}
     
     
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 999) 
    {
        if(buttonIndex == 0x01) 
        {
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {   
                NSMutableArray *array = [[NSMutableArray alloc] init];
                if([gSMS[0] length] > 0x00 && gSMS[0] != nil)
                {
                    [array addObject:gSMS[0]];
                }
                
                if([gSMS[1] length] > 0x00 && gSMS[1] != nil)
                {
                    [array addObject:gSMS[1]];
                }
                
                if([array count] == 0x00)
                {
                    AnnounceController *announce = (AnnounceController *)[[AnnounceController alloc] initWithNibName:@"AnnounceController" bundle:nil];
                    [self.navigationController pushViewController:announce animated:YES];
                    return;
                }
                
                [controller setRecipients:[NSArray arrayWithObjects:gSMS[0], gSMS[1], nil]];
                
                if(gSMS[2] == nil || [gSMS[2] length] == 0x00) {
                    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"];
                    gSMS[2] = [NSString stringWithFormat:@"현재 %@님이 (전화번호, 차량번호, 택시회사)를 타고 (지역) 근처에서 출발하였습니다.", phone];
                }
                
                if([gTAXI_NUM length] == 0x00) {
                    gTAXI_NUM = @"전화번호";
                }
                if([gTAXI_SERIAL length] == 0x00) {
                    gTAXI_SERIAL = @"차량번호";
                }
                if([gTAXI_COMPANY length] == 0x00) {
                    gTAXI_COMPANY = @"택시회사";
                }

                NSString *contents = [NSString stringWithFormat:@"%@", gSMS[2]];
                contents = [contents stringByReplacingOccurrencesOfString:@"전화번호" withString:gTAXI_NUM];
                contents = [contents stringByReplacingOccurrencesOfString:@"차량번호" withString:gTAXI_SERIAL];
                contents = [contents stringByReplacingOccurrencesOfString:@"택시회사" withString:gTAXI_COMPANY];
                if([self.mAlertTextFeild.text length] > 0x00) {
                    contents = [contents stringByReplacingOccurrencesOfString:@"(지역)" withString:self.mAlertTextFeild.text];
                }

                [controller setBody:[NSString stringWithFormat:contents]];
                [controller setMessageComposeDelegate:self];
                [controller.navigationBar setTintColor:kMyGreenColor];
                [self presentModalViewController:controller animated:YES];
                [[UIApplication sharedApplication] setStatusBarHidden:YES];
            }
        }
    }
    else
    {
        if(alertView.tag == 666)
        {
            if(buttonIndex == 0x00)
            {
                ProfileController *controller = (ProfileController*)[[ProfileController alloc] initWithNibName:@"ProfileController" bundle:nil];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        else
        {
            if(buttonIndex == 0x01) 
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                if([gSMS[0] length] > 0x00 && gSMS[0] != nil)
                {
                    [array addObject:gSMS[0]];
                }
                
                if([gSMS[1] length] > 0x00 && gSMS[1] != nil)
                {
                    [array addObject:gSMS[1]];
                }
                
                if([array count] == 0x00)
                {
                    AnnounceController *announce = (AnnounceController *)[[AnnounceController alloc] initWithNibName:@"AnnounceController" bundle:nil];
                    [self.navigationController pushViewController:announce animated:YES];
                    return;
                }
                
                if(gSMS[2] == nil || [gSMS[2] length] == 0x00) {
                    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"];
                    gSMS[2] = [NSString stringWithFormat:@"현재 %@님이 (전화번호, 차량번호, 택시회사)를 타고 (지역) 근처에서 출발하였습니다.", phone];
                }
                
                if([gTAXI_NUM length] == 0x00) {
                    gTAXI_NUM = @"전화번호";
                }
                if([gTAXI_SERIAL length] == 0x00) {
                    gTAXI_SERIAL = @"차량번호";
                }
                if([gTAXI_COMPANY length] == 0x00) {
                    gTAXI_COMPANY = @"택시회사";
                }
                
                NSString *contents = [NSString stringWithFormat:@"%@", gSMS[2]];
                contents = [contents stringByReplacingOccurrencesOfString:@"전화번호" withString:gTAXI_NUM];
                contents = [contents stringByReplacingOccurrencesOfString:@"차량번호" withString:gTAXI_SERIAL];
                contents = [contents stringByReplacingOccurrencesOfString:@"택시회사" withString:gTAXI_COMPANY];
                if([self.mAlertTextFeild.text length] > 0x00) {
                    contents = [contents stringByReplacingOccurrencesOfString:@"(지역)" withString:self.mAlertTextFeild.text];
                }
                
                [self openKaKaoToc:[NSString stringWithFormat:contents]];
            }
        }
    }
}


- (IBAction)smsAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self addTextFeildAlert:button.tag];
}


- (void)openKaKaoToc:(NSString*)string
{
    NSString *message = string;
    NSString *referenceURLString = @"";
    NSString *appBundleID = @"com.toc.momtaxi";
    NSString *appVersion = @"2.0";
    NSString *appName = @"엄마택시";
    
    NSMutableArray *metaInfoArray = [[NSMutableArray alloc] init];
    NSDictionary *metaInfoIOS = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios", @"os",
                                 @"phone", @"devicetype",
                                 @"http://itunes.apple.com/app/id362057947?mt=8", @"installurl", 
                                 @"example://example", @"executeurl",
                                 nil];
    
    [metaInfoArray addObject:metaInfoIOS];
    
    BOOL isInstall = [[KakaoLinkCenter defaultCenter] openKakaoLinkWithURL:referenceURLString 
                                                                appVersion:appVersion 
                                                               appBundleID:appBundleID 
                                                                   appName:appName 
                                                                   message:message];
    
    if(isInstall == YES) {
        [[KakaoLinkCenter defaultCenter] openKakaoAppLinkWithMessage:message URL:referenceURLString
                                                         appBundleID:appBundleID
                                                          appVersion:appVersion
                                                             appName:appName 
                                                       metaInfoArray:metaInfoArray];
    }
    else {
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"친구에게 알리기" message:@"카카오톡이 설치되어 있지 않습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


- (void)stopLocationUpdate
{
    [self.mIndicator stopAnimating];
    [self.mLocationManager stopUpdatingLocation];
    self.mDistanceString = [NSString stringWithFormat:@"%.2f", ([self.mLocationStart distanceFromLocation:self.mLocationEnd] / 1000)];
    [self.mTableView reloadData];
}


#pragma mark location update
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSString *locationString = [NSString stringWithFormat:@"φ:%.4F, λ:%.4F", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    switch((NSInteger)self.mConditionIndex)
    {
        case start:
        {
            self.mLocationStart = newLocation;
            break;
        }
        case end:
        {
            self.mLocationEnd = newLocation;
            break;
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
