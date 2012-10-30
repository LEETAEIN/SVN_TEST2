//
//  DetailViewDriverController.m
//  MomTaxi
//
//  Created by  on 11. 11. 28..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "DetailViewDriverController.h"
#import "AppDelegate.h"


@implementation DetailViewDriverController
@synthesize mTableView;
@synthesize mTextFeild1;
@synthesize mTextFeild2;
@synthesize mTextFeild3;
@synthesize mArray;
@synthesize mImageView;
@synthesize detailImageView;
@synthesize mDictionary;
@synthesize mImage;
@synthesize mIsShowImage;


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
    [self.mTableView setBackgroundColor:kMyBackGroundColor];
    [self.view setBackgroundColor:kMyBackGroundColor];
    [self setTitle:@"기사님 자세히 보기"];
    
    self.mArray = [[NSMutableArray alloc] init];
    [self.mArray addObject:@"사진"];
    [self.mArray addObject:@"이름"];
    [self.mArray addObject:@"성별"];
    [self.mArray addObject:@"차량번호"];
    [self.mArray addObject:@"택시회사"];
    [self.mArray addObject:@"평점, 추천"];
    
    self.mIsShowImage = NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	return [self.mArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 40.0f;
    if(indexPath.row == 0)
    {
        result = 80.0f;
    }
    return result;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, kTableViewCelHeight)];
    [pointLabel setBackgroundColor:[UIColor clearColor]];
    [pointLabel setTextColor:[UIColor blackColor]];
    [pointLabel setText:@"▪"];
    [pointLabel setFont:[UIFont boldSystemFontOfSize:kTableViewFontSize]];
    [pointLabel setTextAlignment:UITextAlignmentCenter];
    
    UILabel *contetnsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 100.0f, kTableViewCelHeight)];
    [contetnsLabel setBackgroundColor:[UIColor clearColor]];
    [contetnsLabel setTextColor:kMyGreenColor];
    [contetnsLabel setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
    [contetnsLabel setText:[self.mArray objectAtIndex:indexPath.row]];
    [contetnsLabel setTextAlignment:UITextAlignmentLeft];

    [cell addSubview:pointLabel];
    [cell addSubview:contetnsLabel];
    
    switch(indexPath.row)
    {
        case 0:
        {
#if 0
            [cell addSubview:[self attachImageView]];
#else
            [cell addSubview:[self attachImageButton]];
#endif
            break;
        }
        case 1:
        {
            [cell addSubview:[self attachTextField:indexPath.row]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 0.0f, 100.0f, cell.frame.size.height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
            [label setText:[self.mDictionary objectForKey:@"us_name"]];
            [label setTextAlignment:UITextAlignmentLeft];
            [cell addSubview:label];
            break;
        }
        case 2:
        {
            [self.mImageView setFrame:CGRectMake(120.0f, 5.0f, self.mImageView.frame.size.width, self.mImageView.frame.size.height)];
            [self.mImageView setImage:[UIImage imageNamed:@""]];
            [cell addSubview:self.mImageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 0.0f, 100.0f, cell.frame.size.height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
            [label setText:[self.mDictionary objectForKey:@"us_sex"]];
            [label setTextAlignment:UITextAlignmentLeft];
            [cell addSubview:label];
            break;
        }
        case 3:
        {
            [cell addSubview:[self attachTextField:indexPath.row]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 0.0f, 100.0f, cell.frame.size.height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
            [label setText:[self.mDictionary objectForKey:@"us_car_num"]];
            [label setTextAlignment:UITextAlignmentLeft];
            [cell addSubview:label];
            break;
        }
        case 4:    
        {
            [cell addSubview:[self attachTextField:indexPath.row]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 0.0f, 100.0f, cell.frame.size.height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
            [label setText:[self.mDictionary objectForKey:@"us_company"]];
            [label setTextAlignment:UITextAlignmentLeft];
            [cell addSubview:label];
            break;
        }
        case 5:
        {
            UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(250.0f, 0.0f, 30.0f, kTableViewCelHeight)];
            [scoreLabel setBackgroundColor:[UIColor clearColor]];
            [scoreLabel setTextColor:[UIColor redColor]];
            [scoreLabel setText:[self.mDictionary objectForKey:@"us_aver"]];
            [scoreLabel setFont:[UIFont boldSystemFontOfSize:kTableViewFontSize]];
            [scoreLabel setTextAlignment:UITextAlignmentCenter];
            
            UILabel *dummyLabel = [[UILabel alloc] initWithFrame:CGRectMake(280.0f, 0.0f, 40.0f, kTableViewCelHeight)];
            [dummyLabel setBackgroundColor:[UIColor clearColor]];
            [dummyLabel setTextColor:[UIColor blackColor]];
            [dummyLabel setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
            NSString *string = [NSString stringWithFormat:@" / %@회", [self.mDictionary objectForKey:@"us_recommand"]];
            [dummyLabel setText:string];
            
            [cell addSubview:scoreLabel];
            [cell addSubview:dummyLabel];
            break;
        }
    }
    
    return cell;
}


- (UIImageView*)attachImageView
{
    UIImageView *result = [[UIImageView alloc] initWithFrame:CGRectMake(120.0f, 5.0f, 80.0f, 70.0f)];
    [result setContentMode:UIViewContentModeScaleToFill];
    [result setImage:self.mImage];
    return result;
}


- (UIButton*)attachImageButton
{
    UIButton *result = [[UIButton alloc] initWithFrame:CGRectMake(120.0f, 5.0f, 80.0f, 70.0f)];
    [result setImage:self.mImage forState:UIControlStateNormal];
    [result addTarget:self action:@selector(showImageView) forControlEvents:UIControlEventTouchUpInside];
    return result;
}

     
- (void)showImageView
{
    self.detailImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.detailImageView setContentMode:UIViewContentModeScaleToFill];
    [self.detailImageView setImage:self.mImage];
    [self.view addSubview:self.detailImageView];
    
    self.mIsShowImage = YES;
    [self.mTableView setUserInteractionEnabled:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.mIsShowImage == YES)
    {
        [self.detailImageView removeFromSuperview];
        [self.mTableView setUserInteractionEnabled:YES];
    }
}

     
- (UITextField*)attachTextField:(NSInteger)index
{
    UITextField *result = nil;
    if(index == 1)
    {
        result = self.mTextFeild1;
    }
    if(index == 3)
    {
        result = self.mTextFeild2;
    }
    if(index == 4)
    {
        result = self.mTextFeild3;
    }
    [result setBackgroundColor:[UIColor clearColor]];
    [result setTextAlignment:UITextAlignmentLeft];
    [result setFrame:CGRectMake(120.0f, 0.0f, 220.0f, 30.0f)];
    [result setTag:index];
    return result;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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


#pragma mark IBAction List ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ---------- ----------
- (IBAction)bottomButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if(button.tag == 10)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"손님의 휴대폰 번호와 위치정보가 전송됩니다." message:@"콜 승인시 다른 차량 잡으시면 안되요." delegate:self cancelButtonTitle:@"취소하기" otherButtonTitles:@"부르기", nil];
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0x01)
    {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *taxiphone = [self.mDictionary objectForKey:@"us_number"];
        NSString *myphone = [[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"];
        NSString *X = [NSString stringWithFormat:@"%f", gLocationInfo.s_locationX];
        NSString *Y = [NSString stringWithFormat:@"%f", gLocationInfo.s_locationY];
        
        gTAXI_SERIAL = [self.mDictionary objectForKey:@"us_car_num"];
        gTAXI_COMPANY = [self.mDictionary objectForKey:@"us_company"];
        [delegate.gClassRequest callTaxiRequest:gDefineDataType[valueJson] phone:myphone locationX:X locationY:Y car:taxiphone];
    }
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
