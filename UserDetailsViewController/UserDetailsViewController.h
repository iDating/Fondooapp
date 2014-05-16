//
//  UserDetailsViewController.h
//  KeithDatingApp
//
//  Created by Mohit on 03/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomUIPageControl.h"
#import "WebServiceAPIController.h"
#import "UIButton+AFNetworking.h"
#import "ImagePreviewViewController.h"
@interface UserDetailsViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
@property (strong, nonatomic) IBOutlet UIScrollView *m_ImagescrollView;
@property(strong,nonatomic)IBOutlet UIScrollView *m_WrapperScrollView;
@property(nonatomic,strong)CustomUIPageControl *m_PageControl;
@property(weak,nonatomic)NSString *m_UserID;
@property (strong, nonatomic) IBOutlet UITableView *m_TablevIew;
@property(strong,nonatomic)NSMutableDictionary *m_UserDetails;
@property(strong,nonatomic)NSMutableDictionary *m_userProfile;
@property(nonatomic)BOOL isChecked;
@property(nonatomic)BOOL isBLocked;
@property(nonatomic)int m_ImageNumber;
@property(strong,nonatomic)NSMutableArray *m_ImagesArray;
@property(nonatomic)BOOL ischat;
@property(nonatomic,strong)NSDictionary *m_FriendsDictionary;
@property(nonatomic,strong)NSDictionary *m_InterestsDictionary;
@property(nonatomic,strong)NSMutableArray *m_PageName;
@property(nonatomic,strong)NSMutableArray *m_PageID;
@property(nonatomic,strong)UIActivityIndicatorView *m_FriendsIndicator;
@property(nonatomic,strong)UIActivityIndicatorView *m_InterestIndicator;
@end
