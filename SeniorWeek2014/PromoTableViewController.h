//
//  PromoTableViewController.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/20/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Beacon.h"

@interface PromoTableViewController : UITableViewController <UIAlertViewDelegate>
@property (strong, nonatomic) NSMutableArray *promos;
@property (strong, nonatomic) NSMutableArray *savedPromos;
@property (strong, nonatomic) NSString *docPath;

@end
