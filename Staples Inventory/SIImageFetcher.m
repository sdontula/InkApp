//
//  SIImageFetcher.m
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import "SIImageFetcher.h"

@implementation SIImageFetcher

-(UIImage*)fetchImage:(NSString*)url{
    NSString *ImageURL =[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    UIImage *myImage = [UIImage imageWithData:data];
    return myImage;
}

@end
