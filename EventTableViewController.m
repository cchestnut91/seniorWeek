//
//  EventTableViewController.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "EventTableViewController.h"
#import "EventDetailViewController.h"
#import "Beacon.h"

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
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    self.archivePath = [docDirectory stringByAppendingPathComponent:@"beaconsArchive.plist"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.archivePath]){
        self.beacons = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.archivePath];
        self.beacons = nil;
        if (self.beacons == nil){
            self.beacons = [[NSMutableDictionary alloc] init];
        }
    } else {
        self.beacons = [[NSMutableDictionary alloc] init];
        NSLog(@"File doesn't exist");
    }
    
    [self.promoButton setEnabled:NO];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self loadBeacons];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveData:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkForData:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:252/255.0 green:185/255.0 blue:34/255.0 alpha:1]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)loadBeacons{
    
    /*
     Beacons should be created here from JSON
    */
    Beacon *a = [[Beacon alloc] initWithIdent:@"beaconA" andUUID:[[NSUUID alloc] initWithUUIDString:@"8492E75F-4FD6-469D-B132-043FE94921D8"] andMajor:(NSInteger)1 andMinor:(NSInteger)1 andPromo:YES andTitle:@"$1 Off Bandwagon Fries" andMessage:@"There's nothing quite like a plate of Bandwagon Fries, so get off your feet and treat yourself to a plate!" andTrack:NO];
    Beacon *b = [[Beacon alloc] initWithIdent:@"beaconB" andUUID:[[NSUUID alloc] initWithUUIDString:@"DE6D8667-45F7-41FF-8295-1850F010AAE0"] andMajor:(NSInteger)1 andMinor:(NSInteger)1 andPromo:YES andTitle:@"Free song from DJ Whatever!" andMessage:@"Enjoy DJ Whatever's performance? Download his latest mix exclusively from here to hear some more!" andTrack:YES];
    
    [self.beacons setObject:a forKey:[a ident]];
    [self.beacons setObject:b forKey:[b ident]];
    
    [self initRegions];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    detailView.path = indexPath;
    
    [self.navigationController pushViewController:detailView animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark iBeacons


/*
 
 ********Start here!!!!**********
 initRegion should take in a dictionary/array of Beacon info, with UUIDs, Major, Minor, Idents, and anything else needed in the Beacon Class
 
 ********************************
*/
- (void)initRegions{
    //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"]; // ORIGINAL
    NSArray *beaconsIn = [self.beacons allValues];
    for (int i = 0; i < beaconsIn.count; i++){
        [self.locationManager startMonitoringForRegion:[(Beacon *)[beaconsIn objectAtIndex:i] region]];
    }
    /*
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:_beaconUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"my_iBeacon"];
    [self.locationManager startMonitoringForRegion:_beaconRegion];
    [self.locationManager startMonitoringForRegion:[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"8492E75F-4FD6-469D-B132-043FE94921D8"] identifier:@"secondBeacon"]];
    */
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

-(void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    if ([self.promoButton isEnabled]){
        [self.promoButton setEnabled:NO];
    }
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[region identifier], nil] forKeys:[NSArray arrayWithObjects:@"ident", nil]];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"lost" object:self userInfo:userInfo];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (int i = 0; i < beacons.count; i++){
        CLBeacon *beacon = [beacons objectAtIndex:i];
        if (beacon.proximity == CLProximityImmediate || beacon.proximity == CLProximityNear){
            if ([[self.beacons objectForKey:[region identifier]] promo]){
                if (![self.promoButton isEnabled]){
                    [self.promoButton setEnabled:YES];
                }
            }
            if (![[self.beacons objectForKey:[region identifier]] found]){
                [[self.beacons objectForKey:[region identifier]] setFound:YES];
            }
            if (![[self.beacons objectForKey:[region identifier]] within]){
                [[self.beacons objectForKey:[region identifier]] setWithin:YES];
                NSDictionary *dataDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[region identifier], @"$1 Off Bandwagon Fries", @"There's nothing like an order of Bandwagon fries, so go enjoy some later on today, and display this message for a $1 discount!", nil] forKeys:[NSArray arrayWithObjects:@"ident", @"title", @"message", nil]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"found" object:self userInfo:dataDict];
            }
        }
        if ([[self.beacons objectForKey:[region identifier]] track]){
            [[self.beacons objectForKey:[region identifier]] track:beacon.rssi];
        }
    }
}

- (void)found: (NSNotification *)note {
    NSDictionary *theData = [note userInfo];
    
    self.promoView = (PromoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"promoVC"];
    //self.promoView = [[PromoViewController alloc] init];
    self.promoView.promoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandwagon"]];
    self.promoView.promoTitle = [theData objectForKey:@"title"];
    self.promoView.promoText = [theData objectForKey:@"message"];
    
    if ([[self.navigationController visibleViewController] isEqual:self]){
        [self.navigationController pushViewController:self.promoView animated:YES];
    };
    
    [self markTime:theData];
}

-(void)markTime:(NSDictionary *)theData {
    [[self.beacons objectForKey:[theData objectForKey:@"ident"]] enter];
    
    /*
    UIAlertView *count = [[UIAlertView alloc] initWithTitle:@"Count" message:[NSString stringWithFormat:@"%lu", (unsigned long)[[[self.beacons objectForKey:[theData objectForKey:@"ident"]] encounters] count]] delegate:self cancelButtonTitle:@"Great!" otherButtonTitles:nil, nil];
    [count show];
    */
}

-(void) lost: (NSNotification *)note{
    NSDictionary *theData = [note userInfo];
    
    [[self.beacons objectForKey:[theData objectForKey:@"ident"]] exit];
    [[self.beacons objectForKey:[theData objectForKey:@"ident"]] setWithin:NO];
    [self saveData:note];
}

-(void)checkForData: (NSNotification *)note{
    
}

-(void)saveData: (NSNotification *)note{
    [NSKeyedArchiver archiveRootObject:self.beacons toFile:self.archivePath];
}

@end
