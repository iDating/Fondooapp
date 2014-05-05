//
//  CheckInMapViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 13/02/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "WebServiceAPIController.h"
#import <MapKit/MapKit.h>
#import "SharedClass.h"
@interface CheckInMapViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *m_TableView;
@property(strong,nonatomic)NSMutableArray *m_PlacesDictionary;
@property(strong,nonatomic)CLLocationManager *m_locationManager;
@property(nonatomic)CGFloat m_Latitude;
@property(nonatomic)CGFloat m_Longitude;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
@property(strong,nonatomic)SharedClass *m_Shared;
@end
