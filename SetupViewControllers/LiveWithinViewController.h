//
//  LiveWithinViewController.h
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/10/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveWithinViewController : UIViewController
{
    int selectedIndex;
}

@property (nonatomic, retain) IBOutletCollection(UIButton) NSMutableArray *arrChkButton;

@end
