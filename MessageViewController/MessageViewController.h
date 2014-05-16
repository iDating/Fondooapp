//
//  MessageViewController.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
@class AppDelegate;
@interface MessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *m_ActivityIndicator;
@property(strong,nonatomic)NSMutableArray *m_MessagesArray;
@property(weak,nonatomic)NSTimer*m_Timer;
@property(nonatomic)BOOL isFirst;

-(void)getMessages;
-(void)stopTimer;
-(void)Setuptableview;
-(void)Setupnavigationcontroller;

@property(nonatomic,strong)AppDelegate *m_Appdel;
@end
