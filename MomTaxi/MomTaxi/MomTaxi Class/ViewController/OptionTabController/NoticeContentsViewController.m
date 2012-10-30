//
//  NoticeContentsViewController.m
//  MomTaxi
//
//  Created by RCSoftASTaeinLee on 12. 1. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "NoticeContentsViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation NoticeContentsViewController
@synthesize mTextFeild;
@synthesize mTextView;
@synthesize mLabel;
@synthesize mDictionary;


/*
 "ca_name" = "";
 "comment_cnt" = 0;
 "file_cnt" = "<null>";
 "is_notice" = "<null>";
 "is_secret" = "<null>";
 "mb_id" = admin;
 "reply_len" = "<null>";
 "wr_content" = "\Ud14c\Uc2a4\Ud2b8 \Uc9c4\Ud589\Uc911\Uc785\Ub2c8\Ub2e4";
 "wr_datetime" = "2012-01-19 17:12:43";
 "wr_hit" = 1;
 "wr_id" = 2;
 "wr_name" = "\Ucd5c\Uace0\Uad00\Ub9ac\Uc790";
 "wr_subject" = "\Uc5c4\Ub9c8\Ud0dd\Uc2dc \Uacf5\Uc9c0\Uc0ac\Ud56d .2";
 */


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"공지사항 자세히 보기"];
    
    [self.mTextFeild.layer setCornerRadius:8.0f];
    [self.mTextFeild.layer setBorderWidth:2.0f];
    [self.mTextFeild.layer setBorderColor:kMyGreenColor.CGColor];
    
    [self.mTextView.layer setCornerRadius:8.0f];
    [self.mTextView.layer setBorderWidth:2.0f];
    [self.mTextFeild.layer setBorderColor:kMyGreenColor.CGColor];
    
    [self.mTextFeild setText:[self.mDictionary objectForKey:@"wr_subject"]];
    [self.mTextView setText:[self.mDictionary objectForKey:@"wr_content"]];
    [self.mLabel setText:[self.mDictionary objectForKey:@"wr_datetime"]];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
