//
//  TimeInBeacon.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/15/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "TimeInBeacon.h"

@implementation TimeInBeacon

-(id)init{
    self = [super init];
    
    self.enter = [[NSDate alloc] init];
    self.distArray = [[NSMutableArray alloc] init];
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.enter forKey:@"enter"];
    [aCoder encodeObject:self.exit forKey:@"exit"];
    [aCoder encodeObject:self.distArray forKey:@"rssi"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    self.enter = [aDecoder decodeObjectForKey:@"enter"];
    self.exit = [aDecoder decodeObjectForKey:@"exit"];
    self.distArray = [aDecoder decodeObjectForKey:@"rssi"];
    
    return self;
}

@end
