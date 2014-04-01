//
//  EventTableViewController.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "EventTableViewController.h"
#import "EventDetailViewController.h"

@interface EventTableViewController ()

@end

@implementation EventTableViewController

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
    return [[SharedEventList sharedEventList] getList].count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"Monday";
    } else if (section == 1){
        return @"Tuesday";
    } else if (section == 2){
        return @"Wednesday";
    } else if (section == 3){
        return @"Thursday";
    } else if (section == 4){
        return @"Saturday";
    } else {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[[SharedEventList sharedEventList] getList] objectAtIndex:section] count];
}

-(void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:253 green:182 blue:43 alpha:1]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"h:mm a"];
    
    Event *event = [[[[SharedEventList sharedEventList] getList] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[[event bannerImage] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    [[[[[cell contentView] viewWithTag:0] subviews] objectAtIndex:0] setText:[event title]];
    [[[[[cell contentView] viewWithTag:0] subviews] objectAtIndex:1] setText:[NSString stringWithFormat:@"%@ %@", [[event location] title], [formatter stringFromDate:[event date]]]];
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    if (cell.contentView.motionEffects.count == 0){
        [cell.contentView addMotionEffect:group];
    }
    
    
    return cell;
}

- (IBAction)openTwitter:(id)sender {
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    detailView.path = indexPath;
    
    [self.navigationController pushViewController:detailView animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
