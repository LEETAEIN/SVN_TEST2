//
//  DriverResisterForController.h
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface DriverRegisterController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
{
    IBOutlet UIScrollView *mScrollView; 
    IBOutlet UIView *mContentsView;
    IBOutlet UITextField *mNameTextField;
    IBOutlet UITextField *mNumberTextField;
    IBOutlet UITextField *mCertifyTextField;
    IBOutlet UITextField *mSerialTextField;
    IBOutlet UITextField *mCompanyTextField;
    IBOutlet UITextField *mPasswordTextField;
    IBOutlet UITextField *mPasswordCkeckTextField;
    IBOutlet UIButton *mManButton;
    IBOutlet UIButton *mWomanButton;
    IBOutlet UIButton *mImageButton;
    IBOutlet UISwitch *mAgreeSwitch;
    IBOutlet UISwitch *mPushSwitch;
    IBOutlet UIView *mView;
    IBOutlet UILabel *mInfoLabel;
    IBOutlet UIToolbar *mToolbar;
    UIImage *mImage;
    NSInteger mDivPhoto;
    NSMutableData *mReceivedData;
    NSURLResponse *mResponse;
    NSInteger mIndex;
}
@property (nonatomic, strong) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, strong) IBOutlet UIView *mContentsView;
@property (nonatomic, strong) IBOutlet UITextField *mNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *mNumberTextField;
@property (nonatomic, strong) IBOutlet UITextField *mCertifyTextField;
@property (nonatomic, strong) IBOutlet UITextField *mSerialTextField;
@property (nonatomic, strong) IBOutlet UITextField *mCompanyTextField;
@property (nonatomic, strong) IBOutlet UITextField *mPasswordTextField;
@property (nonatomic, strong) IBOutlet UITextField *mPasswordCkeckTextField;
@property (nonatomic, strong) IBOutlet UIButton *mManButton;
@property (nonatomic, strong) IBOutlet UIButton *mWomanButton;
@property (nonatomic, strong) IBOutlet UIButton *mImageButton;
@property (nonatomic, strong) IBOutlet UISwitch *mAgreeSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *mPushSwitch;
@property (nonatomic, strong) IBOutlet UIView *mView;
@property (nonatomic, strong) IBOutlet UILabel *mInfoLabel;
@property (nonatomic, strong) IBOutlet UIToolbar *mToolbar;
@property (nonatomic, strong) UIImage *mImage;
@property (nonatomic, strong) NSMutableData *mReceivedData;
@property (nonatomic, strong) NSURLResponse *mResponse;
@property NSInteger mDivPhoto;
@property NSInteger mIndex;
- (void)initControllerInterface;
- (void)setAccessorryView;
- (void)hiddenInfoView;
- (void)RegisterUserRequest:(NSString*)dataType phone:(NSString*)number user:(NSString*)name driver:(NSString*)sex car:(NSString*)serial member:(NSString*)company;
- (void)changeModeRequest:(NSString*)dataType phone:(NSString*)number user:(NSString*)name driver:(NSString*)sex car:(NSString*)serial member:(NSString*)company;
- (void)dissmissSelfController;
- (void)dissmissCancel;
- (void)registerDeviceToken;
- (void)writePassword:(NSString*)password;
- (IBAction)pushSwitchAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)photoAction:(id)sender;
- (IBAction)sexAction:(UIButton*)sender;
- (IBAction)toolbarAction:(UIBarButtonItem*)sender;
- (IBAction)certifyAction:(id)sender;
- (IBAction)nextAction:(UIBarButtonItem*)sender;
- (IBAction)termAction:(UIButton*)sender;
@end