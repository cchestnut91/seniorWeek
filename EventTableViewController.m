/**
 *  EventTableViewController.
 *  Description: Main View for Senior Week Application by Push Interactive. Contains code to search for and react to Beacons\n Beacon functionality could potentially be moved to another Class.
 *  @author Calvin Chestnut
 *
 */

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

/**
 * viewDidLoad
 * Description: Initialize Beacons and Notifications and View Style Properties \n
 * Properties Modified: archivePath, promos, beacons, promoButton, locationManager, sensor, tableView \n
 * Precondition: None \n
 * PostCondition: Beacons begin to be monitored and tableView is initialized \n
 * @return void
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Sets Directory Path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    self.archivePath = [docDirectory stringByAppendingPathComponent:@"beaconsArchive.plist"];
    //Initialize dictionary of promotions to populate PromoTableViewController
    self.promos = [[NSMutableDictionary alloc] init];
    
    //Initialize beacon array from file or create new
    [self checkForData:[NSNotification new]];
    
    //Promo Button off by default
    [self.promoButton setEnabled:NO];
    
    //Initialize LocationManger
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //This method should load beacons from JSON object
    [self loadBeacons];
    
    //Not sure what this block does
    self.sensor.delegate = self;
    _sensor = [[SerialGATT alloc] init];
    [_sensor setup];
    _sensor.delegate = self;
    
    //Creates notification center alerts
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
    
    //Sets tableView and NavigationController properties
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:252/255.0 green:185/255.0 blue:34/255.0 alpha:1]];
}

/**
 * loadBeacons
 * Description: Loads Beacons from database and creates a new dictionary with Beacons to be searched for, and initializes the regions to search for.
 * Properties Modified: beacons \n
 * Precondition: beacons dictionary is initialized \n
 * PostCondition: LocationManager begins searching for beacon regions \n
 * @return void
 */
-(void)loadBeacons{
    
    /*
     Beacons should be created here from JSON
    */
    Beacon *a = [[Beacon alloc] initWithIdent:@"beaconA" andUUID:[[NSUUID alloc] initWithUUIDString:@"8492E75F-4FD6-469D-B132-043FE94921D8"] andMajor:(NSInteger)1 andMinor:(NSInteger)1 andPromo:YES andTitle:@"$1 Off Bandwagon Fries" andMessage:@"There's nothing quite like a plate of Bandwagon Fries, so get off your feet and treat yourself to a plate!" andTrack:NO andOnce:NO];
    Beacon *b = [[Beacon alloc] initWithIdent:@"beaconB" andUUID:[[NSUUID alloc] initWithUUIDString:@"DE6D8667-45F7-41FF-8295-1850F010AAE0"] andMajor:(NSInteger)1 andMinor:(NSInteger)1 andPromo:YES andTitle:@"Free song from DJ Whatever!" andMessage:@"Enjoy DJ Whatever's performance? Download his latest mix exclusively from here to hear some more!" andTrack:YES andOnce:NO];
    
    //key in beacon disctionary is the beacon identifier
    [self.beacons setObject:a forKey:[a ident]];
    [self.beacons setObject:b forKey:[b ident]];
    
    [self initRegions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
 This method no longer necessary due to PromoTableViewController
 
 
- (IBAction)clickPromo:(id)sender {
    if ([sender isEnabled]){
        PromoViewController *promo = [self.storyboard instantiateViewControllerWithIdentifier:@"promoVC"];
        [self.navigationController pushViewController:promo animated:YES];
    } else {
        UIAlertView *noPromo = [[UIAlertView alloc] initWithTitle:@"No Promo Available" message:@"Enjoy Senior Week! We'll let you know if you're near any promotions" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noPromo show];
    }
}
 
 */


/**
 * numberOfSectionsInTableView
 * Description: Determines how many sections in Event Table.
 * Properties Modified: Event Table View \n
 * Precondition: Table View is initializes and Event List singleton is populated \n
 * PostCondition: Event Table begins loading rows \n
 * @param tableView UITableView to be populated
 * @return NSInteger with number of sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[SharedEventList sharedEventList] getList].count;
}

/**
 * tableView: titleForHeaderInSection
 * Description: Sets title for section in Event Table.
 * Properties Modified: EventTable Section Header \n
 * Precondition: TableView is set to display grouped and has more than 0 sections \n
 * PostCondition: Event Table Section Header is set \n
 * @param tableView UITableView to be populated
 * @param section NSInteger representing current section
 * @return NSString with section header text
 */
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

/**
 * tableView: numberOfRowsInSection:
 * Description: Determines number of rows for a particular section.
 * Properties Modified: Event Table View Section row count \n
 * Precondition: EventList Singleton object is initializes and populated \n
 * PostCondition: Event Table begins loading rows \n
 * @param tableView UITableView to be populated
 * @param section NSInteger representing current section to be populated
 * @return NSInteger with number of rows
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[[SharedEventList sharedEventList] getList] objectAtIndex:section] count];
}

/**
 * tableView willDisplayHeaderView forSection
 * Description: Sets Section Header Style.
 * Properties Modified: Section Header \n
 * Precondition: Section Header has already been set \n
 * PostCondition: Displays Section Header \n
 * @param tableView UITableView to be populated
 * @param view UIView containing header text and style
 * @param section NSInteger representing current section to be displayed
 * @return void
 */
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    //[header.textLabel setTextColor:[UIColor colorWithRed:252/255.0 green:185/255.0 blue:34/255.0 alpha:1]];
    [header.textLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [header.textLabel setTextAlignment:NSTextAlignmentLeft];
    [header.textLabel setFont:[UIFont systemFontOfSize:17]];
}

/**
 * tableView: cellForRowAtIndexPath
 * Description: Creates Cell to be placed in EventTable Row.
 * Properties Modified: Event Table View Section \n
 * Precondition: Table View is initializes and Event List singleton is populated \n
 * PostCondition: Row is placed in EventTable \n
 * @param tableView UITableView to be populated
 * @param indexPath NSIndexPath containing section and row for cell
 * @return UITableViewCell formatted Cell to be placed in the EventTable
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Initializes Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //Sets date format
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"h:mm a"];
    
    //Grabs event information for current cell
    Event *event = [[[[SharedEventList sharedEventList] getList] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    //Sets cell background View
    UIImageView *background = [[UIImageView alloc] initWithImage:[[event bannerImage] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    cell.backgroundView = background;
    
    //Sets cell info text
    [[[[[cell contentView] viewWithTag:0] subviews] objectAtIndex:0] setText:[event title]];
    [[[[[cell contentView] viewWithTag:0] subviews] objectAtIndex:1] setText:[NSString stringWithFormat:@"%@ %@", [[event location] title], [formatter stringFromDate:[event date]]]];
    
    //Adds motion effect to cell content view
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

/**
 * tableView didSelectRowAtIndexPath
 * Description: Handles selection of EventTable Row.
 * Properties Modified: EventDetailViewController created \n
 * Precondition: Event for cell is not null \n
 * PostCondition: Navigation Controller pushes EventDetailViewController \n
 * @param tableView UITableView in question
 * @param indexPath NSIndexPath for cell selected
 * @return void
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
    detailView.path = indexPath;
    
    [self.navigationController pushViewController:detailView animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark iBeacons

/**
 * initRegions
 * Description: Tells LocationManager to start looking for beacons in beacons dictionary.
 * Properties Modified: LocationManager \n
 * Precondition: Beacons dictionary is not null \n
 * PostCondition: LocationManager is monitoring all beacons in dictionary \n
 * @return void
 */
- (void)initRegions{
    //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"]; // ORIGINAL
    
    //arranges beacons dictionary linearly into an array
    NSArray *beaconsIn = [self.beacons allValues];
    
    //Stars monitoring for each beacon
    for (int i = 0; i < beaconsIn.count; i++){
        [self.locationManager startMonitoringForRegion:[(Beacon *)[beaconsIn objectAtIndex:i] region]];
    }
}

/**
 * locationManager: didStartMonitoringForRegion
 * Description: Starts ranging given beacon region.
 * Properties Modified: Location Manager \n
 * Precondition: initRegions has been run \n
 * PostCondition: LocationManager begins ranging beacon \n
 * @param manager CLLogationManager to be called
 * @param region CLRegion to be ranged
 * @return void
 */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

/**
 * locationManager: didEnterRegion
 * Description: Starts ranging given beacon region when entered.
 * Properties Modified: Location Manager \n
 * Precondition: initRegions has been run \n
 * PostCondition: LocationManager begins ranging beacon \n
 * @param manager CLLogationManager to be called
 * @param region CLRegion to be ranged
 * @return void
 */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

/**
 * locationManager: didExitRegion
 * Description: Calls notification for Beacon Lost.
 * Properties Modified: Notification Triggered \n
 * Precondition: initRegions has been run \n
 * PostCondition: Notification Sent to System \n
 * @param manager CLLogationManager to be called
 * @param region CLRegion exited
 * @return void
 */
-(void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[region identifier], nil] forKeys:[NSArray arrayWithObjects:@"ident", nil]];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"lost" object:self userInfo:userInfo];
}

/**
 * locationManager: didStartMonitoringForRegion
 * Description: Determines range for given beacon region and responds to range changes.
 * Properties Modified: promoButton, Beacon object in beacons dictionary, Sends notification, promos \n
 * Precondition: initRegions has been run and Location Manager is ranging beacons \n
 * PostCondition: Reacts to Beacons found \n
 * @param manager CLLogationManager to be called
 * @param beacons NSArray of beacons ranged
 * @param region CLRegion ranged
 * @return void
 */
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (int i = 0; i < beacons.count; i++){
        CLBeacon *beacon = [beacons objectAtIndex:i];
        
        //This should become if (beacon.proximity > [[self.beacons objectForKey:[region identifier]] threshold]), but first Beacons need a default threshold
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
            if ([[self.beacons objectForKey:[region identifier]] promo]){
                [self.promos setObject:[self.beacons objectForKey:[region identifier]] forKey:[region identifier]];
            }
        }
        if ([[self.beacons objectForKey:[region identifier]] track]){
            [[self.beacons objectForKey:[region identifier]] track:beacon.rssi];
        }
    }
}

/**
 * found
 * Description: Called when Found Notification is detected.
 * Properties Modified: Creates PromoViewController instance \n
 * Precondition: Beacon information is stored in NSNotification \n
 * PostCondition: Navigation Controller pushes PromoView \n
 * @param note NSNotification containing info about Beacon found
 * @return void
 */
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

/**
 * markTime
 * Description: Marks the current time when the user encounters a beacon .
 * Properties Modified: Beacon's 'encounters' property \n
 * Precondition: Beacon information is stored in theData \n
 * PostCondition: Beacon creates new TimeInBeacon object in Encounters \n
 * @param theData NSDictionary containing information about the Beacon
 * @return void
 */
-(void)markTime:(NSDictionary *)theData {
    [[self.beacons objectForKey:[theData objectForKey:@"ident"]] enter];
    
    /*
    UIAlertView *count = [[UIAlertView alloc] initWithTitle:@"Count" message:[NSString stringWithFormat:@"%lu", (unsigned long)[[[self.beacons objectForKey:[theData objectForKey:@"ident"]] encounters] count]] delegate:self cancelButtonTitle:@"Great!" otherButtonTitles:nil, nil];
    [count show];
    */
}

/**
 * lost
 * Description: Called when Lost Notification is detected.
 * Properties Modified: Beacon from self.beacons Dictionary, promos \n
 * Precondition: Beacon was previously being ranged and located \n
 * PostCondition: Removes Beacon from promos if necessary, saves data into a plist file \n
 * @param note NSNotification containing info about Beacon lost
 * @return void
 */
-(void) lost: (NSNotification *)note{
    NSDictionary *theData = [note userInfo];
    
    [[self.beacons objectForKey:[theData objectForKey:@"ident"]] exit];
    [[self.beacons objectForKey:[theData objectForKey:@"ident"]] setWithin:NO];
    [self saveData:note];
    if ([[self.beacons objectForKey:[theData objectForKey:@"ident"]] promo]){
        [self.promos removeObjectForKey:[self.beacons objectForKey:[theData objectForKey:@"ident"]]];
    }
}

/**
 * checkForData
 * Description: Called when Application enters forground.
 * Properties Modified: beacon dictionary \n
 * Precondition: None \n
 * PostCondition: Beacons are stored in a NSMutableDictionary read from a file or created \n
 * @param note NSNotification which isn't actually used, (I believe this is necessary to call a function from a Notification, correct?)
 * @return void
 */
-(void)checkForData: (NSNotification *)note{
    //Initialize beacon array from file or create new
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
}

/**
 * saveData
 * Description: Saves Beacon Dictionary to a plist file.
 * Properties Modified: plist file stored at self.archivePath \n
 * Precondition: Beacon Dictionary is not null \n
 * PostCondition: Beacons Dictionary and all properties are stored in a plist file \n
 * @param note NSNotification which isn't actually used, (I believe this is necessary to call a function from a Notification, correct?)
 * @return void
 */
-(void)saveData: (NSNotification *)note{
    [NSKeyedArchiver archiveRootObject:self.beacons toFile:self.archivePath];
}

@end
