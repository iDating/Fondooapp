//
//  CustomTableCell.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 09/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *m_PostImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_StatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_NameLabel;
@property (weak, nonatomic) IBOutlet UIButton *m_UserProfileImage;
@property (weak, nonatomic) IBOutlet UIView *m_DisplayView;

@property (weak, nonatomic) IBOutlet UIView *m_view;
@property (weak, nonatomic) IBOutlet UIButton *m_LocationButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_indicator;
@property (weak, nonatomic) IBOutlet UIView *m_LocationView;


@end
