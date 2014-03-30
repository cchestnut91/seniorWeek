//
//  HelpMenuTableViewController.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/30/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface HelpMenuTableViewController : UITableViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *helpArray;
@property (strong, nonatomic) NSArray *questionArray;
@property (strong, nonatomic) NSArray *answerArray;

@end
