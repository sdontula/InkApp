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

//#define dataURL @"http://127.0.0.1:8082/skuList"
#define dataURL @"https://raw.githubusercontent.com/sdontula/InkApp/master/Staples%20Inventory/skuList.json"


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

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    [self retreiveData];
    self.title=@"Staples Ink Inventory";
    imgFetcher = [[SIImageFetcher alloc] init];    
}


- (void)retreiveData{
    NSURL * url = [NSURL URLWithString:dataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    _objects = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    _skus = [[NSMutableArray alloc] init];
    for (int i=0; i<_objects.count; i++) {
        NSString *sku = [[_objects objectAtIndex:i] objectForKey:@"sku"];
        NSString *description = [[_objects objectAtIndex:i] objectForKey:@"description"];
        NSString *capacity = [[_objects objectAtIndex:i] objectForKey:@"capacity"];
        NSString *threshold = [[_objects objectAtIndex:i] objectForKey:@"threshold"];
        NSString *imagePath = [[_objects objectAtIndex:i] objectForKey:@"imageUrl"];
        [_skus addObject:[[SISkuData alloc]initWithDesc:sku description:description capacity:capacity threshold:threshold imagePath:imagePath]];
    }
    [[self tableView]reloadData];
}

-(IBAction)doRefresh:(UIRefreshControl *)sender{
    [self retreiveData];
    [sender endRefreshing];
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
    
    if(indexPath.row == 2){
        cell.backgroundColor = [UIColor redColor];
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
