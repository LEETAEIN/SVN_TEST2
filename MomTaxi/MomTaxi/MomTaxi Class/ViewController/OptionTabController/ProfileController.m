//
//  ProfileController.m
//  MomTaxi
//
//  Created by  on 11. 11. 24..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"
#import "AppraisalViewController.h"


@implementation ProfileController
@synthesize mTotalAppraisedLabel;
@synthesize mTotalScoreLabel;
@synthesize mTotalRecommandLabel;
@synthesize mTotalCountLabel;
@synthesize mTableView;
@synthesize mArray;
@synthesize mReceivedData;
@synthesize mResponse;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"];
    [self getRideHistory:gDefineDataType[valueJson] phone:string];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:kMyGreenColor];
    [self.mTableView setBackgroundColor:kMyBackGroundColor];
    [self.view setBackgroundColor:kMyBackGroundColor];
    [self setTitle:@"사용이력, 평가내역 보기"];
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
	
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }	
    
    NSDictionary *dictionary = [self.mArray objectAtIndex:indexPath.row];

    [cell.textLabel setTextColor:[UIColor colorWithRed:114.0f/255.0f green:155.0f/255.0f blue:24.0f/255.0f alpha:1.0f]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
	[cell.textLabel setText:[dictionary objectForKey:@"uu_regdate"]];
    
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
    
    NSString *uu_eval = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"uu_eval"]];
    if([uu_eval isEqualToString:@"0"] == YES)
    {
        [cell.detailTextLabel setText:@"평가하기"];
    }
    else
    {
        [cell.detailTextLabel setText:@"평가완료"];
    }
    
    /*
     "uu_eval" = 0;
     "uu_idx" = 2;
     "uu_regdate" = "2012-02-03 14:40:23";
     */
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [self.mArray objectAtIndex:indexPath.row];
    NSString *uu_eval = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"uu_eval"]];
    if([uu_eval isEqualToString:@"1"] == YES)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"이미 평가하셨습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        AppraisalViewController *controller = [[AppraisalViewController alloc] initWithNibName:@"AppraisalViewController" bundle:nil];
        NSDictionary *dictionary = [self.mArray objectAtIndex:indexPath.row];
        controller.mRecommandIndex = [[dictionary objectForKey:@"uu_idx"] integerValue];
        [self.navigationController pushViewController:controller animated:YES];
    }
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


#pragma mark RequestCinnection ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
- (void)getRideHistory:(NSString*)dataType phone:(NSString*)number
{
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@", dataType, number];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueRideHistoryList], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    if(connection)
    {
        self.mReceivedData = [NSMutableData dataWithCapacity:0];
    }
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
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"연결시간 초과" message:@"잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *result = [[NSString alloc] initWithData:self.mReceivedData encoding:NSUTF8StringEncoding];
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    NSLog(@"ProfileConroller == %@", dictionary);
    
    UIAlertView *alertView = nil;
    if([result rangeOfString:@"error"].location != NSNotFound)
    {
        alertView = 
        [[UIAlertView alloc] initWithTitle:@"오류" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        [self.mTotalAppraisedLabel setText:[dictionary objectForKey:@"total_eval_count"]];
        [self.mTotalScoreLabel setText:[dictionary objectForKey:@"aver_eval_point"]];
        [self.mTotalRecommandLabel setText:[dictionary objectForKey:@"total_recommand_cnt"]];

        NSString *total_count = [dictionary objectForKey:@"total_eval_count"];
        if([total_count isKindOfClass:[NSNull class]] == YES) total_count = @"0";
        [self.mTotalCountLabel setText:total_count];
        
        self.mArray = [[NSMutableArray alloc] init];
        NSArray *array = [dictionary objectForKey:@"list"];
        for(NSInteger i = 0; i< [array count]; i++)
        {
            NSDictionary *data = [array objectAtIndex:i];
            [self.mArray addObject:data];
        }
        [self.mTableView reloadData];
    }
    /*
     "uu_eval" = 0;
     "uu_idx" = 2;
     "uu_regdate" = "2012-02-03 14:40:23";
     */
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
