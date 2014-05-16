//
//  ILikeViewController.m
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/10/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import "ILikeViewController.h"

#import "CommonClass.h"

#import "LiveWithinViewController.h"
#import "AFWebClient.h"

@interface ILikeViewController ()

@end

@implementation ILikeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"I like...";
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
    nextItem.tintColor = kDarkGrayColor;
    self.navigationItem.rightBarButtonItem = nextItem;
    
    [self fromUserSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction) onLikeMenOrWomen:(UIButton *)chkButton
{
    UIButton *otherButton = chkButton == self.chkLikeMen ? self.chkLikeWomen : self.chkLikeMen;
    chkButton.selected = YES;
    otherButton.selected = NO;
}

- (void) toUserSettings
{
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    [u setInteger:self.chkLikeMen ? 1 : 0 forKey:@"SetupLike"];
    [u synchronize];
}

- (void) fromUserSettings
{
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    int checked = [u integerForKey:@"SetupLike"];
    self.chkLikeMen.selected = checked;
    self.chkLikeWomen.selected = !checked;
}

- (void) onNext
{
    LiveWithinViewController *liveWithinVC = [[LiveWithinViewController alloc] initWithNibName:@"LiveWithinViewController" bundle:nil];
    [self.navigationController pushViewController:liveWithinVC animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self sendData];
}

- (void) sendData
{
    [self toUserSettings];
    
    NSString *stringPerson = self.chkLikeMen.selected ? @"Man" : @"WoMan";
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:stringPerson, kGenderParam, kEditGenderValue, kMethodKey, nil];
    
    AFWebClient *afWebClient = [AFWebClient sharedInstance];
    [afWebClient requestFromSetupView:dict];
}


@end
