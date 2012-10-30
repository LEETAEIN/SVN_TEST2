//
//  MapController.h
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface MapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate>
{
    IBOutlet MKMapView *mMapView;
    IBOutlet UISlider *mSlider;
    IBOutlet UIView *mView;
    IBOutlet UILabel *mDistanceLabel;
    NSMutableArray *mArray;
    NSTimer *mTimer;
    NSString *mIDString;
}
@property (nonatomic, strong) IBOutlet MKMapView *mMapView;
@property (nonatomic, strong) IBOutlet UISlider *mSlider;
@property (nonatomic, strong) IBOutlet UIView *mView;
@property (nonatomic, retain) IBOutlet UILabel *mDistanceLabel;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSTimer *mTimer;
@property (nonatomic, strong) NSString *mIDString;
- (void)setAnnotation;
- (void)settingMapView;
- (void)initSelfController;
- (IBAction)sliderAction:(id)sender;
- (IBAction)fixLocation:(id)sender;
- (IBAction)detailView:(id)sender;
- (IBAction)taxiCall:(id)sender;
- (void)showDetails:(UIButton*)sender;
- (void)updateLocation;
- (void)refreshLocation:(UIButton*)sender;
@end
