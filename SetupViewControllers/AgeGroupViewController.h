//
//  AgeGroupViewController.h
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/10/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RangeSlider.h"

@interface AgeGroupViewController : UIViewController

@property   (strong, nonatomic)     RangeSlider *             ageSlider;
@property   (retain, nonatomic)     IBOutlet    UILabel *       minLabel;
@property   (retain, nonatomic)     IBOutlet    UILabel *       maxLabel;

@property   (retain, nonatomic)     IBOutlet    UIView *        container;

@end
