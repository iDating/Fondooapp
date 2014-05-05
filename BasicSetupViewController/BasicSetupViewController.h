//
//  BasicSetupViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 18/02/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddImagesViewController.h"
#import "BioEditViewController.h"
#import "DetailedSettingsViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@interface BasicSetupViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *m_SetupScrollView;
@property (weak, nonatomic) IBOutlet NMRangeSlider *m_AgeSlider;
@property (weak, nonatomic) IBOutlet UILabel *m_HeadingLabel;
@property(strong,nonatomic)NSArray *m_HeadingArray;
@property(nonatomic)int pageNumber;
@property(strong,nonatomic)DetailedSettingsViewController *m_DetailedVC;
@property(strong,nonatomic) BioEditViewController *m_BioVC;
@property(strong,nonatomic)AddImagesViewController *m_AddImageVC;
- (IBAction)nextButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *m_PageControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
- (IBAction)pageControlClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *m_NextButton;
@property(strong,nonatomic)UILabel *headingLabel;
@end
