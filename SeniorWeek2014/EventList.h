//
//  EventList.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/25/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface EventList : NSObject

@property (strong, nonatomic) NSArray *list;

-(id)init;
-(NSArray *)getList;

@end
