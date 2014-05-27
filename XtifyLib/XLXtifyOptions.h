//
//  XLXtifyOptions.h
//  XtifyLib
//
//  Created by Gilad on 8/Jan/12
/*
 * IBM Confidential
 * OCO Source Materials
 * 5725E28, 5725I03
 * (c) Copyright IBM Corp. 2011, 2014.
 * The source code for this program is not published or otherwise divested of its trade secrets, irrespective of what has been deposited with the U.S. Copyright Office. */
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum _XLBadgeManagedType {
	XLInboxManagedMethod = 0,
    XLDeveloperManagedMethod = 1
} XLBadgeManagedType ;

@interface XLXtifyOptions :NSObject
{
    NSString *xoAppKey;
    BOOL    xoLocationRequired ;
    BOOL    xoBackgroundLocationRequired ;
    BOOL    xoLogging ;
    BOOL    xoMultipleMarkets;
    BOOL    xoNewsstandContent ;
    XLBadgeManagedType xoManageBadge;
    CLLocationAccuracy xoDesiredLocationAccuracy ;
}

+ (XLXtifyOptions *)getXtifyOptions;

- (NSString *)getAppKey ;
- (BOOL) isLocationRequired;
- (BOOL) isBackgroundLocationRequired ;
- (BOOL) isLogging ;
- (BOOL) isMultipleMarkets;
- (BOOL) isNewsstandContent;
- (XLBadgeManagedType)  getManageBadgeType;
- (CLLocationAccuracy ) geDesiredLocationAccuracy ;
- (void)xtLogMessage:(NSString *)header content:(NSString *)message, ...;
@end
