//
//  CustomerResisterForController.h
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface PassengerRegisterController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *mContentsView;
    IBOutlet UISwitch *mAgreeSwitch;
    IBOutlet UISwitch *mPushSwitch;
    IBOutlet UITextField *mNumberTextField;
    IBOutlet UITextField *mCertifyTextFeild;
    IBOutlet UIView *mView;
    IBOutlet UILabel *mInfoLabel;
    IBOutlet UIToolbar *mToolbar;
    NSMutableData *mReceivedData;
    NSURLResponse *mResponse;
}
@property (nonatomic, strong) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, strong) IBOutlet UIView *mContentsView;
@property (nonatomic, strong) IBOutlet UISwitch *mAgreeSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *mPushSwitch;
@property (nonatomic, strong) IBOutlet UITextField *mNumberTextField;
@property (nonatomic, strong) IBOutlet UITextField *mCertifyTextFeild;
@property (nonatomic, strong) IBOutlet UIView *mView;
@property (nonatomic, strong) IBOutlet UILabel *mInfoLabel;
@property (nonatomic, strong) IBOutlet UIToolbar *mToolbar;
@property (nonatomic, strong) NSMutableData *mReceivedData;
@property (nonatomic, strong) NSURLResponse *mResponse;
- (void)hiddenInfoView;
- (void)dissmissSelfController;
- (void)RegisterUserRequest:(NSString*)dataType phone:(NSString*)number user:(NSString*)name driver:(NSString*)sex car:(NSString*)serial member:(NSString*)company photo:(NSString*)file;
- (void)registerDeviceToken;
- (void)setAccessorryView;
- (IBAction)toolbarAction:(UIBarButtonItem*)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)actionPushSwitch:(id)sender;
- (IBAction)certifyAction:(id)sender;
- (IBAction)termAction:(UIButton*)sender;
@end
