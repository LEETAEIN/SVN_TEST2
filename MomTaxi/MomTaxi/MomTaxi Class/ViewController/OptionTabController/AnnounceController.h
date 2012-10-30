//
//  AnnounceController.h
//  MomTaxi
//
//  Created by  on 11. 11. 24..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface AnnounceController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UITextView *mTextView;
    IBOutlet UITextField *mTextFeild1;
    IBOutlet UITextField *mTextFeild2;
    IBOutlet UIToolbar *mToolBar;
}
@property (nonatomic, strong) IBOutlet UITextView *mTextView;
@property (nonatomic, strong) IBOutlet UITextField *mTextFeild1;
@property (nonatomic, strong) IBOutlet UITextField *mTextFeild2;
@property (nonatomic, strong) IBOutlet UIToolbar *mToolBar;
- (void)initMessage;
- (IBAction)doneAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (void)increaseView;
- (void)decreaseView;;
@end
