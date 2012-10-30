//
//  WaitModeForController.h
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"
#import <MapKit/MapKit.h>


@interface WaitModeForController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView *mImageView;
    IBOutlet MKMapView *mMapView;
    IBOutlet UILabel *mLabel;
    UIBarButtonItem *mItem;
    NSMutableArray *mArray;
    NSTimer *mTimer;
    
    UITextField *mAlertTextFeild;
    UIAlertView *mAlertView;
    UIGestureRecognizer *mGestureRecognizer;
}
@property (nonatomic, strong) IBOutlet UIImageView *mImageView;
@property (nonatomic, strong) IBOutlet MKMapView *mMapView;
@property (nonatomic, strong) IBOutlet UILabel *mLabel;
@property (nonatomic, strong) UIBarButtonItem *mItem;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSTimer *mTimer;
@property (nonatomic, strong) UITextField *mAlertTextFeild;
@property (nonatomic, strong) UIAlertView *mAlertView;
@property (nonatomic, strong) UIGestureRecognizer *mGestureRecognizer;
- (void)settingMapView;
- (void)setAnnotation;
- (void)callPassenger:(UIButton*)sender;
- (void)callPassengerItem:(UIBarButtonItem*)sender;
- (void)refreshLocation:(UIButton*)sender;
- (void)makeRecognizerController;
- (void)handleTapFrom:(id)recognizer;
- (void)updateLocation;
- (void)addTextFeildAlert;
- (void)readData;
@end
