//
//  MessageViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "MessageViewController.h"
#import "UIImageView+WebCache.h"
#import "ConversationViewController.h"
#import "PostStatusViewController.h"
@interface MessageViewController ()
@property(nonatomic)int pageNumber;
@property (weak, nonatomic) IBOutlet UITableView *m_MessageTable;


@end

@implementation MessageViewController
@synthesize m_MessagesArray;
@synthesize m_Timer;
@synthesize m_Appdel;
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
     [self.m_ActivityIndicator startAnimating];
    self.m_Appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    _pageNumber=0;
 //   [self getMessages];
    self.m_MessageTable.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.m_MessageTable.layer.shadowOffset = CGSizeMake(0, 1);
    self.m_MessageTable.layer.shadowOpacity = 1;
    self.m_MessageTable.layer.shadowRadius = 1.0;
    self.m_MessageTable.clipsToBounds = NO;
     [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kRedColor,NSForegroundColorAttributeName,nil]];
    UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 5, 25, 25)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"Add_Button"] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBar;
        // Do any additional setup after loading the view from its nib.
}
-(void)startTimer
{
    if (self.m_Appdel.m_Timer==nil) {
    self.m_Appdel.m_Timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getMessages) userInfo:nil repeats:YES];
//        NSRunLoop *runner = [NSRunLoop currentRunLoop];
//        [runner addTimer:m_Timer forMode: NSDefaultRunLoopMode];
    }
   
}
-(void)rightBarButtonClicked
{
    PostStatusViewController *postVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        postVC=[[PostStatusViewController alloc] initWithNibName:@"PostStatusViewController" bundle:nil];
    }
    else
    {
        postVC=[[PostStatusViewController alloc] initWithNibName:@"PostStatusViewController_iPhone4" bundle:nil];
    }
    [self.navigationController pushViewController:postVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animatedascascasc{
    [super viewWillAppear:YES];
     // [self startTimer];
    [self.tabBarController.tabBar setHidden:NO];
 self.navigationItem.title=@"Messages";

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //[self.m_Timer invalidate];
  //  self.m_Timer=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBarButtonClicked
{
    
}

#pragma TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_MessagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"Ident1";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
   
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
           }
    
  for (UIView *view in cell.contentView.subviews) {
      [view removeFromSuperview];
    }

    if (self.m_MessagesArray.count>0) {
        
        UIButton *profileImage=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        profileImage.imageView.contentMode=UIViewContentModeScaleAspectFill;
        profileImage.layer.cornerRadius=3.0f;
        profileImage.clipsToBounds=YES;
        [profileImage.layer setMasksToBounds:YES];
        [profileImage setUserInteractionEnabled:YES];
        [profileImage setBackImageWithURL:[NSURL URLWithString:[[self.m_MessagesArray objectAtIndex:indexPath.row] objectForKey:@"userimage"]] placeholderImage:[UIImage imageNamed:@"PreviewFrame"] options:0];
        profileImage.tag=indexPath.row;
        [profileImage addTarget:self action:@selector(profileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
       
        UILabel *userName=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 180, 15)];
        [userName setText:[[self.m_MessagesArray objectAtIndex:indexPath.row]objectForKey:@"first_name"]];
        [userName setTextColor:[UIColor blackColor]];
        [userName setUserInteractionEnabled:YES];
        [userName setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
      
        UILabel *messageLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 27, 180, 20)];
        [messageLabel setTextColor:[UIColor colorWithRed:161.0f/255.0f green:167.0/255.0f blue:177.0f/255.0f alpha:1.0f]];
        [messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        [messageLabel setUserInteractionEnabled:YES];
        
        NSString *stringValue=[[self.m_MessagesArray objectAtIndex:indexPath.row] objectForKey:@"msg"];
        NSString *valueStr=[stringValue stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
        NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
        [messageLabel setText:valueEmoj1];
        UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(250, 10, 60, 20)];
        [timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
        [timeLabel setTextColor:[UIColor grayColor]];
        [timeLabel setUserInteractionEnabled:YES];
        [timeLabel setText:[[self.m_MessagesArray objectAtIndex:indexPath.row] objectForKey:@"time"]];
        
        UILabel *lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 59, 300, 0.3)];
        [lineLabel setBackgroundColor:[UIColor lightGrayColor]];
        
        [cell.contentView addSubview:profileImage];
        [cell.contentView addSubview:userName];
        [cell.contentView addSubview:messageLabel];
        [cell.contentView addSubview:timeLabel];
        [cell.contentView addSubview:lineLabel];
        
        if ([[[self.m_MessagesArray objectAtIndex:indexPath.row] objectForKey:@"unread"] isEqualToString:@"0"]) {
             [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        }
        else
        {
            UILabel *countButton=[[UILabel alloc] initWithFrame:CGRectMake(270, 35, 20, 15)];
            [countButton setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
            [countButton setText:[[self.m_MessagesArray objectAtIndex:indexPath.row] objectForKey:@"unread"] ];
            countButton.tag=20;
            countButton.layer.cornerRadius=2.0f;
            countButton.layer.masksToBounds=YES;
            countButton.textAlignment=NSTextAlignmentCenter;
            countButton.textColor=[UIColor whiteColor];
            [countButton setBackgroundColor:[UIColor colorWithRed:124.0/255.0 green:139.0/255.0 blue:159.0/255.0 alpha:1.0f]];
            [cell.contentView addSubview:countButton];
          
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:244.0/255.0 blue:245.0/255.0 alpha:1.0f]];
            
        }

    }
    else
    {
        cell.textLabel.text=@"No messages available";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];   
    ConversationViewController *conversationVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
       conversationVC=[[ConversationViewController alloc] initWithNibName:@"ConversationViewController" bundle:nil];
    }
    else
    {
        conversationVC=[[ConversationViewController alloc] initWithNibName:@"ConversationViewController_iPhone4" bundle:nil];
    }
    conversationVC.hidesBottomBarWhenPushed=YES;
    self.navigationItem.title=@"";
    conversationVC.m_userInfo=[self.m_MessagesArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:conversationVC animated:YES];

    
}
-(void)getMessages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

    _pageNumber=0;
        NSString *timeZone=[[NSTimeZone localTimeZone] name];
    NSString *body=[NSString stringWithFormat:@"%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kTimeZoneString,timeZone];
   
    NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kGetAllLatestMessages AndRequestBody:body];
    if ([[dict objectForKey:@"return"] intValue]==1) {
        m_MessagesArray=[[NSMutableArray alloc] initWithArray:[dict objectForKey:@"data"]];
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self.m_ActivityIndicator stopAnimating];
                   
                   if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"unreadusermsg"]] isEqualToString:@"0"]) {
                       [[[[[self tabBarController] tabBar] items]
                         objectAtIndex:2] setBadgeValue:0];
                   }
                   else if(self.m_MessagesArray.count>0)
                   {
                       [[[[[self tabBarController] tabBar] items]
                         objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%@",[dict objectForKey:@"unreadusermsg"]]];
                   }
                   else
                   {
                       [[[[[self tabBarController] tabBar] items]
                         objectAtIndex:2] setBadgeValue:0];
                   }
               
            [self.m_MessageTable reloadData];
        });
    }
    else
    {
      
                           [self.m_ActivityIndicator stopAnimating];
    }
              });
  
}
-(void)stopTimer
{

    if (self.m_Appdel.m_Timer!=nil)
    {
        self.m_Appdel.m_Timer=nil;
        [self.m_Appdel.m_Timer invalidate];
    }
   
}
-(void)profileButtonClicked:(UIButton *)sender
{
    UserDetailsViewController *userDetailsVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        userDetailsVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
    }
    else
    {
        userDetailsVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController_iPhone4" bundle:nil];
    }
    self.navigationItem.title=@"";
    userDetailsVC.navigationItem.title=@"";
    userDetailsVC.hidesBottomBarWhenPushed=NO;
    userDetailsVC.m_userProfile=(NSMutableDictionary*)[self.m_MessagesArray objectAtIndex:sender.tag];
    userDetailsVC.ischat=NO;
    userDetailsVC.isChecked=NO;
    [self.navigationController pushViewController:userDetailsVC animated:YES];
}
@end
