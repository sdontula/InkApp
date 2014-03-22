//
//  SIMasterViewController.h
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIMasterViewController : UITableViewController

@property (strong) NSMutableArray *skus;

- (void)retreiveData;
-(IBAction)doRefresh:(UIRefreshControl *)sender;
@end
