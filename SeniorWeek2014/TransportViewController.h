//
//  TransportViewController.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/26/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"

@interface TransportViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) Location *destination;

@end
