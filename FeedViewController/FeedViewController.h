//
//  FeedViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableCell.h"
#import <MapKit/MapKit.h>
#import "ReplyViewController.h"
#import "CheckInDetailsViewController.h"

@interface FeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

- (void)Fetchlatlong;
- (void)setnavigationbar;
- (void)Addrefreshtable;
@property(nonatomic,strong)NSMutableArray *m_FeedsArray;
@property(strong,nonatomic)NSTimer *m_UpdateTimer;
@property(nonatomic)BOOL m_IsLiked;
@property(nonatomic,strong)NSMutableArray *m_HeightArray;
@property(strong,nonatomic)CLLocationManager *m_locationManager;
@property(nonatomic)CGFloat m_Latitude;
@property(nonatomic)CGFloat m_Longitude;
@property(strong,nonatomic)NSTimer *m_Timer;
@property(strong,nonatomic)NSMutableArray *m_StatusHeightArray;
//-(void)StartTimer;
@end
