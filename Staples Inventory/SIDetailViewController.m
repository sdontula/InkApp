//
//  SIDetailViewController.m
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import "SIDetailViewController.h"
#import "SIImageFetcher.h"

@interface SIDetailViewController (){
    SIImageFetcher *imgFetcher;
}

- (void)configureView;
@end

@implementation SIDetailViewController

@synthesize skuIdLabel, skuDetailLabel, skuCapacityLabel, skuThresholdLabel, skuOnShelfLabel, skuCurrentLevel, skuRestockLevel, skuImageView, currentSku;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//        // Update the view.
//        [self configureView];
//    }
    currentSku = newDetailItem;
}


- (void)configureView
{
    // Update the user interface for the detail item.
//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
//    }
}

- (void)getSku:(id)skuObject{
    currentSku = skuObject;
}

-(void)setLabels{
    skuIdLabel.text = currentSku.sku;
    skuDetailLabel.text = currentSku.description;
    skuCapacityLabel.text = currentSku.capacity;
    skuThresholdLabel.text = currentSku.threshold;
    skuOnShelfLabel.text = currentSku.onShelf;
    skuCurrentLevel.text = currentSku.currentLevel;
    skuRestockLevel.text = currentSku.restockLevel;
    
    
    skuImageView.image = [imgFetcher fetchImage:currentSku.imagePath];
    
    NSNumber  *currentNum = [NSNumber numberWithInteger: [currentSku.currentLevel integerValue]];
    NSNumber  *capacityNum = [NSNumber numberWithInteger: [currentSku.capacity integerValue]];
    
    NSNumber  *thresholdNum = [NSNumber numberWithInteger: [currentSku.threshold integerValue]];
    NSNumber  *onShelfNum = [NSNumber numberWithInteger: [currentSku.onShelf integerValue]];
    
    //if(indexPath.row == 2){
    bool flag = [currentNum intValue] < [capacityNum intValue];
    bool belowThresholdFlag = [onShelfNum intValue] < [thresholdNum intValue];
    if(flag){
        skuOnShelfLabel.backgroundColor = [UIColor redColor];
    }else if(belowThresholdFlag){
        skuOnShelfLabel.backgroundColor = [UIColor yellowColor];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imgFetcher = [[SIImageFetcher alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    self.title = @"Sku Description";
    [self setLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
