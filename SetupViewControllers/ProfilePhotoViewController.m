//
//  ProfilePhotoViewController.m
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/10/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import "ProfilePhotoViewController.h"

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "WebServiceAPIController.h"
#import "AlbumImagesViewController.h"
#import "AlbumsCollectionViewController.h"
#import "SharedClass.h"

@interface ProfilePhotoViewController ()
{
    SharedClass *data;
}
@end

@implementation ProfilePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Edit Photos";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    backItem.tintColor = kDarkGrayColor;
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
    nextItem.tintColor = kDarkGrayColor;
    self.navigationItem.rightBarButtonItem = nextItem;
    
    [self.activityIndicator startAnimating];
    isFirst = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTempImage:) name:@"setImage" object:nil];
    
    self.imagesDictionary=[NSMutableDictionary dictionaryWithDictionary:[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"img"]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if (!isFirst)
    {
        [self.activityIndicator startAnimating];
    }
    else
    {
        [self.activityIndicator stopAnimating];
        isFirst = NO;
    }
    [self performSelector:@selector(endEditingView) withObject:nil afterDelay:0.01];
}

-(void)endEditingView
{
    [self.view endEditing:YES];
}

- (void) viewDidLayoutSubviews
{
    if (self.fromSettings)
        self.navigationItem.rightBarButtonItem = nil;
    
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.container.frame;
    
    float mergeX = 10.0f;
    float mergeY = 10.0f;
    
    int ix = 0;
    int cols = 2;
    int rows = 3;

    float wd = (frame.size.width - mergeX * (cols + 1)) / cols;
    if (wd * rows + (rows + 1) * mergeY > frame.size.height)
    {
        mergeX = 25.0f;
        wd = (frame.size.width - mergeX * (cols + 1)) / cols;
    }
    CGSize szPhoto = CGSizeMake(wd, wd);

    for (UIButton *button in self.arrEditButton)
    {
        int row = ix / cols;
        int col = ix % cols;
        
        CGRect rect = CGRectMake(mergeX * (col + 1) + szPhoto.width * col, mergeY * (row + 1) + szPhoto.height * row, szPhoto.width, szPhoto.height);
        button.frame = rect;
        
        UIButton *delete_button = [self.arrDeleteButton objectAtIndex:ix];
        delete_button.center = CGPointMake(rect.origin.x + rect.size.width - delete_button.frame.size.width * 0.25f, rect.origin.y + delete_button.frame.size.height * 0.25f);
        
        UIImageView *imageView = [self.arrPhotoView objectAtIndex:ix];
        imageView.frame = rect;
        ix++;
    }
    
    [self initializeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTempImage:(NSNotification*)notify
{
    [self initializeView];
}

-(void)initializeView
{
    [self.activityIndicator startAnimating];
    self.imagesDictionary = [NSMutableDictionary dictionaryWithDictionary:[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"img"]];
    for (int i = 0; i < [self.imagesDictionary count]; i++) {
        UIButton *btn = [self.arrEditButton objectAtIndex:i];
        UIButton *deleteButton = [self.arrDeleteButton objectAtIndex:i];
        if ([[[self.imagesDictionary objectForKey:[NSString stringWithFormat:@"image%i",i]] objectForKey:@"imageset"] isEqualToString:@"yes"]) {
            [btn setBackgroundImage:[UIImage imageNamed:@"photo_frame"] forState:UIControlStateNormal];
            deleteButton.hidden = NO;
            UIImageView *img = [self.arrPhotoView objectAtIndex:i];
            [img setImage:nil];
            [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.imagesDictionary objectForKey:[NSString stringWithFormat:@"image%i",i]] objectForKey:@"url"]]] placeholderImage:[UIImage imageNamed:@"PrieviewImage"]];
        }
        else
        {
            if (i == self.imagesDictionary.count - 1)
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"photoadd_frame"] forState:UIControlStateNormal];
            }
            else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"photoplace_frame"] forState:UIControlStateNormal];
            }
            deleteButton.hidden = YES;
        }
    }
    [self.activityIndicator stopAnimating];
}

- (IBAction) changeImageClicked:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    int ix = [self.arrEditButton indexOfObject:btn];
    AlbumsCollectionViewController *albumVC;
    
    data=[SharedClass sharedInstance];
    [data setM_ImageNumber:[NSString stringWithFormat:@"%i", ix + 1]];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"] == 568) {
        albumVC=[[AlbumsCollectionViewController alloc] initWithNibName:@"AlbumsCollectionViewController" bundle:nil];
        
    }
    else
    {
        albumVC=[[AlbumsCollectionViewController alloc] initWithNibName:@"AlbumsCollectionViewController_iPhone4" bundle:nil];
    }
    
    UINavigationController *navBar=[[UINavigationController alloc] initWithRootViewController:albumVC];
    [self presentViewController:navBar animated:YES completion:nil];
    
}

- (IBAction) deleteImage:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    int ix = [self.arrDeleteButton indexOfObject:btn];
    
    [self.activityIndicator startAnimating];
    NSString *body=[NSString stringWithFormat:@"%@%@&img%i",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"], ix + 1];
    
    NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kDeleteImage AndRequestBody:body];
    if ([[dict objectForKey:@"return"] intValue]==1) {
        if ([dict objectForKey:@"totalImageset"] == [NSNull null]) {
            
            
            NSMutableDictionary *dictmain=[[NSMutableDictionary alloc] initWithDictionary:dict];
            [dictmain setObject:@"0" forKey:@"totalImageset"];
            [[NSUserDefaults standardUserDefaults] setObject:dictmain forKey:@"userinfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userinfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageEdit" object:nil];
        [self initializeView];
    }
    else{
        
    }
    [self.activityIndicator stopAnimating];
}

- (void) onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onNext
{
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate initializeTabBar];
}

@end
