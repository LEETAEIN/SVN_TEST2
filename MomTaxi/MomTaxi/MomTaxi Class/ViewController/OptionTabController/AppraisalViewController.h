//
//  AppraisalViewController.h
//  MomTaxi
//
//  Created by  on 11. 12. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface AppraisalViewController : UIViewController <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    IBOutlet UISegmentedControl *mScoreSegment;
    IBOutlet UIView *mView;
    NSMutableData *mReceivedData;
    NSURLResponse *mResponse;
    NSInteger mIsRecommandIndex;
    NSInteger mRecommandIndex;
}
@property (nonatomic, strong) IBOutlet UISegmentedControl *mScoreSegment;
@property (nonatomic, strong) IBOutlet UIView *mView;
@property (nonatomic, strong) NSMutableData *mReceivedData;
@property (nonatomic, strong) NSURLResponse *mResponse;
@property NSInteger mIsRecommandIndex;
@property NSInteger mRecommandIndex;
- (IBAction)scoreAction:(id)sender;
- (IBAction)recommendAction:(id)sender;
- (IBAction)completeAction:(id)sender;
- (void)RecommendRequest:(NSString*)dataType ID:(NSString*)idx score:(NSInteger)point recommend:(NSInteger)choice;
- (void)hiddenInfoView;
@end
