//
//  AppDelegate.m
//  KeithDatingApp
//
//  Created by Devansh Bhardwaj on 03/12/13.
//  Copyright (c) 2013 Devansh Bhardwaj. All rights reserved.
//

#import "AppDelegate.h"
#import "IntroViewController.h"
#import "FeedViewController.h"
#import "MapViewController.h"
#import "MessageViewController.h"
#import "AccountViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize m_Timer;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //*********************Provide Google API Key*************************
        [GMSServices provideAPIKey:[NSString stringWithFormat:@"%@",kGoogleAPIKEY]];
    [Flurry setCrashReportingEnabled:YES];
    
    // Replace YOUR_API_KEY with the api key in the downloaded package
    [Flurry startSession:kFlurryAPIKey];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        if ([UIScreen mainScreen].bounds.size.height==568.0) {
            [[NSUserDefaults standardUserDefaults] setInteger:568 forKey:@"screen"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:480 forKey:@"screen"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //    **********************check if login is done**********************
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]==YES) {
            [self initializeTabBar];
        }
        else
        {
            [self initiaLizeIntroView];
            //  m_Timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startTimer:) userInfo:nil repeats:YES];
        }
    
  application.applicationIconBadgeNumber = 0;
        // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)stopTimer
{
    [self.m_Timer invalidate];
    self.m_Timer=nil;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KeithDatingApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KeithDatingApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}
-(void)startTimer{
m_Timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(startTimer:) userInfo:nil repeats:YES];
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
-(void)initializeTabBar
{
    self.m_TabBarController=[[UITabBarController alloc] init];
    FeedViewController *feedVC;
    MapViewController *mapVC;
 
    AccountViewController *acctVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
    feedVC=[[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
        mapVC=[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        msgVC=[[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        acctVC=[[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil];
    }
    else
    {
        feedVC=[[FeedViewController alloc] initWithNibName:@"FeedViewController_iPhone4" bundle:nil];
        mapVC=[[MapViewController alloc] initWithNibName:@"MapViewController_iPhone4" bundle:nil];
        msgVC=[[MessageViewController alloc] initWithNibName:@"MessageViewController_iPhone4" bundle:nil];
        acctVC=[[AccountViewController alloc] initWithNibName:@"AccountViewController_iPhone4" bundle:nil];
    }
    
    UINavigationController *feedNav=[[UINavigationController alloc] initWithRootViewController:feedVC];
    UIImage *feedImage = [UIImage imageNamed:@"Feed_Selected"];
    UIImage *feedUnSelectedImage = [UIImage imageNamed:@"Feed_Unselected"];
    
    feedImage = [feedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    feedUnSelectedImage = [feedUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    feedNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:feedUnSelectedImage selectedImage:feedImage];
    feedNav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);
    
    UINavigationController *mapNav=[[UINavigationController alloc] initWithRootViewController:mapVC];
    UIImage *mapImage=[UIImage imageNamed:@"Map_Selected"];
    UIImage *mapUnSelectedImage=[UIImage imageNamed:@"Map_UnSelected"];
    mapImage=[mapImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mapUnSelectedImage=[mapUnSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mapNav.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"" image:mapUnSelectedImage selectedImage:mapImage];
    mapNav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);
    
    UINavigationController *msgNav=[[UINavigationController alloc] initWithRootViewController:msgVC];
    UIImage *msgImage=[UIImage imageNamed:@"Chat_Selected"];
    UIImage *msgUnselected=[UIImage imageNamed:@"Chat_UnSelected"];
    msgImage=[msgImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    msgUnselected=[msgUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    msgNav.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"" image:msgUnselected selectedImage:msgImage];
    msgNav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);
    
    UINavigationController *acctNav=[[UINavigationController alloc] initWithRootViewController:acctVC];
    UIImage *acctImage=[UIImage imageNamed:@"Account_Selected"];
    UIImage *acctUnselected=[UIImage imageNamed:@"Account_UnSelected"];
    acctImage=[acctImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    acctUnselected=[acctUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    acctNav.tabBarItem=[[UITabBarItem alloc] initWithTitle:@"" image:acctUnselected selectedImage:acctImage];
acctNav.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);
    
    self.m_TabBarController.viewControllers=[NSArray arrayWithObjects:feedNav,mapNav,msgNav,acctNav, nil];
    self.m_TabBarController.delegate=self;
    
    self.window.rootViewController=self.m_TabBarController;
   // [self startTimer];
    m_Timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(startTimer:) userInfo:nil repeats:YES];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"message" object:nil];
}

-(void)initiaLizeIntroView

{
    IntroViewController *introView;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
       introView =[[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
            }
    else
    {
       introView =[[IntroViewController alloc] initWithNibName:@"IntroViewController_iPhone4" bundle:nil];
    }
    self.window.rootViewController=introView;

}

-(void)initializeBasicSetup
{
    BasicSetupViewController *basicSetupVC;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"screen"]==568) {
        basicSetupVC =[[BasicSetupViewController alloc] initWithNibName:@"BasicSetupViewController" bundle:nil];
    }
    else
    {
        basicSetupVC =[[BasicSetupViewController alloc] initWithNibName:@"BasicSetupViewController_iPhone4" bundle:nil];
    }
    self.window.rootViewController=basicSetupVC;
  
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
  
       return [FBSession.activeSession handleOpenURL:url];
        
   // return YES;
   
}


#pragma TabBar Delegate Method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [tabBarController.tabBar setHidden:NO];
    tabBarController.tabBarController.hidesBottomBarWhenPushed=NO;
    UIImage *selectedImage;
    UIImage *UnselectedImage;
 
        switch (tabBarController.selectedIndex) {
        case 0:
            selectedImage = [UIImage imageNamed:@"Feed_Selected"];
            UnselectedImage = [UIImage imageNamed:@"Feed_Unselected"];
            
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UnselectedImage = [UnselectedImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
            
            viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:UnselectedImage selectedImage:selectedImage];
              
     break;
            
            case 1:
            selectedImage = [UIImage imageNamed:@"Map_Selected"];
            UnselectedImage = [UIImage imageNamed:@"Map_UnSelected"];
            
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UnselectedImage = [UnselectedImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
            
            viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:UnselectedImage selectedImage:selectedImage];
            break;
            
            case 2:
            selectedImage = [UIImage imageNamed:@"Chat_Selected"];
            UnselectedImage = [UIImage imageNamed:@"Chat_UnSelected"];
            
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UnselectedImage = [UnselectedImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
            
            viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:UnselectedImage selectedImage:selectedImage];
            break;
        case 3:
            selectedImage = [UIImage imageNamed:@"Account_Selected"];
            UnselectedImage = [UIImage imageNamed:@"Account_UnSelected"];
            
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            UnselectedImage = [UnselectedImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
            
            viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"" image:UnselectedImage selectedImage:selectedImage];
            break;
            
            
        default:
            break;
    }
       viewController.tabBarItem.imageInsets=UIEdgeInsetsMake(5, 0, -5, 0);
}
#pragma Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}

/*
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 });
 */
-(void)startTimer:(NSTimer *)timer
{
    /*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *dict=[WebServiceAPIController executeAPIRequestForMethod:kMessageCount AndRequestBody:[NSString stringWithFormat:@"%@%@",kAuthKeyString, [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"] objectForKey:@"data"] objectForKey:@"userDetails"]objectForKey:@"auth_key"] ]];
        if ([[dict objectForKey:@"return"] intValue]==1) {
            //   unreadusers
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"unreadusers"] ] isEqualToString:@"0"]) {
                    [[[[[self m_TabBarController] tabBar] items]
                      objectAtIndex:2] setBadgeValue:0];
                }
                else
                {
                    if (self.m_TabBarController.selectedIndex!=2) {
                        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
                        localNotification.alertBody = @"You have a new message";
                        localNotification.timeZone = [NSTimeZone defaultTimeZone];
                        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

                    }
                    [[[[[self m_TabBarController] tabBar] items]
                      objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%@",[dict objectForKey:@"unreadusers"]]];
                }
            });
        }
    });
     */
    [msgVC getMessages];

}
#pragma Fetch device token
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    if (!TARGET_IPHONE_SIMULATOR)
    {
        NSString *strdeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
        
        
        
        strdeviceToken=[strdeviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        
        strdeviceToken=[strdeviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
        
        strdeviceToken=[strdeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSLog(@"%@",strdeviceToken);
        [[NSUserDefaults standardUserDefaults] setObject:strdeviceToken forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"My token is: %@", deviceToken);
}

@end
