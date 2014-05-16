//
//  ImagePreviewViewController.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 13/02/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import "ImagePreviewViewController.h"

@interface ImagePreviewViewController ()

@end

@implementation ImagePreviewViewController
@synthesize m_ImageUrl;
@synthesize isTapped;
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
    isTapped=NO;
    UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
    
    tapOnce.numberOfTapsRequired = 1;
    tapTwice.numberOfTapsRequired = 2;
    //stops tapOnce from overriding tapTwice
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    
    //then need to add the gesture recogniser to a view - this will be the view that recognises the gesture
    [self.view addGestureRecognizer:tapOnce];
    [self.view addGestureRecognizer:tapTwice];
    __block UIImageView * imageView = self.m_ImageView;
    NSURLRequest *url_request = [NSURLRequest requestWithURL:[NSURL URLWithString:m_ImageUrl]];
    [self.m_ImageView setImageWithURLRequest:url_request placeholderImage:[UIImage imageNamed:@"PreviewFrame"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if (image) {
            float widthRatio = self.m_ImageView.bounds.size.width / self.m_ImageView.image.size.width;
            float heightRatio = self.m_ImageView.bounds.size.height / self.m_ImageView.image.size.height;
            float scale = MIN(widthRatio, heightRatio);
            float imageWidth = scale * self.m_ImageView.image.size.width;
            float imageHeight = scale * self.m_ImageView.image.size.height;
            
            self.m_ImageView.frame = CGRectMake(self.m_ImageView.frame.origin.x,(self.m_ImageView.frame.size.height-imageHeight)/2, imageWidth, imageHeight);
            self.m_ImageView.center = self.m_ImageView.superview.center;
            
            [imageView setImage:image];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)tapOnce:(UIGestureRecognizer *)gesture
{
    
}
- (void)tapTwice:(UIGestureRecognizer *)gesture
{
    //on a double tap, call zoomToRect in UIScrollView
      isTapped=!isTapped;
    CGFloat newZoomScale;
    if (isTapped==YES) {
        newZoomScale = self.m_Scrollview.zoomScale * 2.0f;
    }
    else
    {
          newZoomScale = 1.0;
    }
    CGPoint pointInView = [gesture locationInView:self.m_ImageView];
    
    // 2
  
    newZoomScale = MIN(newZoomScale, self.m_Scrollview.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.m_Scrollview.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.m_Scrollview zoomToRect:rectToZoomTo animated:YES];
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Scrollview Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.m_ImageView;
}
- (void)zoomToPoint:(CGPoint)zoomPoint withScale: (CGFloat)scale animated: (BOOL)animated
{
    //Normalize current content size back to content scale of 1.0f
    CGSize contentSize;
    contentSize.width = (self.m_Scrollview.contentSize.width / self.m_Scrollview.zoomScale);
    contentSize.height = (self.m_Scrollview.contentSize.height / self.m_Scrollview.zoomScale);
    
    //translate the zoom point to relative to the content rect
    zoomPoint.x = (zoomPoint.x / self.m_Scrollview.bounds.size.width) * contentSize.width;
    zoomPoint.y = (zoomPoint.y / self.m_Scrollview.bounds.size.height) * contentSize.height;
    
    //derive the size of the region to zoom to
    CGSize zoomSize;
    zoomSize.width = self.m_Scrollview.bounds.size.width / scale;
    zoomSize.height = self.m_Scrollview.bounds.size.height / scale;
    
    //offset the zoom rect so the actual zoom point is in the middle of the rectangle
    CGRect zoomRect;
    zoomRect.origin.x = zoomPoint.x - zoomSize.width / 2.0f;
    zoomRect.origin.y = zoomPoint.y - zoomSize.height / 2.0f;
    zoomRect.size.width = zoomSize.width;
    zoomRect.size.height = zoomSize.height;
    
    //apply the resize
    [self.m_Scrollview zoomToRect: zoomRect animated: animated];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}
- (void)centerScrollViewContents {
    CGSize boundsSize = self.m_Scrollview.bounds.size;
    CGRect contentsFrame = self.m_ImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.m_ImageView.frame = contentsFrame;
}

@end
