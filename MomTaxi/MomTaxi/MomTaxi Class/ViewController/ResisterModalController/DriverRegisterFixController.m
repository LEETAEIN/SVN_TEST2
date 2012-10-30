//
//  DriverResisterForController.m
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "DriverRegisterFixController.h"
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>


@implementation DriverRegisterFixController
@synthesize mScrollView;
@synthesize mContentsView;
@synthesize mNameTextField;
@synthesize mNumberTextField;
@synthesize mCertifyTextField;
@synthesize mSerialTextField;
@synthesize mCompanyTextField;
@synthesize mToolbar;
@synthesize mManButton;
@synthesize mWomanButton;
@synthesize mImageButton;
@synthesize mAgreeSwitch;
@synthesize mPushSwitch;
@synthesize mView;
@synthesize mInfoLabel;
@synthesize mImage;
@synthesize mDivPhoto;
@synthesize mReceivedData;
@synthesize mResponse;
@synthesize mIndex;


#define kDriverCode 2


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        /*
         * 이 클래스는 최초 기사님 회원가입
         * 손님에서 기사님으로 모드 수정 둘 다 처리함
         */
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.gTabView setHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.gTabView setHidden:NO];    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kMyBackGroundColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self setTitle:@"택시기사님 정보수정"];

    [self initControllerInterface];
    [self setAccessorryView];

#if 0
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(delegate.gIsChangeMode == YES)
    {
        UIButton *button = (UIButton*)[self.view viewWithTag:100];
        [button setImage:[UIImage imageNamed:@"BTN_RESISTERFIX.png"] forState:UIControlStateNormal];
    }
#endif
    
    [self preViewController];
}


- (void)preViewController
{
    [self.mNameTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfName"]];
    [self.mNumberTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"]];
    [self.mSerialTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfSerial"]];
    [self.mCompanyTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfCompany"]];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfCompany"] isEqualToString:@"0"] == YES) {
        [self.mManButton setSelected:YES];
    }
    else {
        [self.mWomanButton setSelected:YES];
    }
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfPush"] isEqualToString:@"0"] == YES) {
        [self.mPushSwitch setOn:NO];
    }
    else {
        [self.mPushSwitch setOn:YES];
    }
}


- (void)initControllerInterface
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // init infoView
    [self.mView setFrame:CGRectMake(10.0f, 200.0f, self.mView.frame.size.width, self.mView.frame.size.height)];
    [self.mView.layer setCornerRadius:25.0f];
    [self.mView setHidden:YES];
    [self.view addSubview:self.mView];
    
    // init ScrollView
    [self.mScrollView setBackgroundColor:kMyBackGroundColor];
    if(delegate.gIsChangeMode == NO)
    {
        [self.mScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.mContentsView.frame.size.height)];
    }
    else
    {
        [self.mScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.mContentsView.frame.size.height)];
    }
    [self.mScrollView addSubview:self.mContentsView];
    
    // init button image
	NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [dirPath objectAtIndex:0];
	NSString *dstPath = [path stringByAppendingPathComponent:@"carsample.png"];
	if([[NSFileManager defaultManager] fileExistsAtPath:dstPath] == NO)
    {
        self.mImage = [[UIImage alloc] init];
	}
	else
    {
        self.mImage  = [[UIImage alloc] initWithContentsOfFile:dstPath];
        [self.mImageButton setImage:self.mImage forState:UIControlStateNormal];
    }
    
    // init push switch
    if([delegate isConfirmPush] == UIRemoteNotificationTypeNone)
    {
        [self.mPushSwitch setOn:NO];
    }
    
    // init barbuttonitem 
#if 0
    if(delegate.gIsChangeMode == NO) return;
#endif
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStyleDone target:self action:@selector(dissmissCancel)];
    [cancel setTintColor:[UIColor colorWithRed:117.0f/255.0f green:162.0f/255.0f blue:014.0f/255.0f alpha:1.0f]];
    [self.navigationItem setRightBarButtonItem:cancel];

#if 0
    if(delegate.gIsChangeMode == YES)
    {
        [self.mNumberTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"]];
        [self.mNumberTextField setTextColor:[UIColor darkGrayColor]];
        [self.mNumberTextField setUserInteractionEnabled:YES];
    }
#endif
}


- (void)setAccessorryView
{
    [self.mNameTextField setInputAccessoryView:self.mToolbar];
    [self.mNumberTextField setInputAccessoryView:self.mToolbar];;
    [self.mCertifyTextField setInputAccessoryView:self.mToolbar];
    [self.mSerialTextField setInputAccessoryView:self.mToolbar];
    [self.mCompanyTextField setInputAccessoryView:self.mToolbar];
}


- (IBAction)toolbarAction:(UIBarButtonItem*)sender
{
    [self.mNameTextField resignFirstResponder];
    [self.mNumberTextField resignFirstResponder];;
    [self.mCertifyTextField resignFirstResponder];
    [self.mSerialTextField resignFirstResponder];
    [self.mCompanyTextField resignFirstResponder];
#if 0
    [self.mScrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
#endif
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

    if([self.mNameTextField.text length] == 0)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"이름을 확인하여 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if([self.mSerialTextField.text length] == 0)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"차량번호를 확인하여 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if([self.mCompanyTextField.text length] == 0)
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"회사를 선택하여 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if(self.mAgreeSwitch.isOn == NO)
    {
        alertView = 
        [[UIAlertView alloc] initWithTitle:@"약관" message:@"동의하셔야만 손님을 검색하실 수 있습니다.\n동의 하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
        [alertView setTag:888];
        [alertView show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"agree"];
    
    //  2. 가입
    NSString *sex = @"남";
    if(gSex == 1)
    {
        sex = @"여";
    }

#if 0
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(delegate.gIsChangeMode == NO)
    {
        [self RegisterUserRequest:gDefineDataType[valueJson] phone:self.mNumberTextField.text user:self.mNameTextField.text driver:sex car:self.mSerialTextField.text member:self.mCompanyTextField.text];
    }
    else
    {
        [self changeModeRequest:gDefineDataType[valueJson] phone:self.mNumberTextField.text user:self.mNameTextField.text driver:sex car:self.mSerialTextField.text member:self.mCompanyTextField.text];
    }
#else
    [self changeModeRequest:gDefineDataType[valueJson] phone:self.mNumberTextField.text user:self.mNameTextField.text driver:sex car:self.mSerialTextField.text member:self.mCompanyTextField.text];
#endif
    [self.mView setHidden:NO];
    [self.mInfoLabel setText:@"정보를 발송 하였습니다."];
}


- (IBAction)sexAction:(UIButton*)sender
{
    gSex = sender.tag;
    switch(gSex)
    {
        case 0:
        {
            if(self.mManButton.selected == NO)
            {
                [self.mManButton setSelected:YES];
                [self.mWomanButton setSelected:NO];
            }
            else
            {
                [self.mManButton setSelected:NO];
            }
            break;
        }
        case 1:
        {
            if(self.mWomanButton.selected == NO)
            {
                [self.mWomanButton setSelected:YES];
                [self.mManButton setSelected:NO];
            }
            else
            {
                [self.mWomanButton setSelected:NO];
            }
            break;
        }
    }
}


- (IBAction)photoAction:(id)sender
{
    UIActionSheet *alertView =
    [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"앨범에서 사진 선택", @"사진 촬영", nil];
    [alertView setDelegate:self];
    [alertView setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [alertView showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    self.mDivPhoto = buttonIndex;
    switch(buttonIndex)
    {
        case 0:
        {
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentModalViewController:picker animated:YES];
            break;
        }
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"카메라를 사용할 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentModalViewController:picker animated:YES];
                
                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [delegate.gTabView setHidden:YES];
            }
            break;
        }
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];

    NSData *data = UIImagePNGRepresentation(image);
    self.mImage = image;
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [dirPath objectAtIndex:0];
	NSString *dstPath = [path stringByAppendingPathComponent:@"carsample.png"];
    [data writeToFile:dstPath atomically:YES];

    [self.mImageButton setImage:image forState:UIControlStateNormal];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)nextAction:(UIBarButtonItem*)sender
{
    if(sender.tag == 1)
    {
        // pre
        if(self.mIndex - 1 < 90) return;
        UITextField *control = (UITextField *)[self.view viewWithTag:self.mIndex - 1];
        [control becomeFirstResponder];
    }
    else
    {
        // next
        if(self.mIndex + 1 > 93) return;
        UITextField *control = (UITextField *)[self.view viewWithTag:self.mIndex + 1];
        [control becomeFirstResponder];
    }
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
    self.mIndex = textField.tag;
    
    if(textField == self.mNameTextField)
    {
        [self.mScrollView setContentOffset:CGPointMake(0.0, 180.0f) animated:YES];
    }
    else if(textField == self.mNumberTextField)
    {
        [self.mScrollView setContentOffset:CGPointMake(0.0, 230.0f) animated:YES];
    }
    else if(textField == self.mSerialTextField)
    {
        [self.mScrollView setContentOffset:CGPointMake(0.0, 380.0f) animated:YES];
    }
    else if(textField == self.mCompanyTextField)
    {
        [self.mScrollView setContentOffset:CGPointMake(0.0, 410.0f) animated:YES];
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.mSerialTextField || textField == self.mCompanyTextField)
    {
        [self.mScrollView setContentOffset:CGPointMake(0.0, 240.0f) animated:YES];
    }
    
    if(textField == self.mNumberTextField)
    {
        // 인증 api
        [self.mView setHidden:NO];
        [self.mInfoLabel setText:@"인증 번호를 발송 하였습니다."];
        [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:5.0f];
    }

	[textField resignFirstResponder];
    
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


- (IBAction)pushSwitchAction:(id)sender
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


- (void)hiddenInfoView
{
    [self.mView setHidden:YES];
}


#pragma RequestCinnection ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
- (void)changeModeRequest:(NSString*)dataType phone:(NSString*)number user:(NSString*)name driver:(NSString*)sex car:(NSString*)serial member:(NSString*)company
{
    NSString *apiElement = gDefineAPI[valueUpdateUser];
    NSString *apiAddress = [apiElement stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *boundary = @"----1010101010";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:apiAddress]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:kIntervalTimer];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"return_type\";type=\"text\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[dataType dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"us_type\";type=\"text\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"%d", kDriverCode] dataUsingEncoding:NSUTF8StringEncoding]];
        
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"us_number\";type=\"text\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[number dataUsingEncoding:NSUTF8StringEncoding]];
    
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"us_name\";type=\"text\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"us_sex\";type=\"text\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[sex dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"us_car_num\";type=\"text\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[serial dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"us_company\";type=\"text\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[company dataUsingEncoding:NSUTF8StringEncoding]];
    
#if 0
    NSData *imageData = UIImagePNGRepresentation(self.mImage);
#else
    NSData *imageData = UIImageJPEGRepresentation(self.mImage, 0.5f);
#endif
    
    if([imageData length] > 0x00)
    {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"us_file\";type=\"file\";filename=\"%@\"\r\n", @"carsample.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
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
    
    if([[error localizedDescription] rangeOfString:@"The request timed out"].location != NSNotFound)
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

    NSLog(@"DriverRegisterFixConbtroller = %@", dictionary);
    
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
    }
    else
    {
#if 0
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if(delegate.gIsChangeMode == YES)
        {
            [delegate removeUserInfoToPassenger];
            delegate.gIsChangeMode = NO;
            [self.mInfoLabel setText:@"회원 전환이 완료 되었습니다."];
        }
#endif
        [self.mInfoLabel setText:@"수정이 완료 되었습니다."];

        [[NSUserDefaults standardUserDefaults] setObject:@"driver" forKey:@"KeyOfDivide"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mNameTextField.text forKey:@"KeyOfName"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mNumberTextField.text forKey:@"KeyOfNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", gSex] forKey:@"KeyOfSex"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mSerialTextField.text forKey:@"KeyOfSerial"];
        [[NSUserDefaults standardUserDefaults] setObject:self.mCompanyTextField.text forKey:@"KeyOfCompany"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", (NSInteger)gPushAccept] forKey:@"KeyOfPush"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self performSelector:@selector(registerDeviceToken) withObject:nil afterDelay:1.0f];
        [self performSelector:@selector(hiddenInfoView) withObject:nil afterDelay:2.0f];
        [self performSelector:@selector(dissmissSelfController) withObject:nil afterDelay:3.0f];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 999)
    {
        if(buttonIndex == 0x01)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"driver" forKey:@"KeyOfDivide"];
            [[NSUserDefaults standardUserDefaults] setObject:self.mNameTextField.text forKey:@"KeyOfName"];
            [[NSUserDefaults standardUserDefaults] setObject:self.mNumberTextField.text forKey:@"KeyOfNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", gSex] forKey:@"KeyOfSex"];
            [[NSUserDefaults standardUserDefaults] setObject:self.mSerialTextField.text forKey:@"KeyOfSerial"];
            [[NSUserDefaults standardUserDefaults] setObject:self.mCompanyTextField.text forKey:@"KeyOfCompany"];
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
        
        //  2. 가입
        NSString *sex = @"남";
        if(gSex == 1)
        {
            sex = @"여";
        }
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if(delegate.gIsChangeMode == NO)
        {
        }
        else
        {
            [self changeModeRequest:gDefineDataType[valueJson] phone:self.mNumberTextField.text user:self.mNameTextField.text driver:sex car:self.mSerialTextField.text member:self.mCompanyTextField.text];
        }
        [self.mView setHidden:NO];
        [self.mInfoLabel setText:@"정보를 발송 하였습니다."];
    }
}


- (void)registerDeviceToken
{
    AppRequestController *request = (AppRequestController *)[[AppRequestController alloc] init];    
    [request RegisterDeviceToken:gDefineDataType[valueJson] phone:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"] device:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
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
    [delegate initDriverToInterface];
    [self dismissModalViewControllerAnimated:YES];
    [delegate.tabbarController setSelectedIndex:0];
    [delegate selectedTabButton:0];
}


- (void)dissmissCancel
{
    [self dismissModalViewControllerAnimated:YES];
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
