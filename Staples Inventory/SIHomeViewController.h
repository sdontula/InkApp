//
//  SIHomeViewController.h
//  StaplesInventory
//
//  Created by Vinoth on 5/14/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIHomeViewController : UIViewController
{
    IBOutlet UIButton *highSkuButton;
    IBOutlet UIButton *lowSkuButton;
    IBOutlet UIButton *restockSkuButton;
    IBOutlet UIPickerView *storeList;
}

@end
