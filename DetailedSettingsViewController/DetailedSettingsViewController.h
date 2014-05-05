//
//  DetailedSettingsViewController.h
//  KeithDatingApp
//
//  Created by Mohit on 28/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceAPIController.h"
#import "NMRangeSlider.h"
@interface DetailedSettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)int indexNumber;
@property (weak, nonatomic) IBOutlet UITableView *m_DetailedTableView;

@property(strong,nonatomic)NSMutableArray *m_MenuArray;
@property(nonatomic,assign)int selectedValue;
@property(strong,nonatomic)NSArray *m_MethodArray;
@property(nonatomic)BOOL isTapped;
@property(strong,nonatomic)NMRangeSlider *m_AgeSlider;
@property(strong,nonatomic)UILabel *m_MinLabel;
@property(strong,nonatomic)UILabel *m_MaxLabel;
-(void)editDetails;
@end
