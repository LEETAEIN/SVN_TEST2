//
//  WaitModeForController.m
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "WaitModeForController.h"
#import "AppDelegate.h"
#import "Annotation.h"


@implementation WaitModeForController
@synthesize mImageView;
@synthesize mMapView;
@synthesize mLabel;
@synthesize mItem;
@synthesize mArray;
@synthesize mTimer;
@synthesize mAlertTextFeild;
@synthesize mAlertView;
@synthesize mGestureRecognizer;


// [self.mMapView removeAnnotations:self.mArray];
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"agree"];
    if([string isEqualToString:@"yes"] == YES)
    {
        self.mTimer = [NSTimer scheduledTimerWithTimeInterval:kIntervalTimer * 4.0f target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    }
}


- (void)updateLocation
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate initLocationInfo];
    [delegate.gClassRequest updateMyLocation:gDefineDataType[valueJson] user:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"] locationX:gLocationInfo.s_locationX locationY:gLocationInfo.s_locationY];
    [self settingMapView];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:kMyGreenColor];
    [self setTitle:@"승객위치 확인하기"];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 37.0f)];
    [button setImage:[UIImage imageNamed:@"BTN_REFRESH.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refreshLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:item];
    
    [self settingMapView];
    [self performSelector:@selector(makeRecognizerController) withObject:nil afterDelay:2.0f];
    
    [self.mImageView setHidden:NO];
    [self.mLabel setHidden:NO];

    self.mItem = [[UIBarButtonItem alloc] initWithTitle:@"모드 전환" style:UIBarButtonItemStylePlain target:self action:@selector(callPassengerItem:)];
    [self.navigationItem setLeftBarButtonItem:self.mItem];
    [self.mItem setTintColor:kMyGreenColor];
}


- (void)settingMapView
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CLLocationCoordinate2D location;
	location.latitude = delegate.gLocation.coordinate.latitude;
	location.longitude = delegate.gLocation.coordinate.longitude;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(delegate.gLocation.coordinate, gDistanceValue * 1000, gDistanceValue * 1000);
    MKCoordinateRegion region = [self.mMapView regionThatFits:viewRegion];
    [self.mMapView setRegion:region animated:YES];
    [self.mMapView setDelegate:self];
    
    [self performSelector:@selector(setAnnotation) withObject:nil afterDelay:2.0];
}


- (void)setAnnotation
{
    CLLocationCoordinate2D object;
    object.latitude = gLocationInfo_push.s_locationX_push;
    object.longitude = gLocationInfo_push.s_locationY_push;
    
    Annotation *annotation = [[Annotation alloc] initWithCoordinate:object];
    [annotation setTitle:gUS_NUM];
    
    self.mArray  = [[NSMutableArray alloc] init];
    [self.mArray addObject:annotation];
    
    if([self.mArray count] > 0x01)
    {
        for(NSInteger i = 0; i < [self.mArray count]; i++)
        {
            if(i > 0)
            {
                [self.mArray removeObjectAtIndex:i];
            }
        }
    }
    [self.mMapView addAnnotations:self.mArray];
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{   
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title];
    customPinView.pinColor = MKPinAnnotationColorPurple;
    customPinView.animatesDrop = NO;
    customPinView.canShowCallout = YES;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(callPassenger:) forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;
    
    return customPinView;
}


- (void)calloutAnnotationView:(id <MKAnnotation >)annotation
{
	[self.mMapView selectAnnotation:annotation animated:YES];
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
}


- (void)callPassengerItem:(UIBarButtonItem*)sender
{
    if(gIsUserCall == YES && self.mImageView.hidden == YES)
    {
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"알림" message:@"대기모드로 전환 하시겠습니까?" delegate:self cancelButtonTitle:@"예" otherButtonTitles:@"아니오", nil];
        [alertView setTag:888];
        [alertView show];
    }
}


- (void)callPassenger:(UIButton*)sender
{
    NSString *number = [NSString stringWithFormat:@"tel:%@", gUS_NUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}


- (void)refreshLocation:(UIButton*)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([delegate.gLocationArray count] <= 0x00) return;
    NSDictionary *dicttionary = [delegate.gLocationArray objectAtIndex:0x00];
    CLLocationCoordinate2D object;
    object.latitude = [[dicttionary objectForKey:@"X"] doubleValue];
    object.longitude = [[dicttionary objectForKey:@"Y"] doubleValue];
    
NS_DURING
    if([self.mArray count] > 0x00)
    {
        [self.mMapView removeAnnotations:self.mArray];
    }
    [self setAnnotation];
NS_HANDLER
NS_ENDHANDLER
}


- (void)makeRecognizerController
{
	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [recognizer addTarget:self action:@selector(handleTapFrom:)];
	[recognizer setDelegate:self];
	[recognizer setDelaysTouchesEnded:YES];
    [self.mMapView addGestureRecognizer:recognizer];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(gIsUserCall == YES && self.mImageView.hidden == NO)
    {
        [self addTextFeildAlert];
        self.mGestureRecognizer = gestureRecognizer;
    }

	return YES;
}


- (void)addTextFeildAlert
{
    self.mAlertView = [[UIAlertView alloc] initWithTitle:@"비밀번호 입력하세요" message:@"nil" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    self.mAlertTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];
    [self.mAlertTextFeild setTag:999];
    
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0, 60);
    [self.mAlertView setTransform:myTransform];
    [self.mAlertTextFeild setBackgroundColor:[UIColor whiteColor]];
    [self.mAlertView addSubview:self.mAlertTextFeild];
    [self.mAlertView setTag:999];
    [self.mAlertView show];
}


- (void)readData
{
	NSFileManager *fileMng = [NSFileManager defaultManager];
	NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [dirPath objectAtIndex:0x00];
    NSString *fileName = [NSString stringWithFormat:@"data.dat"];
	NSString *fullPath = [path stringByAppendingPathComponent:fileName];
	
	if([fileMng fileExistsAtPath:fullPath] == NO) {
	}
	else
	{
		NSString *password = [[NSString alloc] initWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
        if([password length] > 0x00)
        {
            NSData *data = [[NSData alloc] initWithData:[self.mAlertTextFeild.text dataUsingEncoding:NSUTF8StringEncoding]];
            unsigned char *bytes = (unsigned char *)[data bytes];
            NSMutableString *object = [NSMutableString string];
            for(NSInteger i = 0; i < [data length]; i++)
            {
                bytes[i] ^= 0xFF;
                [object appendFormat:@"%%%02X", bytes[i]];
            }
            
            if([object isEqualToString:password] == YES)
            {
                if(gIsUserCall == YES && self.mImageView.hidden == NO)
                {
                    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    [delegate.gClassRequest modeChange:gDefineDataType[valueJson] taxi:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"] wait:@"2"];
                    [self.mMapView removeGestureRecognizer:self.mGestureRecognizer];
                    
                    [self.mImageView setHidden:YES];
                    [self.mLabel setHidden:YES];
                }
            }
            else
            {
                UIAlertView *alertView = 
                [[UIAlertView alloc] initWithTitle:@"알림" message:@"회원가입시 입력하신 비밀번호와 다릅니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
	}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 999)
    {
        if(buttonIndex == 0x01)
        {
            [self readData];
        }
    }
    
    if(alertView.tag == 888)
    {
        if(buttonIndex == 0x00)
        {
            [self.mImageView setHidden:NO];
            [self.mLabel setHidden:NO];
            
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate.gClassRequest modeChange:gDefineDataType[valueJson] taxi:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"] wait:@"1"];
            [delegate.gClassRequest cancelTaxiCall:gDefineDataType[valueJson] phone:gUS_NUM];
            gIsUserCall = NO;
            
            [self makeRecognizerController];
            [self.mImageView setHighlighted:NO];
        }
    }
}


- (void)handleTapFrom:(id)recognizer
{
    // 기사님 회원가입 모달뷰로 인래 터치와 제스쳐의 액티브 영역이 잘못 추가된다.
    // 따라서 액션을 쓰지 않고 위에 델리게이트 메소드로 무조건 처리한다.
    // CGPoint point = [recognizer locationInView:recognizer.view];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
