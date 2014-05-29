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
@synthesize store = _store;
@synthesize capacity = _capacity;
@synthesize threshold = _threshold;
@synthesize onShelf = _onShelf;
@synthesize currentLevel = _currentLevel;
@synthesize restockLevel = _restockLevel;
@synthesize imagePath = _imagePath;

- (id)initWithDesc:(NSString*)sku description:(NSString*)description store:(NSString*)store capacity:(NSString*)capacity threshold:(NSString*)threshold onShelf:(NSString*)onShelf currentLevel:(NSString*)currentLevel restockLevel:(NSString*)restockLevel imagePath:(NSString*)imagePath{
    if ((self = [super init])) {
        self.sku = sku;
        self.description = description;
        self.store = store;
        self.imagePath = imagePath;
        self.capacity = capacity;
        self.currentLevel = currentLevel;
        self.restockLevel = restockLevel;
        self.threshold = threshold;
        self.onShelf = onShelf;
    }
    return self;
}

@end
