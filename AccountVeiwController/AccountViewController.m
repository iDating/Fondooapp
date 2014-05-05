//
//  AccountViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "AccountViewController.h"
#import "UIImageView+WebCache.h"
#import "SharedClass.h"
#import "AccountSettingsViewController.h"
@interface AccountViewController ()

@property (strong, nonatomic) IBOutlet UITableView *m_TablevIew;

@end

@implementation AccountViewController
@synthesize m_TitleLabel;
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

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initizlizeScroller) name:@"imageEdit" object:nil];
        UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [backView setBackgroundColor:[UIColor clearColor]];
    [rightButton setTitle:@"Settings" forState:UIControlStateNormal];
    [rightButton setTitleColor:kLightGray forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton addTarget:self action:@selector(editImagesClicked) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:rightButton];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithCustomView:backView];
self.navigationItem.rightBarButtonItem=rightBar;
    
    
    UIButton *backButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *backButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backButtonItem;
    
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
    if (self.m_UserDetails) {
         self.navigationItem.title=[NSString stringWithFormat:@"%@, %@",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"age"]];
    }
    
}

-(void)backButtonClicked
{
    self.tabBarController.selectedIndex=0;
}

-(void)initizlizeScroller
{
    
    
    NSString *timeZone=[[NSTimeZone localTimeZone] name];
    NSDictionary *result=[WebServiceAPIController executeAPIRequestForMethod:kGetUserDetails AndRequestBody:[NSString stringWithFormat:@"%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kTimeZoneString,timeZone]];
    //Shared Class
    SharedClass *shared=[SharedClass sharedInstance];
    [shared setM_UserDetails:[result objectForKey:@"data"] ];
      if ([[result objectForKey:@"return"] integerValue]==1) {
        self.m_UserDetails=[[NSMutableDictionary alloc] initWithDictionary:result];
        [[NSUserDefaults standardUserDefaults] setObject:[self.m_UserDetails objectForKey:@"data"] forKey:@"userdetails"];
        [[NSUserDefaults standardUserDefaults] synchronize];
          [self setScroller:result];
          [self.m_ActivityIndicator stopAnimating];
    }
    else
    {
        [self initizlizeScroller];
        
    }
}
-(void)stopIndicator
{
    [self.m_ActivityIndicator stopAnimating];
}
-(void)setScroller:(NSDictionary *)result
{
    NSMutableArray *images=[[NSMutableArray alloc] init];
    for (int i=0; i<6; i++) {
        
        if ([[[[[result objectForKey:@"data"] objectForKey:@"img"] objectForKey:[NSString stringWithFormat:@"image%i",i]] objectForKey:@"imageset"] isEqualToString:@"yes"]) {
            [images addObject:[[[[result objectForKey:@"data"] objectForKey:@"img"] objectForKey:[NSString stringWithFormat:@"image%i",i]] objectForKey:@"url"]];
        }
        
    }
   // [self.m_PageControl setNumberOfPages:[images count]];
    int  tag = 0;
    for (NSString *image in images) {
        [self.view addSubview:self.m_ActivityIndicator];
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
        
       // [ImageButton setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",image]] placeholderImage:[UIImage imageNamed:@"nopreview"]];
        [ImageButton setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",image]] placeholderImage:[UIImage imageNamed:@"nopreview"] success:^(UIImage *image){
            if (image) {
                [actIndicator stopAnimating];
            }
        }failure:^(NSError *error)
         {
                [actIndicator stopAnimating];
         }];
        ImageButton.frame = CGRectMake(320*tag, 0, 320, kImageHeight4);
        ImageButton.tag = tag;
        tag++;
        [self.m_ImagescrollView addSubview:ImageButton];
    }
    self.m_ImagescrollView.contentSize = CGSizeMake([images count]*320, self.view.bounds.size.height);
    if (self.m_WrapperScrollView==nil) {
        self. m_WrapperScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kImageHeight4)];
        self.m_WrapperScrollView.backgroundColor = [UIColor clearColor];
        self.m_WrapperScrollView.delegate = self;
        self.m_WrapperScrollView.pagingEnabled = YES;
        self.m_WrapperScrollView.showsVerticalScrollIndicator = NO;
        self.m_WrapperScrollView.showsHorizontalScrollIndicator = NO;
    }
    

    self.m_WrapperScrollView.contentSize = CGSizeMake([images count]*320, kImageHeight4);
    [self.m_TablevIew setDelegate:self];
    [self.m_TablevIew setDataSource:self];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.m_ActivityIndicator stopAnimating];
        self.navigationItem.title=[NSString stringWithFormat:@"%@, %@",[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"first_name"],[[[self.m_UserDetails objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"age"]];
        [self.m_TablevIew reloadData];
    });
    
}
-(void)pageChanged:(UIPageControl*)sender
{
    /*
    int page1 = self.m_PageControl.currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.m_ImagescrollView.frame;
    frame.origin.x = frame.size.width * page1;
    frame.origin.y = 0;
    [self.m_ImagescrollView scrollRectToVisible:frame animated:YES];
     */
  }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.hidesBottomBarWhenPushed=NO;
    [self.tabBarController.tabBar setHidden:NO];
    [self setNav];
        }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editImagesClicked
{
      AccountSettingsViewController *actVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
actVC=[[AccountSettingsViewController alloc] initWithNibName:@"AccountSettingsViewController" bundle:nil];
    }
    else
    {
     actVC=[[AccountSettingsViewController alloc] initWithNibName:@"AccountSettingsViewController_iPhone4" bundle:nil];
    }
    actVC.hidesBottomBarWhenPushed=YES;
    self.navigationItem.title=@"";
    [self.navigationController pushViewController:actVC animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateImg];
}
#pragma Tableview Delegates
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellReuseIdentifier   = @"SectionTwoCell";
    NSString *windowReuseIdentifier = @"SectionOneCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:windowReuseIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:windowReuseIdentifier];
            [cell.contentView addSubview:self.m_WrapperScrollView];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.layer.backgroundColor=[UIColor clearColor].CGColor;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
       if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
            cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(0, 1);
            cell.layer.shadowOpacity = 1;
            cell.layer.shadowRadius = 1.0;
            cell.clipsToBounds = NO;
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
                    [TaglineText setTextColor:[UIColor blackColor]];
                    TaglineText.alpha=0.8;
                    [TaglineText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
                    
                    [MainbackView addSubview:TaglineText];
                    [cell.contentView addSubview:MainbackView];
                    UIView *locationView=[[UIView alloc] initWithFrame:CGRectMake(7, paragraphRect.size.height+10, 280, 30)];
                    UILabel *locationName=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 240, 20)];
                    [locationName setBackgroundColor:[UIColor clearColor]];
                    locationName.textColor=[UIColor darkGrayColor];
                    [locationName setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
                    locationName.text=[[self.m_UserDetails objectForKey:@"post"] objectForKey:@"address"];
                    
                    UIImageView *locationImage=[[UIImageView alloc] initWithFrame:CGRectMake(3, 8, 12, 15)];
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


               
               NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
               
               
               NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
               if (valueStr.length>0) {
                  [TaglineText setText:valueEmoj1];
               }
               else{
                    [TaglineText setText:@"No Bio,Just Ask Me!"];
               }
               TaglineText.numberOfLines=0;
                 [TaglineText setBackgroundColor:[UIColor clearColor]];
                [TaglineText setTextColor:[UIColor darkGrayColor]];
               [TaglineText setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
               
                [MainbackView addSubview:TaglineText];
                [cell.contentView addSubview:MainbackView];

            }
            else if (indexPath.section==3) {
                
                UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
                [backView setBackgroundColor:[UIColor whiteColor]];

                int numberOfFriends=[[self.m_UserDetails objectForKey:@"friends"] count];
                UIScrollView *friendsScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(5, 10, 290, 100)];
                [friendsScrollView setContentSize:CGSizeMake(numberOfFriends*75, 100)];
                [friendsScrollView setBackgroundColor:[UIColor clearColor]];
                [friendsScrollView setShowsHorizontalScrollIndicator:NO];
                [friendsScrollView setShowsVerticalScrollIndicator:NO];
                for (int i=0; i<numberOfFriends; i++) {
                
                
                    UIImageView *likeImage=[[UIImageView alloc] init];
                    [likeImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[[[self.m_UserDetails objectForKey:@"friends"]objectAtIndex:i] objectForKey:@"friendid"]]] placeholderImage:[UIImage imageNamed:@"PreviewFrame"]];
            
                    likeImage.layer.cornerRadius=3.0f;
                    likeImage.layer.masksToBounds=YES;
                    [likeImage setFrame:CGRectMake((i*60)+(12*i), 0, 60, 60)];
                    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake((i*60)+(12*i), 60, 60, 30)];
                    [nameLabel setText:[[[self.m_UserDetails objectForKey:@"friends"]objectAtIndex:i] objectForKey:@"frindsname"]];
                    nameLabel.numberOfLines=2;
                    nameLabel.textAlignment=NSTextAlignmentCenter;
                    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f]];
                    [friendsScrollView addSubview:likeImage];
                    [friendsScrollView addSubview:nameLabel];
                }

                [backView addSubview:friendsScrollView];
                [cell.contentView addSubview:backView];
            }
            else if (indexPath.section==4)
            {
                UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
                [backView setBackgroundColor:[UIColor whiteColor]];
             
                
                int numberOfLikes=[[self.m_UserDetails objectForKey:@"interest"] count];
                UIScrollView *friendsScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(5, 10, 290, 100)];
                [friendsScrollView setContentSize:CGSizeMake(numberOfLikes*75, 100)];
                [friendsScrollView setBackgroundColor:[UIColor clearColor]];
                [friendsScrollView setShowsHorizontalScrollIndicator:NO];
                [friendsScrollView setShowsVerticalScrollIndicator:NO];

                for (int i=0; i<numberOfLikes; i++) {
                    UIImageView *likeImage=[[UIImageView alloc] init];
                    [likeImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[[[self.m_UserDetails objectForKey:@"interest"]objectAtIndex:i] objectForKey:@"interestid"]]] placeholderImage:[UIImage imageNamed:@"PreviewFrame"]];
                        likeImage.layer.cornerRadius=3.0f;
                    likeImage.layer.masksToBounds=YES;
                    [likeImage setFrame:CGRectMake((i*60)+(12*i), 0, 60, 60)];
                    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake((i*60)+(12*i), 60, 60, 30)];
                    [nameLabel setBackgroundColor:[UIColor clearColor]];
                [nameLabel setText:[[[self.m_UserDetails objectForKey:@"interest"]objectAtIndex:i] objectForKey:@"interestname"]];
                    nameLabel.numberOfLines=0;
                  
                    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f]];
                    nameLabel.textAlignment=NSTextAlignmentCenter;
                    [friendsScrollView addSubview:likeImage];
                    [friendsScrollView addSubview:nameLabel];
                }

                [backView addSubview:friendsScrollView];
                [cell.contentView addSubview:backView];

            }
            
  
            
        }
      //  }
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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
    titleLabel.alpha=0.8;
    if (section == 0) {
        return nil;
    } else if(section==1) {
        titleLabel.text = @"   Recent Status";
        
    }
    else if (section==2)
    {
        titleLabel.text = @"   About me";
    }
    else if (section==3)
    {
        titleLabel.text = @"   Shared Friends";
    }
    else
    {
        titleLabel.text = @"   Shared Interest";
    }

    [sectionView addSubview:lineLabel];
    [sectionView addSubview:titleLabel];
    return sectionView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0;
 
        return 32;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
            return 330;
   
    }
    else if(indexPath.section==1)
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
            return paragraphRect.size.height+50;
        }
        else
        {
            return 40;
        }
        
       
    }
    
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
    else
    {
        return 110;
    }
    
    }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
@end
