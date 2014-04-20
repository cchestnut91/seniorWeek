//
//  TimeInBeacon.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/15/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "TimeInBeacon.h"

@implementation TimeInBeacon

/**
 * init.
 * Description: Default init sets enter property and initializes distArray \n
 * Properties Modified: TimeInBeacon object created \n
 * Preconditions: none \n
 * Post conditions: TimeInBeacon object created \n
 * @author Calvin Chestnut
 * @return TimeInBeacon object
 */
-(id)init{
    self = [super init];
    
    self.enter = [[NSDate alloc] init];
    self.distArray = [[NSMutableArray alloc] init];
    
    return self;
}

/**
 * encodeWithCoder.
 * Description: Allows Object and properties to be saved as NSData \n
 * Properties Modified: TimeInBeacon object properties encoded by NSCoder \n
 * Preconditions: none \n
 * Post conditions: TimeInBeacon object encoded by NSCoder \n
 * @author Calvin Chestnut
 * @param aCoder NSCoder compiling object into NSData
 * @return void
 */
-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.enter forKey:@"enter"];
    [aCoder encodeObject:self.exit forKey:@"exit"];
    [aCoder encodeObject:self.distArray forKey:@"rssi"];
}

/**
 * initWithCoder.
 * Description: Creates TimeInBeacon object from NSData with given NSCoder \n
 * Properties Modified: TimeInBeacon object created \n
 * Preconditions: NSData with TimeInBeacon object has been saved \n
 * Post conditions: TimeInBeacon object created by NSCoder \n
 * @author Calvin Chestnut
 * @param aDecoder NSCoder compiling object from NSData
 * @return TimeInBeacon object
 */
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    self.enter = [aDecoder decodeObjectForKey:@"enter"];
    self.exit = [aDecoder decodeObjectForKey:@"exit"];
    self.distArray = [aDecoder decodeObjectForKey:@"rssi"];
    
    return self;
}

@end
