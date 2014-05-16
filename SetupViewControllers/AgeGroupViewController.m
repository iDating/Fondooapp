//
//  AgeGroupViewController.m
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/10/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import "AgeGroupViewController.h"

#import "BioViewController.h"
#import "AFWebClient.h"

@interface AgeGroupViewController ()

@end

@implementation AgeGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Age Range";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    backItem.tintColor = kDarkGrayColor;
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
    nextItem.tintColor = kDarkGrayColor;
    self.navigationItem.rightBarButtonItem = nextItem;
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.ageSlider=[[RangeSlider alloc] initWithFrame:self.container.bounds];
    [self.ageSlider addTarget:self action:@selector(labelSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self configureMetalSlider];
    
    [self fromUserSettings];
    
    [self.container addSubview:self.ageSlider];
    [self updateSliderLabels];
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
    BioViewController *ageGroupVC = [[BioViewController alloc] initWithNibName:@"BioViewController" bundle:nil];
    [self.navigationController pushViewController:ageGroupVC animated:YES];
}


#pragma mark -
#pragma mark - Metal Theme Slider

- (void) configureMetalSlider
{
    self.ageSlider.minimumValue = 18;
    self.ageSlider.maximumValue = 75;
    self.ageSlider.minimumRange = 1;
}

- (void) updateSliderLabels
{
    CGPoint lowerCenter = self.minLabel.center;
    lowerCenter.x = (self.ageSlider.minPos.x + self.ageSlider.frame.origin.x);
    self.minLabel.center = lowerCenter;
    
    CGPoint upperCenter = self.maxLabel.center;
    upperCenter.x = (self.ageSlider.maxPos.x + self.ageSlider.frame.origin.x);
    self.maxLabel.center = upperCenter;
    
    self.minLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageSlider.selectedMinimumValue];
    self.maxLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageSlider.selectedMaximumValue];
}

- (void) labelSliderChanged:(RangeSlider*)sender
{
    [self updateSliderLabels];
}

- (void) toUserSettings
{
}

- (void) fromUserSettings
{
    NSString *ageString=[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"age"];
    NSArray *ageArray=[ageString componentsSeparatedByString:@"-"];
    self.ageSlider.selectedMinimumValue=[[ageArray objectAtIndex:0] floatValue];
    self.ageSlider.selectedMaximumValue=[[ageArray objectAtIndex:1] floatValue];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self sendData];
}

- (void) sendData
{
    [self toUserSettings];
    
    NSString *ageString=[[NSString stringWithFormat:@"%@-",self.minLabel.text ] stringByAppendingString:self.maxLabel.text];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:ageString, kAgeParam, kEditAgeValue, kMethodKey, nil];
    AFWebClient *webClient = [AFWebClient sharedInstance];
    [webClient requestFromSetupView:dict];
}

@end
