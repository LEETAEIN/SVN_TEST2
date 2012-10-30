//
//  AlertViewContoller.m
//  MomTaxi
//
//  Created by  on 11. 11. 22..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "AlertViewContoller.h"
#import "AppDelegate.h"
#import "PassengerRegisterController.h"
#import "DriverRegisterController.h"


@implementation AlertViewContoller
@synthesize backgroundImage;
@synthesize okButton;
@synthesize cancelButton;
@synthesize mTag;


- (id)initWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content submit:(NSString *)submit modelnum:(NSString *)modelnum
{
    if (self = [super init]) 
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont boldSystemFontOfSize:14.0];
        contentLabel.text = content;
        [self addSubview:contentLabel];
        [self setBackgroundImage:image];
        
        okButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [okButton setImage:[UIImage imageNamed:@"BTN_MAINALERT1.png"] forState:UIControlStateNormal];
        [okButton setTag:valuePassenger];
        [okButton addTarget:self action:@selector(okSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [cancelButton setImage:[UIImage imageNamed:@"BTN_MAINALERT2.png"] forState:UIControlStateNormal];
        [cancelButton setTag:valueDriver];
        [cancelButton addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:okButton];
        [self addSubview:cancelButton];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [self setCenter:delegate.window.center];
    }
    return self;
}


- (void)okSelect:(UIButton*)sender
{   
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.tabbarController = [[UITabBarController alloc] init];  
    
    PassengerRegisterController *modalView = [[PassengerRegisterController alloc] initWithNibName:@"PassengerRegisterController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:modalView];
    [delegate.navigationController presentModalViewController:controller animated:YES];
    
    gActiveMode = sender.tag;
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    // 최초 얼럿 창의 그리기 오류로 인하여 위치 옮김 
    [delegate initLocationInfo];
}


- (void)cancelSelect:(UIButton*)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.tabbarController = [[UITabBarController alloc] init];

    DriverRegisterController *modalView = [[DriverRegisterController alloc] initWithNibName:@"DriverRegisterController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:modalView];
    [delegate.navigationController presentModalViewController:controller animated:YES];
    
    gActiveMode = sender.tag;
    [self dismissWithClickedButtonIndex:1 animated:YES];
    
    // 최초 얼럿 창의 그리기 오류로 인하여 위치 옮김
    [delegate initLocationInfo];
}


- (id)initWithImagePush:(UIImage *)image title:(NSString *)title content:(NSString *)content submit:(NSString *)submit modelnum:(NSString *)modelnum
{
    if (self = [super init]) 
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.textColor = [UIColor lightGrayColor];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont boldSystemFontOfSize:14.0];
        contentLabel.text = content;
        [self addSubview:contentLabel];
        [self setBackgroundImage:image];
        
        okButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [okButton setImage:[UIImage imageNamed:@"btn_yes.png"] forState:UIControlStateNormal];
        [okButton setTag:valuePassenger];
        [okButton addTarget:self action:@selector(yesSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [cancelButton setImage:[UIImage imageNamed:@"btn_no.png"] forState:UIControlStateNormal];
        [cancelButton setTag:valueDriver];
        [cancelButton addTarget:self action:@selector(noSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:okButton];
        [self addSubview:cancelButton];
    }
    return self;
}


- (void)yesSelect:(UIButton*)sender
{   
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.gClassRequest acceptCall:gDefineDataType[valueJson] user:gUS_NUM taxi:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"]];
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    gIsUserCall = YES;
}


- (void)noSelect:(UIButton*)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.gClassRequest cancelTaxiCall:gDefineDataType[valueJson] phone:gUS_NUM];
    [self dismissWithClickedButtonIndex:1 animated:YES];
    
    gIsUserCall = NO;
}


- (void)drawRect:(CGRect)rect 
{ 
    [self.backgroundImage drawInRect:CGRectMake(0.0f, 0.0f, 260.0f, 140.0f)];
}


- (void) layoutSubviews 
{
    titleLabel.transform = CGAffineTransformIdentity;
    [titleLabel sizeToFit];
    CGRect textRect = titleLabel.frame;
    textRect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(textRect)) / 2;
    textRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(textRect)) / 2;
    textRect.origin.y -= 35.0;
    titleLabel.frame = textRect;
    
    contentLabel.transform = CGAffineTransformIdentity;
    [contentLabel sizeToFit];
    CGRect textRect2 = contentLabel.frame;
    textRect2.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(textRect2)) / 2;
    textRect2.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(textRect2)) / 2;
    textRect2.origin.y -= 5.0;
    contentLabel.frame = textRect2;

    if(self.mTag == 0)
    {
        [okButton setFrame:CGRectMake(0.0f, 102.0f, 130.0f, 46.0f)];
        [cancelButton setFrame:CGRectMake(130.0f, 102.0f, 130.0f, 46.0f)];
    }
    
    if(self.mTag == 1)
    {
        [okButton setFrame:CGRectMake(0.0f, 98.0f, 130.0f, 46.0f)];
        [cancelButton setFrame:CGRectMake(130.0f, 98.0f, 130.0f, 46.0f)];
    }
    
    for(UIView *subView in [self subviews])
    {
        if([subView isKindOfClass:[UIImageView class]] == YES)
        {
#if 1
            [subView removeFromSuperview];
#else
            [subView setHidden:YES];
#endif
            break;
        }
    }
}

- (void)show 
{
    [super show];
    
#if 0
    self.bounds = CGRectMake(0.0f, 0.0f, 260.0f, 140.0f);
    if(self.mTag == 1)
    {
        [contentLabel setNumberOfLines:2];
        [self performSelector:@selector(cancelTimer) withObject:nil afterDelay:kIntervalTimer];
    }
#else
    CGSize imageSize = backgroundImage.size;
    [self setBounds:CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height)];
#endif
}


- (void)cancelTimer
{
    [self dismissWithClickedButtonIndex:1 animated:YES];
}



@end
