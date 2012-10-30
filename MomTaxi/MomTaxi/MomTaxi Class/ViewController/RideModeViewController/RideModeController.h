//
//  RideModeController.h
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>


typedef enum {
    none = 0,
    start,
    end,
} GO_ARRIVE_CONDITION;


@interface RideModeController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate, UINavigationBarDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UITableView *mTableView;
    IBOutlet UILabel *mDateLabel;    
    IBOutlet UILabel *mTimeLabel0;
    IBOutlet UILabel *mTimeLabel1;
    IBOutlet UILabel *mMinLabel0;
    IBOutlet UILabel *mMinLabel1;
    IBOutlet UILabel *mSecLabel0;
    IBOutlet UILabel *mSecLabel1;
    IBOutlet UIActivityIndicatorView *mIndicator;
    UITextField *mAlertTextFeild;
    NSTimer *mTimer;
    NSMutableString *mTimeObject;
    NSString *mStartTime;
    NSString *mEndTime;
    
    CLLocationManager *mLocationManager;
    CLLocation *mLocationStart;
    CLLocation *mLocationEnd;
    NSString *mDistanceString;
    GO_ARRIVE_CONDITION mConditionIndex;
}
@property (nonatomic, strong) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) IBOutlet UILabel *mDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *mTimeLabel0;
@property (nonatomic, strong) IBOutlet UILabel *mTimeLabel1;
@property (nonatomic, strong) IBOutlet UILabel *mMinLabel0;
@property (nonatomic, strong) IBOutlet UILabel *mMinLabel1;
@property (nonatomic, strong) IBOutlet UILabel *mSecLabel0;
@property (nonatomic, strong) IBOutlet UILabel *mSecLabel1;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *mIndicator;
@property (nonatomic, strong) UITextField *mAlertTextFeild;
@property (nonatomic, strong) NSTimer *mTimer;
@property (nonatomic, strong) NSMutableString *mTimeObject;
@property (nonatomic, strong) NSString *mStartTime;
@property (nonatomic, strong) NSString *mEndTime;
@property (nonatomic, strong) CLLocationManager *mLocationManager;
@property (nonatomic, strong) CLLocation *mLocationStart;
@property (nonatomic, strong) CLLocation *mLocationEnd;
@property (nonatomic, strong) NSString *mDistanceString;
@property GO_ARRIVE_CONDITION mConditionIndex;
- (void)initLocationInfo;
- (void)initSelfController;
- (void)initDateAndTime;
- (void)reloadTime;
- (void)onTimer:(NSTimer*)timer;
- (IBAction)goAndStopAction:(UIButton*)sender;
- (IBAction)smsAction:(id)sender;
- (void)stopLocationUpdate;
- (void)addTextFeildAlert:(NSInteger)tag;
- (void)openKaKaoToc:(NSString*)string;
@end
