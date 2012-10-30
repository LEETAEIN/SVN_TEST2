//
//  NoticeListController.m
//  MomTaxi
//
//  Created by  on 11. 11. 24..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "NoticeListController.h"
#import "NoticeContentsViewController.h"


@implementation NoticeListController
@synthesize mTableView;
@synthesize mArray;
@synthesize mReceivedData;
@synthesize mResponse;


#define kAccesoryLength 15.0f
static NSString *apiURL = @"http://momtaxi.rcsoft.co.kr/api/getBoardList.php?";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self getNoticeListView:gDefineDataType[valueJson] table:@"notice"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:kMyGreenColor];
    [self.mTableView setBackgroundColor:kMyBackGroundColor];
    [self.view setBackgroundColor:kMyBackGroundColor];
    [self setTitle:@"공지사항"];
    
    self.mArray = [[NSMutableArray alloc] init];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma www.rcsoft.com
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return [self.mArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
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
    
    NSDictionary *dictionary = [self.mArray objectAtIndex:indexPath.row];
    NSString *title = [dictionary objectForKey:@"wr_subject"];
    NSString *date = [[dictionary objectForKey:@"wr_datetime"] substringToIndex:10];

    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
    [cell.textLabel setText:title];
    
    [cell.detailTextLabel setBackgroundColor:[UIColor redColor]];
    [cell.detailTextLabel setTextColor:kMyGreenColor];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
    [cell.detailTextLabel setText:date];
    
    UIImageView *accesoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kAccesoryLength, kAccesoryLength)];
    [accesoryView setBackgroundColor:[UIColor clearColor]];
    [accesoryView setImage:[UIImage imageNamed:@"BTN_ACCESORRYVIEW.png"]];
    [cell setAccessoryView:accesoryView];
    
    [cell.imageView setImage:[UIImage imageNamed:@"BG_TABLEVIEWCELL_POINT.png"]];
    
    if(indexPath.row == 0)
    {
        [cell.imageView setImage:[UIImage imageNamed:@"BG_TABLEVIEWCELL_NEW.png"]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:kTableViewFontSize]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeContentsViewController *controller = 
    (NoticeContentsViewController *)[[NoticeContentsViewController alloc] initWithNibName:@"NoticeContentsViewController" bundle:nil];
    controller.mDictionary = [self.mArray objectAtIndex:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma www.rcsoft.com
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
- (void)getNoticeListView:(NSString*)dataType table:(NSString*)name
{
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&bo_table=%@", dataType, name];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", apiURL, apiElement];
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
    if([[error localizedDescription] rangeOfString:@"The request timed out"].location != NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"연결시간 초과" message:@"잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receive = [[NSString alloc] initWithData:self.mReceivedData encoding:NSUTF8StringEncoding];
    NSData *data = [receive dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSString *result = [dictionary objectForKey:@"result"];
    
    [self.mArray removeAllObjects];
    self.mArray = [dictionary objectForKey:@"list"];

    if([result rangeOfString:@"error"].location != NSNotFound)
    {
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"알림" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    [self.mTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
