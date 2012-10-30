//
//  AnnounceController.m
//  MomTaxi
//
//  Created by  on 11. 11. 24..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "AnnounceController.h"


@implementation AnnounceController
@synthesize mTextView;
@synthesize mTextFeild1;
@synthesize mTextFeild2;
@synthesize mToolBar;


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
    [self setTitle:@"엄마한테 알리기 설정"];
    
    [self initMessage];
    
    [self.mTextFeild1 setInputAccessoryView:self.mToolBar];
    [self.mTextFeild2 setInputAccessoryView:self.mToolBar];
    [self.mTextView setInputAccessoryView:self.mToolBar];
}


- (void)initMessage 
{
#if 0
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:@"HH:mm"]; 
    NSString *dateStr = [dateFormat stringFromDate:date]; 
#endif
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"];
#if 0
    NSString *serial = @"";
    NSString *driver = @"";
    NSString *number = @"";
#endif    
#if 0
    NSString *company = @"";
#endif
    
    NSString *message = [NSString stringWithFormat:@"현재 %@님이 (전화번호, 차량번호, 택시회사)를 타고 (지역)근처에서 출발하였습니다.", phone];
    [self.mTextView setText:message];    
    [self.mTextFeild1 setText:gSMS[0]];
    [self.mTextFeild2 setText:gSMS[1]];
}


- (IBAction)doneAction:(id)sender
{
    [self.mTextFeild1 resignFirstResponder];
    [self.mTextFeild2 resignFirstResponder];
    [self.mTextView resignFirstResponder];
    
    [self increaseView];
    gSMS[2] = self.mTextView.text;
}


- (IBAction)saveAction:(id)sender
{
    UIAlertView *alertView = nil;
    BOOL isOk = NO;
    if([self.mTextFeild1.text length] == 12 || [self.mTextFeild1.text length] == 13)
    {
        gSMS[0] = self.mTextFeild1.text;
        isOk = YES;
    }
#if 0
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰 번호를 확인하여 주십시오." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
#endif
    if([self.mTextFeild2.text length] == 12 || [self.mTextFeild2.text length] == 13)
    {
        gSMS[1] = self.mTextFeild2.text;
        isOk = YES;
    }
#if 0
    else
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰 번호를 확인하여 주십시오." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
#endif
    
    if(isOk == NO)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰 번호를 확인하여 주십시오." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"엄마한테 알리기 저장이 완료 되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    [alertView show];
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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
    
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self decreaseView];
    return YES;
}


- (void)increaseView
{
    [self.view setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
}


- (void)decreaseView
{
    [self.view setFrame:CGRectMake(0.0f, -100.0f, self.view.frame.size.width, self.view.frame.size.height)];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
#if 0
    if ([text isEqualToString: @"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
#endif
    return YES;   
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
