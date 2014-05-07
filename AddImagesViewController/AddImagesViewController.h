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

@property (nonatomic, retain)   IBOutletCollection(UIButton)        NSArray * m_changeButtons;
@property (nonatomic, retain)   IBOutletCollection(UIButton)        NSArray * m_deleteButtons;
@property (nonatomic, retain)   IBOutletCollection(UIImageView)     NSArray * m_ImageViews;

@property (weak, nonatomic)     IBOutlet    UIScrollView *              m_ScrollView;
@property (weak, nonatomic)     IBOutlet    UIActivityIndicatorView *   m_ActivityIndicator;
@property (strong,nonatomic)                NSMutableDictionary *       m_ImagesDictionary;
@property (nonatomic)                       BOOL                        isFirst;

- (IBAction)changeImageClicked:(id)sender;
- (IBAction)deleteImage:(id)sender;

@end
