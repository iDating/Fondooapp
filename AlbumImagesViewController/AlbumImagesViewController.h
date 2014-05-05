//
//  AlbumImagesViewController.h
//  KeithDatingApp
//
//  Created by Mohit on 19/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumImagesCustomCell.h"
#import "AppDelegate.h"
@interface AlbumImagesViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSString *m_AlbumDetail;
@property(nonatomic,strong)NSMutableArray *m_FacebookAlbumImages;
@property(nonatomic,strong)UIActivityIndicatorView *m_ActivityIndicator;
@property(strong,nonatomic)NSString *m_ImageNumber;
@end
