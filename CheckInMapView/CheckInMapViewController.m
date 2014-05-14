//
//  CheckInMapViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 13/02/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "CheckInMapViewController.h"

@interface CheckInMapViewController ()

@end

@implementation CheckInMapViewController
@synthesize m_PlacesDictionary;
@synthesize m_Latitude;
@synthesize m_locationManager;
@synthesize m_Longitude;
@synthesize m_ActivityIndicator;
@synthesize m_Shared;
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
    [self.navigationController.navigationBar setHidden:NO];
    m_Shared=[SharedClass sharedInstance];
    
    [self setNav];
    
    [self.m_ActivityIndicator startAnimating];
    
    self.m_locationManager = [[CLLocationManager alloc] init];
    self.m_locationManager.delegate = self;
    self.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.m_locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.m_locationManager startUpdatingLocation];
    CLLocation *location = [self.m_locationManager location];
       CLLocationCoordinate2D coordinate = [location coordinate];
    
    self.m_Latitude=coordinate.longitude;
    self.m_Longitude=coordinate.latitude;
        // Do any additional setup after loading the view from its nib.
}
-(void)setNav
{
    UIButton *closeButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [closeButton setTitleColor:kGrayColor forState:UIControlStateNormal];
    [closeButton setTitle:@"  Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.title=@"Near by locations";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem=rightBarButton;
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithCustomView:self.m_ActivityIndicator];
    self.navigationItem.leftBarButtonItem=leftButton;
    [self.navigationController.navigationBar setTranslucent:YES];
}
-(void)closeButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    if (self.m_PlacesDictionary.count>0) {
      
        if ([[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"categories"] count]>0) {
            NSString *finalURL=[[[[[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"prefix"] stringByAppendingString:[NSString stringWithFormat:@"64%@" ,[[[[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"suffix"] ]];
            [cell.imageView setBackgroundColor:[UIColor grayColor]];
            [cell.imageView setImageWithURL:[NSURL URLWithString:finalURL]];
            
        }
        cell.textLabel.text=[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text=[[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"address"];
    }

    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_PlacesDictionary.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"  Near Locations";
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pin_IconBlack"]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    [m_Shared setM_FoursquareID:[[self.m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [m_Shared setM_FourSquareLattitude:[[[self.m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"lat"]];
    [m_Shared setM_FourSquareLongitude:[[[self.m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"lng"]];
    [m_Shared setM_LocationName:[[self.m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"name"]];
    if ([[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"categories"] count]>0) {
        NSString *finalURL=[[[[[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"prefix"] stringByAppendingString:[NSString stringWithFormat:@"64%@" ,[[[[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"suffix"] ]];
        [m_Shared setM_IconImage:finalURL];
        
    }
    else{
        [m_Shared setM_IconImage:@"https://playfoursquare.s3.amazonaws.com/press/logo/icon-36x36.png"];
    }
    
    if ([[[self.m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"address"]) {
       [m_Shared setM_FullAddress:[NSString stringWithFormat:@"%@",[[[self.m_PlacesDictionary objectAtIndex:indexPath.row]objectForKey:@"location"] objectForKey:@"address"]] ];
    }
    else
    {
        if ([[[self.m_PlacesDictionary objectAtIndex:indexPath.row]  objectForKey:@"location"] objectForKey:@"city"]) {
            [m_Shared setM_FullAddress: [NSString stringWithFormat:@"%@",[[[self.m_PlacesDictionary objectAtIndex:indexPath.row]objectForKey:@"location"] objectForKey:@"city"]] ];
        }
        else
        {
            [m_Shared setM_FullAddress:[NSString stringWithFormat:@"%@",[[[self.m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"country"]]];
        }
        
    }
    if ([[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"categories"] count]>0) {
        [m_Shared setM_LocationType:[[[[m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"shortName"] ];
    }
    else
    {
         [m_Shared setM_LocationType:@"Unknown"];
        
    }
    if ([[[self.m_PlacesDictionary objectAtIndex:indexPath.row]objectForKey:@"contact"] objectForKey:@"phone"]) {
   [m_Shared setM_PhoneNumber:[NSString stringWithFormat:@"%@",[[[self.m_PlacesDictionary objectAtIndex:indexPath.row] objectForKey:@"contact"] objectForKey:@"phone"]] ];
        
    }
    else
    {
        [m_Shared setM_PhoneNumber:@"Unknown"];
       
    }


      [[NSNotificationCenter defaultCenter] postNotificationName:@"checkin" object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
     
    }];
}
#pragma Fetch FourSquareData
-(void)nearPlacesSearch
{
    dispatch_async(dispatch_get_main_queue(), ^{
        int miles=([[NSString stringWithFormat:@"%@", [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"defaultcategory"] objectAtIndex:0] objectForKey:@"radius"]] floatValue]*1609.34);
        NSString* requestString = [[NSString alloc] initWithFormat:@"https://api.foursquare.com/v2/venues/search?&ll=%f,%f&client_id=%@&client_secret=%@&radius=%i&v=%@",self.m_Latitude,self.m_Longitude,kFourSquareClientID,kFourSquareClientSecret,miles,[self getCurrentDate]];
        NSLog(@"String URL :%@",requestString);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   if ([[[dictionary objectForKey:@"meta"] objectForKey:@"errorType"] isEqualToString:@"invalid_auth"]) {
                                       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please first login with FOURSQUARE" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                       [alert show];
                                   }else
                                   {
                                       m_PlacesDictionary=[[NSMutableArray alloc] initWithArray:[[dictionary objectForKey:@"response"] objectForKey:@"venues"]];
                                       NSLog(@"places : %@",m_PlacesDictionary);
                                       
                                   }
                                   
                                   [self.m_ActivityIndicator stopAnimating];
                                   [self.m_TableView reloadData];
                                   [self.m_locationManager stopUpdatingLocation];
                                   
                               }];
   
    });
    
}

-(NSString*)getCurrentDate
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSString *currentDate;
    if([components day] < 10)
    {
        if([components month] < 10)
            currentDate = [NSString stringWithFormat:@"%ld0%ld0%ld",(long)[components year],(long)[components month],(long)[components day]];
        else
            currentDate = [NSString stringWithFormat:@"%ld%ld0%ld",(long)[components year],(long)[components month],(long)[components day]];
    }
    else if([components month] < 10)
    {
        if([components day] < 10)
            currentDate = [NSString stringWithFormat:@"%ld0%ld0%ld",(long)[components year],(long)[components month],(long)[components day]];
        else
            currentDate = [NSString stringWithFormat:@"%ld0%ld%ld",(long)[components year],(long)[components month],(long)[components day]];
    }
    else {
        currentDate = [NSString stringWithFormat:@"%ld%ld%ld",(long)[components year],(long)[components month],(long)[components day]];
    }
    return currentDate;
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
    [self nearPlacesSearch];
}
#pragma ALertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
           
            break;
            
        default:
            break;
    }
}


@end
