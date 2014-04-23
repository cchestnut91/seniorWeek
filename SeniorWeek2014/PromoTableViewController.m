//
//  PromoTableViewController.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/20/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "PromoTableViewController.h"
#import "PromoTableViewCell.h"
#import "PromoViewController.h"

@interface PromoTableViewController ()

@end

@implementation PromoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    self.docPath = [docDirectory stringByAppendingPathComponent:@"savedPromos.plist"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:_docPath]){
        self.savedPromos = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:_docPath];
        if (self.savedPromos == nil){
            self.savedPromos = [[NSMutableArray alloc] init];
        }
    } else {
        self.savedPromos = [[NSMutableArray alloc] init];
        NSLog(@"File doesn't exist");
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([self.savedPromos count] == 0){
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0){
        if (self.promos.count == 0){
            return 1;
        }
        return self.promos.count;
    } else {
        return self.savedPromos.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"Promos Near You";
    } else {
        return @"Saved Promos";
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.promos.count == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noPromoCell"];
        return cell;
    }
    PromoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"promoCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    Beacon *promoBeacon;
    
    if (indexPath.section == 0){
        promoBeacon = [self.promos objectAtIndex:indexPath.row];
    } else {
        promoBeacon = [self.savedPromos objectAtIndex:indexPath.row];
    }
    
    [cell.label setText:promoBeacon.title];
    
    if (indexPath.section == 1){
        [cell.starButton setImage:[UIImage imageNamed:@"Star_Active"] forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PromoViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"promoVC"];
    Beacon *promo;
    if (indexPath.section == 0){
        promo = [self.promos objectAtIndex:indexPath.row];
    } else {
        promo = [self.savedPromos objectAtIndex:indexPath.row];
    }
    
    [detail.promoTitle setText:promo.title];
    detail.promoText.text = promo.description;
    detail.promoImage.image = [UIImage imageWithData:promo.media];
    
    [self.navigationController pushViewController:detail animated:YES];
    /*
    if ([self.savedPromos containsObject:[self.promos objectAtIndex:indexPath.row]]){
        UIAlertView *exists = [[UIAlertView alloc] initWithTitle:@"Already Saved" message:@"This promotion has already been saved" delegate:self cancelButtonTitle:@"Oh yeah!" otherButtonTitles:nil, nil];
        [exists show];
    } else {
        [self.savedPromos addObject:[self.promos objectAtIndex:indexPath.row]];
        [self saveData];
        [tableView reloadData];
    }
     */
}

-(void)saveData{
    [NSKeyedArchiver archiveRootObject:self.savedPromos toFile:_docPath];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0)
    {
        return NO;
    }
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.savedPromos removeObjectAtIndex:indexPath.row];
        if ([self.savedPromos count] == 0){
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self saveData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
