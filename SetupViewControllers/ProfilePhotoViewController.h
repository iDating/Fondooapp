//
//  ProfilePhotoViewController.h
//  KeithDatingApp
//
//  Created by ShiYangYang on 5/10/14.
//  Copyright (c) 2014 Ankush Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfilePhotoViewController : UIViewController
{
    BOOL    isFirst;
}

@property (nonatomic, retain) IBOutletCollection(UIButton)      NSMutableArray *    arrEditButton;
@property (nonatomic, retain) IBOutletCollection(UIButton)      NSMutableArray *    arrDeleteButton;
@property (nonatomic, retain) IBOutletCollection(UIImageView)   NSMutableArray *    arrPhotoView;

@property (nonatomic, retain) IBOutlet  UIView *  container;

@property (nonatomic, retain) IBOutlet  UIActivityIndicatorView *   activityIndicator;

@property (strong,nonatomic)                NSMutableDictionary *       imagesDictionary;

@property BOOL                              fromSettings;

@end
