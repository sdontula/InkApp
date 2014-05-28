//
//  SIHomeViewController.m
//  StaplesInventory
//
//  Created by Vinoth on 5/14/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import "SIHomeViewController.h"
#import "SIMasterViewController.h"
#import "SIAppDelegate.h"
#import "XLappMgr.h"

#define STORELISTURL @"http://velocitylinux:3001/storeList"
#define STORESKUURL @"http://velocitylinux:3001/skuList?store="

@interface SIHomeViewController ()
{
    NSMutableArray *storeNumber;
    NSMutableArray *storeAddress;
    NSString *skuURL;
    int selectedRow;
}

- (void)getStoreList;
- (IBAction)refreshStoreList:(id)sender;
- (IBAction)highProfileSKUList:(id)sender;
- (IBAction)lowProfileSKUList:(id)sender;

@end

@implementation SIHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    storeNumber = [[NSMutableArray alloc] init];
    storeAddress = [[NSMutableArray alloc]init];
    skuURL = nil;
  
    // Do any additional setup after loading the view.
    [highSkuButton setHidden:YES];
    [lowSkuButton setHidden:YES];
    [self getStoreList];
    self.title=@"Choose Your Store";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Store" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (IBAction)refreshStoreList:(id)sender
{
    [self getStoreList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    
}

- (void)getStoreList
{
  
    SIAppDelegate *appDelegate = (SIAppDelegate *)[[UIApplication sharedApplication]delegate];
                                                   
    if([appDelegate isConnectivityAvailabile] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connectivity" message:@"You are not connected to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [storeList setHidden:YES];
    if([storeAddress count]>0)
    {
        [storeAddress removeAllObjects];
    }
    
    if([storeNumber count]>0)
    {
        [storeNumber removeAllObjects];
    }

    [storeAddress addObject:@"Please select your store"];
    [storeNumber addObject:@""];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:STORELISTURL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(error)
                               {
                                   NSString *errorMessage = [NSString stringWithFormat:@"Unable to connect to store inventory service. More Error Information: %@", error];
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                   [alert show];
                                   
                               }
                               else if(data!=nil)
                               {
                               
                               NSMutableArray *_objects = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                               for (int i=0; i<_objects.count; i++) {
                                   if([_objects indexOfObject:@"storeNum"])
                                   {
                                       [storeNumber addObject:[[[_objects objectAtIndex:i] objectForKey:@"storeNum"] stringByReplacingOccurrencesOfString:@" " withString:@""]];
                                   }
                                   if([_objects indexOfObject:@"address"])
                                   {
                                       [storeAddress addObject:[[_objects objectAtIndex:i] objectForKey:@"address"]];
                                   }
                                   
                               }
                                   }
                            
                                   if([storeNumber count]>1)
                                   {
                                       [storeList setHidden:NO];
                                       [storeList reloadAllComponents];
                                   }
                                   [spinner stopAnimating];
                                   
                             
                               
                               
                           }];
    
    
    

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([sender tag] == 1 )
    {
    [[segue destinationViewController] setDataURL:skuURL];
    }
    
    else{
    [[segue destinationViewController] setDataURL:skuURL];
    
    }
    NSLog(@"skuURL=%@",skuURL);
}

#pragma mark - Picker View Data Source Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return [storeAddress count];
}

#pragma mark - Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    NSString *value = nil;
    if([storeAddress count]>0)
    {
        value = [NSString stringWithFormat:@"%@-%@",[storeNumber objectAtIndex:row], [storeAddress objectAtIndex:row]];
        NSLog(@"1=%@ 2=%@",[storeNumber objectAtIndex:row],[storeAddress objectAtIndex:row]);
    }
    return value;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *retval = (id)view;
    
    if([storeAddress count]>0)
    {
    if (!retval) {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    [retval setTextAlignment:NSTextAlignmentCenter];
    retval.text = [NSString stringWithFormat:@"%@   %@",[storeNumber objectAtIndex:row], [storeAddress objectAtIndex:row]];
        
    retval.font = [UIFont systemFontOfSize:10];
    }
    return retval;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(row == 0)
    {
        [highSkuButton setHidden:YES];
        [lowSkuButton setHidden:YES];
    }
    else
    {
        
        selectedRow =row;
        [highSkuButton setHidden:NO];
        [lowSkuButton setHidden:NO];
        
        //Tag the xid with store number tag.
        NSMutableArray *tagsArray = [[NSMutableArray alloc] init];
        [tagsArray addObject:[storeNumber objectAtIndex:row]];
        [[XLappMgr get] setTag:tagsArray];
    }
}
- (IBAction)lowProfileSKUList:(id)sender
{
    skuURL = [NSString stringWithFormat:@"%@%@&status=low",STORESKUURL,[storeNumber objectAtIndex:selectedRow]];
}
- (IBAction)highProfileSKUList:(id)sender
{
    skuURL = [NSString stringWithFormat:@"%@%@&status=high",STORESKUURL,[storeNumber objectAtIndex:selectedRow]];
}

@end
