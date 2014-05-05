//
//  CollectionViewCell.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 13/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //**************************** customize collection cell ***********************
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        self.m_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-25)];
        self.m_ImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.m_ImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.m_ImageView];
        
        self.m_TitleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-25, self.bounds.size.width, 25)];
        [self.m_TitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0f]];
        [self.m_TitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.m_TitleLabel setTextColor:[UIColor blackColor]];
        self.m_TitleLabel.backgroundColor=[UIColor whiteColor];
        self.m_TitleLabel.text=@"Album";
        [self.contentView addSubview:self.m_TitleLabel];
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
