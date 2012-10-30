//
//  CustomerResisterForController.m
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "PassengerFixController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation PassengerFixController
@synthesize mAgreeSwitch;
@synthesize mPushSwitch;
@synthesize mNumberTextField;
@synthesize mView;
@synthesize mContentsView;
@synthesize mInfoLabel;
@synthesize mReceivedData;
@synthesize mResponse;


#define kPassengerCode      1
#define kComplete           100
#define kChangeMode         200


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.view setBackgroundColor:kMyBackGroundColor];
    
    [self.mNumberTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"]];
    [self.mPushSwitch setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfPush"] integerValue]];
    [self setTitle:@"개인정보수정"];
    
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
    
    // init barbuttonitem
    if(delegate.gIsChangeMode == NO) return;
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStyleDone target:self action:@selector(dissmissSelfCancel)];
    [cancel setTintColor:[UIColor colorWithRed:117.0f/255.0f green:162.0f/255.0f blue:014.0f/255.0f alpha:1.0f]];
    [self.navigationItem setRightBarButtonItem:cancel];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self increaseView];
	[textField resignFirstResponder];
	return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self decreaseView];
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
    
    /*
     * 기사님->승객 변경
     * 승객->승객 정보 수정
     */

    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"agree"];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(delegate.gIsChangeMode == YES)
    {
        [self changeDriverToPassenger:gDefineDataType[valueJson] phone:mNumberTextField.text];
    }
    else
    {
#if 0
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.gClassRequest RegisterAPNs:gDefineDataType[valueJson] phone:self.mNumberTextField.text accept:(NSInteger)gPushAccept];
        [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:5.0f];
#else
        [self RegisterUserRequest:gDefineDataType[valueJson] phone:self.mNumberTextField.text user:nil driver:nil car:nil member:nil photo:nil];
#endif
    }

    [self.mView setHidden:NO];
    [self.mInfoLabel setText:@"정보를 발송 하였습니다."];
}


- (void)increaseView
{
    [self.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
}


- (void)decreaseView
{
    [self.view setFrame:CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height)];
}


- (void)dissmissSelfController
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate initCustomerToInterface];
    [self dismissModalViewControllerAnimated:YES];
    [delegate.tabbarController setSelectedIndex:0];
    [delegate selectedTabButton:0];
}


- (void)dissmissSelfCancel
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma RequestCinnection ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------


- (void)RegisterUserRequest:(NSString*)dataType phone:(NSString*)number user:(NSString*)name driver:(NSString*)sex car:(NSString*)serial member:(NSString*)company photo:(NSString*)file
{
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_type=%d&us_number=%@", dataType, kPassengerCode, number];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueUpdateUser], apiElement];
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


- (void)changeDriverToPassenger:(NSString*)dataType phone:(NSString*)number
{
    NSString *apiElement = [NSString stringWithFormat:@"return_type=%@&us_number=%@", dataType, number];
    NSString *apiAddress = [NSString stringWithFormat:@"%@%@", gDefineAPI[valueChangeMode], apiElement];
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
    
    NSLog(@"PassengerFixController == %@", dictionary);
    
    [self hiddenInfoView];
    
    UIAlertView *alertView = nil;
    if([result rangeOfString:@"error"].location != NSNotFound)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[dictionary objectForKey:@"result_text"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else
    {
        /*
        [[NSUserDefaults standardUserDefaults] setObject:@"passenger" forKey:@"KeyOfDivide"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mNumberTextField.text forKey:@"KeyOfNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        alertView = [[UIAlertView alloc] initWithTitle:@"회원 전환이 완료 되었습니다." message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView setTag:kChangeMode];
        [alertView show]; 
        */
        
        //
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if(delegate.gIsChangeMode == YES)
        {
            [delegate removeUserInfoToDriver];
            delegate.gIsChangeMode = NO;
            [self.mInfoLabel setText:@"회원 전환이 완료 되었습니다."];
        }
        else
        {
            [self.mInfoLabel setText:@"회원가입이 완료 되었습니다."];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"passenger" forKey:@"KeyOfDivide"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mNumberTextField.text forKey:@"KeyOfNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:2.0f];
        [self performSelector:@selector(dissmissSelfController) withObject:nil afterDelay:3.0f];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 888)
    {
        if(buttonIndex == 0x00)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"agree"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"agree"];
        }
        
        /*
         * 기사님->승객 변경
         * 승객->승객 정보 수정
         */
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(delegate.gIsChangeMode == YES)
        {
            [self changeDriverToPassenger:gDefineDataType[valueJson] phone:mNumberTextField.text];
        }
        else
        {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate.gClassRequest RegisterAPNs:gDefineDataType[valueJson] phone:self.mNumberTextField.text accept:(NSInteger)gPushAccept];
            [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:5.0f];
        }
        
        [self.mView setHidden:NO];
        [self.mInfoLabel setText:@"정보를 발송 하였습니다."];
    }
    else
    {
        if(alertView.tag == kChangeMode)
        {
            [self dissmissSelfController];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            delegate.gIsChangeMode = NO;
        }
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
