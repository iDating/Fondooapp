//
//  CheckInUsersTableViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 25/03/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "CheckInUsersTableViewController.h"

@interface CheckInUsersTableViewController ()

@end

@implementation CheckInUsersTableViewController
@synthesize m_PeopleArray;
@synthesize checkInValue;
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
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@""
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:nil action:nil];
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@ Check-ins",[NSString stringWithFormat:@"%@",checkInValue ]];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self.tabBarController.tabBar setHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Tableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.m_PeopleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *ident=@"Ident";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *userImage=[[UIImageView alloc] init];
    userImage.layer.cornerRadius=4.0f;
    [userImage setFrame:CGRectMake(10, 10, 80, 80)];
    [userImage setImageWithURL:[NSURL URLWithString:[[self.m_PeopleArray objectAtIndex:indexPath.row] objectForKey:@"userimage"]] placeholderImage:[UIImage imageNamed:@"PreviewFrame"]];
    userImage.clipsToBounds=YES;
    userImage.contentMode=UIViewContentModeScaleAspectFill;
    NSString *text=[NSString stringWithFormat:@"%@",[[self.m_PeopleArray objectAtIndex:indexPath.row] objectForKey:@"recentpost"] ];
    
    NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                       attributes:@
                                         {
                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:14.0f]
                                         }];
   CGRect paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(200, 1000)
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                context:nil];
    UILabel *statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 30, 200, paragraphRect.size.height)];
    statusLabel.textAlignment=NSTextAlignmentLeft;
    statusLabel.numberOfLines=0;
    [statusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:14.0f]];
    [statusLabel setText:text];
    [statusLabel setTextColor:[UIColor blackColor]];
    statusLabel.textColor=[UIColor blackColor];
    [statusLabel setBackgroundColor:[UIColor clearColor]];
    
    UILabel *recentStatus=[[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 20)];
        recentStatus.textAlignment=NSTextAlignmentLeft;
     [recentStatus setText:[NSString stringWithFormat:@"%@",[[self.m_PeopleArray objectAtIndex:indexPath.row] objectForKey:@"username"] ]];
    [recentStatus setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [cell.contentView addSubview:recentStatus];
    [cell.contentView addSubview:userImage];
     [cell.contentView addSubview:statusLabel];
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text=[NSString stringWithFormat:@"%@",[[self.m_PeopleArray objectAtIndex:indexPath.row] objectForKey:@"recentpost"] ];
    
    NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                       attributes:@
                                         {
                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:14.0f]
                                         }];
    CGRect paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(200, 1000)
                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       context:nil];
    return MAX(100, paragraphRect.size.height+40) ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UserDetailsViewController *userVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        userVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
    }
    else
    {
        userVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController_iPhone4" bundle:nil];
    }
    userVC.ischat=NO;
    userVC.isChecked=YES;
    userVC.m_userProfile=[self.m_PeopleArray objectAtIndex:indexPath.row];
    userVC.title=@"";
    userVC.hidesBottomBarWhenPushed=NO;
    [self.navigationController pushViewController:userVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
