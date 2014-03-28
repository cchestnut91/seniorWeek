//
//  SharedEventList.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventList.h"

@interface SharedEventList : NSObject {
    EventList *eventList;
}

+(SharedEventList *) sharedEventList;

-(NSArray *)getList;

@end
