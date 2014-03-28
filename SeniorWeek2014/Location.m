//
//  Location.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "Location.h"
#import <AddressBook/AddressBook.h>

@implementation Location

@synthesize latitude, longitude;

-(id) initWithName:(NSString *)nameIn andAddress:(NSString *)addressIn andLat:(NSNumber *)latIn andLong:(NSNumber *)longIn{
    self = [super init];
    
    self.title = nameIn;
    self.subtitle = addressIn;
    self.latitude = latIn;
    self.longitude = longIn;
    
    self.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    
    return self;
}

-(MKMapItem *)mapItem{
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : self.subtitle};
    
    MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:place];
    
    return mapItem;
}

@end

