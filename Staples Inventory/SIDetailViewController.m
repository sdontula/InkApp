//
//  SIDetailViewController.m
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import "SIDetailViewController.h"
#import "SIImageFetcher.h"
#import "urlConstants.h"


@interface SIDetailViewController (){
    SIImageFetcher *imgFetcher;
}

- (void)configureView;
@end

@implementation SIDetailViewController

@synthesize skuIdLabel, skuDetailLabel, skuCapacityLabel, skuThresholdLabel, skuOnShelfLabel, skuCurrentLevel, skuRestockLevel, skuImageView, currentSku, restockButton;

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

- (IBAction)reStock:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSString *urlString = [RESTOCKURL stringByReplacingOccurrencesOfString:@"$store$" withString:currentSku.store];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"$sku$" withString:currentSku.sku];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
           if(error){
               NSString *errorMessage = [NSString stringWithFormat:@"Unable to connect to store inventory service. More Error Information: %@", error];
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
               [alert show];               
           }
           else if(data!=nil){
               [spinner stopAnimating];
               NSString *alertMessage = [NSString stringWithFormat:@"Sku %@ at store %@ is restocked sucessfully. Refresh table to see updated data.", currentSku.sku,currentSku.store];
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
               [alert show];
           }
    }];
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
    
    //NSNumber  *currentNum = [NSNumber numberWithInteger: [currentSku.currentLevel integerValue]];
    //NSNumber  *capacityNum = [NSNumber numberWithInteger: [currentSku.capacity integerValue]];
    
    //NSNumber  *thresholdNum = [NSNumber numberWithInteger: [currentSku.threshold integerValue]];
    //NSNumber  *onShelfNum = [NSNumber numberWithInteger: [currentSku.onShelf integerValue]];
    
    //if(indexPath.row == 2){
    //bool flag = [currentNum intValue] < [capacityNum intValue];
    //bool belowThresholdFlag = [onShelfNum intValue] < [thresholdNum intValue];
    bool flag = false;
    bool belowThresholdFlag = false;
    if( [currentSku.status caseInsensitiveCompare:@"low"] == NSOrderedSame ) {
        flag = true;
    }
    if( [currentSku.alertStatus caseInsensitiveCompare:@"reStock"] == NSOrderedSame ) {
        belowThresholdFlag = true;
        restockButton.userInteractionEnabled = YES;
        restockButton.hidden = NO;
    }
    
    if(flag){
        skuCurrentLevel.backgroundColor = [UIColor redColor];
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
    restockButton.userInteractionEnabled = NO;
    restockButton.hidden = YES;
    [self setLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
