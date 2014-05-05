//
//  AlbumsCollectionViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 13/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
@interface AlbumsCollectionViewController : UICollectionViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSMutableArray *m_facebookAlbumArray;
@property(nonatomic,strong)NSMutableArray *m_FacebookAlbumCover;
@property(nonatomic,strong)NSMutableArray *m_FacebookAlbumIDs;
@property(nonatomic,strong)UIActivityIndicatorView *m_ActivityIndicator;
@property(nonatomic,strong)NSString *m_ImageNumber;
@property(nonatomic,strong)NSMutableArray *m_AlbumsArray;
@end
