//
//  AlbumImagesViewController.m
//  KeithDatingApp
//
//  Created by Mohit on 19/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "AlbumImagesViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIImageView+WebCache.h"
#import "WebServiceAPIController.h"
#import "SharedClass.h"
static NSString *AlbumImageCellIdentifier  =@"AlbumImage";
@interface AlbumImagesViewController ()
{
    SharedClass *data;
}
@property (strong, nonatomic) IBOutlet UICollectionView *m_PhotoCollection;

@end

@implementation AlbumImagesViewController
@synthesize m_ImageNumber;
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
    data=[SharedClass sharedInstance];
  
    self.m_ActivityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    [self.m_ActivityIndicator setColor:kRedColor];
    self.m_ActivityIndicator.hidesWhenStopped=YES;
    UIBarButtonItem *rightBarButon=[[UIBarButtonItem alloc] initWithCustomView:self.m_ActivityIndicator];
    self.navigationItem.rightBarButtonItem=rightBarButon;
    //[self.view addSubview:self.m_ActivityIndicator];
    [self.m_ActivityIndicator startAnimating];


    self.navigationItem.leftBarButtonItem.tintColor=[UIColor darkGrayColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kRedColor}];
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@""
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:nil action:nil];
    self.navigationItem.title=@"Select Photos";
   
    self.m_FacebookAlbumImages=[[NSMutableArray alloc] init];
    [self.m_PhotoCollection registerClass:[AlbumImagesCustomCell class] forCellWithReuseIdentifier: AlbumImageCellIdentifier];
    [self getAlbumImages:self.m_AlbumDetail];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma CollectionView Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.m_FacebookAlbumImages.count!=0) {
        return self.m_FacebookAlbumImages.count;
    }
    
    else
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate *appDel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDel stopTimer];
    NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[self.m_FacebookAlbumImages objectAtIndex:indexPath.section] objectForKey:@"images"] objectAtIndex:0] objectForKey:@"source"]]]];
      //  [self editImages:[self uploadimage:imageData]];
        [self editImages:[self uploadJPEGImage:kImageUploadFondooPhpFile image:imageData]];
        [appDel startTimer];
    }];
    

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumImagesCustomCell *customCell=(AlbumImagesCustomCell*)[collectionView dequeueReusableCellWithReuseIdentifier:AlbumImageCellIdentifier forIndexPath:indexPath];
    
    if (customCell==nil) {
        CALayer *cellImageLayer = customCell.m_ImageView.layer;
        [cellImageLayer setCornerRadius:15.0f];
        [cellImageLayer setMasksToBounds:YES];
    }
    
    if ([self.m_FacebookAlbumImages count]!=0) {
          [customCell.m_ImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[self.m_FacebookAlbumImages objectAtIndex:indexPath.section] objectForKey:@"images"] objectAtIndex:0] objectForKey:@"source"]]]];
    }
    return customCell;
}

-(void)getAlbumImages:(NSString*)albumID
{
    [FBSession openActiveSessionWithReadPermissions:@[@"user_photos"] allowLoginUI:YES completionHandler:^(FBSession *session , FBSessionState state, NSError *error)
     {
    [FBRequestConnection
     startWithGraphPath:[NSString stringWithFormat:@"%@/photos",albumID]
     parameters:nil
     HTTPMethod:@"GET"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {

             self.m_FacebookAlbumImages=[[NSMutableArray alloc] initWithArray:[result objectForKey:@"data"]];
             [self.m_ActivityIndicator stopAnimating];
             [self.m_PhotoCollection reloadData];
         }
                 }];
     }];
}

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
    NSLog(@"Return STring : %@",returnString);
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

-(void)editImages:(NSString*)urlString
{
    //http://deftsoft.info/meetups/services.php?method=setUserDetails&auth_key=1652b43b10208373.99484617&image1=zfh.jpg&dob=05/12/2013&interest=cricket&tagline=testing&img1=test1.jpg&img2=test2.jpg&img3=test3.jpg&img4=test5.jpg&img5=test6.jpg&img6=asdf.jpg&intrestname=circket&interestimage=test.jpg
    
    data=[SharedClass sharedInstance];
    NSString *reqBody=[NSString stringWithFormat:@"%@%@&img%@=%@",kAuthKeyString,[[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"],data.m_ImageNumber,urlString];
    NSDictionary *resultDict=[WebServiceAPIController executeAPIRequestForMethod:kEditUserProfile AndRequestBody:reqBody];
    if ([[resultDict objectForKey:@"return"] boolValue]==1) {
        [data setM_TempImageUrl:urlString];
        [[NSUserDefaults standardUserDefaults] setObject:resultDict forKey:@"userinfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:urlString,@"urlString", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageEdit" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setImage" object:nil userInfo:dict];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else
    {
      //  UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
       // [alert show];
    }

}
#pragma ScaleImageMethod
-(UIImage *)scaleAndRotateImage:(UIImage *)image max:(int)kMaxResolution
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    if (width > kMaxResolution || height > kMaxResolution) {
        
        CGFloat ratio = width/height;
        
        if (ratio > 1) {
            
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        
        else {
            
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    
    else {
        
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    normalizedImage=[self compressMe:normalizedImage width:295 height:137];
    
    return normalizedImage;
}


-(UIImage*)compressMe:(UIImage*)image width:(float)width height:(float)height
{
    CGSize size = [image size];
    
    if( size.width == width && size.height == height){
        
        return image;
    }
    
    CGSize newSize = CGSizeMake(width, height);
    
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.height);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    
    if (image.size.width > image.size.height) {
        
        ratio = newSize.height / image.size.height;
        delta = ratio*(image.size.width - image.size.height);
        offset = CGPointMake(delta/2, 0);
        sz.width=ratio*image.size.width;
        
    }
    else {
        
        ratio = newSize.width / image.size.width;
        delta = ratio*(image.size.height - image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    CGRect clipRect = CGRectMake(0,0, (ratio * image.size.width), (ratio * image.size.height));
    
    CGSize szz = CGSizeMake((ratio * image.size.width), (ratio * image.size.height));
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        
        UIGraphicsBeginImageContextWithOptions(szz, YES, 0.0);
        
    }
    else {
        
        UIGraphicsBeginImageContext(szz);
    }
    
    UIRectClip(clipRect);
    
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
