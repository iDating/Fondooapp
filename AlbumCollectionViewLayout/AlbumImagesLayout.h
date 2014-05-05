//
//  AlbumImagesLayout.h
//  KeithDatingApp
//
//  Created by Mohit on 19/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString const *AlbumImageCell  =@"AlbumImage";
@interface AlbumImagesLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic, strong) NSDictionary *layoutInfo;
@end
