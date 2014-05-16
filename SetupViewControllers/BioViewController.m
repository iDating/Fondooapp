//
//  BioViewController.m
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/10/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import "BioViewController.h"
#import "ProfilePhotoViewController.h"

#import "AFWebClient.h"

@interface BioViewController ()

@end

@implementation BioViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Bio";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    backItem.tintColor = kDarkGrayColor;
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
    nextItem.tintColor = kDarkGrayColor;
    self.navigationItem.rightBarButtonItem = nextItem;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
        self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self fromUserSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onNext
{
    ProfilePhotoViewController *profilePhotoVC = [[ProfilePhotoViewController alloc] initWithNibName:@"ProfilePhotoViewController" bundle:nil];
    [self.navigationController pushViewController:profilePhotoVC animated:YES];
}

- (void) toUserSettings
{
}

- (void) fromUserSettings
{
    NSString *valueStr=[[NSString stringWithFormat:@"%@",[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"] objectForKey:@"tagline"]] stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
    NSData *dataStr = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strBio = [[NSString alloc] initWithData:dataStr encoding:NSNonLossyASCIIStringEncoding];
    self.txtView.text = strBio;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self sendData];
}

- (void) sendData
{
    [self toUserSettings];
    
    NSData *data11 = [self.txtView.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    
    NSString *valueUnicode = [[NSString alloc] initWithData:data11 encoding:NSUTF8StringEncoding];
    NSString *valueStr=[valueUnicode stringByReplacingOccurrencesOfString:@"\\" withString:@"-"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:valueStr, kTagLineParam, kEditTagLineValue, kMethodKey, nil];
    AFWebClient *client = [AFWebClient sharedInstance];
    [client requestFromSetupView:dict];
}

@end
