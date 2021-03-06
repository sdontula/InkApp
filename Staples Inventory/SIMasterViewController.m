//
//  SIMasterViewController.m
//  Staples Inventory
//
//  Created by Sarat Dontula on 3/21/14.
//  Copyright (c) 2014 Staples Inc. All rights reserved.
//

#import "SIMasterViewController.h"

#import "SIDetailViewController.h"
#import "SISkuData.h"
#import "SIImageFetcher.h"
#import "AFNetworking.h"
#import "SIAppDelegate.h"

//#define dataURL @"http://127.0.0.1:8082/skuList"
//#define dataURL @"https://raw.githubusercontent.com/sdontula/InkApp/master/Staples%20Inventory/skuListFull.json"

static NSString * const BaseApiURLString = @"http://api.staples.com/v1/10001/product/partnumber/skunumber?locale=en_US&catalogId=10051&zipCode=02421&client_id=JxP9wlnIfCSeGc9ifRAAGku7F4FSdErd";

static int counter = 0;
static bool showAlert = false;

@interface SIMasterViewController () {
    NSMutableArray *_objects;
    SIImageFetcher *imgFetcher;
}
@end

@implementation SIMasterViewController

@synthesize skus = _skus;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    [self retreiveData];
    self.title=@"Staples Ink Inventory";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:nil action:nil];
    imgFetcher = [[SIImageFetcher alloc] init];    
}


- (void)retreiveData{
    counter = 0;
    [self getInventorySkuData];
    //[self getSkuImageURLs];
    [[self tableView]reloadData];
}

- (void)getInventorySkuData{
    SIAppDelegate *appDelegate = (SIAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if([appDelegate isConnectivityAvailabile] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connectivity" message:@"You are not connected to internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSURL * url = [NSURL URLWithString:_dataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    _objects = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    _skus = [[NSMutableArray alloc] init];
    for (int i=0; i<_objects.count; i++) {
        NSString *sku = [[_objects objectAtIndex:i] objectForKey:@"sku"];
        NSString *description = [[_objects objectAtIndex:i] objectForKey:@"description"];
        NSString *store = [[_objects objectAtIndex:i] objectForKey:@"store"];
        NSString *capacity = [[_objects objectAtIndex:i] objectForKey:@"capacity"];
        NSString *restockLevel = [NSString stringWithFormat:@"%@", [[_objects objectAtIndex:i]objectForKey:@"restockLevel"]];
        NSString *threshold = [NSString stringWithFormat:@"%@", [[_objects objectAtIndex:i]objectForKey:@"threshold"]];
        NSString *onShelf = [NSString stringWithFormat:@"%@", [[_objects objectAtIndex:i]objectForKey:@"onShelf"]];
        NSString *currentLevel = [NSString stringWithFormat:@"%@", [[_objects objectAtIndex:i]objectForKey:@"currentLevel"]];
        NSString *imagePath = [[_objects objectAtIndex:i] objectForKey:@"imageUrl"];
        NSString *status = [[_objects objectAtIndex:i] objectForKey:@"status"];
        NSString *alertStatus = [[_objects objectAtIndex:i] objectForKey:@"alertStatus"];
        //NSLog(@"%@",imagePath);
        //NSString *imagePath = @"";
        //if([sku isEqualToString:@"325905"]){
        [_skus addObject:[[SISkuData alloc]initWithDesc:sku description:description store:store capacity:capacity threshold:threshold onShelf:onShelf currentLevel:currentLevel restockLevel:restockLevel imagePath:imagePath status:status alertStatus:alertStatus]];
        //}
    }
}

- (void) getSkuImageURLs{
    for (int i=0; i<_skus.count; i++) {
        //NSString *currentSku = [_skus[i] sku];
        [self getSkuThumbnailUrl:_skus[i]];
    }
}

- (void) getSkuThumbnailUrl:(SISkuData *) sku{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[BaseApiURLString stringByReplacingOccurrencesOfString:@"skunumber" withString:sku.sku] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSArray *productArray = [responseObject valueForKey:@"Product"];
        NSArray *thumbArray = [[[productArray valueForKey:@"thumbnailImage"] valueForKey:@"url"] lastObject];
        [sku setImagePath:[thumbArray lastObject]];
        NSLog(@"%@",[sku imagePath]);
        [self checkCounter];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self checkCounter];
    }];
}

- (void) checkCounter{
    counter++;
    if(counter==(int)_skus.count){
        [[self tableView]reloadData];
    }
}

-(IBAction)doRefresh:(UIRefreshControl *)sender{
    [self retreiveData];
    [sender endRefreshing];
    [self shouldIShowAlert];
    if(showAlert){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Re-Stock Alert" message: @"Found some ink skus which need to be re-stocked" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) shouldIShowAlert{
    showAlert = false;
    for (SISkuData *skuData in _skus){
        //NSNumber  *onShelfNum = [NSNumber numberWithInteger: [skuData.onShelf integerValue]];
        //NSNumber  *thresholdNum = [NSNumber numberWithInteger: [skuData.threshold integerValue]];
        //showAlert = [onShelfNum intValue] < [thresholdNum intValue];
        if( [skuData.alertStatus caseInsensitiveCompare:@"reStock"] == NSOrderedSame ) {
            showAlert = true;
         }
        if(showAlert) break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return _objects.count;
    return _skus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBasicCell" forIndexPath:indexPath];

    SISkuData *skuData = [self.skus objectAtIndex:indexPath.row];
    //NSString *cellText = [[skuData.sku stringByAppendingString:@":"] stringByAppendingString:skuData.description];
    
    cell.textLabel.text = skuData.sku;
    cell.detailTextLabel.text = skuData.description;
    cell.imageView.image = [imgFetcher fetchImage:skuData.imagePath];
    
    //NSLog(@"%@",skuData.imagePath);
    
    //NSNumber  *currentNum = [NSNumber numberWithInteger: [skuData.currentLevel integerValue]];
    //NSNumber  *capacityNum = [NSNumber numberWithInteger: [skuData.capacity integerValue]];
    
    NSNumber  *thresholdNum = [NSNumber numberWithInteger: [skuData.threshold integerValue]];
    NSNumber  *onShelfNum = [NSNumber numberWithInteger: [skuData.onShelf integerValue]];
    
    //bool flag = [currentNum intValue] < [capacityNum intValue];
    //bool belowThresholdFlag = [onShelfNum intValue] < [thresholdNum intValue];
    bool flag = false;
    bool belowThresholdFlag = false;
    if( [skuData.status isEqualToString:@"low"]) {
        flag = true;
    }
    if( [skuData.alertStatus isEqualToString:@"reStock"]) {
        belowThresholdFlag = true;
    }else if([skuData.status isEqualToString:@"high"] && [onShelfNum intValue] < [thresholdNum intValue]){
        belowThresholdFlag = true;
    }
    if(flag){
        cell.contentView.backgroundColor = [UIColor redColor];
    }else if(belowThresholdFlag){
        cell.contentView.backgroundColor = [UIColor yellowColor];
        showAlert = true;
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SISkuData *skuData = _skus[indexPath.row];
        [[segue destinationViewController] setDetailItem:skuData];
    }
}

@end
