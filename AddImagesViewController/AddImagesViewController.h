//
//  AddImagesViewController.h
//  KeithDatingApp
//
//  Created by Mohit on 28/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "WebServiceAPIController.h"
#import "AlbumImagesViewController.h"
#import "AlbumsCollectionViewController.h"
#import "SharedClass.h"
@interface AddImagesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *m_Button1;
@property (weak, nonatomic) IBOutlet UIButton *m_Button2;
- (IBAction)changeImageClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *m_ScrollView;
- (IBAction)deleteImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *m_Button3;
@property (weak, nonatomic) IBOutlet UIButton *m_Button4;
@property (weak, nonatomic) IBOutlet UIButton *m_Button5;
@property (weak, nonatomic) IBOutlet UIButton *m_Button6;
@property(strong,nonatomic)NSMutableDictionary *m_ImagesDictionary;
@property(nonatomic)BOOL isFirst;
@end
