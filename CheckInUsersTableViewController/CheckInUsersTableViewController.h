//
//  CheckInUsersTableViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 25/03/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "UserDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface CheckInUsersTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)NSMutableArray *m_PeopleArray;
@property(strong,nonatomic)NSString *checkInValue;
@property (weak, nonatomic) IBOutlet UITableView *m_CheckInUserTable;
@end
