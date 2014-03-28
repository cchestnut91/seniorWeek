//
//  Event.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id)initWithTitle:(NSString *)titleIn andDate:(NSDate *)dateIn andEnd:(NSDate *)endIn andImages:(NSArray *)imgsIn andBanner:(UIImage *)bannerIn andLocation:(Location *)locationIn andInfo:(NSString *)infoIn andReqs:(NSString *)reqsIn andTransport:(NSString *)transportIn andAlcohol:(NSString *)alcoholIn andFood:(NSString *)foodIn{
    self = [super init];
    
    self.title = titleIn;
    self.date = dateIn;
    self.end = endIn;
    self.images = imgsIn;
    self.bannerImage = bannerIn;
    self.location = locationIn;
    self.info = infoIn;
    self.reqs = reqsIn;
    self.transport = transportIn;
    self.alcohol = alcoholIn;
    self.food = foodIn;
    self.inCal = NO;
    
    return self;
}

-(id)initWithTitle:(NSString *)titleIn andDate:(NSDate *)dateIn andEnd:(NSDate *)endIn andImages:(NSArray *)imgsIn andBanner:(UIImage *)bannerIn andLocationName:(NSString *)nameIn andLocationAddress:(NSString *)addressIn andLat:(NSNumber *)latIn andLong:(NSNumber *)longIn andInfo:(NSString *)infoIn andReqs:(NSString *)reqsIn andTransport:(NSString *)transportIn andAlcohol:(NSString *)alcoholIn andFood:(NSString *)foodIn{
    Location *location = [[Location alloc] initWithName:nameIn andAddress:addressIn andLat:latIn andLong:longIn];
    
    self = [self initWithTitle:titleIn andDate:dateIn andEnd:endIn andImages:imgsIn andBanner:bannerIn andLocation:location andInfo:infoIn andReqs:reqsIn andTransport:transportIn andAlcohol:alcoholIn andFood:foodIn];
    
    return self;
}

@end
