//
//  BioEditViewController.h
//  KeithDatingApp
//
//  Created by Mohit on 28/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceAPIController.h"
@interface BioEditViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *m_BioTextView;
@property(nonatomic)BOOL isTapped;
@property(nonatomic,strong)UILabel *m_CharacterLabel;
-(void)editBioDetails;
@end
