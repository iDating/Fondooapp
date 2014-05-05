//
//  AlbumImagesCustomCell.m
//  KeithDatingApp
//
//  Created by Mohit on 19/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "AlbumImagesCustomCell.h"

@implementation AlbumImagesCustomCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //**************************** customize collection cell ***********************
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        //        self.layer.borderColor = [UIColor whiteColor].CGColor;
        //        self.layer.borderWidth = 3.0f;
        //        self.layer.shadowColor = [UIColor blackColor].CGColor;
        //        self.layer.shadowRadius = 3.0f;
        //        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        //        self.layer.shadowOpacity = 0.5f;
        
        self.m_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.m_ImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.m_ImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.m_ImageView];
        
        
               // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.m_ImageView.image = nil;
}

@end
