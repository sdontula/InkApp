//
//  SIAppDelegate.h
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLappMgr;

@interface SIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)isConnectivityAvailabile;

@end
