//
//  XLhmSupport.h
//  XtifyLib
//
//  Created by Gilad on 8/Jan/14.
/*
 * IBM Confidential
 * OCO Source Materials
 * 5725E28, 5725I03
 * (c) Copyright IBM Corp. 2011, 2014.
 * The source code for this program is not published or otherwise divested of its trade secrets, irrespective of what has been deposited with the U.S. Copyright Office. */
//

#import <UIKit/UIKit.h>
#define xMarketToAppkey		@"Market_appkey" // Market to app key mapping
#define xCountryToLocale    @"Locale_Desc"


@interface XLhmSupport : NSObject {
    
	NSString *userCountryCode ;
    NSMutableDictionary *appKeyMapping;
    NSMutableDictionary *countryInitialMapping;
    NSMutableDictionary *localeCountryMapping;
    NSMutableDictionary *localeLanguageMapping;
    
}
+(XLhmSupport*) get;

-(void) changeCountryCode:(NSString *)newCountryCode;
-(NSString *)getAppkey ;
- (void) setCountryLocaleDict;

@property (nonatomic, retain) NSString *userCountryCode;
@property (nonatomic, retain) NSMutableDictionary *appKeyMapping;
@property (nonatomic, retain) NSMutableDictionary *localeCountryMapping;
@property (nonatomic, retain) NSMutableDictionary *countryInitialMapping;
@property (nonatomic, retain) NSMutableDictionary *localeLanguageMapping;
@end
