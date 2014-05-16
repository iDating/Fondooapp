//
//  MapViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "MapViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AsyncImageView.h"
@interface MapViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;

@end

@implementation MapViewController
@synthesize m_PlacesDictionary;
@synthesize m_GoogleMapView;
@synthesize m_SharedInstance;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.m_ActivityIndicator];
    m_SharedInstance=[SharedClass sharedInstance];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
      self.navigationItem.title=@"";
    [self.navigationController.navigationBar setHidden:YES];
    [self.m_ActivityIndicator startAnimating];
    self.m_locationManager = [[CLLocationManager alloc] init];
    self.m_locationManager.delegate = self;
    self.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.m_locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.m_locationManager startUpdatingLocation];
    CLLocation *location = [self.m_locationManager location];
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    self.m_Longitude=coordinate.longitude;
    self.m_Latitude=coordinate.latitude;
    [m_SharedInstance setM_Lattitude:[NSString stringWithFormat:@"%f",coordinate.latitude]];
    [m_SharedInstance setM_Longitude:[NSString stringWithFormat:@"%f",coordinate.longitude]];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.m_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.m_Latitude  = newLocation.coordinate.latitude;
    self.m_Longitude = newLocation.coordinate.longitude;
    [m_SharedInstance setM_Lattitude:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude]];
    [m_SharedInstance setM_Longitude:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude]];
    [self performSelectorInBackground:@selector(fetchLocationUsers) withObject:nil];
    }


-(void)nearPlacesSearch
{
    int miles=([[NSString stringWithFormat:@"%@", [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"radius"]] floatValue]*1609.34);

      NSString* requestString = [[NSString alloc] initWithFormat:@"https://api.foursquare.com/v2/venues/search?&ll=%f,%f&client_id=%@&client_secret=%@&radius=%i&v=%@",self.m_Latitude,self.m_Longitude,kFourSquareClientID,kFourSquareClientSecret,miles,[self getCurrentDate]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data.length>0) {
                                   NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   if ([[[dictionary objectForKey:@"meta"] objectForKey:@"errorType"] isEqualToString:@"invalid_auth"]) {
                                       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please first login with FOURSQUARE" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                       [alert show];
                                   }else
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                            [self plotGoogleData:data];
                                       });
                                       
                                   }
  
                               }
                               else
                               {
                                   UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                   [alert show];
                               }
                               
                               
                               [self.m_ActivityIndicator stopAnimating];

                               
                           }];
    
}

-(NSString*)getCurrentDate
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSString *currentDate;
    if([components day] < 10)
    {
        if([components month] < 10)
            currentDate = [NSString stringWithFormat:@"%d0%d0%d",[components year],[components month],[components day]];
        else
            currentDate = [NSString stringWithFormat:@"%d%d0%d",[components year],[components month],[components day]];
    }
    else if([components month] < 10)
    {
        if([components day] < 10)
            currentDate = [NSString stringWithFormat:@"%d0%d0%d",[components year],[components month],[components day]];
        else
            currentDate = [NSString stringWithFormat:@"%d0%d%d",[components year],[components month],[components day]];
    }
    else {
        currentDate = [NSString stringWithFormat:@"%d%d%d",[components year],[components month],[components day]];
    }
    return currentDate;
}




- (void)fetchPlaces:(id)sender {
    [self performSelector:@selector(nearPlacesSearch) withObject:nil afterDelay:0.1f];
    
}

#pragma Google Methods
-(void)initGoogleMap
{
    
       GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.m_Latitude
                                                            longitude:self.m_Longitude
                                                                 zoom:14];
    m_GoogleMapView.camera=camera;
    m_GoogleMapView.frame=self.m_GoogleMapView.frame;
    m_GoogleMapView.delegate=self;
    m_GoogleMapView.myLocationEnabled = NO;
    [self displayPins];
  
   }
-(void)plotGoogleData:(NSData*)data
{/* for (id<MKAnnotation> annotation in self.m_MapView.annotations) {
    [self.m_MapView removeAnnotation:annotation];
}
    */
   // [m_GoogleMapView clear];
   
    [m_GoogleMapView clear];
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    NSArray *reaponseData = [[root objectForKey:@"response"] objectForKey:@"venues"];
    m_PlacesDictionary=[[NSArray alloc] initWithArray:reaponseData];
    for (int i=0; i<[reaponseData count]; i++) {
        NSNumber * latitude = [[[reaponseData objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"];
        NSNumber * longitude = [[[reaponseData objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"];
        NSString * locationName =[[reaponseData objectAtIndex:i] objectForKey:@"name"];
        //[[[reaponseData objectAtIndex:i] objectForKey:@"location"] objectForKey:@"city"];
        NSString * address;
        if ([[[reaponseData objectAtIndex:i] objectForKey:@"categories"] count]>0) {
            address=[[[[reaponseData objectAtIndex:i] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"shortName"];
                   }
        else
        {
            address=@"Unknown";
            
        }
        GMSMarker *annotation;

            if (self.m_FourSquareArray.count!=0) {
                for (int j=0; j<self.m_FourSquareArray.count; j++) {
                    NSLog(@"value :%@ == %@",[[reaponseData objectAtIndex:i]  objectForKey:@"id"],[[self.m_FourSquareArray objectAtIndex:j] objectForKey:@"foursquareid"]);
                    if ([[[reaponseData objectAtIndex:i]  objectForKey:@"id"] isEqualToString:[[self.m_FourSquareArray objectAtIndex:j] objectForKey:@"foursquareid"]]) {
                        if (j==0) {
                            [self.m_GoogleMapView animateToLocation:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)];
                        }
                        annotation=[[GMSMarker alloc] init];
                        CLLocationCoordinate2D coordinate;
                        coordinate.latitude = latitude.doubleValue;
                        coordinate.longitude = longitude.doubleValue;
                        annotation=[GMSMarker markerWithPosition:coordinate];
                        annotation.userData=@[[reaponseData objectAtIndex:i]];
                        annotation.title=locationName;
                        annotation.snippet=address;
                        annotation.appearAnimation=kGMSMarkerAnimationPop;
                        annotation.icon=[UIImage imageNamed:@"Red_White_Icon"];
                        annotation.map=m_GoogleMapView;
                       // j=(int)self.m_FourSquareArray.count;
                    }
                    
                }
            
        }
        
 
    }
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.m_Latitude, self
                                                 .m_Longitude);
    marker.title = @"Current Location";
    marker.icon=[UIImage imageNamed:@"Map_CurrentLocation"];
    marker.tappable=NO;
    marker.map = m_GoogleMapView;
    [self.m_locationManager stopUpdatingLocation];
    }

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
  
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    
       return NO;
   
}

- (UIView *) mapView:(GMSMapView *)  mapView markerInfoWindow: (GMSMarker *) marker
{
    UIView *markerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 65)];
    NSMutableArray *PlacesDict=(NSMutableArray*)marker.userData;;
    NSLog(@"places Dict : %@",PlacesDict);
    [markerView setBackgroundColor:[UIColor clearColor]];
    UIImageView *bacImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white-comment-bg"]];
    [bacImage setFrame:CGRectMake(0, 0, 200, 65)];
     [markerView addSubview:bacImage];
    UIImageView *imageview;
     imageview =[[UIImageView alloc] init];
        [imageview setBackgroundColor:[UIColor lightGrayColor]];
         [imageview setFrame:CGRectMake(7, 7, 45, 45)];
    imageview.image=[UIImage imageNamed:@"FoursquareLogo"];
    [imageview setImageWithURL:[NSURL URLWithString:[[PlacesDict objectAtIndex:0] objectForKey:@"image"]]];
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 8, 130, 18)];
        [nameLabel setNumberOfLines:0];
      nameLabel.adjustsFontSizeToFitWidth=YES;
    
    nameLabel.text=marker.title;
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica-Medium" size:15.0f]];
    UILabel *AddressLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 23, 130, 18)];
    [AddressLabel setNumberOfLines:0];
    [AddressLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]];
      AddressLabel.adjustsFontSizeToFitWidth=YES;
    [AddressLabel setTextColor:[UIColor lightGrayColor]];
    AddressLabel.text=marker.snippet;
  
   
          UIButton *taggedButton=[[UIButton alloc] initWithFrame:CGRectMake(60, 36, 130, 18)];
        [taggedButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
    [taggedButton setTitleColor:kSeaGreenColor forState:UIControlStateNormal];
    
                if ([[[PlacesDict objectAtIndex:0] objectForKey:@"numberofUsers"] isEqualToString:@"0"]) {
                        [taggedButton setTitle:@"" forState:UIControlStateNormal];
                }
                else
                {
                        [taggedButton setTitle:[NSString stringWithFormat:@"with %@ others",[[PlacesDict objectAtIndex:0] objectForKey:@"numberofUsers"]] forState:UIControlStateNormal];
                }

        [taggedButton setBackgroundColor:[UIColor clearColor]];
        taggedButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [taggedButton.titleLabel setTextAlignment:NSTextAlignmentLeft];

        [markerView addSubview:taggedButton];
    
    UIImageView *arrowImage=[[UIImageView alloc] initWithFrame:CGRectMake(180, 27, 10, 10)];
    [arrowImage setImage:[UIImage imageNamed:@"back-arrow"]];
    
    [markerView addSubview:arrowImage];
    [markerView addSubview:AddressLabel];
    [markerView addSubview:nameLabel];
    [markerView addSubview:imageview];

    return markerView;
    
   }
- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker
{
       CheckInDetailsViewController *checkInVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        checkInVC=[[CheckInDetailsViewController alloc] initWithNibName:@"CheckInDetailsViewController" bundle:nil];
    }
    else
    {
        checkInVC=[[CheckInDetailsViewController alloc] initWithNibName:@"CheckInDetailsViewController_iPhone4" bundle:nil];
    }
    checkInVC.m_CheckInDetailDictionary=(NSMutableArray*)marker.userData;
    checkInVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:checkInVC animated:YES];
    
}

 -(void)fetchLocationUsers
{
    NSString *body=[NSString stringWithFormat:@"%@%@%@%f%@%f",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kLatitudeString,self.m_Latitude,kLongitudeString,self.m_Longitude];
    
    NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kGetCountOfUsers AndRequestBody:body] ;
       if ([[dict objectForKey:@"return"] intValue]==1) {
        if ([[dict objectForKey:@"data"] count]>0) {
        self.m_FourSquareArray=[[NSMutableArray alloc] initWithArray:[dict objectForKey:@"data"]];
            [self.m_ActivityIndicator stopAnimating];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initGoogleMap];
            });

        }
           else
           {
               [self.m_ActivityIndicator stopAnimating];
               dispatch_async(dispatch_get_main_queue(), ^{
              [self initGoogleMap];
               });

           }
    }
    else
    {
        [self.m_ActivityIndicator stopAnimating];
       // [self fetchLocationUsers];
    }
}
-(void)displayPins
{
    [m_GoogleMapView clear];
    if (self.m_FourSquareArray.count!=0) {
        for (int j=0; j<self.m_FourSquareArray.count; j++) {

               NSLog(@"four : %@",[self.m_FourSquareArray objectAtIndex:j]);
                GMSMarker *annotation=[[GMSMarker alloc] init];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = [[[self.m_FourSquareArray objectAtIndex:j] objectForKey:@"lat"] floatValue];
                coordinate.longitude = [[[self.m_FourSquareArray objectAtIndex:j] objectForKey:@"lon"] floatValue];
                annotation=[GMSMarker markerWithPosition:coordinate];
                annotation.userData=@[[self.m_FourSquareArray objectAtIndex:j]];
                annotation.title=[[self.m_FourSquareArray objectAtIndex:j] objectForKey:@"address"];
                annotation.snippet=[[self.m_FourSquareArray objectAtIndex:j] objectForKey:@"locationtype"];
                annotation.appearAnimation=kGMSMarkerAnimationPop;
                annotation.icon=[UIImage imageNamed:@"Red_White_Icon"];
                annotation.map=m_GoogleMapView;
            }
    }
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.m_Latitude, self
                                                 .m_Longitude);
    marker.title = @"Current Location";
    marker.icon=[UIImage imageNamed:@"Map_CurrentLocation"];
    marker.tappable=NO;
    marker.map = m_GoogleMapView;
    [self.m_locationManager stopUpdatingLocation];
}

@end
