//
//  MapController.m
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "Annotation.h"
#import "DetailViewDriverController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation MapViewController
@synthesize mMapView;
@synthesize mSlider;
@synthesize mArray;
@synthesize mView;
@synthesize mDistanceLabel;
@synthesize mTimer;
@synthesize mIDString;


#define kDefaultDistance 2


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.mArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mView setHidden:YES];
    
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"agree"];
    [self updateLocation];
    if([string isEqualToString:@"yes"] == YES)
    {
        self.mTimer = [NSTimer scheduledTimerWithTimeInterval:kIntervalTimer * 20.0f target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    }
}


- (void)updateLocation
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate initLocationInfo];
    [delegate.gClassRequest updateMyLocation:gDefineDataType[valueJson] user:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"] locationX:gLocationInfo.s_locationX locationY:gLocationInfo.s_locationY];
    
    NSInteger count = [delegate.gLocationArray count];
    if(count == 0x00)
    {
        [self.mMapView removeAnnotations:self.mArray];
        [self.mArray removeAllObjects];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    gDistanceValue = kDefaultDistance;
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate initLocationInfo];
    [delegate.gClassRequest getListTaxiInfo:gDefineDataType[valueJson] locationX:gLocationInfo.s_locationX locationY:gLocationInfo.s_locationY distance:gDistanceValue];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 37.0f)];
    [button setImage:[UIImage imageNamed:@"BTN_REFRESH.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refreshLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:item];
    
    [self initSelfController];
    [self settingMapView];
}


- (void)initSelfController
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:kMyGreenColor];
    [self setTitle:@"택시검색-지도"];

    [self.mSlider setThumbImage:[UIImage imageNamed:@"BG_SLIDERARROW.png"] forState:UIControlStateNormal];
    [self.mSlider setThumbImage:[UIImage imageNamed:@"BG_SLIDERARROW.png"] forState:UIControlStateHighlighted];
    [self.mSlider setThumbImage:[UIImage imageNamed:@"BG_SLIDERARROW.png"] forState:UIControlStateSelected];
    [self.mSlider setValue:(CGFloat)kDefaultDistance];
    
    [self.mDistanceLabel setText:[NSString stringWithFormat:@"%.2f km", (CGFloat)gDistanceValue]];
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
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSInteger count = [delegate.gLocationArray count];
    
    if(count == 0x00)
    {
        [delegate initLocationInfo];
        return;
    }
    else
    {
        [self.mArray removeAllObjects];
        for(NSInteger i = 0; i < count; i++)
        {
            NSDictionary *listDic = [delegate.gLocationArray objectAtIndex:i];
            
            CLLocationCoordinate2D object;
#if 0
            object.latitude = [[listDic objectForKey:@"us_x_pos"] doubleValue];
            object.longitude = [[listDic objectForKey:@"us_y_pos"] doubleValue];
#else
            NSString *us_x_pos = [listDic objectForKey:@"us_x_pos"];
            NSString *us_y_pos = [listDic objectForKey:@"us_y_pos"];
            
            if([us_x_pos length] == 30) object.latitude = [delegate.gClassEncode decryptInfo:us_x_pos type:YES];
            if([us_y_pos length] == 30) object.longitude = [delegate.gClassEncode decryptInfo:us_y_pos type:NO];
#endif
            Annotation *annotation = [[Annotation alloc] initWithCoordinate:object];
            [annotation setTag:i];
            [annotation setTitle:[listDic objectForKey:@"us_name"]];
            [annotation setSubtitle:[listDic objectForKey:@"us_number"]];
            annotation.tag = i;
            
            [self.mArray addObject:annotation];
        }
        [self.mMapView addAnnotations:self.mArray];
    }
}


- (void)refreshLocation:(UIButton*)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.gClassRequest getListTaxiInfo:gDefineDataType[valueJson] locationX:gLocationInfo.s_locationX locationY:gLocationInfo.s_locationY distance:gDistanceValue];
    
    NSInteger count = [delegate.gLocationArray count];
    
    [self.mSlider setValue:(CGFloat)gDistanceValue];

    
    if(count <= 0x00) return;
    else
    {
NS_DURING
        if([self.mArray count] > 0x00)
        {
            [self.mMapView removeAnnotations:self.mArray];
        }
        [self setAnnotation];
NS_HANDLER
NS_ENDHANDLER
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{   
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title];
    customPinView.pinColor = MKPinAnnotationColorPurple;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;

    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSInteger count = [delegate.gImageArray count];
    for(NSInteger i = 0; i < count; i++)
    {
        NSDictionary *dictionary = [delegate.gImageArray objectAtIndex:i];
        NSString *name = [dictionary objectForKey:@"index"];
        if([name isEqualToString:annotation.title] == YES)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
            [imageView setBackgroundColor:[UIColor whiteColor]];
            [imageView.layer setCornerRadius:5.0f];
            [imageView setImage:[dictionary objectForKey:@"image"]];
            customPinView.leftCalloutAccessoryView = imageView;
            break;
        }
    }

    return customPinView;
}


- (void)showDetails:(UIButton*)sender
{
    BOOL hidden = self.mView.hidden;
    [self.mView setHidden:!hidden];
}


- (void)calloutAnnotationView:(id <MKAnnotation >)annotation
{
	[self.mMapView selectAnnotation:annotation animated:YES];
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	NSString *string = [NSString stringWithFormat:@"%@", view.annotation.title];
    self.mIDString = string;
}


#pragma mark IBAction List ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
- (IBAction)sliderAction:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    gDistanceValue = (double)slider.value;

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(delegate.gLocation.coordinate, gDistanceValue * 1000, gDistanceValue * 1000);
    MKCoordinateRegion region = [self.mMapView regionThatFits:viewRegion];
    [self.mMapView setRegion:region animated:YES];
    [self.mDistanceLabel setText:[NSString stringWithFormat:@"%.2f km", (CGFloat)gDistanceValue]];
}


- (IBAction)fixLocation:(id)sender
{
    gDistanceValue = (double)kDefaultDistance;

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(delegate.gLocation.coordinate, gDistanceValue * 1000, gDistanceValue * 1000);
    MKCoordinateRegion region = [self.mMapView regionThatFits:viewRegion];
    [self.mMapView setRegion:region animated:YES];
    [self.mDistanceLabel setText:[NSString stringWithFormat:@"%.2f km", (CGFloat)gDistanceValue]];
    
    [self.mSlider setValue:(CGFloat)gDistanceValue];
}


- (IBAction)detailView:(id)sender
{
    DetailViewDriverController *controller = [[DetailViewDriverController alloc] initWithNibName:@"DetailViewDriverController" bundle:nil];    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSInteger count = [delegate.gLocationArray count];
    NSDictionary *listDic = nil;
    NSInteger img = 0;
    for(NSInteger i = 0; i < count; i++)
    {
        listDic = [delegate.gLocationArray objectAtIndex:i];
        NSString *string = [listDic objectForKey:@"us_name"];
        if([string isEqualToString:self.mIDString] == YES)
        {
            img = i;
            break;
        }
    }
    
    NSInteger count2 = [delegate.gImageArray count];
    UIImage *image = nil;
    for(NSInteger i = 0; i < count2; i++)
    {
        NSDictionary *dictionary = [delegate.gImageArray objectAtIndex:i];
        NSString *name = [dictionary objectForKey:@"index"];
        if([name isEqualToString:[listDic objectForKey:@"us_name"]] == YES)
        {
            image = [dictionary objectForKey:@"image"];
            break;
        }
    }

    controller.mDictionary = listDic;
    controller.mImage = image;
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)taxiCall:(id)sender
{
    UIAlertView *alertView = 
    [[UIAlertView alloc] initWithTitle:@"손님의 휴대폰 번호와 위치정보가 전송됩니다." message:@"콜 승인시 다른 차량 잡으시면 안되요." delegate:self cancelButtonTitle:@"취소하기" otherButtonTitles:@"부르기", nil];
    [alertView setTag:999];
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 999)
    {   
        if(buttonIndex == 0x01)
        {
            NSString *myPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"];
            NSString *X = [NSString stringWithFormat:@"%f", gLocationInfo.s_locationX];
            NSString *Y = [NSString stringWithFormat:@"%f", gLocationInfo.s_locationY];

            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSInteger count = [delegate.gLocationArray count];
            NSDictionary *listDic = nil;
            for(NSInteger i = 0; i < count; i++)
            {
                listDic = [delegate.gLocationArray objectAtIndex:i];
                NSString *string = [listDic objectForKey:@"us_name"];
                if([string isEqualToString:self.mIDString] == YES)
                {
                    gTAXI_SERIAL = [listDic objectForKey:@"us_car_num"];
                    gTAXI_COMPANY = [listDic objectForKey:@"us_company"];
                    break;
                }
            }

            [delegate.gClassRequest callTaxiRequest:gDefineDataType[valueJson] phone:myPhone locationX:X locationY:Y car:[listDic objectForKey:@"us_number"]];
        }
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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
     
     
     
