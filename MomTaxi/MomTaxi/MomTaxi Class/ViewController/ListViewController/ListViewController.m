//
//  ListViewController.m
//  MomTaxi
//
//  Created by  on 11. 11. 7..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewDriverController.h"
#import "AppDelegate.h"


@implementation ListViewController
@synthesize mTableView;
@synthesize mArray;


#define kTableViewHeadLabelDistance     75.0f
#define kTableViewHeadLabelName         75.0f
#define kTableViewHeadLabelPicture      50.0f
#define kTableViewHeadLabelRate         50.0f
#define kTableViewHeadLabelRecommand    50.0f
#define kAccesoryLength                 15.0f


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    /*
     * 위치정보 업데이트
     */
    // [self initLocationInfo];
    [self.mTableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"BG_NAVIGATIONBAR.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:kMyGreenColor];
    [self setTitle:@"택시검색-목록"];

    [self.mTableView setBackgroundColor:kMyBackGroundColor];
    
    self.mArray = [[NSMutableArray alloc] init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return [delegate.gLocationArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *listDic = [delegate.gLocationArray objectAtIndex:indexPath.row];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kTableViewHeadLabelDistance, 40.0f)];
    [distanceLabel setBackgroundColor:[UIColor clearColor]];
    [distanceLabel setTextColor:kMyGreenColor];
    [distanceLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [distanceLabel setTextAlignment:(UITextAlignment)UITextAlignmentCenter];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTableViewHeadLabelDistance, 0.0f, kTableViewHeadLabelName, 40.0f)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [nameLabel setTextAlignment:(UITextAlignment)UITextAlignmentCenter];

#if 1
    UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(150.0f, 0.0f, kTableViewHeadLabelPicture, 40.0f)];
#else
    UIButton *pictureImageButton = [[UIButton alloc] initWithFrame:CGRectMake(150.0f, 0.0f, kTableViewHeadLabelPicture, 40.0f)];
#endif
    NSInteger count = [delegate.gImageArray count];
    for(NSInteger i = 0; i < count; i++)
    {
        NSDictionary *dictionary = [delegate.gImageArray objectAtIndex:i];
        NSString *name = [dictionary objectForKey:@"index"];
        if([name isEqualToString:[listDic objectForKey:@"us_name"]] == YES)
        {
#if 1
            [pictureImageView setBackgroundColor:[UIColor clearColor]];
            [pictureImageView setContentMode:UIViewContentModeScaleToFill];
            [pictureImageView setImage:[dictionary objectForKey:@"image"]];
#else
            [pictureImageButton setImage:[dictionary objectForKey:@"image"] forState:UIControlStateNormal];
            [pictureImageButton addTarget:self action:@selector(showImageView) forControlEvents:UIControlEventTouchUpInside];
#endif

            break;
        }
    }

    UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0f, 0.0f, kTableViewHeadLabelRate, 40.0f)];
    [rateLabel setBackgroundColor:[UIColor clearColor]];
    [rateLabel setTextColor:[UIColor blueColor]];
    [rateLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [rateLabel setTextAlignment:(UITextAlignment)UITextAlignmentCenter];
    
    UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(250.0f, 0.0f, kTableViewHeadLabelRecommand, 40.0f)];
    [recommandLabel setBackgroundColor:[UIColor clearColor]];
    [recommandLabel setTextColor:[UIColor blackColor]];
    [recommandLabel setFont:[UIFont fontWithName:@"Helvetica" size:kTableViewFontSize]];
    [recommandLabel setTextAlignment:(UITextAlignment)UITextAlignmentCenter];
    
    UIImageView *accesoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kAccesoryLength, kAccesoryLength)];
    [accesoryView setBackgroundColor:[UIColor clearColor]];
    [accesoryView setImage:[UIImage imageNamed:@"BTN_ACCESORRYVIEW.png"]];

    double distance = [[listDic objectForKey:@"distance"] doubleValue] / 1000.0f;
    [distanceLabel setText:[NSString stringWithFormat:@"%f km", distance]];
    [nameLabel setText:[listDic objectForKey:@"us_name"]];
    [rateLabel setText:[NSString stringWithFormat:@"%@", [listDic objectForKey:@"us_aver"]]];
    [recommandLabel setText:[listDic objectForKey:@"us_recommand"]];

    [cell addSubview:distanceLabel];
    [cell addSubview:nameLabel];
#if 1
    [cell addSubview:pictureImageView];
#else
    [cell addSubview:pictureImageButton];
#endif
    [cell addSubview:rateLabel];
    [cell addSubview:recommandLabel];
    [cell setAccessoryView:accesoryView];
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewDriverController *controller = [[DetailViewDriverController alloc] initWithNibName:@"DetailViewDriverController" bundle:nil];    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *listDic = [delegate.gLocationArray objectAtIndex:indexPath.row];
    
    NSInteger count = [delegate.gImageArray count];
    UIImage *image = nil;
    for(NSInteger i = 0; i < count; i++)
    {
        NSDictionary *dictionary = [delegate.gImageArray objectAtIndex:i];
        NSString *name = [dictionary objectForKey:@"index"];
        if([name isEqualToString:[listDic objectForKey:@"us_name"]] == YES)
        {
            image = [dictionary objectForKey:@"image"];
            break;
        }
    }
    
    
    controller.mDictionary = listDic;
    controller.mImage = image;
    
    [self.navigationController pushViewController:controller animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)showImageView
{
    
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




