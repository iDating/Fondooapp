//
//  ReplyViewController.m
//  KeithDatingApp
//
//  Created by Mohit on 06/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "ReplyViewController.h"
#import "WebServiceAPIController.h"

#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UserDetailsViewController.h"
@interface ReplyViewController ()

@end

@implementation ReplyViewController
@synthesize m_PostDictionary;
@synthesize m_viewHeight;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//[[NSNotificationCenter defaultCenter] removeObserver:self];
-(void)setShadow
{
    
     self.m_ProfilePicture.layer.cornerRadius=3.0f;
     self.m_ProfilePicture.clipsToBounds=YES;
     [self.m_ProfilePicture.layer setMasksToBounds:YES];

    
//    CALayer *layer = self.m_BackView.layer;
//    layer.shadowOffset = CGSizeMake(1, 1);
//    layer.shadowColor = [[UIColor blackColor] CGColor];
//    layer.shadowRadius = 1.0f;
//    layer.shadowOpacity = 0.50f;
    self.m_BackView.layer.shadowOffset = CGSizeMake(1, 1);
      self.m_BackView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.m_BackView.layer.shadowRadius = 1.0f;
        self.m_BackView.layer.shadowOpacity = 0.50f;

}
- (void)viewDidLoad
{
    [super viewDidLoad];

       // [self setShadow];
     [self setNavBarView];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.m_MessageTextView.placeholder=[NSString stringWithFormat:@"Reply to %@",[m_PostDictionary objectForKey:@"first_name"]];
    self.navigationItem.title=@"Details";
    [self performSelectorInBackground:@selector(setUserDetails) withObject:nil];
    [self.m_MessageTextView resignFirstResponder];
    // Do any additional setup after loading the view from its nib.
}
-(void)setNavBarView
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClicked:)];
    tapGesture.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tapGesture];
    UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 5, 25, 25)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"User_ImageIcon"] forState:UIControlStateNormal];
    rightButton.alpha=0.5f;
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBar;
}
-(void)setUserDetails
{
    NSString *stringValue=[m_PostDictionary objectForKey:@"post_message"];
    NSString *valueStr=[stringValue stringByReplacingOccurrencesOfString:@"-" withString:@"\\"];
    NSData *data11 = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *valueEmoj1 = [[NSString alloc] initWithData:data11 encoding:NSNonLossyASCIIStringEncoding];
    self.m_ProfilePicture.layer.cornerRadius=2.0f;
    [self.m_StatusLabel setText:valueEmoj1];
    self.m_UserName.text=[m_PostDictionary objectForKey:@"first_name"];
    self.m_TimeLabel.text=[m_PostDictionary objectForKey:@"posted_on"];
    [self.m_LocationButton setTitle:[m_PostDictionary objectForKey:@"address"] forState:UIControlStateNormal];
    [self.m_ProfilePicture setImageWithURL:[NSURL URLWithString:[m_PostDictionary objectForKey:@"userimage"]] placeholderImage:nil];
    
    if ([[m_PostDictionary  objectForKey:@"imageset"] isEqualToString:@"no"] && [[m_PostDictionary objectForKey:@"is_checkIn"] isEqualToString:@"no"] ) {
        
        [self.m_LocationButton setHidden:NO];
        [self.m_LocationImage setHidden:NO];
        [self.m_BackView setFrame:CGRectMake(10, 5, 300, 90+m_viewHeight)];
        [self.m_StatusLabel setFrame:CGRectMake(8, 60, 285, m_viewHeight)];
        [self.m_LocationButton setFrame:CGRectMake(8, m_viewHeight+65, 260, 29)];
        [self.m_LocationImage setFrame:CGRectMake(8, m_viewHeight+70, 10, 16)];
        [self.m_ImageBackView setHidden:YES];
         [self.m_ActivityIndicator stopAnimating];
         self.m_ActivityIndicator.hidden=YES;
        
        
    }
    else if ([[m_PostDictionary objectForKey:@"imageset"] isEqualToString:@"no"] && [[m_PostDictionary objectForKey:@"is_checkIn"] isEqualToString:@"yes"] )
    {
       
       

        [self.m_LocationButton setFrame:CGRectMake(8, m_viewHeight+195, 260, 29)];
        [self.m_LocationImage setFrame:CGRectMake(8, m_viewHeight+200, 10, 16)];
        [self.m_BackView setFrame:CGRectMake(10, 5, 300, m_viewHeight+225)];
        [self.m_StatusLabel setFrame:CGRectMake(8, 71, 285, m_viewHeight)];
        [self.m_ImageBackView setFrame:CGRectMake(0, m_viewHeight+75, 300, 120)];
        [self.m_ImageButton setHidden:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
                   [self initializeGoogleMap:self.m_BackView.frame];
        });
        
         [self.m_ActivityIndicator stopAnimating];
        self.m_ActivityIndicator.hidden=YES;
    }
    else {
        
        [self.m_ActivityIndicator startAnimating];
        __block UIImageView * imageView = self.m_ImageButton;
        NSURLRequest *url_request = [NSURLRequest requestWithURL:[NSURL URLWithString:[m_PostDictionary objectForKey:@"image"]]];
        [self.m_ImageButton setImageWithURLRequest:url_request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            if (image) {
                [self.m_ActivityIndicator stopAnimating];
                self.m_ActivityIndicator.hidden=YES;
                [imageView setImage:image];
            }
        } failure:nil];
       // [self.m_ImageButton setImageWithURL:[NSURL URLWithString:[m_PostDictionary objectForKey:@"image"]] placeholderImage:nil];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage:)];
        tapGesture.numberOfTapsRequired=1;
        [self.m_ImageButton addGestureRecognizer:tapGesture];
        [self.m_LocationButton setFrame:CGRectMake(8, m_viewHeight+67+130, 260, 29)];
        [self.m_LocationImage setFrame:CGRectMake(8, m_viewHeight+72+130, 10, 16)];
        [self.m_StatusLabel setFrame:CGRectMake(8, 71, 285, m_viewHeight)];
        [self.m_ImageBackView setFrame:CGRectMake(0, m_viewHeight+75, 300, 120)];
        [self.m_MapView setHidden:YES];
        if ([[m_PostDictionary objectForKey:@"imageset"] isEqualToString:@"yes"] && [[m_PostDictionary objectForKey:@"is_checkIn"] isEqualToString:@"no"]) {
            [self.m_LocationButton setHidden:NO];
            [self.m_LocationImage setHidden:NO];
             [self.m_BackView setFrame:CGRectMake(10, 5, 300, m_viewHeight+225)];
        }
        else
        {
               [self.m_BackView setFrame:CGRectMake(10, 5, 300, m_viewHeight+220)];
            [self.m_LocationButton setHidden:NO];
            [self.m_LocationImage setHidden:NO];
        }
        

        
    }
    
   }
-(void)openImage:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    ImagePreviewViewController *imagePrev;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
    imagePrev=[[ImagePreviewViewController alloc] initWithNibName:@"ImagePreviewViewController" bundle:nil];
    }
    else{
         imagePrev=[[ImagePreviewViewController alloc] initWithNibName:@"ImagePreviewViewController_iPhone4" bundle:nil];
    }
    imagePrev.m_ImageUrl=[self.m_PostDictionary objectForKey:@"image"];
    [self presentViewController:imagePrev animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:YES];
    self.tabBarController.hidesBottomBarWhenPushed=YES;
      [self.m_BackView setFrame:CGRectMake(self.m_BackView.frame.origin.x, 5, self.m_BackView.frame.size.width, self.m_BackView.frame.size.height)];
    [self setNavColor];
    [self registerForKeyboardNotifications];
}
-(void)setNavColor
{
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil action:nil];
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)rightBarButtonClicked
{
    
    
    if([[m_PostDictionary objectForKey:@"is_me"] isEqualToString:@"yes"])
    {
        [self.tabBarController setSelectedIndex:3];
    }
    else
    {
        UserDetailsViewController *userDetailsVC;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
            userDetailsVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController" bundle:nil];
        }
        else
        {
            userDetailsVC=[[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController_iPhone4" bundle:nil];
        }
      //  userDetailsVC.hidesBottomBarWhenPushed=YES;
         userDetailsVC.m_userProfile=self.m_PostDictionary;
        [self.navigationController pushViewController:userDetailsVC animated:YES];
    }

    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendMessage
{
    if (self.m_MessageTextView.text.length>0) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSData *data11 = [self.m_MessageTextView.text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
            
            NSString *valueUnicode = [[NSString alloc] initWithData:data11 encoding:NSUTF8StringEncoding];
            NSString *valueStr=[valueUnicode stringByReplacingOccurrencesOfString:@"\\" withString:@"-"];
            
                NSString *timeZoneName = [[NSTimeZone localTimeZone] name];
            NSString *body=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],kOtherUserID,[self.m_PostDictionary objectForKey:@"userid"],kMessageSting,valueStr,kTimeZoneString,timeZoneName];
            
            NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kSendMessage AndRequestBody:body];

            if ([[dict objectForKey:@"return"] intValue]==1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            else
            {
                
            }
        });
    }
    
    else
    {
          [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter some text" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextView *)textView
{
   // [self.m_ScrollView setContentOffset:CGPointMake(0, 64)];
  //  self.m_MessageTextView.inputAccessoryView=self.m_TextViewBack;
  
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextView *)textView
{
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextView *)textView
{
  
    
  //  [self.m_ScrollView setContentSize:CGSizeMake(320, 700)];
//    216
    /*
  [UIView animateWithDuration:0.27f animations:^{
      [self.m_ScrollView setContentOffset:CGPointMake(0, self.m_TextViewBack.frame.origin.y-140) animated:YES];
   }];
*/
    /*
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        [self.m_TextViewBack setFrame:CGRectMake(0, self.view.frame.size.height-216+self.m_TextViewBack.frame.size.height, 320, self.m_TextViewBack.frame.size.height)];
    }
    else
    {
        
    }
    */
}
- (void)textFieldDidEndEditing:(UITextView *)textView
{
 //   [self.view endEditing:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [string rangeOfCharacterFromSet:doneButtonCharacterSet];
    
    NSUInteger location = replacementTextRange.location;
    if (location != NSNotFound){
        [self sendMessage];  
        return NO;
    }

    return YES;
}
- (void)textFieldDidChange:(UITextView *)textView
{
    
}

- (void)textFieldDidChangeSelection:(UITextView *)textView
{
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.m_ScrollView.contentInset = contentInsets;
    self.m_ScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.m_ScrollView.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.m_TextViewBack.frame.origin) ) {
        CGPoint scrollPoint;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
         scrollPoint= CGPointMake(0.0, self.m_TextViewBack.frame.origin.y-kbSize.height-25);
        }
        else
        {
          scrollPoint= CGPointMake(0.0, self.m_TextViewBack.frame.origin.y-kbSize.height+60);
        }
        [UIView animateWithDuration:0.17 animations:^{
        [self.m_ScrollView setContentOffset:scrollPoint animated:NO];
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
                [self.m_BackView setFrame:CGRectMake(self.m_BackView.frame.origin.x, self.m_TextViewBack.frame.origin.y-self.m_BackView.frame.size.height-20, self.m_BackView.frame.size.width, self.m_BackView.frame.size.height)];
            }
            else
            {[self.m_BackView setFrame:CGRectMake(self.m_BackView.frame.origin.x, self.m_TextViewBack.frame.origin.y-self.m_BackView.frame.size.height-20, self.m_BackView.frame.size.width, self.m_BackView.frame.size.height)];
                }
         
        }];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.m_ScrollView.contentInset = contentInsets;
    self.m_ScrollView.scrollIndicatorInsets = contentInsets;
}
-(void)tapGestureClicked:(UITapGestureRecognizer*)tapGesture
{
    [self.view endEditing:YES];
    [self.m_ScrollView setContentOffset:CGPointMake(0, 0)];
     [self.m_BackView setFrame:CGRectMake(self.m_BackView.frame.origin.x, 5, self.m_BackView.frame.size.width, self.m_BackView.frame.size.height)];
}

-(void)initializeGoogleMap :(CGRect)rect
{
   
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[m_PostDictionary objectForKey:@"latitude"] doubleValue]
                                                            longitude:[[m_PostDictionary objectForKey:@"longitude"] doubleValue]
                                                                 zoom:12];
    [self.m_MapView setFrame:self.m_MapView.frame];
    self.m_MapView.camera=camera;
    self.m_MapView.myLocationEnabled = YES;
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([[m_PostDictionary objectForKey:@"latitude"] doubleValue],[[m_PostDictionary objectForKey:@"longitude"] doubleValue] );
    marker.title = [NSString stringWithFormat:@"%@",[m_PostDictionary objectForKey:@"address"]];
    if ([[m_PostDictionary objectForKey:@"data"] count]>0) {
        if([[[[m_PostDictionary objectForKey:@"data"] objectAtIndex:0] objectForKey:@"numberofUsers"] isEqualToString:@"0"])
        {
            marker.snippet = @"";
        }
        else
        {
             marker.snippet = [NSString stringWithFormat:@"with %@ others",[[[m_PostDictionary objectForKey:@"data"] objectAtIndex:0] objectForKey:@"numberofUsers"]];
        }
      
    }
    else
    {
        marker.snippet=@"";
    }
   
    marker.icon=[UIImage imageNamed:@"Red_White_Icon"];
    self.m_MapView.selectedMarker=marker;
    marker.map = self.m_MapView;

}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    
    return NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(IBAction)LocationClicked :(UIButton*)sender

{
   if( [[m_PostDictionary objectForKey:@"is_checkIn"] isEqualToString:@"yes"])
   {
    CheckInDetailsViewController *checkInVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        checkInVC=[[CheckInDetailsViewController alloc] initWithNibName:@"CheckInDetailsViewController" bundle:nil];
    }
    else
    {
        checkInVC=[[CheckInDetailsViewController alloc] initWithNibName:@"CheckInDetailsViewController_iPhone4" bundle:nil];
    }
    checkInVC.m_CheckInDetailDictionary=(NSMutableArray*)[m_PostDictionary objectForKey:@"data"];
    checkInVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:checkInVC animated:YES];
   }
}


@end
