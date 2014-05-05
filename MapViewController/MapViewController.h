//
//  MapViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CheckInDetailsViewController.h"
#import "SharedClass.h"
@interface MapViewController : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate,UIAlertViewDelegate>
{

}
@property(strong,nonatomic)CLLocationManager *m_locationManager;
@property(nonatomic)CGFloat m_Latitude;
@property(nonatomic)CGFloat m_Longitude;
@property(retain,nonatomic)NSArray*m_PlacesDictionary;
@property(strong,nonatomic)NSMutableArray *m_FourSquareArray;
@property(strong,nonatomic)SharedClass *m_SharedInstance;
@property (weak, nonatomic) IBOutlet UIView *m_MapBackView;
@property (weak, nonatomic) IBOutlet GMSMapView *m_GoogleMapView;
@end
