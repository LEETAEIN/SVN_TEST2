//
//  HistoryAffirmForController.h
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface HistoryAffirmForController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    IBOutlet UIScrollView *mScrollView;
    IBOutlet UIView *mView;
    IBOutlet UITableView *mTableView;
    IBOutlet UILabel *mNowPointLabel;
    IBOutlet UILabel *mMyScoreLabel;
    IBOutlet UILabel *mMyReCommandLabel;
    IBOutlet UILabel *mReFillListLabel;
    IBOutlet UILabel *mConsumePointLabel;
    IBOutlet UILabel *mConsumeCountLabel;
    IBOutlet UIActivityIndicatorView *mIndicator;
    NSMutableArray *mArray;
    NSMutableData *mReceivedData;
    NSURLResponse *mResponse;
}
@property (nonatomic, strong) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, strong) IBOutlet UIView *mView;
@property (nonatomic, strong) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) IBOutlet UILabel *mNowPointLabel;
@property (nonatomic, strong) IBOutlet UILabel *mMyScoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *mMyReCommandLabel;
@property (nonatomic, strong) IBOutlet UILabel *mReFillListLabel;
@property (nonatomic, strong) IBOutlet UILabel *mConsumePointLabel;
@property (nonatomic, strong) IBOutlet UILabel *mConsumeCountLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *mIndicator;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSMutableData *mReceivedData;
@property (nonatomic, strong) NSURLResponse *mResponse;
- (void)getCallList:(NSString*)dataType taxi:(NSString*)number;
- (IBAction)buyCoupon:(id)sender;
- (IBAction)changeMode:(id)sender;
- (void)noticeContoller;
@end
