//
//  DetailViewDriverController.h
//  MomTaxi
//
//  Created by  on 11. 11. 28..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface DetailViewDriverController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *mTableView;
    IBOutlet UITextField *mTextFeild1;
    IBOutlet UITextField *mTextFeild2;
    IBOutlet UITextField *mTextFeild3;
    IBOutlet UIImageView *mImageView;
    UIImageView *detailImageView;
    NSMutableArray *mArray;
    NSDictionary *mDictionary;
    UIImage *mImage;
    BOOL mIsShowImage;
}
@property (nonatomic, strong) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) IBOutlet UITextField *mTextFeild1;
@property (nonatomic, strong) IBOutlet UITextField *mTextFeild2;
@property (nonatomic, strong) IBOutlet UITextField *mTextFeild3;
@property (nonatomic, strong) IBOutlet UIImageView *mImageView;
@property (nonatomic, strong) UIImageView *detailImageView;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSDictionary *mDictionary;
@property (nonatomic, strong) UIImage *mImage;
@property BOOL mIsShowImage;
- (UIImageView*)attachImageView;
- (UITextField*)attachTextField:(NSInteger)index;
- (IBAction)bottomButton:(id)sender;
- (UIButton*)attachImageButton;
- (void)showImageView;
@end
