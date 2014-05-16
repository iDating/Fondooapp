//
//  AccountSettingsViewController.h
//  KeithDatingApp
//
//  Created by Mohit on 27/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "DetailedSettingsViewController.h"
#import "BioEditViewController.h"
#import "AddImagesViewController.h"
#import "FeedViewController.h"
#import "MessageViewController.h"
#import <MessageUI/MessageUI.h>
@interface AccountSettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *m_SettingsTableview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;

@property(strong,nonatomic)NSArray *m_SectionTwoArray;
@end
