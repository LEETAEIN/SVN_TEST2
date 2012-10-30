//
//  ProfileController.h
//  MomTaxi
//
//  Created by  on 11. 11. 24..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface ProfileController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    IBOutlet UILabel *mTotalAppraisedLabel;
    IBOutlet UILabel *mTotalScoreLabel;
    IBOutlet UILabel *mTotalRecommandLabel;
    IBOutlet UILabel *mTotalCountLabel;
    IBOutlet UITableView *mTableView;
    NSMutableArray *mArray;
    NSMutableData *mReceivedData;
    NSURLResponse *mResponse;
}
@property (nonatomic, strong) IBOutlet UILabel *mTotalAppraisedLabel;
@property (nonatomic, strong) IBOutlet UILabel *mTotalScoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *mTotalRecommandLabel;
@property (nonatomic, strong) IBOutlet UILabel *mTotalCountLabel;


@property (nonatomic, strong) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSMutableData *mReceivedData;
@property (nonatomic, strong) NSURLResponse *mResponse;
- (void)getRideHistory:(NSString*)dataType phone:(NSString*)number;
@end
