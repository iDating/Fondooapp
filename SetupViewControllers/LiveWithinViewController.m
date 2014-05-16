//
//  LiveWithinViewController.m
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/10/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import "LiveWithinViewController.h"

#import "AgeGroupViewController.h"
#import "AFWebClient.h"

@interface LiveWithinViewController ()

@end

@implementation LiveWithinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"That live within";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    backItem.tintColor = kDarkGrayColor;
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
    nextItem.tintColor = kDarkGrayColor;
    self.navigationItem.rightBarButtonItem = nextItem;
    
    [self fromUserSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onNext
{
    AgeGroupViewController *ageGroupVC = [[AgeGroupViewController alloc] initWithNibName:@"AgeGroupViewController" bundle:nil];
    [self.navigationController pushViewController:ageGroupVC animated:YES];
}

- (IBAction) onChkButton:(id)sender
{
    int ix = 0;
    for (UIButton *btn in self.arrChkButton)
    {
        btn.selected = btn == sender;
        if (btn.selected)
            selectedIndex = ix;
        ix++;
    }
}

- (void) toUserSettings
{
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    [u setInteger:selectedIndex forKey:@"SetupWithInLive"];
    [u synchronize];
}

- (void) fromUserSettings
{
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    selectedIndex = [u integerForKey:@"SetupWithInLive"];
    UIButton *btn = [self.arrChkButton objectAtIndex:selectedIndex];
    btn.selected = YES;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self sendData];
}

- (void) sendData
{
    [self toUserSettings];
    
    int livein[] = {5, 10, 30, 50, 70, 90};
    NSString *stringData = [NSString stringWithFormat:@"%d", livein[selectedIndex]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:stringData, kRadiusParam, kEditRadiusValue, kMethodKey, nil];
    
    AFWebClient *afWebClient = [AFWebClient sharedInstance];
    [afWebClient requestFromSetupView:dict];
}

@end
