//
//  IntroViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIPageControl.h"
#import "AppDelegate.h"
#import "WebServiceAPIController.h"
#import "BasicSetupViewController.h"
@interface IntroViewController : UIViewController<UIScrollViewDelegate>

@property(strong,nonatomic)NSString *m_FriendsString;
@property(strong,nonatomic)NSString *m_InterestString;
@property(strong,nonatomic)NSString *m_ALbumsString;
@property(strong,nonatomic)NSString *m_FriendsNameString;
@property(nonatomic,strong)NSString *m_InterestNameString;
@property(strong,nonatomic)NSMutableArray *m_ALbumArray;
@property(strong,nonatomic)NSMutableDictionary *m_CombinedArray;
@property(strong,nonatomic)NSMutableArray *m_friendsName;
@property(strong,nonatomic)NSMutableArray *m_InterestName;
@property(strong,nonatomic)NSMutableArray *m_AlbumName;
@property(strong,nonatomic)NSString *m_AlbumNameString;
@property (weak, nonatomic) IBOutlet UIImageView *m_BackgroundImage;

@end
