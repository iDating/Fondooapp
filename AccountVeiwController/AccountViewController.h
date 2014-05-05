//
//  AccountViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "CommonClass.h"
@interface AccountViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate> {
}
@property (strong, nonatomic) IBOutlet UIScrollView *m_ImagescrollView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
@property(strong,nonatomic)IBOutlet UIScrollView *m_WrapperScrollView;
@property(nonatomic,strong)NSMutableDictionary *m_UserDetails;
@property(strong,nonatomic)UILabel *m_TitleLabel;
-(void)editImagesClicked;
@end
