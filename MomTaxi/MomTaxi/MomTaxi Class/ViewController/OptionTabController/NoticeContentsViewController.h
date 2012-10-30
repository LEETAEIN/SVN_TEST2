//
//  NoticeContentsViewController.h
//  MomTaxi
//
//  Created by RCSoftASTaeinLee on 12. 1. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"


@interface NoticeContentsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UITextField *mTextFeild;
    IBOutlet UITextView *mTextView;
    IBOutlet UILabel *mLabel;
    NSDictionary *mDictionary;
}
@property (nonatomic, strong) IBOutlet UITextField *mTextFeild;
@property (nonatomic, strong) IBOutlet UITextView *mTextView;
@property (nonatomic, strong) IBOutlet UILabel *mLabel;
@property (nonatomic, strong) NSDictionary *mDictionary;
@end
