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


@interface PassengerFixController : UIViewController <UITextFieldDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    IBOutlet UISwitch *mAgreeSwitch;
    IBOutlet UISwitch *mPushSwitch;
    IBOutlet UITextField *mNumberTextField;
    IBOutlet UIView *mView;
    IBOutlet UILabel *mInfoLabel;
    IBOutlet UIView *mContentsView;
    NSMutableData *mReceivedData;
    NSURLResponse *mResponse;
}
@property (nonatomic, strong) IBOutlet UISwitch *mAgreeSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *mPushSwitch;
@property (nonatomic, strong) IBOutlet UITextField *mNumberTextField;
@property (nonatomic, strong) IBOutlet UIView *mView;
@property (nonatomic, strong) IBOutlet UILabel *mInfoLabel;
@property (nonatomic, strong) IBOutlet UIView *mContentsView;
@property (nonatomic, strong) NSMutableData *mReceivedData;
@property (nonatomic, strong) NSURLResponse *mResponse;
- (IBAction)registerAction:(id)sender;
- (IBAction)actionPushSwitch:(id)sender;
- (void)RegisterUserRequest:(NSString*)dataType phone:(NSString*)number user:(NSString*)name driver:(NSString*)sex car:(NSString*)serial member:(NSString*)company photo:(NSString*)file;
- (void)changeDriverToPassenger:(NSString*)dataType phone:(NSString*)number;
- (void)hiddenInfoView;
- (void)increaseView;
- (void)decreaseView;
- (void)dissmissSelfController;
- (void)dissmissSelfCancel;
- (IBAction)termAction:(UIButton*)sender;
@end
