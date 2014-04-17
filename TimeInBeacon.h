//
//  TimeInBeacon.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/15/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeInBeacon : NSObject <NSCoding>

@property (strong, nonatomic) NSDate *enter;
@property (strong, nonatomic) NSDate *exit;
@property (strong, nonatomic) NSMutableArray *distArray;

-(id)init;

@end
