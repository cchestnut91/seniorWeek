//
//  EventDetailViewController.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/25/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "EventDetailViewController.h"
#import "TransportViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

@synthesize path, event, eventImage, venueNameLabel, venueAddressLabel, table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"h:mm a"];
    
    event = [[[[SharedEventList sharedEventList] getList] objectAtIndex:path.section] objectAtIndex:path.row];
    
    [eventImage setImage:[[event images] objectAtIndex:0]];
    [venueNameLabel setText:[[event location] title]];
    [venueAddressLabel setText:[NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:[event date]], [formatter stringFromDate:[event end]]]];
    
    table = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
    
    //table.delegate = self;
    table.dataSource = self;
    
    [table reloadData];
    
    [self.navigationItem setTitle:[event title]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"About";
    } else if (section == 1){
        return @"Important Info";
    } else if (section == 2){
        return @"Food";
    } else if (section == 3){
        return @"Drinks";
    } else if (section == 4){
        return @"Transportation";
    } else {
        return @"";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return [self heightForText:[event info]];
    } else if (indexPath.section == 1){
        return [self heightForText:[event reqs]] + 35;
    } else if (indexPath.section == 2){
        return [self heightForText:[event food]] + 35;
    } else if (indexPath.section == 3){
        return [self heightForText:[event alcohol]] + 35;
    } else if (indexPath.section == 4) {
        return [self heightForText:[event transport]] + 35;
    } else {
        return [self heightForText:@"Add to Calendar"] + 35;
    }
}

-(CGFloat)heightForText:(NSString *)textIn{
    NSInteger MAX_HEIGHT = 2000;
    UITextView * textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, 320, MAX_HEIGHT)];
    textView.text = textIn;
    textView.font = [UIFont systemFontOfSize:16];
    [textView sizeToFit];
    return textView.frame.size.height;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        
        [[cell.contentView.subviews objectAtIndex:0] setText:[event info]];
    } else if (indexPath.section == 5){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailTextCell"];
        [[cell.contentView.subviews objectAtIndex:0] setText:@"Add to Calendar"];
        [[cell.contentView.subviews objectAtIndex:0] setTextAlignment:NSTextAlignmentCenter];
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        
        if (indexPath.section == 1){
            [[cell.contentView.subviews objectAtIndex:0] setText:[event reqs]];
        } else if (indexPath.section == 2){
            [[cell.contentView.subviews objectAtIndex:0] setText:[event food]];
        } else if (indexPath.section == 3){
            [[cell.contentView.subviews objectAtIndex:0] setText:[event alcohol]];
        } else if (indexPath.section == 4) {
            [[cell.contentView.subviews objectAtIndex:0] setText:[event transport]];
            if (![[event transport] isEqual:@"No Transportation Provided"]){
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
        }
    }
    
    return cell;
}

-(IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4 && ![event.transport isEqualToString:@"No Transportation Provided"]){
        TransportViewController *transport = [self.storyboard instantiateViewControllerWithIdentifier:@"transportView"];
        
        NSArray *pickup;
        
        if ([event.title isEqualToString:@"Wine Tour"]){
            Location *park = [[Location alloc] initWithName:@"O Lot at Park" andAddress:@"953 Danby Rd, Ithaca NY, 14850" andLat:[[NSNumber alloc] initWithFloat:42.424323] andLong:[[NSNumber alloc] initWithFloat:-76.495070]];
            pickup = [NSArray arrayWithObject:park];
        } else {
            Location *pickupA = [[Location alloc] initWithName:@"Commons at Madeline's" andAddress:@"Ithaca Commons, S Aurora St, Ithaca NY, 14850" andLat:[NSNumber numberWithFloat:42.439236] andLong:[NSNumber numberWithFloat:-76.495580]];
            Location *pickupB = [[Location alloc] initWithName:@"Therm Sign at Hudson St" andAddress:@"702 Hudson St, Ithaca NY, 14850" andLat:[NSNumber numberWithFloat:42.430312] andLong:[NSNumber numberWithFloat:-76.492359]];
            Location *pickupC = [[Location alloc] initWithName:@"Circles Community Center" andAddress:@"College Circle, Ithaca NY, 14850" andLat:[NSNumber numberWithFloat:42.411691] andLong:[NSNumber numberWithFloat:-76.500350]];
            pickup = [NSArray arrayWithObjects:pickupA, pickupB, pickupC, nil];
            if ([event.title isEqualToString:@"Drinks on the Lake"]){
                transport.destination = pickupC;
            } else {
                transport.destination = event.location;
            }
        }
        
        transport.locations = pickup;
        
        [self.navigationController pushViewController:transport animated:YES];
    } else if (indexPath.section == 5){
        if (event.inCal){
            UIAlertView *inCal = [[UIAlertView alloc] initWithTitle:@"Already Added" message:[NSString stringWithFormat:@"%@ has already been added to your calendar. Are you sure you want to add again?", event.title] delegate:self cancelButtonTitle:@"Nevermind" otherButtonTitles:@"Yes", nil];
            [inCal show];
        } else {
            [self addToCalendar];
            event.inCal = YES;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0){
        [self addToCalendar];
    }
}

- (void)addToCalendar {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        EKEvent *calEvent = [EKEvent eventWithEventStore:eventStore];
        calEvent.title = event.title;
        calEvent.startDate = event.date;
        calEvent.endDate = event.end;
        calEvent.notes = event.info;
        
        [calEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
        
        NSError *err;
        [eventStore saveEvent:calEvent span:EKSpanThisEvent error:&err];
    }];
    
    UIAlertView *added = [[UIAlertView alloc] initWithTitle:@"Event Added" message:[NSString stringWithFormat:@"%@ has been added to your calendar", event.title] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [added show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-25);
    verticalMotionEffect.maximumRelativeValue = @(25);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    /*
     [venueAddressLabel addMotionEffect:group];
     [venueNameLabel addMotionEffect:group];
     */
    
    [eventImage addMotionEffect:group];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
