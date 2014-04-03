//
//  HelpMenuTableViewController.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/30/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "HelpMenuTableViewController.h"
#import "Help.h"

@interface HelpMenuTableViewController ()

@end

@implementation HelpMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.questionArray = [NSArray arrayWithObjects:@"What is Senior Week?", @"Can I bring friends?", @"How do I get into events?", @"How do I get to events?", @"Where do I get a Senior Pass?", @"How much do they cost?", @"How do I pick it up?", @"Question about this app?", nil];
    self.answerArray = [NSArray arrayWithObjects:@"Senior Week is a week long celebration of your time here at Ithaca College. Plus, it's a great way to spend the time between finals and graduation. Enjoy a variety of events with your friends before stepping off campus as an alumni.", @"Anyone with a Senior Pass can get into the events, and some of the events allow for friends without Senior Passes to join, like the Senior Formal or the Senior Splash. The Senior Formal costs $35 for guests.", @"To get into events, just bring your Senior Pass! Some events require some extra stuff, like ID if you want to drink. Check the event details in this app for more information", @"For many events transportation is provided by the Senior Week Comittee. Check the events details for transportation info to see bus stop locations and times.", @"Senior Pass sales open up on at www.icsw2014.com for everyone on Wednesday, April 8th.", @"Senior Week Passes are $110 without a Senior Card, and $55 with a Senior Card. Senior Cards are no longer on sale.", @"Pickup your Pass between 11am and 3pm at Emerson Suites on May 8th or 9th. You can also pick up your Pass at the first event you go to.", @"Email the developer", nil];
    
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
    return self.questionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.questionArray objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForText:[self.answerArray objectAtIndex:indexPath.section]];
}

-(CGFloat)heightForText:(NSString *)textIn{
    NSInteger MAX_HEIGHT = 2000;
    UITextView * textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, 320, MAX_HEIGHT)];
    textView.text = textIn;
    textView.font = [UIFont systemFontOfSize:17];
    [textView sizeToFit];
    return textView.frame.size.height;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    //[header.textLabel setTextColor:[UIColor colorWithRed:252/255.0 green:185/255.0 blue:34/255.0 alpha:1]];
    [header.textLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QA Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == self.questionArray.count - 1){
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    
    [[cell.contentView.subviews objectAtIndex:0] setText:[self.answerArray objectAtIndex:indexPath.section]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == self.questionArray.count - 1){
        if ([MFMailComposeViewController canSendMail]){
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setToRecipients:[NSArray arrayWithObject:@"cchestnut91@gmail.com"]];
            [controller setSubject:@"Senior Week App Help"];
            [controller setMessageBody:@"Hi there, I am having some trouble with the Senior Week Application. My problem is as follows:\n" isHTML:NO];
            if (controller) {
                [self presentViewController:controller animated:YES completion:nil];
            }
        } else {
            UIAlertView *cantMail = [[UIAlertView alloc] initWithTitle:@"Cannot Send Mail" message:@"Email cannot be sent from this device. Please email cchestnut91@gmail.com with any questions" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [cantMail show];
        }
    }
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
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
