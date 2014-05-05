//
//  ReplyViewController.h
//  KeithDatingApp
//
//  Created by Mohit on 06/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import "ImagePreviewViewController.h"
#import "CheckInDetailsViewController.h"
@interface ReplyViewController : UIViewController<GMSMapViewDelegate,UITextFieldDelegate>


@property(strong,nonatomic)NSMutableDictionary *m_PostDictionary;
-(void)setUserDetails;
-(void)setNavBarView;


@property (weak, nonatomic) IBOutlet UIImageView *m_ProfilePicture;
@property (weak, nonatomic) IBOutlet UIScrollView *m_ScrollView;
@property (weak, nonatomic) IBOutlet UILabel *m_UserName;
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_StatusLabel;
@property (weak, nonatomic) IBOutlet AsyncImageView *m_ImageButton;
@property (weak, nonatomic) IBOutlet UIButton *m_LocationButton;
@property (weak, nonatomic) IBOutlet UIImageView *m_LocationImage;
@property (weak, nonatomic) IBOutlet UIView *m_BackView;
@property (weak, nonatomic) IBOutlet UIView *m_TextViewBack;
@property (weak, nonatomic) IBOutlet UITextField *m_MessageTextView;
@property(weak,nonatomic)IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
@property (weak, nonatomic) IBOutlet UIView *m_ImageBackView;
@property(nonatomic)CGFloat m_viewHeight;
-(IBAction)LocationClicked :(UIButton*)sender;
@property (weak, nonatomic) IBOutlet GMSMapView *m_MapView;
@end
