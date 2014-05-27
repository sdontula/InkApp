//
//  SISkuData.h
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SISkuData : NSObject

@property (strong) NSString *sku;
@property (strong) NSString *description;
@property (strong) NSString *capacity;
@property (strong) NSString *threshold;
@property (strong) NSString *onShelf;
@property (strong) NSString *currentLevel;
@property (strong) NSString *restockLevel;
@property (strong) NSString *imagePath;

- (id)initWithDesc:(NSString*)sku description:(NSString*)description capacity:(NSString*)capacity threshold:(NSString*)threshold onShelf:(NSString*)onShelf currentLevel:(NSString*)currentLevel restockLevel:(NSString*)restockLevel imagePath:(NSString*)imagePath;

@end
