//
//  SIAppDelegate.m
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import "SIAppDelegate.h"
#import "SISkuData.h"
#import "SIMasterViewController.h"
#import "SI_Reachability.h"
#import "XLappMgr.h"

@implementation SIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //UINavigationController *navController = (UINavigationController *) self.window.rootViewController;
    //SIMasterViewController *masterController = [navController.viewControllers objectAtIndex:0];
    //masterController.skus = skus;
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil)
    {
        NSDictionary * aPush =[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self handleAnyNotification:aPush];
    }
    return YES;
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
    NSLog(@"Application is about to Enter Background");
    [[XLappMgr get] appEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"Application moved to Foreground");
    [[XLappMgr get] appEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"Application moved from inactive to Active state");
    [[XLappMgr get] appEnterActive];
    application.applicationIconBadgeNumber = 0;  // Reset the badge number on the application icon.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
    [[XLappMgr get] applicationWillTerminate];
}

- (BOOL)isConnectivityAvailabile
{
    BOOL available = YES;
    
    SI_Reachability *networkReachability = [SI_Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        available = NO;
    }
    
    return available;
    
}

- init
{
    if (self == [super init]) {
        XLXtifyOptions *anXtifyOptions=[XLXtifyOptions getXtifyOptions];
        [[XLappMgr get ]initilizeXoptions:anXtifyOptions];
    }
    return self;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSLog(@"Succeeded registering for push notifications. Device token: %@", devToken);
    [[XLappMgr get] registerWithXtify:devToken ];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)launchOptions
{
    NSLog(@"Receiving notification, app is running");
    NSDictionary * aPush=[[NSDictionary alloc] initWithDictionary:launchOptions];
    [self handleAnyNotification:aPush];
    //[aPush release];
}

- (void)handleAnyNotification:(NSDictionary *)aPush
{
    [[XLappMgr get] setBadgeCountSpringBoardAndServer:0];
    // Update Notification Click metrics
    [[XLappMgr get]insertNotificationClick:aPush];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    NSLog(@"Failed to register with error: %@", error);
    [[XLappMgr get] registerWithXtify:nil ];
}
@end
