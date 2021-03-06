//
//  SIDetailViewController.h
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SISkuData.h"

@interface SIDetailViewController : UIViewController

//@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *skuIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuCapacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuCurrentLevel;
@property (weak, nonatomic) IBOutlet UILabel *skuRestockStaticTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuRestockLevel;
@property (weak, nonatomic) IBOutlet UILabel *skuThresholdLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuOnShelfLabel;
@property (weak, nonatomic) IBOutlet UIImageView *skuImageView;
@property (weak, nonatomic) SISkuData *currentSku;
@property (weak, nonatomic) IBOutlet UIButton *restockButton;

- (IBAction)reStock:(id)sender;

- (void)getSku:(id)skuObject;
- (void)setLabels;
- (void)setDetailItem:(id)newDetailItem;
@end
