//
//  UserDetailsViewController.m
//  KeithDatingApp
//
//  Created by Mohit on 03/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SharedClass.h"
#import "AccountViewController.h"
#import "ConversationViewController.h"
@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController
@synthesize m_UserID;
@synthesize m_userProfile;
@synthesize isChecked;
@synthesize isBLocked;
@synthesize m_ImageNumber;
@synthesize m_ImagesArray;
@synthesize m_FriendsDictionary;
@synthesize m_InterestsDictionary;
@synthesize m_PageName;
@synthesize m_PageID;
@synthesize m_FriendsIndicator;
@synthesize m_InterestIndicator;
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
    m_PageName=[[NSMutableArray alloc] init];
    m_PageID=[[NSMutableArray alloc] init];
    m_FriendsIndicator=[[UIActivityIndicatorView alloc] init];
    m_InterestIndicator=[[UIActivityIndicatorView alloc] init];
    [m_FriendsIndicator setColor:kRedColor];
    [m_FriendsIndicator setFrame:CGRectMake(131, 30, 37, 37)];
    m_FriendsIndicator.hidesWhenStopped=YES;
    [m_FriendsIndicator startAnimating];
    
    [m_InterestIndicator setColor:kRedColor];
    [m_InterestIndicator setFrame:CGRectMake(131, 30, 37, 37)];
    m_InterestIndicator.hidesWhenStopped=YES;
    [m_InterestIndicator startAnimating];

    
    
    [self fetchFriends];
      m_ImagesArray=[[NSMutableArray alloc] init];
      if (self.ischat==NO) {
          UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
          [backView setBackgroundColor:[UIColor clearColor]];

        UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(20, 0, 60, 30)];
        [rightButton setTitle:@"Chat" forState:UIControlStateNormal];
        [rightButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [rightButton setBackgroundColor:[UIColor clearColor]];
        [rightButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
          [backView addSubview:rightButton];
        UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithCustomView:backView];
        self.navigationItem.rightBarButtonItem=rightBar;
    }

    
    
    [self.m_ActivityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self initizlizeScroller];
    });
            // Do any additional setup after loading the view from its nib.
}
-(void)setNav
{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    
    self.navigationItem.backBarButtonItem.title=@"";

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setNav];
  
    [self.m_ImagescrollView setDelegate:self];
    [self.m_WrapperScrollView setDelegate:self];
    if (self.m_UserDetails) {
        if (isChecked==YES) {
            self.navigationItem.title=[NSString stringWithFormat:@"%@, %@",[self.m_userProfile objectForKey:@"first_name"],[self.m_userProfile objectForKey:@"age"]];
        }
        else
        {
            self.navigationItem.title=[NSString stringWithFormat:@"%@, %@",[self.m_userProfile objectForKey:@"first_name"],[self.m_userProfile objectForKey:@"age"]];
        }

    }
    [self.tabBarController.tabBar setHidden:YES];
    self.tabBarController.hidesBottomBarWhenPushed=YES;
//    [self.tabBarController.tabBar set]
}
-(void)rightBarButtonClicked
{
    ConversationViewController *conversationVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
conversationVC=[[ConversationViewController alloc] initWithNibName:@"ConversationViewController" bundle:nil];
    }
    else{
conversationVC=[[ConversationViewController alloc] initWithNibName:@"ConversationViewController_iPhone4" bundle:nil];
    }
    self.navigationItem.title=@"";
    conversationVC.hidesBottomBarWhenPushed=YES;
    conversationVC.isChecked=YES;
    conversationVC.m_userInfo=self.m_userProfile;
    [self.navigationController pushViewController:conversationVC animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initizlizeScroller
{
    NSString *timeZone=[[NSTimeZone localTimeZone] name];
    NSDictionary *result=[WebServiceAPIController executeAPIRequestForMethod:kGetOtherUserDetails AndRequestBody:[NSString stringWithFormat:@"%@%@%@%@%@%@",kUserIDString,[self.m_userProfile objectForKey:@"userid"],kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kTimeZoneString,timeZone]];
    NSLog(@"dict : %@",result);
 dispatch_async(dispatch_get_main_queue(), ^{
    if ([[result objectForKey:@"return"] integerValue]==1) {
        self.m_UserDetails=[[NSMutableDictionary alloc] initWithDictionary:result];
        if ([[self.m_UserDetails objectForKey:@"is_block"] isEqualToString:@"yes"]) {
            isBLocked=YES;
        }
        else
        {
            isBLocked=NO;
        }
        NSMutableArray *images=[[NSMutableArray alloc] init];
        for (int i=0; i<6; i++) {
            
            if ([[[[[result objectForKey:@"data"] objectForKey:@"img"] objectForKey:[NSString stringWithFormat:@"image%i",i]] objectForKey:@"imageset"] isEqualToString:@"yes"]) {
                [images addObject:[[[[result objectForKey:@"data"] objectForKey:@"img"] objectForKey:[NSString stringWithFormat:@"image%i",i]] objectForKey:@"url"]];
                [m_ImagesArray addObject:[[[[result objectForKey:@"data"] objectForKey:@"img"] objectForKey:[NSString stringWithFormat:@"image%i",i]] objectForKey:@"url"]];
            }
        }
        [self.m_PageControl setNumberOfPages:[images count]];
        int  tag = 0;
        for (NSString *image in images) {
            if (tag>0) {
                UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SlideImage"]];
                [image setFrame:CGRectMake(80, 280, 160, 15)];
                [image setTag:2];
                [self.m_ImagescrollView addSubview:image];
            }
            UIImageView *ImageButton=[[UIImageView alloc] init];
            ImageButton.contentMode=UIViewContentModeScaleAspectFill;
            ImageButton.clipsToBounds=YES;
            UIActivityIndicatorView *actIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 140, 37, 37)];
            [actIndicator setColor:kRedColor];
            actIndicator.hidesWhenStopped=YES;
            [actIndicator startAnimating];
            NSURLRequest *url_request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",image]]];
            __block UIImageView * imageView = ImageButton;
            [ImageButton setImageWithURLRequest:url_request placeholderImage:[UIImage imageNamed:@"nopreview"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                if (image) {
                    [imageView setImage:image];
                    [actIndicator stopAnimating];
                }
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                [actIndicator stopAnimating];
            }];

            ImageButton.frame = CGRectMake(320*tag, 0, 320, kImageHeight4);
            ImageButton.tag = tag;
            tag++;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
            [tap setNumberOfTouchesRequired:1];
            [tap setNumberOfTapsRequired:1];
            [ImageButton addGestureRecognizer:tap];
            [self.m_ImagescrollView addSubview:ImageButton];
            }
        self.m_ImagescrollView.contentSize = CGSizeMake([images count]*320, self.view.bounds.size.height);
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [tap2 setNumberOfTouchesRequired:1];
        [self.m_ImagescrollView addGestureRecognizer:tap2];
        if (self.m_WrapperScrollView==nil) {
            self. m_WrapperScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kImageHeight4)];
            self.m_WrapperScrollView.backgroundColor = [UIColor clearColor];
            self.m_WrapperScrollView.delegate = self;
            self.m_WrapperScrollView.pagingEnabled = YES;
            self.m_WrapperScrollView.showsVerticalScrollIndicator = NO;
            self.m_WrapperScrollView.showsHorizontalScrollIndicator = NO;
            self.m_WrapperScrollView.userInteractionEnabled=YES;
           
        }
        
        self.m_WrapperScrollView.contentSize = CGSizeMake([images count]*320, kImageHeight4);
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [tap1 setNumberOfTouchesRequired:1];
        [tap1 setNumberOfTapsRequired:1];
        [self.m_WrapperScrollView addGestureRecognizer:tap1];
        [self.m_TablevIew setDelegate:self];
        [self.m_TablevIew setDataSource:self];

//            UILabel *ClickTolabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 280, 240, 30)];
//            [ClickTolabel setTextColor:[UIColor whiteColor]];
//            [ClickTolabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f]];
//            [ClickTolabel setTextAlignment:NSTextAlignmentCenter];
//            [ClickTolabel setText:@"<< Slide to see photos"];
//            [ClickTolabel setBackgroundColor:[UIColor clearColor]];
//            [ClickTolabel setUserInteractionEnabled:YES];
        
       
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
//        [tap setNumberOfTouchesRequired:1];
//        [tap setNumberOfTapsRequired:1];
        
           // [self.m_ImagescrollView addSubview:ClickTolabel];
            [self.m_TablevIew reloadData];
            [self.m_ActivityIndicator stopAnimating];
        if (isChecked==YES) {
            self.navigationItem.title=[NSString stringWithFormat:@"%@, %@",[self.m_userProfile objectForKey:@"first_name"],[self.m_userProfile objectForKey:@"age"]];
        }
        else
        {
            self.navigationItem.title=[NSString stringWithFormat:@"%@, %@",[self.m_userProfile objectForKey:@"first_name"],[self.m_userProfile objectForKey:@"age"]];
        }
    }
     });
    
    
}
-(void)pageChanged:(UIPageControl*)sender
{
    int page1 = self.m_PageControl.currentPage;
    // update the scroll view to the appropriate page
    CGRect frame = self.m_ImagescrollView.frame;
    frame.origin.x = frame.size.width * page1;
    frame.origin.y = 0;
    [self.m_ImagescrollView scrollRectToVisible:frame animated:YES];
   }

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self updateImg];
    CGFloat pageWidth = self.m_ImagescrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.m_ImagescrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.m_PageControl.currentPage = page;
    m_ImageNumber=page;
    
}




#pragma Tableview Delegates
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellReuseIdentifier   = @"SectionTwoCell";
    NSString *windowReuseIdentifier = @"SectionOneCell";
    
    UITableViewCell *cell;
        if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
            [cell.contentView addSubview:self.m_WrapperScrollView];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.layer.backgroundColor=[UIColor clearColor].CGColor;

        }
    }
  
    else  {
         cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
        if (cell==nil) {
           
            //  if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
            cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(0, 1);
            cell.layer.shadowOpacity = 1;
            cell.layer.shadowRadius = 1.0;
            cell.clipsToBounds = NO;
        }
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        

        if ([self.m_UserDetails count]!=0) {
            //*********************Friends Scrolller **************************
            if (indexPath.section==1) {
                if ([[[self.m_UserDetails objectForKey:@"post"] objectForKey:@"is_recentpost"] isEqualToString:@"yes"]) {
                    UIView *MainbackView=[[UIView alloc] init];
                    [MainbackView setBackgroundColor:[UIColor whiteColor]];
                    NSString *text=[[self.m_UserDetails objectForKey:@"post"] objectForKey:@"post_message"];
                    NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                                       attributes:@
                                                         {
                                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                                         }];
                    CGRect paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(280, 1000)
                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                       context:nil];
                    [MainbackView setFrame:CGRectMake(0, 0, 300, paragraphRect.size.height+40)];
                    UILabel *TaglineText=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, paragraphRect.size.height)];
                    
                    NSString *valueStr=[text stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
                    
                    NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
                    
                    
                    NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
                    [TaglineText setText:valueEmoj1];
                    TaglineText.numberOfLines=0;
                    [TaglineText setBackgroundColor:[UIColor clearColor]];
                    [TaglineText setTextColor:[UIColor darkGrayColor]];
                    [TaglineText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
                    
                    [MainbackView addSubview:TaglineText];
                    [cell.contentView addSubview:MainbackView];
                    UIView *locationView=[[UIView alloc] initWithFrame:CGRectMake(7, paragraphRect.size.height+10, 280, 30)];
                    UILabel *locationName=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 240, 20)];
                    [locationName setBackgroundColor:[UIColor clearColor]];
                    locationName.textColor=[UIColor darkGrayColor];
                    [locationName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
                    locationName.text=[[self.m_UserDetails objectForKey:@"post"] objectForKey:@"address"];
                    
                    UIImageView *locationImage=[[UIImageView alloc] initWithFrame:CGRectMake(3, 4, 12, 20)];
                    locationImage.image=[UIImage imageNamed:@"Map_Pin"];
                    
                    [locationView addSubview:locationName];
                    [locationView addSubview:locationImage];
                    [cell.contentView addSubview:locationView];
                    
                }
                else
                {
                    UIView *MainbackView=[[UIView alloc] init];
                    [MainbackView setBackgroundColor:[UIColor whiteColor]];
                    NSString *text=@"No Status";
                    NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                                       attributes:@
                                                         {
                                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                                         }];
                    CGRect paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(280, 1000)
                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                       context:nil];
                    [MainbackView setFrame:CGRectMake(0, 0, 300, paragraphRect.size.height+10)];
                    UILabel *TaglineText=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, paragraphRect.size.height)];
                    
                    
                    [TaglineText setText:text];
                    TaglineText.numberOfLines=0;
                    [TaglineText setBackgroundColor:[UIColor clearColor]];
                    [TaglineText setTextColor:[UIColor darkGrayColor]];
                    [TaglineText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
                    
                    [MainbackView addSubview:TaglineText];
                    [cell.contentView addSubview:MainbackView];
                    
                    
                }
            }
            else if (indexPath.section==2) {
                
                UIView *MainbackView=[[UIView alloc] init];
                [MainbackView setBackgroundColor:[UIColor whiteColor]];
                NSString *text=[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"tagline"];
                NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                                   attributes:@
                                                     {
                                                     NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                                     }];
                CGRect paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(280, 1000)
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                   context:nil];
                [MainbackView setFrame:CGRectMake(0, 0, 300, paragraphRect.size.height+10)];
                UILabel *TaglineText=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, paragraphRect.size.height)];
                NSString *stringValue=[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"tagline"];
                NSString *valueStr=[stringValue stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
                //self.m_TagelineTextView.text=valueStr;
                
                NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
                
                
                NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
                [TaglineText setText:valueEmoj1];
                TaglineText.numberOfLines=0;
                [TaglineText setBackgroundColor:[UIColor clearColor]];
                [TaglineText setTextColor:[UIColor darkGrayColor]];
                [TaglineText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
                
                [MainbackView addSubview:TaglineText];
                [cell.contentView addSubview:MainbackView];
                
            }
            else if (indexPath.section==3) {
               
                UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
                [backView addSubview:m_FriendsIndicator];
               
                [backView setBackgroundColor:[UIColor whiteColor]];
                if ([[self.m_FriendsDictionary objectForKey:@"data"] count]>0) {
                    
                int numberOfFriends=[[self.m_FriendsDictionary objectForKey:@"data"] count];
                UIScrollView *friendsScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(5, 10, 290, 100)];
                if (numberOfFriends>0) {
                    [friendsScrollView setContentSize:CGSizeMake(numberOfFriends*75, 100)];
                    [friendsScrollView setBackgroundColor:[UIColor clearColor]];
                    [friendsScrollView setShowsHorizontalScrollIndicator:NO];
                    [friendsScrollView setShowsVerticalScrollIndicator:NO];
                    
                    for (int i=0; i<numberOfFriends; i++) {
                        UIImageView *likeImage=[[UIImageView alloc] init];
                        //                        [likeImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[[[self.m_UserDetails objectForKey:@"friends"]objectAtIndex:i] objectForKey:@"friendid"]]] placeholderImage:[UIImage imageNamed:@"PreviewFrame"]];
                                               [likeImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=120&height=120",[[[self.m_FriendsDictionary objectForKey:@"data"] objectAtIndex:i] objectForKey:@"id"]]] placeholderImage:[UIImage imageNamed:@"PreviewFrame"]];
                        
                        likeImage.layer.cornerRadius=3.0f;
                        likeImage.layer.masksToBounds=YES;
                        [likeImage setFrame:CGRectMake((i*60)+(12*i), 0, 60, 60)];
                        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake((i*60)+(12*i), 60, 60, 30)];
                        [nameLabel setBackgroundColor:[UIColor clearColor]];
                        [nameLabel setText:[[[self.m_FriendsDictionary objectForKey:@"data"] objectAtIndex:i] objectForKey:@"name"]];
                        nameLabel.numberOfLines=2;
                        [nameLabel setTextColor:[UIColor blackColor]];
                        nameLabel.textAlignment=NSTextAlignmentCenter;
                        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f]];
                        [friendsScrollView addSubview:likeImage];
                        [friendsScrollView addSubview:nameLabel];
                    }
                }
                [backView addSubview:friendsScrollView];
                 [m_FriendsIndicator stopAnimating];
            }
            [cell.contentView addSubview:backView];
            }
            
            else if (indexPath.section==4)
            {
                
                UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
                [backView addSubview:m_InterestIndicator];
                               [backView setBackgroundColor:[UIColor whiteColor]];
                if ([[self.m_InterestsDictionary objectForKey:@"data"] count]>0) {
                    
                   
                    int numberOfFriends=[[self.m_InterestsDictionary objectForKey:@"data"] count];
                    UIScrollView *friendsScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(5, 10, 290, 100)];
                    if (numberOfFriends>0) {
                        [friendsScrollView setContentSize:CGSizeMake(numberOfFriends*75, 100)];
                        [friendsScrollView setBackgroundColor:[UIColor clearColor]];
                        [friendsScrollView setShowsHorizontalScrollIndicator:NO];
                        [friendsScrollView setShowsVerticalScrollIndicator:NO];
                        
                        for (int i=0; i<numberOfFriends; i++) {
                            UIImageView *likeImage=[[UIImageView alloc] init];
                           

                            if (self.m_PageID.count==numberOfFriends) {
                            [likeImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=120&height=120",[self.m_PageID objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"PreviewFrame"]];
                            }
            
                            
                            likeImage.layer.cornerRadius=3.0f;
                            likeImage.layer.masksToBounds=YES;
                            [likeImage setFrame:CGRectMake((i*60)+(12*i), 0, 60, 60)];
                            UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake((i*60)+(12*i), 60, 60, 30)];
                            [nameLabel setBackgroundColor:[UIColor clearColor]];
                            if (self.m_PageName.count==numberOfFriends) {
                               [nameLabel setText:[self.m_PageName objectAtIndex:i]];
                            }
                            nameLabel.numberOfLines=2;
                            [nameLabel setTextColor:[UIColor blackColor]];
                            nameLabel.textAlignment=NSTextAlignmentCenter;
                            [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f]];
                            [friendsScrollView addSubview:likeImage];
                            [friendsScrollView addSubview:nameLabel];
                        }
                    }
                    [backView addSubview:friendsScrollView];
                    [m_InterestIndicator stopAnimating];
                }
             [cell.contentView addSubview:backView];
            }
            
            else
            {
                /*
                UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                UILabel *NameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 4, 200, 20)];
                
                if ([[self.m_UserDetails objectForKey:@"is_block"] isEqualToString:@"yes"]) {
                    [NameLabel setText:[NSString stringWithFormat:@"UnBlock %@ %@",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"last_name"]]];
                }
                else
                {
                    [NameLabel setText:[NSString stringWithFormat:@"Block %@ %@",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"last_name"]]];
                }
                
                
                [NameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
                [backView addSubview:NameLabel];
                [cell.contentView addSubview:backView];
                 */
                
            }
        }
    
    }
	cell.selectionStyle       = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
	[cell.contentView setBackgroundColor:[UIColor clearColor]];
    return cell;
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel *lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 31, 320, 0.5)];
    [lineLabel setBackgroundColor:[UIColor darkGrayColor]];
    
    //Add label to view
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
    if (section == 0) {
        return nil;
    }
    else if (section==1)
    {
      titleLabel.text = @"   Recent Status";
    }
    /*
    else if(section==2) {
        titleLabel.text = @"   About me";
    }
     */
    else if (section==2)
    {
        titleLabel.text = @"   Tagline";
    }
    else if (section==3)
    {
        titleLabel.text = @"   Shared Friends";
    }
    else if(section==4)
    {
        titleLabel.text = @"   Shared Interest";
    }
    else
    {
//        if ([[self.m_UserDetails objectForKey:@"is_block"] isEqualToString:@"yes"]) {
//           titleLabel.text=@"   UnBlock";
//        }
//        else
//        {
//          titleLabel.text=@"   Block";
//        }
        UIButton *BlockButton=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, 300, 50)];
        [BlockButton setBackgroundColor:[UIColor whiteColor]];
        if ([[self.m_UserDetails objectForKey:@"is_block"] isEqualToString:@"yes"]) {
            [BlockButton setTitle:[NSString stringWithFormat:@"Unblock %@",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"]] forState:UIControlStateNormal];
        }
        else{
            [BlockButton setTitle:[NSString stringWithFormat:@"Block %@",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"]] forState:UIControlStateNormal];
        }
        [BlockButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [BlockButton addTarget:self action:@selector(blockUserClicked) forControlEvents:UIControlEventTouchUpInside];
        BlockButton.layer.cornerRadius=8.0f;
        BlockButton.clipsToBounds=YES;
        return BlockButton;
    }
    if (section==5) {
        
    }
    else{
    [sectionView addSubview:lineLabel];
            [sectionView addSubview:titleLabel];
    }


    return sectionView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0;
    if (section==5) {
            return 50;
    }
    else{
    return 32;        
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 330;
        
    }
    else if (indexPath.section==1)
    {
        if ([[[self.m_UserDetails objectForKey:@"post"] objectForKey:@"is_recentpost"] isEqualToString:@"yes"]) {

        NSString *text=[[self.m_UserDetails objectForKey:@"post"] objectForKey:@"post_message"];
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                           attributes:@
                                             {
                                             NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                             }];
        CGRect paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(280, 1000)
                                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                           context:nil];
       
        return paragraphRect.size.height+60;
        }
        else
        {
            return 40;
        }
    }
    /*
    else if(indexPath.section==2)
    {
        return 60;
    }
     */
    else if (indexPath.section==2)
    {
        
        NSString *text=[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"tagline"];
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                           attributes:@
                                             {
                                             NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]
                                             }];
        CGRect paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(280, 1000)
                                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                           context:nil];
        return paragraphRect.size.height+20;
    }
    else if(indexPath.section==3)
    {
        return 110;
    }
    else if (indexPath.section==4)
    {
        return 110;
    }
    else
    {
        return 40;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(void)blockUserClicked
{
    NSString *messageString;
    NSString *title;
    if (isBLocked==YES) {
        messageString=@" DO You Want To UnBlock ";
        title=@"UnBlock!";
        isBLocked=NO;
        
    }
    else
    {
        isBLocked=YES;
        messageString=@" DO You Want To Block ";
        title=@"Block!";
    }
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:[NSString stringWithFormat:@"%@%@ %@?",messageString,[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"last_name"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Block", nil];
    [alertView show];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==5) {
        NSString *messageString;
        NSString *title;
        if (isBLocked==YES) {
            messageString=@" DO You Want To UnBlock ";
            title=@"UnBlock!";
            isBLocked=NO;
          
        }
        else
        {
            isBLocked=YES;
            messageString=@" DO You Want To Block ";
            title=@"Block!";
        }
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:[NSString stringWithFormat:@"%@%@ %@?",messageString,[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"last_name"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Block", nil];
        [alertView show];
    }
    
}
- (void)updateImg {
    CGFloat yOffset   = self.m_TablevIew.contentOffset.y;
    CGFloat xOffset   = self.m_WrapperScrollView.contentOffset.x;
    
    if (yOffset < 0) {
        
        CGFloat pageWidth = self.m_WrapperScrollView.frame.size.width;
		int page = floor((self.m_WrapperScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        UIImageView *imgTmp;
		for (UIView *view in self.m_ImagescrollView.subviews) {
			if ([view isKindOfClass:[UIImageView class]]) {
				if (view.tag ==  page) {
					imgTmp = (UIImageView*)view;
				}
			}
		}
        
        CGFloat factor = ((ABS(yOffset)+ kImageHeight4 )*320)/ kImageHeight4;
        
        CGRect f = CGRectMake((-(factor-320)/2) + 320 *page, 0, 320, kImageHeight4);
        f.size.height = kImageHeight4+ABS(yOffset);
        f.size.width = factor;
		imgTmp.frame = f;
        
        CGRect frame = self.m_ImagescrollView.frame;
		frame.origin.y = 64;
		self.m_ImagescrollView.frame = frame;
    } else {
        
        self.m_ImagescrollView.contentOffset = CGPointMake(xOffset, yOffset);
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.m_ImagescrollView setDelegate:nil];
    [self.m_WrapperScrollView setDelegate:nil];
   }

#pragma ALertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            //Block Clicked
            case 1:
            if (isBLocked==NO) {
                [self unBlockUser];
            }
            else
            {
                [self blockUser];
            }
          
            break;
            
            
        default:
            break;
    }
    isBLocked=!isBLocked;
}
-(void)blockUser
{
    NSString *body=[NSString stringWithFormat:@"%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kUserIDString,[self.m_userProfile objectForKey:@"userid"]];

    NSDictionary *resultDict=[WebServiceAPIController executeAPIRequestForMethod:kBlockUserMethod AndRequestBody:body];
    
    if ([[resultDict objectForKey:@"return"] intValue]==1) {
        [[[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"%@ %@ Blocked",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"last_name"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error in Blocking %@ %@",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"last_name"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

-(void)unBlockUser
{
    NSString *body=[NSString stringWithFormat:@"%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kUserIDString,[self.m_userProfile objectForKey:@"userid"]];
    
    NSDictionary *resultDict=[WebServiceAPIController executeAPIRequestForMethod:kBlockUserMethod AndRequestBody:body];
    
    if ([[resultDict objectForKey:@"return"] intValue]==1) {
        [[[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"%@ %@ UnBlocked",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"last_name"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error in UnBlocking %@ %@",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"last_name"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
 
}
-(void)singleTapping:(UITapGestureRecognizer*)tapGesture
{
 
 
    ImagePreviewViewController *imageVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        imageVC=[[ImagePreviewViewController alloc] initWithNibName:@"ImagePreviewViewController" bundle:nil];
    }
    else
    {
        imageVC=[[ImagePreviewViewController alloc] initWithNibName:@"ImagePreviewViewController_iPhone4" bundle:nil];
    }
    imageVC.m_ImageUrl=[m_ImagesArray objectAtIndex:self.m_ImageNumber];
    [self presentViewController:imageVC animated:YES completion:nil];
}

-(void)getFacebookPages
{
    }


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self fetchFriends];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            break;
        default:
            break;
    }
    
    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.description
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your Facebook login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
- (void)openSession
{
    
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state,NSError *error)
     {
         [self sessionStateChanged:session
                             state:state
                             error:error];
     }];
}
-(void)fetchFriends
{
    if ([[FBSession activeSession]isOpen]) {

        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/mutualfriends/%@",[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"facebookid"],[self.m_userProfile objectForKey:@"otherfacebookid"]]
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  
                                                  ) {
                                  if (!error) {
                                        [self.m_FriendsIndicator stopAnimating];
                                      self.m_FriendsDictionary=[[NSDictionary alloc] initWithDictionary:result];
                                      [self.m_TablevIew reloadData];
                                      [self.m_FriendsIndicator stopAnimating];
                                      self.m_FriendsIndicator.hidden=YES;
                                      [self.m_InterestIndicator stopAnimating];
                                      [self fetchInterest];
                                  }
                                  else
                                  {
                                        [self.m_FriendsIndicator stopAnimating];
                                        [self.m_InterestIndicator stopAnimating];
                                  }
                              }];
    }
        else
        {
            [self openSession];
        }
        

}
-(void)fetchInterest
{
    if ([[FBSession activeSession]isOpen]) {
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSString stringWithFormat:@"SELECT page_id FROM page_fan WHERE uid= %@ AND page_id IN (SELECT page_id FROM page_fan WHERE uid = %@)",[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"facebookid"],[self.m_userProfile objectForKey:@"otherfacebookid"]], @"q",
                                        nil];
        FBRequest *request = [FBRequest requestWithGraphPath:@"/fql" parameters:params HTTPMethod:@"GET"];
        
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            //do your stuff
            if(!error)
            {
                self.m_InterestsDictionary=[[NSDictionary alloc] initWithDictionary:result];
                for (int i=0; i<[[self.m_InterestsDictionary objectForKey:@"data"] count]; i++) {
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@",[[[self.m_InterestsDictionary objectForKey:@"data"] objectAtIndex:i] objectForKey:@"page_id"]]]
                                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                       timeoutInterval:10];
                    
                    [request setHTTPMethod: @"GET"];
                    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
                [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response,NSData *data,NSError *error)
                                  {
                                      NSDictionary* json = [NSJSONSerialization
                                                            JSONObjectWithData:data
                                                            
                                                            options:kNilOptions
                                                            error:&error];
                                      [self.m_PageName addObject:[json objectForKey:@"name"]];
                                      [self.m_PageID addObject:[json objectForKey:@"id"]];
                                        [self.m_InterestIndicator stopAnimating];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (self.m_PageID.count==[[self.m_InterestsDictionary objectForKey:@"data"] count]) {
                                              [self.m_TablevIew reloadData];
                                              self.m_InterestIndicator.hidden=YES;
                                              [self.m_FriendsIndicator stopAnimating];
                                              [self.m_InterestIndicator stopAnimating];
                                          }
                                          [self.m_FriendsIndicator stopAnimating];
                                          [self.m_InterestIndicator stopAnimating];
                                      });
                                  }];

                }

            }
        }];
    
    }
    else
    {
        [self openSession];
    }
    

}
@end
