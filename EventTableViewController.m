//
//  EventTableViewController.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "EventTableViewController.h"
#import "EventDetailViewController.h"
#import "PromoViewController.h"

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

-(void) viewWillAppear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.found = NO;
    
    [self.promoButton setEnabled:NO];
    
    _beaconUUID = @"DE6D8667-45F7-41FF-8295-1850F010AAE0";
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
    
    self.sensor.delegate = self;
    _sensor = [[SerialGATT alloc] init];
    [_sensor setup];
    _sensor.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(found:)
                                                 name:@"found"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lost:)
                                                 name:@"lost"
                                               object:nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:252/255.0 green:185/255.0 blue:34/255.0 alpha:1]];
    
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

- (IBAction)clickPromo:(id)sender {
    if ([sender isEnabled]){
        PromoViewController *promo = [self.storyboard instantiateViewControllerWithIdentifier:@"promoVC"];
        [self.navigationController pushViewController:promo animated:YES];
    } else {
        UIAlertView *noPromo = [[UIAlertView alloc] initWithTitle:@"No Promo Available" message:@"Enjoy Senior Week! We'll let you know if you're near any promotions" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noPromo show];
    }
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

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    //[header.textLabel setTextColor:[UIColor colorWithRed:252/255.0 green:185/255.0 blue:34/255.0 alpha:1]];
    [header.textLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [header.textLabel setTextAlignment:NSTextAlignmentLeft];
    [header.textLabel setFont:[UIFont systemFontOfSize:17]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"h:mm a"];
    
    Event *event = [[[[SharedEventList sharedEventList] getList] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[[event bannerImage] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    cell.backgroundView = background;
    /*
    [cell.backgroundView setOpaque:NO];
    [cell.backgroundView setAlpha:0.6];
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    */
    [[[[[cell contentView] viewWithTag:0] subviews] objectAtIndex:0] setText:[event title]];
    [[[[[cell contentView] viewWithTag:0] subviews] objectAtIndex:1] setText:[NSString stringWithFormat:@"%@ %@", [[event location] title], [formatter stringFromDate:[event date]]]];
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-5);
    horizontalMotionEffect.maximumRelativeValue = @(5);
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-5);
    verticalMotionEffect.maximumRelativeValue = @(5);
    
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

#pragma mark iBeacons

- (void)initRegion {
    //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"]; // ORIGINAL
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:_beaconUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"my_iBeacon"];
    [self.locationManager startMonitoringForRegion:_beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    if ([self.promoButton isEnabled]){
        [self.promoButton setEnabled:NO];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"lost" object:self userInfo:nil];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    if (beacon.proximity == CLProximityImmediate || beacon.proximity == CLProximityNear){
        if (![self.promoButton isEnabled]){
            [self.promoButton setEnabled:YES];
        }
        if (!self.found){
            self.found = YES;
            NSDictionary *dataDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Enjoy some Bandwagon fries", @"There's nothing like an order of Bandwagon fries, so go enjoy some later on today, and display this message for a $1 discount!", nil] forKeys:[NSArray arrayWithObjects:@"title", @"message", nil]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"found" object:self userInfo:dataDict];
        }
    }
}

- (void)found: (NSNotification *)note {
    NSDictionary *theData = [note userInfo];
    
    PromoViewController *promo = [self.storyboard instantiateViewControllerWithIdentifier:@"promoVC"];
    promo.promoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandwagon"]];
    promo.promoTitle = [theData objectForKey:@"title"];
    promo.promoText = [theData objectForKey:@"message"];
    
    [self.navigationController pushViewController:promo animated:YES];
;
    
}

-(void) lost: (NSNotification *)note{
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
