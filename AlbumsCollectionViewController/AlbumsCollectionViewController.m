//
//  AlbumsCollectionViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 13/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "AlbumsCollectionViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIImageView+WebCache.h"
#import "AlbumImagesViewController.h"
static NSString * const PhotoCellIdentifier = @"PhotoCell";
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface AlbumsCollectionViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *m_AlbumCollection;
@end

@implementation AlbumsCollectionViewController
@synthesize m_ImageNumber;
@synthesize m_AlbumsArray;
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
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header-bg"] forBarMetrics:UIBarMetricsDefault];
    m_AlbumsArray=[[NSMutableArray alloc] init];
    self.m_ActivityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    [self.m_ActivityIndicator setTintColor:kRedColor];
    [self.m_ActivityIndicator setColor:kRedColor];
    self.m_ActivityIndicator.hidesWhenStopped=YES;
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.m_ActivityIndicator];
    self.navigationItem.leftBarButtonItem=leftButtonItem;
  
    [self.m_ActivityIndicator startAnimating];
    [self.navigationController.navigationBar setHidden:NO];
    self.m_FacebookAlbumCover=[[NSMutableArray alloc] init];
    _m_FacebookAlbumIDs=[[NSMutableArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"album"]];
    _m_facebookAlbumArray=[[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@""
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:nil action:nil];
    self.navigationItem.title=@"Albums";
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Close" forState:UIControlStateNormal];
    [btn setTitleColor:kGrayColor forState:UIControlStateNormal];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=rightButton;
    [self.m_AlbumCollection registerClass:[CollectionViewCell class]
                   forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self getFacebookImages];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([self.m_AlbumsArray count]>0) {
        return [self.m_AlbumsArray count];
    }
    
    else
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return 1;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CollectionViewCell *photoCell =
    (CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                                                   forIndexPath:indexPath];
    
    if (photoCell==nil) {
        
        CALayer *cellImageLayer = photoCell.m_ImageView.layer;
        [cellImageLayer setCornerRadius:15.0f];
        [cellImageLayer setMasksToBounds:YES];
     
    }
        if ([self.m_AlbumsArray count]>0) {
                [photoCell.m_ImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=album&access_token=%@",[[self.m_AlbumsArray objectAtIndex:indexPath.section] objectForKey:@"cover_photo"],[[NSUserDefaults standardUserDefaults] objectForKey:@"fbtoken"]]]];
        photoCell.m_TitleLabel.text=[[m_AlbumsArray objectAtIndex:indexPath.section] objectForKey:@"name"];
    }
    return photoCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    AlbumImagesViewController *albumVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
albumVC=[[AlbumImagesViewController alloc] initWithNibName:@"AlbumImagesViewController" bundle:nil];
    }
    else
    {
     albumVC=[[AlbumImagesViewController alloc] initWithNibName:@"AlbumImagesViewController_iPhone4" bundle:nil];   
    }
    albumVC.m_AlbumDetail=[[self.m_AlbumsArray objectAtIndex:indexPath.section] objectForKey:@"id"];
    [self.navigationController pushViewController:albumVC animated:YES];
}

-(void)getFacebookImages
{
    if ([[FBSession activeSession]isOpen]) {
       // AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        
        
        
        //**************************** requestion for facebook album ***********************
        [FBSession openActiveSessionWithReadPermissions:@[@"user_photos"] allowLoginUI:YES completionHandler:^(FBSession *session , FBSessionState state, NSError *error)
         {
             if ((session.accessTokenData != nil || session.accessTokenData != (id)[NSNull null])) {
                 [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",session.accessTokenData.accessToken ] forKey:@"fbtoken"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
            
             [FBRequestConnection
              startWithGraphPath:@"me/albums"
              parameters:nil
              HTTPMethod:@"GET"
              completionHandler:^(FBRequestConnection *connection,
                                  id result,
                                  NSError *error) {
                  if (error) {
                  } else {
                        _m_FacebookAlbumIDs=nil;
                      m_AlbumsArray=[result objectForKey:@"data"];
                      [self.m_AlbumCollection reloadData];
                      [self.m_ActivityIndicator stopAnimating];
                  }
                  
              }];
                       
         }];
        
        
    }
    else
    {
        [self openSession];
    }
    
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self getFacebookImages];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.description
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)openSession
{
    
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"user_photos"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state,NSError *error)
     {
         [self sessionStateChanged:session
                             state:state
                             error:error];
     }];
}
-(void)doneClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
