//
//  OptionController.m
//  MomTaxi
//
//  Created by  on 11. 11. 8..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "OptionController.h"
#import "NoticeListController.h"
#import "PassengerFixController.h"
#import "DriverRegisterController.h"
#import "ProfileController.h"
#import "AnnounceController.h"
#import "CellForCustomController.h"
#import "AppDelegate.h"


@implementation OptionController
@synthesize mTableView;
@synthesize mArray;


#define EA_ARRAY [NSArray arrayWithObjects:@"3", @"1", nil]

#define kAccesoryLength 15.0f



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:kMyGreenColor];
    [self.mTableView setBackgroundColor:kMyBackGroundColor];
    [self.view setBackgroundColor:kMyBackGroundColor];
    [self setTitle:@"설정"];
    
    self.mArray = [[NSMutableArray alloc] init];
    [self.mArray addObject:@"공지사항"];
    [self.mArray addObject:@"개인정보 수정"];
    [self.mArray addObject:@"사용이력 보기"];
    [self.mArray addObject:@"엄마한테 알리기 설정"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - www.rcsoft.com 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
	return [EA_ARRAY count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	return [[EA_ARRAY objectAtIndex:section] integerValue];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d", indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

	NSUInteger i = 0L, rowIndex = 0L;
	for (i = 0; i < indexPath.section; i++) rowIndex += [[EA_ARRAY objectAtIndex:i] integerValue];
	rowIndex += indexPath.row;
    [cell.textLabel setFont:[UIFont systemFontOfSize:kTableViewFontSize]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setText:[self.mArray objectAtIndex:rowIndex]];

    UIImageView *accesoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kAccesoryLength, kAccesoryLength)];
    [accesoryView setBackgroundColor:[UIColor clearColor]];
    [accesoryView setImage:[UIImage imageNamed:@"BTN_ACCESORRYVIEW.png"]];
    [cell setAccessoryView:accesoryView];

     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = nil;
    if(indexPath.section == 0)
    {
        switch(indexPath.row)
        {
            case 0:
            {
                viewController = [[NoticeListController alloc] initWithNibName:@"NoticeListController" bundle:nil];
                break;
            }
            case 1:
            {
                viewController = [[PassengerFixController alloc] initWithNibName:@"PassengerFixController" bundle:nil];
                break;
            }
            case 2:
            {
                viewController = [[ProfileController alloc] initWithNibName:@"ProfileController" bundle:nil];
                break;
            }
        }
    }
    else if(indexPath.section == 1)
    {
        viewController  = [[AnnounceController alloc] initWithNibName:@"AnnounceController" bundle:nil];
    }
    else
    {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        delegate.gIsChangeMode = YES;
        
        viewController = [[DriverRegisterController alloc] initWithNibName:@"DriverRegisterController" bundle:nil]; 
#if 1
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentModalViewController:navigationController animated:YES];
#else
        [self.navigationController pushViewController:viewController animated:YES];
#endif
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self navigationController] pushViewController:viewController animated:YES];
}

#if 0
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	// Section title is the region name
	Region *region = [displayList objectAtIndex:section];
	return region.name;
}
#endif


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
