//
//  NoticeListController.h
//  MomTaxi
//
//  Created by  on 11. 11. 24..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface NoticeListController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    IBOutlet UITableView *mTableView;
    NSMutableArray *mArray;
    NSMutableData *mReceivedData;
    NSURLResponse *mResponse;
}
@property (nonatomic, strong) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSMutableData *mReceivedData;
@property (nonatomic, strong) NSURLResponse *mResponse;
- (void)getNoticeListView:(NSString*)dataType table:(NSString*)name;
@end

