//
//  SISkuData.m
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import "SISkuData.h"

@implementation SISkuData

@synthesize sku = _sku;
@synthesize description = _description;
@synthesize capacity = _capacity;
@synthesize threshold = _threshold;
@synthesize currentLevel = _currentLevel;
@synthesize imagePath = _imagePath;

- (id)initWithDesc:(NSString*)sku description:(NSString*)description capacity:(NSString*)capacity threshold:(NSString*)threshold currentLevel:(NSString*)currentLevel imagePath:(NSString*)imagePath{
    if ((self = [super init])) {
        self.sku = sku;
        self.description = description;
        self.imagePath = imagePath;
        self.capacity = capacity;
        self.currentLevel = currentLevel;
        self.threshold = threshold;
    }
    return self;
}

@end
