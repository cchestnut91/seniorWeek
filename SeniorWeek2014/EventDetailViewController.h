//
//  EventDetailViewController.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/25/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedEventList.h"
#import <EventKit/EventKit.h>

@interface EventDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSIndexPath *path;
@property (strong, nonatomic) Event *event;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueAddressLabel;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end
