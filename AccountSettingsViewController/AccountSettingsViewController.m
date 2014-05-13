//
//  AccountSettingsViewController.m
//  KeithDatingApp
//
//  Created by Mohit on 27/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "AccountSettingsViewController.h"

#import "ProfilePhotoViewController.h"

@interface AccountSettingsViewController ()

@end

@implementation AccountSettingsViewController
@synthesize m_SectionTwoArray;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:@"editProfile" object:nil];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil action:nil];
    self.navigationItem.title=@"Settings";
    m_SectionTwoArray=[[NSArray alloc] initWithObjects:@"I am",@"I like",@"Proximity",@"Age",@"Invite a Friend",@"Contact Us",@"Log Out", nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableViewDelegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 static  NSString *ident=@"Identifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident];
    
        }
    for (UIView *views in cell.contentView.subviews) {
        [views removeFromSuperview];
    }
    UILabel *SectionTwolabel;
    UIButton *Editbutton;
    UIButton *BioButton;
    UIImageView *ProfileImage;
    UILabel *Linelabel;
    UIImageView *arrowimage1;
    UIImageView *arrowImage2;
    UIImageView *logoImage;
    switch (indexPath.section) {
        case 0:
            Editbutton=[[UIButton alloc] initWithFrame:CGRectMake(100, 0, 220, 50)];
            [Editbutton setTitle:@"   Edit Photos" forState:UIControlStateNormal];
            [Editbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [Editbutton setBackgroundColor:[UIColor clearColor]];
            Editbutton.titleLabel.textAlignment=NSTextAlignmentLeft;
            [Editbutton addTarget:self action:@selector(editPhotosClicked) forControlEvents:UIControlEventTouchUpInside];
            Editbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            BioButton=[[UIButton alloc] initWithFrame:CGRectMake(100, 50, 220, 50)];
            [BioButton setTitle:@"   Bio" forState:UIControlStateNormal];
            BioButton.titleLabel.textAlignment=NSTextAlignmentLeft;
            [BioButton addTarget:self action:@selector(bioButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [BioButton setBackgroundColor:[UIColor clearColor]];
            [BioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            BioButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            
            Linelabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 50, 220, 0.5f)];
            [Linelabel setBackgroundColor:[UIColor lightGrayColor]];
            ProfileImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            ProfileImage.clipsToBounds=YES;
            [ProfileImage setContentMode:UIViewContentModeScaleAspectFill];
            [ProfileImage setImageWithURL:[NSURL URLWithString:[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"]objectForKey:@"userDetails"] objectForKey:@"images"]] placeholderImage:nil];
            arrowimage1=[[UIImageView alloc] initWithFrame:CGRectMake(295, 20, 9, 12)];
            [arrowimage1 setImage:[UIImage imageNamed:@"Arrow_Icon"]];
            arrowImage2=[[UIImageView alloc] initWithFrame:CGRectMake(295, 70, 9, 12)];
            [arrowImage2 setImage:[UIImage imageNamed:@"Arrow_Icon"]];
            [cell.contentView addSubview:Editbutton];
            [cell.contentView addSubview:BioButton];
             [cell.contentView addSubview:Linelabel];
            [cell.contentView addSubview:ProfileImage];
            [cell.contentView addSubview:arrowimage1];
            [cell.contentView addSubview:arrowImage2];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            break;
            
            
            case 1:
            SectionTwolabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 140, 30)];
            [SectionTwolabel setText:[self.m_SectionTwoArray objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:SectionTwolabel];
            logoImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 27, 27)];
            if (indexPath.row==0) {
               
                logoImage.image=[UIImage imageNamed:@"User_Icon"];
                cell.detailTextLabel.text=[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"gender"];
               
            }
            else if (indexPath.row==1)
            {
                cell.detailTextLabel.text=[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"genderType"];
            logoImage.image=[UIImage imageNamed:@"Heart_Icon"];
            }
            else if(indexPath.row==2)
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ mi",[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"radius"] ];
                logoImage.image=[UIImage imageNamed:@"Pin_IconBlack"];
            }
            else
            {
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"age"] ];
                logoImage.image=[UIImage imageNamed:@"GiftImage"];
            }
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:logoImage];
            break;
            
            
            case 2:
            cell.textLabel.text=[self.m_SectionTwoArray objectAtIndex:indexPath.row+4];
            break;
            
            case 3:
            cell.textLabel.text=@"Delete Account";
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailedSettingsViewController *detailedVC;
    switch (indexPath.section) {
        case 0:
        break;
            case 1:
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
                detailedVC=[[DetailedSettingsViewController alloc] initWithNibName:@"DetailedSettingsViewController" bundle:nil];
            }
            else{
                detailedVC=[[DetailedSettingsViewController alloc] initWithNibName:@"DetailedSettingsViewController_iPhone4" bundle:nil];
                
            }
            switch (indexPath.row) {
                    
                case 0:
                    
                    detailedVC.indexNumber=indexPath.row;
                    break;
                    
                    case 1:
                   detailedVC.indexNumber=indexPath.row;
                    break;
                    
                    case 2:
                    detailedVC.indexNumber=indexPath.row;
                    break;
                    
                    case 3:
                    detailedVC.indexNumber=indexPath.row;
                    break;
                default:
                    break;
                    
            }
            self.navigationController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:detailedVC animated:YES];
            break;
            
            case 2:

            switch ( indexPath.row) {
                case 0:
                    [self displayShareSheet];
                    break;
                    
                    case 1:
                    [self showActionSHeet];
                    break;
                    
                    case 2:
                    [self logOutUser];
                    
                    break;
                    
                  default:
                    break;
            }

            break;
            
            case 3:
            [self showDeleteAlertView];
            break;
            
        default:
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
            case 1:
            return 4;
            break;
            
            case 2:
            return 3;
            break;
            
            case 3:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    else
    {
    return 50;
    }
}
#pragma TableView Custom Methods

-(void)logOutUser
{
    [UIView animateWithDuration:0.3f animations:^{
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"stop" object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [appdel.m_Timer invalidate];
            appdel.m_Timer=nil;
            [FBSession.activeSession closeAndClearTokenInformation];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [appdel.window.superview removeFromSuperview];
            [appdel initiaLizeIntroView];
            
              });
       
    }];
    
}
-(void)bioButtonClicked
{
    BioEditViewController *bioEdit;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        bioEdit=[[BioEditViewController alloc] initWithNibName:@"BioEditViewController" bundle:nil];
    }
    else
    {
        bioEdit=[[BioEditViewController alloc] initWithNibName:@"BioEditViewController_iPhone4" bundle:nil];
    }
    self.navigationController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:bioEdit animated:YES];
    
}
-(void)editPhotosClicked
{
//    AddImagesViewController *addVC;
//    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
//        addVC=[[AddImagesViewController alloc] initWithNibName:@"AddImagesViewController" bundle:nil];
//    }
//    else
//    {
//        addVC=[[AddImagesViewController alloc] initWithNibName:@"AddImagesViewController_iPhone4" bundle:nil];
//    }
//    addVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:addVC animated:YES];
    
    ProfilePhotoViewController *addVC = [[ProfilePhotoViewController alloc] initWithNibName:@"ProfilePhotoViewController" bundle:nil];
    addVC.hidesBottomBarWhenPushed = YES;
    addVC.fromSettings = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}

-(void)ageButtonClicked
{
    
}
-(void)reloadTableView:(NSNotification*)notification
{
    [self.m_SettingsTableview reloadData];
}
-(void)showActionSHeet
{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Contact Us",@"Make a Suggestion",@"Report a Issue", nil];
    [sheet showInView:self.view];
    
}
#pragma ActionSheet Delegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self displayEmailController];
            break;
            
            case 1:
            [self displayEmailController];
            break;
            
            case 2:
           [self displayEmailController];
            break;
            
            case 3:

            break;
            
        default:
            break;
    }
}
-(void)displayEmailController
{
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:@[@"help@virginlabsinc.com"]];
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)displayShareSheet
{
    NSArray *array=[[NSArray alloc] initWithObjects:@"Check out this Fondoo App, its Great !", nil];
    UIActivityViewController *shareView=[[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    [self.navigationController presentViewController:shareView animated:YES completion:^{
        
    }];
}
#pragma Delete User Profile
-(void)deleteUser
{
       NSDictionary *resultDict=[WebServiceAPIController executeAPIRequestForMethod:kDeleteUserMethod AndRequestBody:[NSString stringWithFormat:@"%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"]]];

    if ([[resultDict objectForKey:@"return"] intValue]==1) {
        [self logOutUser];
    }
    else
    {
        
    }
}
#pragma Alertview Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:
            switch (buttonIndex) {
                    
                case 1:
                    
                    [self.m_ActivityIndicator startAnimating];
                    [self deleteUser];
                    [self.m_ActivityIndicator stopAnimating];
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

-(void)showDeleteAlertView
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Delete Account" message:@"Do you want to delete account?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    alert.tag=1;
    [alert show];
}

@end
