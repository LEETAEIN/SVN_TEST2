//
//  HistoryAffirmForController.m
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "HistoryAffirmForController.h"
#import "PassengerRegisterController.h"
#import "PassengerFixController.h"
#import "DriverRegisterFixController.h"
#import "NoticeListController.h"
#import "AppDelegate.h"


@implementation HistoryAffirmForController
@synthesize mScrollView;
@synthesize mView;
@synthesize mTableView;
@synthesize mNowPointLabel;
@synthesize mMyScoreLabel;
@synthesize mMyReCommandLabel;
@synthesize mReFillListLabel;
@synthesize mConsumePointLabel;
@synthesize mConsumeCountLabel;
@synthesize mIndicator;
@synthesize mArray;
@synthesize mReceivedData;
@synthesize mResponse;


#define kScrollViewContetnsOffset 640.0f
#define kPointNow       010
#define kMyScore        020
#define kMyRecommand    030
#define kReFillPoint    040
#define kConsumePoint   050
#define kCallCount      060
#define kCallList       070
#define kCallData       080
#define kUserID         090
#define kUserRegdate    100



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [self getCallList:gDefineDataType[valueJson] taxi:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:kMyGreenColor];
    [self.view setBackgroundColor:kMyBackGroundColor];
    [self.mView setBackgroundColor:kMyBackGroundColor];
    [self.mTableView setBackgroundColor:kMyBackGroundColor];
    [self setTitle:@"이용내역"];
    
    [self.mScrollView setContentSize:CGSizeMake(320.0f, kScrollViewContetnsOffset)];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"공지사항" style:UIBarButtonItemStyleDone target:self action:@selector(noticeContoller)];
    [cancel setTintColor:[UIColor colorWithRed:117.0f/255.0f green:162.0f/255.0f blue:014.0f/255.0f alpha:1.0f]];
    [self.navigationItem setRightBarButtonItem:cancel];
}


- (void)noticeContoller
{
    NoticeListController *controller = (NoticeListController *)[[NoticeListController alloc] initWithNibName:@"NoticeListController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	return [self.mArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    [cell.imageView setImage:[UIImage imageNamed:@"BG_TABLEVIEWCELL_POINT.png"]];
    
    if([self.mArray count] == 0x00) return nil;
    NSDictionary *dictionary = [self.mArray objectAtIndex:indexPath.row];
    /*
     {
     "uc_regdate" = "<null>";
     "user_num" = 0;
     }
     */

    NSString *title = [dictionary objectForKey:@"uc_regdate"];
    if([title isKindOfClass:[NSNull class]])
    {
        title = [[NSString alloc] initWithString:@""];
    }
    if([title length] == 0x00)
    {
        title = @"";
    }
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [cell.textLabel setText:title];

    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", [[dictionary objectForKey:@"user_num"] integerValue]]];
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0)
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]];
    }
}


- (IBAction)buyCoupon:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"포인트 구매" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"$0.99 ➟ 1000Point", @"$1.99 ➟ 2000Point", @"$2.99 ➟ 3000Point", @"$3.99 ➟ 4000Point", @"$4.99 ➟ 5000Point", @"$5.99 ➟ 6000Point", @"$9.99 ➟ 10000Point", nil];
    [actionSheet setActionSheetStyle:(UIActionSheetStyle)UIBarStyleBlackOpaque];
    [actionSheet showInView:self.tabBarController.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate buyCouponConnect:buttonIndex];
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}


- (IBAction)changeMode:(id)sender
{
#if 0
    UIAlertView *alertView = 
    [[UIAlertView alloc] initWithTitle:@"승객으로 전환 하시겠습니까?" message:@"택시기사로 재가입시 회원정보를 다시 입력해야 합니다." delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
    [alertView show];
#else
    DriverRegisterFixController *controller = 
    (DriverRegisterFixController *)[[DriverRegisterFixController alloc] initWithNibName:@"DriverRegisterFixController" bundle:nil];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self.navigationController presentModalViewController:navigation animated:YES];
#endif
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0x01)
    {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.gIsChangeMode = YES;

        UIViewController *viewController = [[PassengerFixController alloc] initWithNibName:@"PassengerFixController" bundle:nil]; 
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentModalViewController:navigationController animated:YES];
    }
}


#pragma mark RequestCinnection ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
- (void)getCallList:(NSString*)dataType taxi:(NSString*)number
{
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&taxi_number=%@", dataType, number];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueDriveCallList], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
    
    [self.mIndicator startAnimating];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
	[self.mReceivedData setLength:0];
    self.mResponse = aResponse;	
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.mReceivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{   
    if([[error  localizedDescription] rangeOfString:@"The request timed out"].location != NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"연결시간 초과" message:@"잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [self.mIndicator stopAnimating];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.mIndicator stopAnimating];
    
    NSString *result = [[NSString alloc] initWithData:self.mReceivedData encoding:NSUTF8StringEncoding];
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    UIAlertView *alertView = nil;
    if([result rangeOfString:@"error"].location != NSNotFound)
    {
        alertView = 
        [[UIAlertView alloc] initWithTitle:@"오류" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
NS_DURING
        NSString *total_chared_point = [dictionary objectForKey:@"total_chared_point"];
        NSString *total_use_point = [dictionary objectForKey:@"total_use_point"];
        NSString *total_call_count = [dictionary objectForKey:@"total_call_count"];
        
        if([total_chared_point isKindOfClass:[NSNull class]] == YES) total_chared_point = @"0";
        if([total_use_point isKindOfClass:[NSNull class]] == YES) total_use_point = @"0";
        if([total_call_count isKindOfClass:[NSNull class]] == YES) total_call_count = @"0";
        
        [self.mNowPointLabel setText:[dictionary objectForKey:@"my_point"]];
        [self.mMyScoreLabel setText:[dictionary objectForKey:@"aver_eval_point"]];
        [self.mMyReCommandLabel setText:[dictionary objectForKey:@"total_recommand_cnt"]];
        [self.mReFillListLabel setText:total_chared_point];
        [self.mConsumePointLabel setText:total_use_point];
        
        [self.mArray removeAllObjects];
        self.mArray = [dictionary objectForKey:@"list"];
        if([self.mArray count] == 0x00)
        {
            [self.mConsumeCountLabel setText:@"0"];
            return;
        }
        else
        {
            [self.mConsumeCountLabel setText:[NSString stringWithFormat:@"%d", [self.mArray count]]];   
        }
        [self.mTableView reloadData];
NS_HANDLER
NS_ENDHANDLER
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
