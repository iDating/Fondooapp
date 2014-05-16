//
//  CheckInDetailsViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 05/03/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "ImagePreviewViewController.h"
#import "SharedClass.h"
#import "CheckInUsersTableViewController.h"
#import <GoogleMaps/GoogleMaps.h>
@interface CheckInDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,GMSMapViewDelegate>

@property(strong,nonatomic)id m_CheckInDetailDictionary;
@property (weak, nonatomic) IBOutlet UIScrollView *m_ImageScrollview;
@property (strong, nonatomic) IBOutlet UIScrollView *m_WrapperScrollview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *m_TablewvIew;
@property(strong,nonatomic)NSMutableArray *m_FourSquareDictionary;
@property(nonatomic)int m_ImageNumber;
@property(nonatomic,strong)NSMutableDictionary *m_PeopleDictionary;
@property(nonatomic,strong)SharedClass *m_Shared;
@property(nonatomic,strong)GMSMapView *m_Mapview;
@end
