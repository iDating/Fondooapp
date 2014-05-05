//
//  ConversationViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 09/01/14.
//  Copyright (c) 2014 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBubbleTableViewDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import "EGORefreshTableHeaderView.h"
#import "UserDetailsViewController.h"

@interface ConversationViewController : UIViewController<UIBubbleTableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate,UITableViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIBubbleTableView *m_ConversationTable;
@property(strong,nonatomic)NSDictionary *m_userInfo;
@property(strong,nonatomic)NSMutableArray *m_ConversationArray;
@property(strong,nonatomic)NSBubbleData *m_MybubbleData;
@property (strong, nonatomic) IBOutlet UIView *m_TextviewBackground;
@property (strong, nonatomic) IBOutlet UITextField *m_MessageField;
@property(strong,nonatomic)NSBubbleData *m_OtherBubbleData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
@property(weak,nonatomic)NSTimer *m_MessageTimer;
@property(nonatomic)BOOL isFirst;
@property(nonatomic)BOOL isChecked;
@property(nonatomic)BOOL isSuccess;
@property(nonatomic)int previousCount;
@property(nonatomic)BOOL ispageSet;
@property(nonatomic)BOOL isRefresh;
@property(nonatomic)BOOL isPaused;
@property(strong,nonatomic)NSMutableDictionary *m_MessageDictionary;
@property (weak, nonatomic) IBOutlet UITextView *m_TextView;
@property(strong,nonatomic)UIActivityIndicatorView *m_MessageLoadingView;
@property (weak, nonatomic) IBOutlet UITextView *m_MessageTextView;
-(void)StartTimerForConversation;
-(void)stopTimerForConversation;
@end
