//
//  AppraisalViewController.m
//  MomTaxi
//
//  Created by  on 11. 12. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "AppraisalViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation AppraisalViewController
@synthesize mScoreSegment;
@synthesize mView;
@synthesize mReceivedData;
@synthesize mResponse;
@synthesize mIsRecommandIndex;
@synthesize mRecommandIndex;


#define kRecommendYES   10
#define kRecommendNO    20


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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:kMyGreenColor];
    [self.view setBackgroundColor:kMyBackGroundColor];
    [self setTitle:@"평가"];
    
    NSDictionary *textAttributes1 = [NSDictionary dictionaryWithObjectsAndKeys:kMyYellowColor, UITextAttributeTextColor, [UIFont systemFontOfSize:13], UITextAttributeFont, nil];
    [self.mScoreSegment setTintColor:[UIColor viewFlipsideBackgroundColor]];
    [self.mScoreSegment setTitleTextAttributes:textAttributes1 forState:UIControlStateHighlighted];
    [self.mScoreSegment setSelectedSegmentIndex:4];
    
    [self.mView.layer setCornerRadius:25.0f];
    [self.mView setHidden:YES];
    
    UIButton *button1 = (UIButton *)[self.view viewWithTag:10];
    [button1 setSelected:NO];
    
    UIButton *button2 = (UIButton *)[self.view viewWithTag:20];
    [button2 setSelected:NO];
}


- (IBAction)scoreAction:(id)sender { 
}


- (IBAction)recommendAction:(id)sender
{
    UIButton *controll = (UIButton *)sender;
    if(controll.tag == 10)
    {
        mIsRecommandIndex = 1;
        
        UIButton *button1 = (UIButton *)[self.view viewWithTag:10];
        [button1 setSelected:YES];
        
        UIButton *button2 = (UIButton *)[self.view viewWithTag:20];
        [button2 setSelected:NO];

    }
    if(controll.tag == 20)
    {
        mIsRecommandIndex = -1;
        
        UIButton *button1 = (UIButton *)[self.view viewWithTag:10];
        [button1 setSelected:NO];
        
        UIButton *button2 = (UIButton *)[self.view viewWithTag:20];
        [button2 setSelected:YES];
    }
}


- (IBAction)completeAction:(id)sender
{
    [self RecommendRequest:gDefineDataType[valueJson] ID:[NSString stringWithFormat:@"%d", self.mRecommandIndex] score:(NSInteger)self.mScoreSegment.selectedSegmentIndex + 1 recommend:self.mIsRecommandIndex];
}


#pragma RequestCinnection ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
- (void)RecommendRequest:(NSString*)dataType ID:(NSString*)idx score:(NSInteger)point recommend:(NSInteger)choice
{
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&uu_idx=%@&eval_point=%d&recommand=%d", dataType, idx, point, choice];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueDoTaxiScore], apiElement];
    apiAddress = [apiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kIntervalTimer];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[apiAddress dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    [self hiddenInfoView];
    
    if([[error  localizedDescription] rangeOfString:@"The request timed out"].location != NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"연결시간 초과" message:@"잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *result = [[NSString alloc] initWithData:self.mReceivedData encoding:NSUTF8StringEncoding];
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"AppraisalViewController = %@", dictionary);
    
    UIAlertView *alertView = nil;
    if([result rangeOfString:@"error"].location != NSNotFound)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"오류" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    }
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"평가" message:@"평가를 완료 하였습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    }
    [alertView show];
    [self hiddenInfoView];
}


- (void)hiddenInfoView
{
    [self.mView setHidden:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
