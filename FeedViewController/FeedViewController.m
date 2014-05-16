//
//  FeedViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "FeedViewController.h"
#import "PostStatusViewController.h"
#import "AppDelegate.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "SharedClass.h"
#import "EGORefreshTableHeaderView.h"
#import "UserDetailsViewController.h"
@interface FeedViewController ()<EGORefreshTableHeaderDelegate>
{
    SharedClass *shared;
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (strong, nonatomic) UIView *m_ActivityView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
@property (strong, nonatomic) UIActivityIndicatorView *m_TableFooterActivity;
@property (strong, nonatomic) IBOutlet UITableView *m_FeedTableview;
@property(nonatomic)BOOL isLoadData;
@property(nonatomic)BOOL IsPageNumberSet;
@property(nonatomic)int pageNumber;
@end

@implementation FeedViewController
@synthesize m_UpdateTimer;
@synthesize m_Timer;
@synthesize m_HeightArray;
@synthesize m_StatusHeightArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)Fetchlatlong
{
    self.m_locationManager = [[CLLocationManager alloc] init];
    self.m_locationManager.delegate = self;
    self.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.m_locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.m_locationManager startUpdatingLocation];
    CLLocation *location = [self.m_locationManager location];
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    self.m_Latitude=coordinate.latitude;
    self.m_Longitude=coordinate.longitude;
    shared=[SharedClass sharedInstance];
    [shared setM_Lattitude:[NSString stringWithFormat:@"%f",self.m_Latitude]];
    [shared setM_Longitude:[NSString stringWithFormat:@"%f",self.m_Longitude]];
}
- (void)setnavigationbar
{
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kRedColor,NSForegroundColorAttributeName,nil]];
    UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 5, 25, 25)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"Add_Button"] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
     self.navigationItem.rightBarButtonItem=rightBar;
   }
- (void)Addrefreshtable
{
    if (_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.m_FeedTableview.bounds.size.height, self.view.frame.size.width, self.m_FeedTableview.bounds.size.height)];
        view.delegate = self;
        [self.m_FeedTableview addSubview:view];
        _refreshHeaderView = view;
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    if([CLLocationManager locationServicesEnabled]){

        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
           UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
        }
        else{
            [self startFetchingFeeds];
        }
    }
}
-(void)startFetchingFeeds
{
    self.navigationItem.title=@"Feed";
    [self setnavigationbar];
    [self Addrefreshtable];
       [self Fetchlatlong];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageCount" object:nil];
    _IsPageNumberSet=NO;
    self.isLoadData=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchFeedsDetails) name:@"refresh" object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.m_ActivityIndicator startAnimating];
        [self fetchFeedsDetails];
    });
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     self.navigationItem.title=@"Feed";
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
    self.navigationItem.title=@"";
    postVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:postVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.m_FeedsArray count]!=0) {
        return self.m_FeedsArray.count;
    }
    else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
  __strong CustomTableCell *cell=(CustomTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.m_UserProfileImage.imageView.layer.cornerRadius=3.0f;
        cell.m_UserProfileImage.imageView.clipsToBounds=YES;
        [cell.m_UserProfileImage.imageView.layer setMasksToBounds:YES];
        cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 1.5);
        cell.layer.shadowOpacity = 1.5;
        cell.layer.shadowRadius = 1.5;
        cell.clipsToBounds =YES;

           }
    if ([self.m_FeedsArray count]>0) {
        CGRect paragraphRect;
        
         NSString *text=[NSString stringWithFormat:@"%@",[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"post_message"]];
        
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                           attributes:@
                                             {
                                             NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0f]
                                             }];
        paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(281.0f, 1000)
                                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                    context:nil];
        
              // [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.m_TimeLabel.text=[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"posted_on"];
        [cell.m_LocationButton setTitle:[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"address"] forState:UIControlStateNormal];
        [cell.m_UserProfileImage setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"userimage"]] placeholderImage:[UIImage imageNamed:@"ProfileImageFrame"]];
        [cell.m_UserProfileImage addTarget:self action:@selector(profileClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.m_UserProfileImage setTag:indexPath.row];
        cell.m_UserProfileImage.imageView.contentMode=UIViewContentModeScaleAspectFill;
     
        NSString *valueStr=[text stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
        NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
        if (valueEmoj1 == nil || valueEmoj1 == (id)[NSNull null]) {
            cell.m_StatusLabel.text=[NSString stringWithFormat:@"%@",text];
        } else {
            cell.m_StatusLabel.text=[NSString stringWithFormat:@"%@",valueEmoj1];
        }
        cell.m_NameLabel.text=[NSString stringWithFormat:@"%@", [[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"first_name"]];
        
       
        [cell.m_StatusLabel setFrame:CGRectMake(7, 66, 281, paragraphRect.size.height)];
         [cell.m_LocationButton addTarget:self action:@selector(LocationClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"Hieght : %f",paragraphRect.size.height);
        [cell.m_LocationButton setTag:indexPath.row];
           [cell.m_DisplayView    setFrame:CGRectMake(0, paragraphRect.size.height+70, 295, 137)];
 if ([[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"imageset"] isEqualToString:@"no"] && [[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"is_checkIn"] isEqualToString:@"no"] ) {
     [cell.m_DisplayView setHidden:YES];
     [cell.m_LocationView  setFrame:CGRectMake(3,70+paragraphRect.size.height , 275, 29)];
     [cell.m_view setFrame:CGRectMake(13, 7, 295, 190+paragraphRect.size.height)];
   
     
 }
        else if ([[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"imageset"] isEqualToString:@"no"] && [[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"is_checkIn"] isEqualToString:@"yes"] )
        {
     [cell.m_DisplayView setHidden:NO];
           
            [cell.m_indicator startAnimating];
            NSURLRequest *url_request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"image"]]]];
            __block UIImageView * imageView = cell.m_PostImageView;
            [cell.m_PostImageView setImageWithURLRequest:url_request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                if (image) {
                    [cell.m_indicator stopAnimating];
                    cell.m_indicator.hidden=YES;
                    [imageView setImage:image];
                }
            } failure:nil];
            
            [cell.m_DisplayView    setFrame:CGRectMake(0, paragraphRect.size.height+70, 295, 137)];
            [cell.m_LocationView  setFrame:CGRectMake(3,205+paragraphRect.size.height , 275, 29)];
            [cell.m_view         setFrame:CGRectMake(13, 7, 295, 240+paragraphRect.size.height+240)];
           
            }
 else {
    [cell.m_DisplayView setHidden:NO];
     [cell.m_indicator startAnimating];
     NSURLRequest *url_request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.m_FeedsArray objectAtIndex:indexPath.row]]]];
     __block UIImageView * imageView = cell.m_PostImageView;
     [cell.m_PostImageView setImageWithURLRequest:url_request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         if (image) {
             [cell.m_indicator stopAnimating];
             cell.m_indicator.hidden=YES;
             [imageView setImage:image];
         }
     } failure:nil];
          [cell.m_DisplayView    setFrame:CGRectMake(0, paragraphRect.size.height+70, 295, 137)];
              [cell.m_view         setFrame:CGRectMake(13, 7, 295, 240+paragraphRect.size.height)];
            [cell.m_LocationView  setFrame:CGRectMake(3,205+paragraphRect.size.height , 275, 29)];


//     if ([[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"imageset"] isEqualToString:@"yes"] && [[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"is_checkIn"] isEqualToString:@"no"] ) {
//
//            [cell.m_LocationView  setFrame:CGRectMake(3,208+paragraphRect.size.height+250 , 275, 29)];
//        // http://www.fondooapp.co/Webservices/images/1514357.jpg
//     }
//     else
//     {
//         
//            [cell.m_LocationView  setFrame:CGRectMake(3,208+paragraphRect.size.height+250 , 275, 29)];
//         
//     }
 }
}
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      CGFloat height=0;
    /*
    if (self.m_HeightArray.count>0) {
          if (self.m_HeightArray.count>indexPath.row) {
        height=[[self.m_HeightArray objectAtIndex:indexPath.row] floatValue];
          }
    }
     */
    CGRect paragraphRect;
    NSString *text=[NSString stringWithFormat:@"%@",[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"post_message"]];
    
    NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                       attributes:@
                                         {
                                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0f]
                                         }];
    paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(281.0f, 1000)
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                context:nil];
    
    
    if ([[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"imageset"] isEqualToString:@"no"] && [[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"is_checkIn"] isEqualToString:@"no"] ) {
        height=paragraphRect.size.height+110;
    }
    else if ([[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"imageset"] isEqualToString:@"no"] && [[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"is_checkIn"] isEqualToString:@"yes"] )
    {
        height=paragraphRect.size.height+240;
    }
    else {
        height=paragraphRect.size.height+240;
    }
    
    
    
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.m_FeedsArray.count>0) {
        
        
        CGRect paragraphRect;
        NSString *text=[NSString stringWithFormat:@"%@",[[self.m_FeedsArray objectAtIndex:indexPath.row] objectForKey:@"post_message"]];
        
        NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:text
                                                                           attributes:@
                                             {
                                             NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0f]
                                             }];
        paragraphRect =[attributedText boundingRectWithSize:CGSizeMake(281.0f, 1000)
                                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                    context:nil];
        
    ReplyViewController *ReplyVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        ReplyVC=[[ReplyViewController alloc] initWithNibName:@"ReplyViewController" bundle:nil];
    }
    else
    {
        ReplyVC=[[ReplyViewController alloc] initWithNibName:@"ReplyViewController_iPhone4" bundle:nil];
    }
    ReplyVC.navigationItem.title=@"";
    self.navigationItem.title=@"";
    ReplyVC.hidesBottomBarWhenPushed=YES;
    if (self.m_FeedsArray.count>indexPath.row) {
        ReplyVC.m_PostDictionary=[[NSMutableDictionary alloc] initWithDictionary:[self.m_FeedsArray objectAtIndex:indexPath.row]];
       
            ReplyVC.m_viewHeight=paragraphRect.size.height;
     
        [self.navigationController pushViewController:ReplyVC animated:YES];
    }
    }
}

-(void)fetchFeedsDetails{
    NSString *PageString;
    NSString *timeZone;
    if (_IsPageNumberSet==YES) {
        PageString=[NSString stringWithFormat:@"%i",_pageNumber];
    }
    else
    {
       PageString=@"1";
    }
    timeZone=[[NSTimeZone localTimeZone] name];
    NSString *body=[NSString stringWithFormat:@"%@%@%@%f%@%f%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kLatitudeString,self.m_Latitude,kLongitudeString,self.m_Longitude,kPageString,PageString,kTimeZoneString,timeZone];
    
    NSLog(@"Feed Body is %@",body);
    
  __strong  NSDictionary *ResultDict=[WebServiceAPIController executeAPIRequestForMethod:kGetPostMessages AndRequestBody:body];

    _pageNumber=[[ResultDict objectForKey:@"nextpage"] intValue];
    if ([[ResultDict objectForKey:@"return"] intValue]==1) {
        _IsPageNumberSet=YES;
        
        self.m_FeedsArray=nil;
    self.m_FeedsArray=[[NSMutableArray alloc] initWithArray:[ResultDict objectForKey:@"data"]];
        dispatch_async(dispatch_get_main_queue(), ^{
                  
            self.isLoadData=NO;
            [self.m_ActivityIndicator stopAnimating];
            //reload you tableview here
            [self.m_TableFooterActivity stopAnimating];
            [self.m_FeedTableview reloadData];
        });
    }
    else
        
    {
        
              [self.m_TableFooterActivity  stopAnimating];
              [self.m_ActivityIndicator    stopAnimating];
            _IsPageNumberSet=NO;
         }
    
}

-(void)refresh:(UIRefreshControl *)refreshControl {
    _IsPageNumberSet=NO;
    [self performSelector:@selector(fetchFeedsDetails) withObject:nil afterDelay:0.1];
    [refreshControl endRefreshing];
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
#if TARGET_IPHONE_SIMULATOR
    self.m_Latitude=30.7800;
    self.m_Longitude=76.6900;
    [self.m_locationManager stopUpdatingLocation];
#else
    self.m_Latitude  = newLocation.coordinate.latitude;
    self.m_Longitude = newLocation.coordinate.longitude;
#endif
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    //for Nav/TabBar Scroll begin
    CGFloat currentOffset0 = scrollView.contentOffset.y;
    CGFloat differenceFromLast = lastContentOffset - currentOffset0;
    differenceFromLast = currentOffset0;
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if(scrollView.contentSize.height>550)
    {
        if(currentOffset>maximumOffset-170)
            
        {
            float height=[UIScreen mainScreen].bounds.size.height;
            
            
            
            int tableViewOffset = 20;
            
            int labelOffset = 55;
            
            int activityOffset = 45;
            // calculate offsets
            if(height>470)
                
            {
                
                tableViewOffset = 50;
                
                labelOffset = 75;
                
                activityOffset = 65;
                
            }
            // Footer View
            [self.m_ActivityView removeFromSuperview];
            [self.m_ActivityIndicator removeFromSuperview];
            self.m_ActivityView=[[UIView alloc]initWithFrame:CGRectMake(0, tableViewOffset, self.m_FeedTableview.frame.size.width, 67)];
            	self.m_ActivityView.backgroundColor = [UIColor colorWithRed:206.0/255.0 green:65.0/255.0 blue:67.0/255.0 alpha:1.0];
                  [self.m_ActivityView setBackgroundColor:[UIColor clearColor]];
            
            [self.m_ActivityView setAlpha:0.8f];
            self.m_TableFooterActivity=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.m_ActivityView.center.x-15, self.m_ActivityView.center.y-activityOffset+10, 37, 37)];
            [self.m_TableFooterActivity setTintColor:[UIColor colorWithRed:229/255.0 green:55/255.0 blue:65/255.0 alpha:1.0]];
            [self.m_TableFooterActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
             [self.m_TableFooterActivity setColor:[UIColor colorWithRed:229/255.0 green:55/255.0 blue:65/255.0 alpha:1.0]];
            [self.m_TableFooterActivity hidesWhenStopped];
            [self.m_ActivityView addSubview:self.m_TableFooterActivity];
            [self.view addSubview:self.m_ActivityView];
             [self.m_FeedTableview setTableFooterView:self.m_ActivityView];
            
            if (maximumOffset - currentOffset <= -40) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        [self.m_TableFooterActivity startAnimating];
                        [self fetchFeedsDetails];
                });
                
             }
        }
        else
        {
            [self.m_ActivityView removeFromSuperview];
        }
    }
}
#pragma Pull to Refresh

//Pull to refresh begin
- (void)reloadTableView
{
    [self.m_FeedTableview reloadData];
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
    //[self performSelectorInBackground:@selector(fetchFeedsDetails) withObject:nil];
    [self fetchFeedsDetails];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.m_FeedTableview];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
      //Pull to refresh begin
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
   }

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
    _IsPageNumberSet=NO;
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

-(void)profileClicked:(UIButton*)sender
{
    if (self.m_FeedsArray.count>0) {
        
    if([[[self.m_FeedsArray objectAtIndex:sender.tag] objectForKey:@"is_me"] isEqualToString:@"yes"])
    {
        [self.tabBarController setSelectedIndex:3];
    }
    else
    {
    UserDetailsViewController *userDetailsVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        userDetailsVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
    }
    else
    {
        userDetailsVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController_iPhone4" bundle:nil];
    }
       
        userDetailsVC.hidesBottomBarWhenPushed=YES;
        self.navigationItem.title=@"";
        userDetailsVC.navigationItem.title=@"";
    userDetailsVC.m_userProfile=[self.m_FeedsArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:userDetailsVC animated:YES];
    }
    
    }
}
-(void)LocationClicked :(UIButton*)sender

{
    if ([[[self.m_FeedsArray objectAtIndex:sender.tag]objectForKey:@"is_checkIn"] isEqualToString:@"yes"]) {
     
    CheckInDetailsViewController *checkInVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        checkInVC=[[CheckInDetailsViewController alloc] initWithNibName:@"CheckInDetailsViewController" bundle:nil];
    }
    else
    {
        checkInVC=[[CheckInDetailsViewController alloc] initWithNibName:@"CheckInDetailsViewController_iPhone4" bundle:nil];
    }
    NSLog(@"Value : %@",[self.m_FeedsArray objectAtIndex:sender.tag]);
    checkInVC.m_CheckInDetailDictionary=(NSMutableArray*)[[self.m_FeedsArray objectAtIndex:sender.tag]objectForKey:@"data"];
    checkInVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:checkInVC animated:YES];
    }
}

@end
