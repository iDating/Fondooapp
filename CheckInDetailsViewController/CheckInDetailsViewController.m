//
//  CheckInDetailsViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 05/03/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "CheckInDetailsViewController.h"

@interface CheckInDetailsViewController ()

@end

@implementation CheckInDetailsViewController
@synthesize m_CheckInDetailDictionary;
@synthesize m_FourSquareDictionary;
@synthesize m_ImageNumber;
@synthesize m_PeopleDictionary;
@synthesize m_Shared;
@synthesize m_Mapview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_Shared=[SharedClass sharedInstance];
    NSLog(@" details : %@",[[m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"address"]);
    [self initizlizeScroller];
    [self.m_ActivityIndicator startAnimating];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    UILabel *MainTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 8, 200, 28)];
    MainTitle.textAlignment=NSTextAlignmentCenter;
    [MainTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
    [MainTitle setTextColor:kRedColor];
    
    UILabel *descriptionTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 28, 200, 16)];
    descriptionTitle.textAlignment=NSTextAlignmentCenter;
    [descriptionTitle setTextColor:kGrayColor];
    [descriptionTitle setFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]];
    MainTitle.text=[[m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"address"];
    UIView *TitleView=[[UIView alloc] initWithFrame:CGRectMake(0, 60, 200, 44)];
    [TitleView setBackgroundColor:[UIColor clearColor]];
    [TitleView addSubview:MainTitle];
    [TitleView addSubview:descriptionTitle];
    self.navigationItem.titleView=TitleView;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setNav
{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    
    self.navigationItem.backBarButtonItem.title=@"";
    
}

-(void)initizlizeScroller
{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[self.m_CheckInDetailDictionary objectAtIndex:0]  objectForKey:@"lat"] floatValue]
                                                            longitude:[[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"lon"] floatValue]
                                                                 zoom:16];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        self.m_Mapview=[[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    }
    else{
        self.m_Mapview=[[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 270)];
    }
    
    self.m_Mapview.delegate=self;
    self.m_Mapview.camera=camera;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"lat"] floatValue],[[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"lon"] floatValue]);
    marker.title=[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"address"];
    marker.snippet=[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"locationtype"];
    marker.icon=[UIImage imageNamed:@"Red_PinIcon"];
    self.m_Mapview.selectedMarker=marker;
    marker.map = self.m_Mapview;
    
}

#pragma Tableview Delegates
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellReuseIdentifier   = @"SectionTwoCell";
    NSString *windowReuseIdentifier = @"SectionOneCell";
    
    UITableViewCell *cell;
      cell.backgroundView=nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
            [cell.contentView addSubview:self.m_Mapview];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.layer.backgroundColor=[UIColor clearColor].CGColor;
            
        }
    }
    
    else  {
        cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
            
        }
        
        //*********************Friends Scrolller **************************
        
        if (indexPath.section==1) {
            //  UIImageView *IconImage=[[UIImageView alloc] init];
            // [IconImage setFrame:CGRectMake(10, 10, 30, 30)];
            switch (indexPath.row) {
                case 0:
                    // IconImage.image=[UIImage imageNamed:@"User_Icon"];
                    cell.imageView.image=[UIImage imageNamed:@"User_Icon"];
                    cell.textLabel.text=[NSString stringWithFormat:@"%@ Check-ins",[[m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"numberofUsers"]];
                    if ([[[m_CheckInDetailDictionary objectAtIndex:0]objectForKey:@"numberofUsers"] integerValue]>0) {
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
                        
                        
                    }
                    else{
                        cell.accessoryType=UITableViewCellAccessoryNone;
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        
                        
                        
                    }
                    break;
                case 1:
                    //IconImage.image=[UIImage imageNamed:@"Pin_IconBlack"];
                    cell.imageView.image=[UIImage imageNamed:@"Pin_IconBlack"];
                   cell.textLabel.text=[NSString stringWithFormat:@"%@",[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"full_address"]];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
                    break;
                    
                case 2:
                    cell.imageView.image=[UIImage imageNamed:@"Phone_Icon"];
                    if ([[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"phone_number"] isEqualToString:@"unknown"]) {
                        cell.textLabel.text=@"Unknown";
                        cell.accessoryType=UITableViewCellAccessoryNone;
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                       
                        
                    }
                    else
                    {
                        cell.textLabel.text=[NSString stringWithFormat:@"%@",[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"phone_number"]];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
                    }
                    
                    break;
                    
                default:
                    break;
            }
            // [cell.contentView addSubview:IconImage];
        }
        
    }
    cell.selectionStyle       = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
            return 320;
        }
        else{
            return 270;
        }
        
        
    }
    else
    {
        return 50;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else
    {
        return 3;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CheckInUsersTableViewController* checkinNew;
    NSURL *phoneURL;
    NSURL *URL ;
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
                if ([[[m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"numberofUsers"] integerValue]>0) {
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
                        checkinNew=[[CheckInUsersTableViewController alloc] initWithNibName:@"CheckInUsersTableViewController" bundle:nil];
                    }
                    else
                    {
                        checkinNew=[[CheckInUsersTableViewController alloc] initWithNibName:@"CheckInUsersTableViewController_iPhone4" bundle:nil];
                    }
                    checkinNew.m_PeopleArray=[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"userDetails"];
                    checkinNew.checkInValue=[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"numberofUsers"];
                    checkinNew.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:checkinNew animated:YES];
                    //                    CheckInUsersTableViewController
                }
                
                break;
                
            case 1:
                URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",[m_Shared.m_Lattitude floatValue],[m_Shared.m_Longitude floatValue],[[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"lat"] floatValue],[[[self.m_CheckInDetailDictionary objectAtIndex:0]objectForKey:@"lon"] floatValue]]];
                [[UIApplication sharedApplication] openURL:URL];
                break;
            case 2:
                if (![[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"phone_number"] isEqualToString:@"unknown"]) {
                    phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[[self.m_CheckInDetailDictionary objectAtIndex:0] objectForKey:@"phone_number"]]];
                    [[UIApplication sharedApplication] openURL:phoneURL];
                }
                
                break;
                
            default:
                break;
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.m_ImageScrollview setDelegate:nil];
    [self.m_WrapperScrollview setDelegate:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.m_ImageScrollview setDelegate:self];
    [self.m_WrapperScrollview setDelegate:self];
    [self.tabBarController.tabBar setHidden:YES];
}
//-(void)singleTapping:(UITapGestureRecognizer*)tapGesture
//{
//    
//    if ([[m_PeopleDictionary  objectForKey:@"forsquareimg"]  count]>0) {
//        ImagePreviewViewController *imageVC;
//        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
//            imageVC=[[ImagePreviewViewController alloc] initWithNibName:@"ImagePreviewViewController" bundle:nil];
//        }
//        else
//        {
//            imageVC=[[ImagePreviewViewController alloc] initWithNibName:@"ImagePreviewViewController_iPhone4" bundle:nil];
//        }
//        imageVC.m_ImageUrl=[[m_PeopleDictionary objectForKey:@"forsquareimg"] objectAtIndex:self.m_ImageNumber];
//        [self presentViewController:imageVC animated:YES completion:nil];
//    }
//    
//    // [self.navigationController pushViewController:imageVC animated:YES];
//    
//}

@end
