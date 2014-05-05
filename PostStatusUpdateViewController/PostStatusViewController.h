//
//  PostStatusViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 12/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceAPIController.h"
#import <MapKit/MapKit.h>
#import "CheckInMapViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CommonClass.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "UIImage+UIImage_fixOrientation.h"

@interface PostStatusViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,CLLocationManagerDelegate>
{    BOOL m_IsImageSet;
    

  //  ASIFormDataRequest *request;

    
}
@property (weak, nonatomic) IBOutlet UIView *m_MapContextView;
@property(strong,nonatomic)AppDelegate *m_AppDel;
@property(strong,nonatomic)UIImage *m_MapImage;
@property (weak, nonatomic) IBOutlet GMSMapView *m_MapView;
@property(nonatomic)BOOL isCheckIn;

@property(strong,nonatomic)UIImagePickerController *m_ImagePickerController;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicatore;
@property (weak, nonatomic) IBOutlet UIButton *m_SendButton;

@property (weak, nonatomic) IBOutlet UIImageView *m_PreviewImage;
@property (weak, nonatomic) UIActivityIndicatorView *m_LoadingView;
@property(strong,nonatomic)CLLocationManager *m_locationManager;
@property(nonatomic)CGFloat m_Latitude;
@property(nonatomic)CGFloat m_Longitude;
@property(strong,nonatomic) UIView *m_LocationView;
@property(strong,nonatomic)IBOutlet UILabel *m_LocationLabel;




@property (weak, nonatomic) IBOutlet UIImageView *m_BackImagePreview;
@property (strong, nonatomic) IBOutlet UITextView *m_TextView;
@property (weak, nonatomic) IBOutlet UIScrollView *m_ScrollView;
@property(strong,nonatomic)NSString *m_LocationString;
@property(nonatomic)BOOL isGoogleLocation;
@property(nonatomic)int positionInt;
@property(strong,nonatomic)UILabel *m_NumberOfCharactersLabel;
- (IBAction)imageRemoved:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *m_AccesoryView;

- (IBAction)checkInButtonClicked:(id)sender;
- (IBAction)imageButtonClicked:(id)sender;
- (IBAction)SendButtonClicked:(id)sender;
- (void)Loadtextviewlbl;
- (void)Loadsendbtn;
@end
