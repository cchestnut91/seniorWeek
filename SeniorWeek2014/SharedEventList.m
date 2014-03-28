//
//  SharedEventList.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "SharedEventList.h"

static SharedEventList *sharedList;

@implementation SharedEventList

-(id)init {
	self = [super init];
    
	eventList = [[EventList alloc] init];
	return self;
}

+(SharedEventList *) sharedEventList {
	if (!sharedList) {
		sharedList = [[SharedEventList alloc] init];
	}
	return sharedList;
}

-(NSArray *)getList{
    return [eventList getList];
}

@end
