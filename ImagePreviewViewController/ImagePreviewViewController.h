//
//  ImagePreviewViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 13/02/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
@interface ImagePreviewViewController : UIViewController<UIScrollViewDelegate>
- (IBAction)closeButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *m_ImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *m_Scrollview;
@property(weak,nonatomic)NSString *m_ImageUrl;
@property(nonatomic)BOOL isTapped;
@end
