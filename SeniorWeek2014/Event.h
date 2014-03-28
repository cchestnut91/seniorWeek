//
//  Event.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/24/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Event : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSDate *end;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) UIImage *bannerImage;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSString *reqs;
@property (strong, nonatomic) NSString *transport;
@property (strong, nonatomic) NSString *alcohol;
@property (strong, nonatomic) NSString *food;
@property (nonatomic) BOOL inCal;

-(id) initWithTitle:(NSString *)titleIn andDate:(NSDate *)dateIn andEnd:(NSDate *)endIn andImages:(NSArray *)imgsIn andBanner:(UIImage *)bannerIn andLocation:(Location *)locationIn andInfo:(NSString *)infoIn andReqs:(NSString *)reqsIn andTransport:(NSString *)transportIn andAlcohol:(NSString *)alcoholIn andFood:(NSString *)foodIn;
-(id) initWithTitle:(NSString *)titleIn andDate:(NSDate *)dateIn andEnd:(NSDate *)endIn andImages:(NSArray *)imgsIn andBanner:(UIImage *)bannerIn andLocationName:(NSString *)nameIn andLocationAddress:(NSString *)addressIn andLat:(NSNumber *)latIn andLong:(NSNumber *)longIn andInfo:(NSString *)infoIn andReqs:(NSString *)reqsIn andTransport:(NSString *)transportIn andAlcohol:(NSString *)alcoholIn andFood:(NSString *)foodIn;

@end
