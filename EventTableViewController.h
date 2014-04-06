//
//  EventTableViewController.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sharedEventList.h"
#import <CoreLocation/CoreLocation.h>
#import "SerialGATT.h"

#define RSSI_THRESHOLD -60  // boundry signal strength

@class CBPeripheral;
@class SerialGATT;

@interface EventTableViewController : UITableViewController <CLLocationManagerDelegate, BTSmartSensorDelegate>;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *promoButton;
@property (strong, nonatomic) NSString *beaconUUID;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property BOOL found;

@property (strong, nonatomic) SerialGATT *sensor;


@end
