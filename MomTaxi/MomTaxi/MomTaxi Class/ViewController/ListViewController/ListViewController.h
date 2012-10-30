//
//  ListViewController.h
//  MomTaxi
//
//  Created by  on 11. 11. 7..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mTableView;
    NSMutableArray *mArray;
}
@property (nonatomic, strong) IBOutlet UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *mArray;
- (void)showImageView;
@end
