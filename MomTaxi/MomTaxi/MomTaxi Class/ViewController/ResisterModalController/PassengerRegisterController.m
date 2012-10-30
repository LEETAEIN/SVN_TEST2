//
//  CustomerResisterForController.m
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "PassengerRegisterController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation PassengerRegisterController
@synthesize mScrollView;
@synthesize mContentsView;
@synthesize mAgreeSwitch;
@synthesize mPushSwitch;
@synthesize mNumberTextField;
@synthesize mCertifyTextFeild;
@synthesize mView;
@synthesize mInfoLabel;
@synthesize mReceivedData;
@synthesize mResponse;
@synthesize mToolbar;


#define kPassengerCode      1
#define kComplete           100


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.gTabView setHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.gTabView setHidden:NO];    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.view setBackgroundColor:kMyBackGroundColor];
    [self setTitle:@"택시손님 회원가입"];
    
    [self.mScrollView setContentSize:CGSizeMake(self.mContentsView.frame.size.width, self.mContentsView.frame.size.height)];
    [self.mScrollView addSubview:self.mContentsView];
    [self.mView setFrame:CGRectMake(10.0f, 180.0f, self.mView.frame.size.width, self.mView.frame.size.height)];
    [self.mScrollView addSubview:self.mView];

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([delegate isConfirmPush] == UIRemoteNotificationTypeNone)
    {
        [self.mPushSwitch setOn:NO];
    }
    else
    {
        [self.mPushSwitch setOn:YES];
    }
    
    [self.mView.layer setCornerRadius:25.0f];
    [self.mView setHidden:YES];
    
    [self setAccessorryView];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    
    if(textField == self.mNumberTextField)
    {
        // 인증 api
        [self.mView setHidden:NO];
        [self.mInfoLabel setText:@"인증 번호를 발송 하였습니다."];
        [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:5.0f];
    }
    
	return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.mNumberTextField)
    {
        NSString *inputString = [NSString stringWithFormat:@"%@%@", textField.text, string];
		inputString = [inputString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSString *phone1 = @"";
		NSString *phone2 = @"";
		NSString *phone3 = @"";
		
		phone1 = inputString;
		if ([inputString length] >= 3)
        {
			phone1 = [inputString substringToIndex:3];
		}
        
		if ([inputString length] >= 4 && [inputString length] <= 6)
        {
			phone2 = [inputString substringFromIndex:3];
		}	
		
		if ([inputString length] >= 7 && [inputString length] <= 10)
        {
			phone2 = [inputString substringWithRange:NSMakeRange(3, 3)];
			phone3 = [inputString substringFromIndex:6];
		}
		
		if ([inputString length] >= 11)
        {
			phone2 = [inputString substringWithRange:NSMakeRange(3, 4)];
			phone3 = [inputString substringFromIndex:7];
		}
        
		NSString *phone = @"";
		if (![phone2 isEqualToString:@""])
        {
			if (![phone3 isEqualToString:@""])
            {
				phone = [NSString stringWithFormat:@"%@-%@-%@",phone1,phone2,phone3];
			}
			else
            {
				phone = [NSString stringWithFormat:@"%@-%@",phone1,phone2];
			}
		}
		else
        {
			phone = [NSString stringWithFormat:@"%@",phone1];
		}
        
		textField.text = [phone substringToIndex:[phone length] - 1];
    }
    
    return YES;
}


- (void)hiddenInfoView
{
    [self.mView setHidden:YES];
}


- (IBAction)certifyAction:(id)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if([self.mNumberTextField.text length] == 12 || [self.mNumberTextField.text length] == 13)
    {
        [self.mView setHidden:NO];
        [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:5.0f];
        [delegate.gClassRequest certifyPhone:gDefineDataType[valueJson] phone:self.mNumberTextField.text];
    }
    else
    {
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대전화 번호를 확인하여 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil];
        [alertView show];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{    
    if(textField == self.mNumberTextField)
    {
        [self.mScrollView setContentOffset:CGPointMake(0.0, 160.0f) animated:YES];
    }
    else if(textField == self.mCertifyTextFeild)
    {
        [self.mScrollView setContentOffset:CGPointMake(0.0, 210.0f) animated:YES];
    }
    
    return YES;
}


- (void)setAccessorryView
{
    [self.mNumberTextField setInputAccessoryView:self.mToolbar];
    [self.mCertifyTextFeild setInputAccessoryView:self.mToolbar];;
}


- (IBAction)toolbarAction:(UIBarButtonItem*)sender
{
    [self.mNumberTextField resignFirstResponder];
    [self.mCertifyTextFeild resignFirstResponder];
    
    [self.mScrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}


- (IBAction)actionPushSwitch:(id)sender
{
    UISwitch *controll = (UISwitch*)sender;
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    gPushAccept = controll.isOn;
    if(controll.isOn == YES)
    {
        [delegate setPushNotification];
    }
    else
    {
        [delegate deletePushNotification];
    }
}


- (IBAction)registerAction:(id)sender
{
    UIAlertView *alertView = nil;
    
    if([self.mNumberTextField.text length] < 12 || [self.mNumberTextField.text length] > 13)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대전화 번호를 확인하여 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil];
        [alertView show];
        return;
    }
    
    if(self.mAgreeSwitch.isOn == NO)
    {
        alertView = 
        [[UIAlertView alloc] initWithTitle:@"약관" message:@"동의하셔야만 택시를 검색하실 수 있습니다.\n동의 하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
        [alertView setTag:888];
        [alertView show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"agree"];

    [self RegisterUserRequest:gDefineDataType[valueJson] phone:self.mNumberTextField.text user:nil driver:nil car:nil member:nil photo:nil];
    [self.mView setHidden:NO];
    [self.mInfoLabel setText:@"가입 정보를 발송 하였습니다."];
    [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:5.0f];
}


#pragma mark RequestCinnection ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
- (void)RegisterUserRequest:(NSString*)dataType phone:(NSString*)number user:(NSString*)name driver:(NSString*)sex car:(NSString*)serial member:(NSString*)company photo:(NSString*)file
{
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_type=%d&us_number=%@&pv_str=%@", dataType, kPassengerCode, number, @"iphone"];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueRegister], apiElement];
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
    
    NSLog(@"PassengerResisterController == %@", dictionary);

    UIAlertView *alertView = nil;
    if([dictionary objectForKey:@"result"] == nil || [[dictionary objectForKey:@"result"] length] == 0x00)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"잠시 후 다시 시도하여 주십시오." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        [self hiddenInfoView];
        return;
    }
    
    if([result rangeOfString:@"error"].location != NSNotFound)
    {
        [self hiddenInfoView];
        
#if 1
        if([[dictionary objectForKey:@"result_text"] isEqualToString:@"이미 등록된 휴대전화번호입니다."] == YES)
        {
            alertView = 
            [[UIAlertView alloc] initWithTitle:@"이미 등록된 휴대전화번호입니다." message:@"바로 로그인 하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
            [alertView setTag:999];
            [alertView show];
        }
        else
        {
            alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
#else
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
#endif
    }
    else
    {
        [self.mInfoLabel setText:@"회원가입이 완료 되었습니다."];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"passenger" forKey:@"KeyOfDivide"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mNumberTextField.text forKey:@"KeyOfNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", (NSInteger)gPushAccept] forKey:@"KeyOfPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelector:@selector(registerDeviceToken) withObject:nil afterDelay:1.0f];
        [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:2.0f];
        [self performSelector:@selector(dissmissSelfController) withObject:nil afterDelay:3.0f];
        
    }
}


- (void)registerDeviceToken
{
    AppRequestController *request = (AppRequestController *)[[AppRequestController alloc] init];    
    [request RegisterDeviceToken:gDefineDataType[valueJson] phone:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"] device:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 999)
    {
        if(buttonIndex == 0x01)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"passenger" forKey:@"KeyOfDivide"];
            [[NSUserDefaults standardUserDefaults] setObject:self.mNumberTextField.text forKey:@"KeyOfNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", (NSInteger)gPushAccept] forKey:@"KeyOfPush"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSelector:@selector(registerDeviceToken) withObject:nil afterDelay:1.0f];
            [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:2.0f];
            [self performSelector:@selector(dissmissSelfController) withObject:nil afterDelay:3.0f];
        }
    }
    else if(alertView.tag == 888)
    {
        if(buttonIndex == 0x00)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"agree"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"agree"];
        }
        [self RegisterUserRequest:gDefineDataType[valueJson] phone:self.mNumberTextField.text user:nil driver:nil car:nil member:nil photo:nil];
        [self.mView setHidden:NO];
        [self.mInfoLabel setText:@"가입 정보를 발송 하였습니다."];
        [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:5.0f];
    }
}


- (void)dissmissSelfController
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initCustomerToInterface];
    [self dismissModalViewControllerAnimated:YES];
    [delegate.tabbarController setSelectedIndex:0];
    [delegate selectedTabButton:0];
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


- (IBAction)termAction:(UIButton*)sender
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *text = nil;
    if(sender.tag == 0)
    {
        text = [delegate readDataOfUser:@"term1"];
    }
    else 
    {
        text = [delegate readDataOfUser:@"term2"];
    }
    
    UITextView *textview = (UITextView *)[self.mContentsView viewWithTag:100];
    [textview setText:text];
}


@end
