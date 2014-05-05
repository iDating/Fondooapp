//
//  IntroViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "IntroViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface IntroViewController ()


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
@property(nonatomic,strong)NSMutableArray *m_FriendsArray;
@property(nonatomic,strong)NSMutableArray *m_InterestArray;
@property(strong,nonatomic)NSArray *m_IntroArray;
@property (strong, nonatomic) IBOutlet UIScrollView *m_IntroScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *m_PageControl;
- (IBAction)SignInWithFacebookClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *m_IntroView;

- (IBAction)CustomPageControlClicked:(id)sender;
@property (strong, nonatomic) IBOutlet CustomUIPageControl *m_CustomPageControl;
@property (strong, nonatomic) IBOutlet UIButton *m_SignUpWithFacebookButton;

@end

@implementation IntroViewController
@synthesize m_FriendsString;
@synthesize m_CombinedArray;
@synthesize m_ALbumsString;
@synthesize m_ALbumArray;
@synthesize m_friendsName;
@synthesize m_InterestName;
@synthesize m_InterestNameString;
@synthesize m_FriendsNameString;
@synthesize m_AlbumName;
@synthesize m_AlbumNameString;
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
   // [self.m_BackgroundImage.layer addAnimation:[self ZoomAnimation] forKey:@"Zoom"];
     self.m_IntroArray=[[NSArray alloc] initWithObjects:@"Fondoo",@"Fondoo",@"Fondoo", nil];
       [self initializeScrollViewForIntroductionScreen];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
   
    [UIView animateWithDuration:0.4 animations:^{
         if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        [self.m_IntroView setFrame:CGRectMake(0, 0, 320, 568)];
         }
        else
        {
         [self.m_IntroView setFrame:CGRectMake(0, 0, 320, 480)];
        }
    }completion:^(BOOL finished)
     {
     [self animateObjects];
     }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Facebook Login
- (IBAction)SignInWithFacebookClicked:(id)sender {
    [self.m_ActivityIndicator startAnimating];
  
    if ([[FBSession activeSession] isOpen]) {
        [FBRequestConnection startWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObject:@"picture.type(large),id,birthday,email,name,gender,interests,username,first_name,last_name,location,likes,albums" forKey:@"fields"] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            
            if (error) {
                NSLog(@"Error %@",error.description);
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error in Authentication" message:@"Please authenticate" delegate:   self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        [self.m_ActivityIndicator stopAnimating];
            }
            else
            {
//                ********************Check If facebook ID is already register or not************************
                BOOL alreadyRegisted=[self LoginWIthID:[NSString stringWithFormat:@"%@",[result objectForKey:@"id"]]];
                if (alreadyRegisted==1) {
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [UIView animateWithDuration:0.4f animations:^{
                            [self.m_IntroView setFrame:CGRectMake(0, -568, 320, 568)];
                            }completion:^(BOOL finished)
                         {
                             
                             AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                             [appdel.window.superview removeFromSuperview];
                             [appdel initializeTabBar];
                         }];
                    

                                    }
                else
                {
                   
                    //                ********************Begin signup Process************************
                      //  NSString *imageURL = [self uploadimage:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=320&height=320",[result objectForKey:@"id"]]]]];
                         NSString *imageURL = [self uploadJPEGImage:kImageUploadFondooPhpFile image:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=320&height=320",[result objectForKey:@"id"]]]]];
                    
                        BOOL  signUpCompleted= [self signUpWithFacebook:[result objectForKey:@"id"] firstName:[result objectForKey:@"first_name"] lastName:[result objectForKey:@"last_name"] birthDay:[result objectForKey:@"birthday"] email:[result objectForKey:@"email"] gender:[result objectForKey:@"gender"] username:[result objectForKey:@"username"] imageURL:imageURL];
                        if (signUpCompleted) {
                    //                ********************Signup Complete now initialize tabbarcontroller************************
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"login"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [UIView animateWithDuration:0.4f animations:^{
                                [self.m_IntroView setFrame:CGRectMake(0, -568, 320, 568)];
                            }completion:^(BOOL finished)
                             {
                                 if (![[NSUserDefaults standardUserDefaults] objectForKey:@"setup"]) {
                                     [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"setup"];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                 }
                                 if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"setup"] isEqualToString:@"yes"]) {
                                     AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                                     [appdel.window.superview removeFromSuperview];
                                     [appdel initializeTabBar];
                                 }
                                 else
                                 {
                                     AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                                     [appdel.window.superview removeFromSuperview];
                                     [appdel initializeBasicSetup];
                                 }
                                 
                             }];
                        }
                        else{
                            
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Problem" message:@"Something went wrong!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    
                                   }
                  [self.m_ActivityIndicator stopAnimating];
                            }
            
        }];
    }
    else
    {
        //                ********************Open Facebook active session************************
        [self OpenSession];
    
    }
    

}

#pragma Facebook Methods

#pragma Facebook Methods
-(void)OpenSession
{//,@"user_location",@"user_likes",@"user_photos"
    //                ********************Set permissions************************
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"user_birthday"] allowLoginUI:YES completionHandler:^(FBSession *session,FBSessionState state,NSError *error)
     {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
            
        case FBSessionStateOpen: {
            //                ********************signup process when active state is opened************************
            [self SignInWithFacebookClicked:nil];
        }
            break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession close];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        [FBSession.activeSession close];
        [FBSession.activeSession closeAndClearTokenInformation];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.description
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)CustomPageControlClicked:(id)sender {
    int page = (int)self.m_CustomPageControl.currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.m_IntroScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.m_IntroScrollView scrollRectToVisible:frame animated:YES];
}

#pragma ScrollView Methods
-(void)initializeScrollViewForIntroductionScreen
{
    
    //                ********************Initialize scrollbar************************
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        [self.m_IntroScrollView setContentSize:CGSizeMake(960, 548)];
        for (int i=0; i<3; i++) {
            //        TopLabel
            UILabel *IntroLabel=[[UILabel alloc] initWithFrame:CGRectMake(320*i+10, 0, 300, 80)];
            IntroLabel.text=[self.m_IntroArray objectAtIndex:i];
            IntroLabel.numberOfLines=0;
            IntroLabel.textAlignment=NSTextAlignmentCenter;
            IntroLabel.font=[UIFont systemFontOfSize:15.0f];
            IntroLabel.textColor=[UIColor whiteColor];
            IntroLabel.backgroundColor=[UIColor clearColor];
            //ImageView
            UIImageView *IntroImage=[[UIImageView alloc] initWithFrame:CGRectMake(320*i+30, 50, 260, 498)];
            [IntroImage setBackgroundColor:[UIColor clearColor]];
            IntroImage.image=[UIImage imageNamed:@"IphoneImage"];
            [self.m_IntroScrollView addSubview:IntroImage];
            [self.m_IntroScrollView addSubview:IntroLabel];
        }
    }
    else
    {
        [self.m_IntroScrollView setContentSize:CGSizeMake(960, 460)];
        for (int i=0; i<3; i++) {
            //        TopLabel
            UILabel *IntroLabel=[[UILabel alloc] initWithFrame:CGRectMake(320*i+10, 0, 300, 60)];
            IntroLabel.text=[self.m_IntroArray objectAtIndex:i];
            IntroLabel.numberOfLines=0;
            IntroLabel.textAlignment=NSTextAlignmentCenter;
            IntroLabel.font=[UIFont systemFontOfSize:12.0f];
            IntroLabel.textColor=[UIColor whiteColor];
            IntroLabel.backgroundColor=[UIColor clearColor];
            //ImageView
            UIImageView *IntroImage=[[UIImageView alloc] initWithFrame:CGRectMake(320*i+45, 50, 235, 430)];
            [IntroImage setBackgroundColor:[UIColor clearColor]];
            //  IntroImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"Screen%d",i ]];
            IntroImage.image=[UIImage imageNamed:@"IphoneImage"];
            [self.m_IntroScrollView addSubview:IntroImage];
            [self.m_IntroScrollView addSubview:IntroLabel];
        }
    }
    }

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.m_IntroScrollView.frame.size.width;
    int page = floor((self.m_IntroScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.m_CustomPageControl.currentPage = page;
}

#pragma Animations
-(void)animateObjects
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // Set the initial and the final values
    [animation setFromValue:[NSNumber numberWithFloat:1.5f]];
    [animation setToValue:[NSNumber numberWithFloat:1.f]];
    
    // Set duration
    [animation setDuration:0.7f];
    
    // Set animation to be consistent on completion
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    // Add animation to the view's layer
    [[self.m_SignUpWithFacebookButton layer] addAnimation:animation forKey:@"scale"];
    [[self.m_PageControl layer] addAnimation:animation forKey:@"scale"];
    [[self.m_IntroScrollView layer] addAnimation:animation forKey:@"scale"];
}

//                ********************Login user************************
-(BOOL)LoginWIthID:(NSString*)facebookID
{
    NSString *body=[NSString stringWithFormat:@"%@%@%@%@",kUserFacebookID,facebookID,kDeviceTokenString,[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
    NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kLogInMethod AndRequestBody:body];
    BOOL isRegisted=[[dict objectForKey:@"return"] boolValue];
    if (isRegisted) {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userinfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return isRegisted;
}
//                ********************Signup user************************
-(BOOL)signUpWithFacebook:(NSString*)facebookID firstName:(NSString*)firstName lastName:(NSString*)lastName birthDay:(NSString*)birthDay email:(NSString*)emailID gender:(NSString*)gender username:(NSString*)username imageURL:(NSString*)ImageUrl
{
    NSString *body=[NSString stringWithFormat:@"&first_name=%@&last_name=%@&dob=%@&email=%@&gender=%@&userfacebookid=%@&username=%@&images=%@%@%@",firstName,lastName,birthDay,emailID,gender,facebookID,[NSString stringWithFormat:@"%@ %@",firstName,lastName],ImageUrl,kDeviceTokenString,[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
      NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kSinUpMethod AndRequestBody:body];
    BOOL signUpcompleted=[[dict objectForKey:@"return"] boolValue];
    if (signUpcompleted) {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userinfo"];
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"data"] forKey:@"userdetails"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return signUpcompleted;
}
//                ********************Upload image************************
- (NSString*)uploadimage:(NSData*)image
{
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
    return url;
   }
- (NSString*)uploadJPEGImage:(NSString*)requestURL image:(NSData*)image
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
    //    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    NSLog(@"image Data lenght :%u",image.length/1024);
    if (image) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:image];
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
    return urlString;
    // Extract the imageurl
}


-(CABasicAnimation *)zoomIn {
    CABasicAnimation *ZoomInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ZoomInAnimation.beginTime = 0.0f;
    ZoomInAnimation.fromValue = [NSNumber numberWithFloat:2.0];
    ZoomInAnimation.autoreverses = YES;
    
    ZoomInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    ZoomInAnimation.duration = 25.0f;
    return ZoomInAnimation;
}

-(CABasicAnimation *)zoomOut {
    CABasicAnimation *ZoomInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ZoomInAnimation.beginTime = 0.0f;
    ZoomInAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    ZoomInAnimation.autoreverses = YES;
    
    ZoomInAnimation.toValue = [NSNumber numberWithFloat:2.0];
    ZoomInAnimation.duration = 25.0f;
    return ZoomInAnimation;
}

-(CAAnimationGroup *)ZoomAnimation {
    CAAnimationGroup *ZoomAnimation = [CAAnimationGroup animation];
    CABasicAnimation *In = [self zoomIn];
    CABasicAnimation *Out = [self zoomOut];
    
    ZoomAnimation.animations = [NSArray arrayWithObjects: In,Out, nil];
    ZoomAnimation.repeatCount = 1000;
    ZoomAnimation.duration = 50.0;
    return ZoomAnimation;
}

@end
