//
//  SIImageFetcher.h
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIImageFetcher : NSObject

-(UIImage*)fetchImage:(NSString*)url;

@end
