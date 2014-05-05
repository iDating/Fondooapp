//
//  AppDelegate.h
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebServiceAPIController.h"
#import "Reachability.h"
#import "MessageViewController.h"
#import "Flurry.h"
@class MessageViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate>
{
       MessageViewController *msgVC;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,nonatomic)UITabBarController *m_TabBarController;
@property(weak,nonatomic)NSTimer *m_Timer;

-(void)stopTimer;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)initializeTabBar;
-(void)initiaLizeIntroView;
-(void)initializeBasicSetup;
-(void)startTimer;

@end
