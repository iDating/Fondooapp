//
//  PostStatusViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 12/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "PostStatusViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "SharedClass.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+SBJSON.h"
#import "NSData+Base64.h"
#import "MapViewController.h"


@interface PostStatusViewController ()
{
    SharedClass *shared;
    UIButton *btn;
    UIButton *btnSend;
}
@property (weak, nonatomic) IBOutlet UIView *m_PlaceBackView;
@property (strong, nonatomic) ALAssetsLibrary *library;
@end

@implementation PostStatusViewController
@synthesize m_NumberOfCharactersLabel;
@synthesize m_LocationView;
@synthesize m_LocationLabel;
@synthesize m_LocationString;
@synthesize m_ImagePickerController;
@synthesize m_MapImage;
@synthesize isCheckIn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)startpost
{
    if (self.m_TextView.text.length>0) {

        if (m_IsImageSet==YES) {
          
            UIImage *updatedImage=[self.m_PreviewImage.image fixOrientation];
            
         // [self uploadimage:UIImageJPEGRepresentation(updatedImage,0.1)];
            [self uploadJPEGImage:kImageUploadFondooPhpFile image:updatedImage];
            
        }
        else if (isCheckIn==YES)
        {
     
            if(UIGraphicsBeginImageContextWithOptions != NULL)
            {
                UIGraphicsBeginImageContextWithOptions(self.m_MapContextView.frame.size, NO, 0.0);
            } else {
                UIGraphicsBeginImageContext(self.m_MapContextView.frame.size);
            }
            
            [self.m_MapContextView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.m_MapImage=image;
            [self uploadimage:UIImageJPEGRepresentation(self.m_MapImage, 0.1)];
        }
        else
        {
            [self postWithoutImage];
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Enter some text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
             [btn setUserInteractionEnabled:YES];
        [btn setHidden:NO];
        [btnSend setUserInteractionEnabled:YES];
        [self.m_ActivityIndicatore stopAnimating];
    }

}


- (IBAction)SendButtonClicked:(id)sender {
    [self.m_ActivityIndicatore startAnimating];
   [self performSelector:@selector(startpost) withObject:nil afterDelay:1.0f];
}

- (void)Loadtextviewlbl
{
    m_IsImageSet=NO;
    self.m_TextView.inputAccessoryView=self.m_AccesoryView;
}

- (void)Loadsendbtn
{
    m_NumberOfCharactersLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [m_NumberOfCharactersLabel setTextColor:kGrayColor];
    m_NumberOfCharactersLabel.text=@"0";
    
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc] initWithCustomView:m_NumberOfCharactersLabel];
    self.navigationItem.rightBarButtonItem=btnItem;
    btnItem.width=-10;
 
    UITapGestureRecognizer *tapGest=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
    tapGest.numberOfTapsRequired=1;
    [self.m_ScrollView addGestureRecognizer:tapGest];
    [self.view addGestureRecognizer:tapGest];
   
}



#pragma mark - View Did Load Method
- (void)viewDidLoad
{
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(CheckInClicked) name:@"checkin" object:nil];
    [super viewDidLoad];
    [self.m_TextView addSubview:self.m_PlaceBackView];
    [self performSelector:@selector(fetchLatLong) withObject:nil afterDelay:0.1];
    isCheckIn=NO;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        [self.m_ScrollView setContentSize:CGSizeMake(320, 600)];

        [UIView animateWithDuration:0.3 animations:^{
            [self.m_ScrollView setContentOffset:CGPointMake(0, 64)];
        }];
    }
    else
    {
        [self.m_ScrollView setContentSize:CGSizeMake(320, 540)];
        [UIView animateWithDuration:0.3 animations:^{
            [self.m_ScrollView setContentOffset:CGPointMake(0, 64)];
        }];
    }
    
    m_NumberOfCharactersLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 30)];
    [m_NumberOfCharactersLabel setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.title=@"New Post";
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    self.navigationItem.backBarButtonItem.title=@"";
    _positionInt=1;
    _isGoogleLocation=NO;
    [self Loadtextviewlbl];
    [self Loadsendbtn];

     shared=[SharedClass sharedInstance];

}
-(void)CheckInClicked
{
    self.m_LocationLabel.text=[NSString stringWithFormat:@"at- %@",shared.m_LocationName];
    isCheckIn=YES;
    [self InitializeMaplatitude:shared.m_Lattitude longitude:shared.m_Longitude address:shared.m_LocationName];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    m_MapImage=[[UIImage alloc] init];
    [self performSelector:@selector(becameFirstResponder) withObject:nil afterDelay:0.1f];

}
-(void)becameFirstResponder
{
    [self.m_TextView becomeFirstResponder];
}
-(void)fetchLatLong
{
    self.m_locationManager = [[CLLocationManager alloc] init];
    self.m_locationManager.delegate = self;
    self.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.m_locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.m_locationManager startUpdatingLocation];
    CLLocation *location = [self.m_locationManager location];
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    self.m_Latitude=coordinate.latitude;
    self.m_Longitude=coordinate.longitude;
    [shared setM_Lattitude:[NSString stringWithFormat:@"%f",coordinate.latitude]];
    [shared setM_Longitude:[NSString stringWithFormat:@"%f",coordinate.longitude]];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{


    if (isCheckIn==NO) {
        self.m_Latitude  = newLocation.coordinate.latitude;
        self.m_Longitude = newLocation.coordinate.longitude;
        [self performSelectorInBackground:@selector(fetchLocationThroughGoogleApi) withObject:nil];
        //[self fetchLocationThroughGoogleApi];
    }
   

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)imageButtonClicked:(id)sender {
      self.m_ImagePickerController=[[UIImagePickerController alloc] init];
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"Select Image from" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Camera",@"Library", nil];
    [action showInView:self.view];
    
}


-(void)setStatus:(NSString *)UrlString :(BOOL)isImageSet : (NSString*)authKey :(NSString*)lat :(NSString*)lon
{
    
    
    if (shared.m_LocationName == (id)[NSNull null]) {
        shared.m_LocationName=@"Unknown Location";
    }
    
    NSData *data11 = [self.m_TextView.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *valueUnicode = [[NSString alloc] initWithData:data11 encoding:NSUTF8StringEncoding];
    NSString *valueStr=[valueUnicode stringByReplacingOccurrencesOfString:@"\\" withString:@"-"];

     NSString *timeZoneName = [[NSTimeZone localTimeZone] name];
   if (shared.m_LocationName == nil || shared.m_LocationName == (id)[NSNull null]) {
       shared.m_LocationName=@"unknown";
    }
    NSString *body=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",kMessageSting,valueStr,kAuthKeyString,authKey,kLatitudeString,lat,kLongitudeString,lon,kAddressString,shared.m_LocationName,kTimeZoneString,timeZoneName];
    NSString *withImage=[body stringByAppendingString:[NSString stringWithFormat:@"%@%@",kPostImageString,UrlString]];
    [self.m_LoadingView setHidden:YES];
    NSString *withCheckInImage=[body stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",kCheckInImage,UrlString,kFourSquareID,shared.m_FoursquareID,kCheckinImageParamerterString,@"yes",kFullAdressString,shared.m_FullAddress,kPhoneString,shared.m_PhoneNumber,kIconImageString,shared.m_IconImage,kPlaceNameString,shared.m_LocationName,kLocationType,shared.m_LocationType]];
    
    NSString *withCheckandImage=[body stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",kPostImageString,UrlString,kFourSquareID,shared.m_FoursquareID,kCheckinImageParamerterString,@"yes",kFullAdressString,shared.m_FullAddress,kPhoneString,shared.m_PhoneNumber,kIconImageString,shared.m_IconImage,kPlaceNameString,shared.m_LocationName,kLocationType,shared.m_LocationType]];
    NSLog(@"llat lon : %@  %@",shared.m_Lattitude,shared.m_Longitude);
    
        NSLog(@"llat second lon : %@  %@",shared.m_FourSquareLattitude,shared.m_FourSquareLongitude);
    NSDictionary *resultDect;
    if (m_IsImageSet==YES && isCheckIn==NO)
    {
        resultDect=[WebServiceAPIController executeAPIRequestForMethod:kPostStatusMethod AndRequestBody:withImage];
    }
    else if (isCheckIn==YES &&m_IsImageSet==YES)
    {
        resultDect=[WebServiceAPIController executeAPIRequestForMethod:kPostStatusMethod AndRequestBody:withCheckandImage];
    }
    else if(isCheckIn==YES)
    {
        resultDect=[WebServiceAPIController executeAPIRequestForMethod:kPostStatusMethod AndRequestBody:withCheckInImage];
    }
    else
    {
        resultDect=[WebServiceAPIController executeAPIRequestForMethod:kPostStatusMethod AndRequestBody:body];
    }
       // m_IsImageSet=NO;
        if ([[resultDect objectForKey:@"return"] intValue]==1) {
            [btn setUserInteractionEnabled:YES];
             [self.m_AppDel stopTimer];
        }
        else
        {
            [btn setUserInteractionEnabled:YES];
            [btnSend setUserInteractionEnabled:YES];
            [self.m_AppDel stopTimer];
        }
        [self.m_ActivityIndicatore stopAnimating];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageEdit" object:nil];
        [btn setUserInteractionEnabled:YES];
        [btnSend setUserInteractionEnabled:YES];
        [self.navigationController popViewControllerAnimated:YES];

}
-(void)Tapped:(UITapGestureRecognizer*)sender
{
       if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
       [self.m_ScrollView setContentSize:CGSizeMake(320, 600)];
        [UIView animateWithDuration:0.3 animations:^{
        [self.m_ScrollView setContentOffset:CGPointMake(0, 0)];
        }];
    }
    else
    {
       [self.m_ScrollView setContentSize:CGSizeMake(320, 540)];
        [UIView animateWithDuration:0.3 animations:^{
            [self.m_ScrollView setContentOffset:CGPointMake(0, 0)];
        }];
    }
   
}
-(void)doneClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma TextView Delegates
//[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"result"] objectAtIndex:0]objectForKey:@"auth_key"]

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
       return YES;
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"Range : %lu",(unsigned long)range.location);
    [self.m_NumberOfCharactersLabel setText:[NSString stringWithFormat:@"%u",140-range.location]];
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    
//    if (range.location<37) {
//        [self.m_LocationLabel setFrame:CGRectMake(10, 30, 282, 21)];
//    }
//    else if(range.location<70)
//    {
//        [self.m_LocationLabel setFrame:CGRectMake(10,60, 282, 21)];
//    }
//    else
//    {
//        
//    }
    
       if (location != NSNotFound){
           _positionInt++;
           [self SendButtonClicked:nil];
     
           return NO;
       }

    if (text.length<=0) {
        return YES;
    }
    if (textView.text.length<140 || [text isEqualToString:@"\n"]) {
        
    return YES;
    }
    else
    {
        [self.view endEditing:YES];
        return NO;
    }
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    NSLog(@"line : %f",line.origin.y);
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    NSLog(@"value : %f",overflow);
    [UIView animateWithDuration:.2 animations:^{
//        [textView setContentOffset:offset];
        [self.m_PlaceBackView setFrame:CGRectMake(0, line.origin.y+30, 320, 204)];
    }];

    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
           // [self.m_LocationLabel setFrame:CGRectMake(10, line.origin.y+20, 282, 21)];
        }];
    }
 
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
#pragma UIImagepicker controller Delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.m_PreviewImage.image=image;


    self.m_BackImagePreview.image=[UIImage imageNamed:@"PreviewPostImageFrame"];
 m_IsImageSet=YES;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
            [self.m_ScrollView setContentSize:CGSizeMake(320, 600)];
            [self.m_ScrollView setContentOffset:CGPointMake(0, 0)];
        }
        else
        {
            [self.m_ScrollView setContentSize:CGSizeMake(320, 540)];
            [self.m_ScrollView setContentOffset:CGPointMake(0, 0)];
        }
        [self.m_TextView becomeFirstResponder];
    }];

}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.m_TextView becomeFirstResponder];
     m_IsImageSet=NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)uploadimage:(NSData*)image
{
    NSLog(@"data Lenght :%u",image.length/1024);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:kImageUploadFondooPhpFile]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:image]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSString *url=[NSString stringWithFormat:@"%@%@",kImageUploadFondooUrlPrefixFile,returnString];
    NSLog(@"Return Data : %@",returnString);
    if ([returnData length] > 0)
    {
        [self postWithImage:url];
       
        [self.m_AppDel startTimer];
    }
 else
 {
     [self.m_ActivityIndicatore stopAnimating];
 }
}

- (void)uploadJPEGImage:(NSString*)requestURL image:(UIImage*)image
{
    NSURL *url = [[NSURL alloc] initWithString:requestURL];
    NSMutableURLRequest *urequest = [NSMutableURLRequest requestWithURL:url];
    
    [urequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urequest setHTTPShouldHandleCookies:NO];
    [urequest setTimeoutInterval:60];
    [urequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [urequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    // Add __VIEWSTATE
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"__VIEWSTATE\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"/wEPDwUKLTQwMjY2MDA0M2RkXtxyHItfb0ALigfUBOEHb/mYssynfUoTDJNZt/K8pDs=" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    NSLog(@"image Data lenght :%u",imageData.length/1024);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urequest setHTTPBody:body];
    NSLog(@"Check response if image was uploaded after this log");
    //return and test
    NSHTTPURLResponse *response = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urequest returningResponse:&response error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", returnString);
    NSString *urlString=[NSString stringWithFormat:@"%@%@",kImageUploadFondooUrlPrefixFile,returnString];
    NSLog(@"Return Data : %@",returnString);
    if ([returnData length] > 0)
    {
        [self postWithImage:urlString];
       // [self.m_AppDel startTimer];
    }
    else
    {
        [self.m_ActivityIndicatore stopAnimating];
    }

    // Extract the imageurl
   }

#pragma UIActionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    switch (buttonIndex) {
        case 0:
           // [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            break;
            
            case 1:
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Device doesn't support camera" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                 return;
            }
           
            self.m_ImagePickerController.delegate=self;
            self.m_ImagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.m_ImagePickerController animated:YES completion:nil];

            break;
            case 2:
            self.m_ImagePickerController.delegate=self;
            self.m_ImagePickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:self.m_ImagePickerController animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    switch (buttonIndex) {
        case 0:
            break;
            
            case 1:
            break;
            
        default:
            break;
    }
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getCheckInData
{
    NSDictionary *resultDict=[WebServiceAPIController executeAPIRequestForMethod:kGetCurrentUserCheckinDetail AndRequestBody:[NSString stringWithFormat:@"%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"]]];

    if ([[resultDict objectForKey:@"return"] integerValue]==1) {
  
        if ([[[[resultDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"is_check"]isEqualToString:@"yes"]) {
            if (m_IsImageSet==YES) {
            
            isCheckIn=NO;
            }
            else
            {
                isCheckIn=YES;
            }
            
            _isGoogleLocation=NO;
                      [shared setM_Lattitude:[NSString stringWithFormat:@"%@",[[[resultDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"lat"]]];
            [shared setM_Longitude:[NSString stringWithFormat:@"%@",[[[resultDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"lon"]]];
            self.m_LocationString=[NSString stringWithFormat:@"%@",[[[resultDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"address"]];
            [shared setM_LocationName:[[[resultDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"address"]];
            m_LocationLabel.text=[NSString stringWithFormat:@"- at %@",[[[resultDict objectForKey:@"data"] objectAtIndex:0] objectForKey:@"address"]];
            [self InitializeMaplatitude:shared.m_Lattitude longitude:shared.m_Longitude address:shared.m_LocationName];
        }
        else{
            [self fetchLocationThroughGoogleApi];
        }
    }
    else
    {
         [self fetchLocationThroughGoogleApi];
          }

}

-(void)postWithImage: (NSString *)urlString
{
        NSLog(@"llat lon : %@  %@",shared.m_FourSquareLongitude,shared.m_FourSquareLattitude);
    if (self.m_TextView.text.length>0) {
        if (isCheckIn==NO) {
            [self setStatus:urlString :YES :[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"] : shared.m_Lattitude:shared.m_Longitude];
        }
        else
        {
            [self setStatus:urlString : YES :[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"] :shared.m_FourSquareLattitude:shared.m_FourSquareLongitude];
        }
        
    }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Some Text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    


}
-(void)postWithoutImage
{
      NSLog(@"llat lon : %@  %@",shared.m_FourSquareLongitude,shared.m_FourSquareLattitude);
    if (self.m_TextView.text.length>0) {
        
    if (isCheckIn==NO) {
        
        [self setStatus:nil :NO :[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"] :shared.m_Lattitude :shared.m_Longitude];
    
    }
    else
    {
        [self setStatus:nil :NO :[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"] :shared.m_FourSquareLattitude :shared.m_FourSquareLongitude];
    }
}
else
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Some Text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

}

-(void)fetchLocationThroughGoogleApi
{
   
    
    NSString *sensorString;
//#if TARGET_IPHONE_SIMULATOR
//    sensorString=@"true";
//#else
    sensorString=@"true";
    
//#endif
    
     NSString *urlString=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=%@",self.m_Latitude,self.m_Longitude,sensorString];
 //   NSLog(@"url : %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    //send it synchronous
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dict=[[NSDictionary alloc] initWithDictionary:[responseString JSONValue]];
   // NSLog(@"dic : %@",dict);
    // check for an error. If there is a network error, you should handle it here.
    if(!error)
    {

        int i=0;
        i++;
                   if ([[dict objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
                  if (i<3) {
                  [self fetchLocationThroughGoogleApi];
                  }
        }
        else
        {
                      for (NSDictionary *locationArray in [[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"address_components"]) {
                
                    if ([[[locationArray objectForKey:@"types"] objectAtIndex:0] isEqualToString:@"sublocality"]) {
                        self.m_LocationLabel.text=[NSString stringWithFormat:@"- at %@",[locationArray objectForKey:@"short_name"] ];
                        [shared setM_GoogleLat:[[[[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"]];
                        [shared setM_GoogleLng:[[[[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"]];
                        [shared setM_LocationName:[locationArray objectForKey:@"short_name"]];
                        _isGoogleLocation=YES;

                    }
            }
                   }
        
             }
    else
    {
      
    }
 
}

- (IBAction)imageRemoved:(id)sender {
    self.m_BackImagePreview.image=nil;
    self.m_PreviewImage.image=nil;
}

- (IBAction)checkInButtonClicked:(id)sender {
    CheckInMapViewController *checkInVC;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        checkInVC=[[CheckInMapViewController alloc] initWithNibName:@"CheckInMapViewController" bundle:nil];
    }
    else
    {
        checkInVC=[[CheckInMapViewController alloc] initWithNibName:@"CheckInMapViewController_iPhone4" bundle:nil];
    }
    UINavigationController *navBar=[[UINavigationController alloc] initWithRootViewController:checkInVC];
    [self presentViewController:navBar animated:YES completion:nil];
   }
     


-(void)InitializeMaplatitude:(NSString*)lat longitude:(NSString*)lng address:(NSString*)adr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[lat floatValue]
                                                                longitude:[lng floatValue]
                                                                     zoom:12];
        //  [cell.m_MapView setFrame:cell.m_DisplayView.bounds];
        self.m_MapView.camera=camera;
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([lat floatValue],[lng floatValue]);
        marker.title = [NSString stringWithFormat:@"%@",adr];
        marker.snippet=@"";
        marker.icon=[UIImage imageNamed:@"Red_PinIcon"];
        self.m_MapView.selectedMarker=marker;
        marker.map = self.m_MapView;
        
       
   });

}



@end
