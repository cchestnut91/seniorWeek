/**
 *  EventTableViewController.
 *  Description: Main View for Senior Week Application by Push Interactive. Contains code to search for and react to Beacons\n Beacon functionality could potentially be moved to another Class.
 *  @author Calvin Chestnut
 *
 */

#import "EventTableViewController.h"
#import "EventDetailViewController.h"
#import "PBiBeaconManager.h"
#import "Beacon.h"
#import "TimeInBeacon.h"
#import "PromoTableViewController.h"
#import "BBBadgeBarButtonItem.h"

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
    [self checkPromos];
}

-(void) viewDidAppear:(BOOL)animated{
    //This method should load beacons from JSON object
}

-(void)barButtonItemPressed:(UIButton *)sender{
    for (id key in self.promos){
        [[self.promos objectForKey:key] setSeen:YES];
    }
    [self checkPromos];
    [self performSegueWithIdentifier:@"showPromos" sender:self];
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
    self.docDirectory = [paths objectAtIndex:0];
    self.archivePath = [self.docDirectory stringByAppendingPathComponent:@"beaconsArchive.plist"];
    //Initialize dictionary of promotions to populate PromoTableViewController
    self.promos = [[NSMutableDictionary alloc] init];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.docDirectory stringByAppendingPathComponent:@"userID"]]){
        self.userID = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.docDirectory stringByAppendingPathComponent:@"userID"]];
    } else {
        NSError *error = nil;
        NSString *userID = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://experiencepush.com/beacon_portal/new_anon_user.php"] encoding:NSASCIIStringEncoding error:&error];
        self.userID = userID;
        [NSKeyedArchiver archiveRootObject:userID toFile:[self.docDirectory stringByAppendingPathComponent:@"userID"]];
    }
    
    //Initialize beacon array from file or create new
    //[self checkForData:[[NSNotification alloc] init]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.archivePath]){
        self.beacons = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.archivePath];
        //self.beacons = nil;
        if (self.beacons == nil){
            self.beacons = [[NSMutableDictionary alloc] init];
        }
    } else {
        self.beacons = [[NSMutableDictionary alloc] init];
        NSLog(@"File doesn't exist");
    }
    
    //Promo Button off by default
    //[self.promoButton setEnabled:NO];
    self.promoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 63, 20)];
    // Add your action to your button
    [self.promoButton addTarget:self action:@selector(barButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.promoButton setTitle:@"Promos" forState:UIControlStateNormal];
    [self.promoButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.promoButton setTitleColor:[UIColor colorWithRed:(252/255.0) green:(185/255.0) blue:(34/255.0) alpha:1] forState:UIControlStateNormal];
    //[self.promoButton setTitleColor:[[[[UIApplication sharedApplication] delegate] window] tintColor] forState:UIControlStateNormal];
    [self.promoButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.promoButton setTitleColor:[self.tableView tintColor] forState:UIControlStateHighlighted];
    BBBadgeBarButtonItem *right = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:self.promoButton];
    right.badgeOriginX = 58;
    [self.navigationItem setRightBarButtonItem:right];
    
    //Initialize LocationManger
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
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
    
    
    PBiBeaconManager *myiBeaconManager = [[PBiBeaconManager alloc] initWithIdent:@"senior_week" andManager:self.locationManager];
    if (self.beacons == nil){
        self.beacons = myiBeaconManager.beacons;
    } else {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        for (id key in myiBeaconManager.beacons){
            if ([self.beacons objectForKey:key] != nil){
                Beacon *old = [self.beacons objectForKey:key];
                if ([old isSame:[myiBeaconManager.beacons objectForKey:key]]){
                    [[myiBeaconManager.beacons objectForKey:key] setEncounters:[[self.beacons objectForKey:key] encounters]];
                    [[myiBeaconManager.beacons objectForKey:key] setSeen:[[self.beacons objectForKey:key] seen]];
                    [temp setObject:[myiBeaconManager.beacons objectForKey:key] forKey:key];
                } else {
                    [temp setObject:old forKey:[NSString stringWithFormat:@"%@Old", [old ident]]];
                    [temp setObject:[myiBeaconManager.beacons objectForKey:key] forKey:key];
                }
            } else {
                [temp setObject:[myiBeaconManager.beacons objectForKey:key] forKey:key];
            }
        }
        for (id key in self.beacons){
            if ([temp objectForKey:key] == nil){
                [temp setObject:[self.beacons objectForKey:key] forKey:key];
            }
        }
        self.beacons = temp;
    }
    

    
    //[self initRegions];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PromoTableViewController class]]){
        [(PromoTableViewController *)[segue destinationViewController] setPromos:[NSMutableArray arrayWithArray:[self.promos allValues]]];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark iBeacons

/**
 * initRegions
 * Description: Tells LocationManager to start looking for beacons in beacons dictionary.
 * Properties Modified: LocationManager \n
 * Precondition: Beacons dictionary is not null \n
 * PostCondition: LocationManager is monitoring all beacons in dictionary \n
 * @return void
 
- (void)initRegions{
    //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23542266-18D1-4FE4-B4A1-23F8195B9D39"]; // ORIGINAL
    
    //arranges beacons dictionary linearly into an array
    NSArray *beaconsIn = [self.beacons allValues];
    
    //Stars monitoring for each beacon
    for (int i = 0; i < beaconsIn.count; i++){
        [self.locationManager startMonitoringForRegion:[(Beacon *)[beaconsIn objectAtIndex:i] region]];
    }
}*/

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
        
        NSLog(@"fired");
        //This should become if (beacon.proximity > [[self.beacons objectForKey:[region identifier]] threshold]), but first Beacons need a default threshold
        NSLog(@"%ld", (long)beacon.rssi);
        if (beacon.rssi >= [[self.beacons objectForKey:[region identifier]] threshold]){
            if (![[self.beacons objectForKey:[region identifier]] within]){
                [[self.beacons objectForKey:[region identifier]] setWithin:YES];
                [self markTime:[region identifier]];
                if ([[self.beacons objectForKey:[region identifier]] promo]){
                    [self.promos setObject:[self.beacons objectForKey:[region identifier]] forKey:[region identifier]];
                }
                [self checkPromos];
                if (!([[self.beacons objectForKey:[region identifier]] once] && [[self.beacons objectForKey:[region identifier]] found])){
                    NSDictionary *dataDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[region identifier], nil] forKeys:[NSArray arrayWithObjects:@"ident", nil]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"found" object:self userInfo:dataDict];
                }
            }
            if (![[self.beacons objectForKey:[region identifier]] found]){
                [[self.beacons objectForKey:[region identifier]] setFound:YES];
            }
        }
        if ([[self.beacons objectForKey:[region identifier]] track]){
            [[self.beacons objectForKey:[region identifier]] range:beacon.rssi];
        }
    }
}

-(void) checkPromos {
    int cnt;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.docDirectory stringByAppendingPathComponent:@"savedPromos.plist"]]){
        NSArray *savedPromos = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:[self.docDirectory stringByAppendingPathComponent:@"savedPromos.plist"]];
        cnt = (int)savedPromos.count;
    } else {
        cnt = 0;
        NSLog(@"File doesn't exist");
    }
    if (cnt != 0){
        if (![self.promoButton isEnabled]){
            [self.promoButton setEnabled:YES];
        }
    } else {
        if ([self.promos count] == 0){
            if ([self.promoButton isEnabled]){
                [self.promoButton setEnabled:NO];
            }
        } else {
            if (![self.promoButton isEnabled]){
                [self.promoButton setEnabled:YES];
            }
        }
    }
    cnt = 0;
    for (id key in self.promos){
        if (![[self.beacons objectForKey:key] seen]){
            cnt++;
        }
    }
    if (cnt > 0){
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d", cnt]];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:(NSInteger)cnt];
    } else {
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d", 0]];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:(NSInteger)cnt];
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
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"%@", [[self.beacons objectForKey:[theData objectForKey:@"ident"]] title]];
    notification.alertAction = @"save";
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:0.02];
    if (![notification.alertBody isEqualToString:@"(null)"]){
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
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
-(void)markTime:(NSString *)ident {
    [[self.beacons objectForKey:ident] markEnter];
    
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
    
    [[self.beacons objectForKey:[theData objectForKey:@"ident"]] markExit];
    [[self.beacons objectForKey:[theData objectForKey:@"ident"]] setWithin:NO];
    [self saveData:note];
    if ([[self.beacons objectForKey:[theData objectForKey:@"ident"]] promo]){
        [self.promos removeObjectForKey:[theData objectForKey:@"ident"]];
    }
    [self checkPromos];
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
        //self.beacons = nil;
        if (self.beacons == nil){
            self.beacons = [[NSMutableDictionary alloc] init];
        }
    } else {
        self.beacons = [[NSMutableDictionary alloc] init];
        NSLog(@"File doesn't exist");
    }
    [self loadBeacons];
}

-(void)uploadData {
    NSString *data = [NSString stringWithFormat:@"B:%@", self.userID];
    for (id key in self.beacons){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"MM-dd-yyyyHH:mm"];
        data = [data stringByAppendingString:[NSString stringWithFormat:@"%@~", [(Beacon *)[self.beacons objectForKey:key] ident]]];
        for (int i = 0; i < [(Beacon *)[self.beacons objectForKey:key] encounters].count; i++){
            TimeInBeacon *time = [[[self.beacons objectForKey:key] encounters] objectAtIndex:i];
            if (time.exit != nil){
                data = [data stringByAppendingString:[NSString stringWithFormat:@"%@*%@:", [formatter stringFromDate:time.enter], [formatter stringFromDate:time.exit]]];
                for (int j = 0; j < time.distArray.count; j++){
                    data = [data stringByAppendingString:[NSString stringWithFormat:@"%@^", [time.distArray objectAtIndex:j]]];
                }
                data = [data stringByAppendingString:@"-"];
            }
        }
        data = [data stringByAppendingString:@","];
    }
    data = [data stringByAppendingString:@"."];
    NSLog(@"%@", data);
    NSString *url = [NSString stringWithFormat:@"http://www.experiencepush.com/beacon_portal/upload.php?id=%@&data=%@", self.userID, data];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
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
    [self uploadData];
}

@end
