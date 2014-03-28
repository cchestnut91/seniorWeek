//
//  Location.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

- (id) initWithName:(NSString *)nameIn andAddress:(NSString *)addressIn andLat:(NSNumber *)latIn andLong:(NSNumber *)longIn;
-(MKMapItem *)mapItem;

@end
