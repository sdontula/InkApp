//
//  XLXtifyOptions.m
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

#import "XLXtifyOptions.h"
#import "XtifyGlobal.h"

static  XLXtifyOptions *xXtifyOptions=nil;

@implementation XLXtifyOptions

+ (XLXtifyOptions *)getXtifyOptions
{
    if (xXtifyOptions==nil) {
        xXtifyOptions=[[XLXtifyOptions alloc]init];
    }
    return xXtifyOptions;
}

-(id)init
{
    if (self = [super init]) {        
        xoAppKey=xAppKey;
        xoLocationRequired=xLocationRequired;
        xoBackgroundLocationRequired=xRunAlsoInBackground ;
        xoLogging =xLogging ;
        xoMultipleMarkets=xMultipleMarkets;
        xoNewsstandContent =xNewsstandContent ;
        xoManageBadge=xBadgeManagerMethod;
        xoDesiredLocationAccuracy =xDesiredLocationAccuracy ;
    }
    return self;
}

- (NSString *)getAppKey
{
    return xoAppKey;
}
- (BOOL) isLocationRequired
{
    return xoLocationRequired;
}
- (BOOL) isBackgroundLocationRequired 
{
    return xoBackgroundLocationRequired;
}
- (BOOL) isLogging 
{
    return xoLogging;
}
- (BOOL) isMultipleMarkets
{
    return xoMultipleMarkets;
}
- (BOOL) isNewsstandContent
{
    return xoNewsstandContent;
}

- (XLBadgeManagedType)  getManageBadgeType
{
    return xoManageBadge;
}
- (CLLocationAccuracy ) geDesiredLocationAccuracy
{
    return xoDesiredLocationAccuracy;
}
- (void)xtLogMessage:(NSString *)header content:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    if (xoLogging) {
        NSString *prettyFmt=[NSString stringWithFormat:@"%@ %@", header,format];
        NSLogv(prettyFmt, args);
    }
    va_end(args);
}
@end
