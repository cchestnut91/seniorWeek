//
//  Beacon.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/15/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "Beacon.h"
#import "TimeInBeacon.h"

@implementation Beacon

-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)majorIn andMinor:(NSInteger)minorIn andTrack:(BOOL)trackIn;{
    self = [super init];
    self.ident = identIn;
    self.uuid = uuidIn;
    self.major = majorIn;
    self.minor = minorIn;
    self.track = trackIn;
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:(CLBeaconMinorValue)self.major minor:(CLBeaconMinorValue)self.minor identifier:self.ident];
    self.encounters = [[NSMutableArray alloc] init];
    
    return self;
}

-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTrack:(BOOL)trackIn;{
    self = [self initWithIdent:identIn andUUID:uuidIn andMajor:major andMinor:minorIn andTrack:trackIn];
    self.promo = promoIn;
    
    return self;
}
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andTrack:(BOOL)trackIn;{
    self = [self initWithIdent:identIn andUUID:uuidIn andMajor:major andMinor:minorIn andPromo:promoIn andTrack:trackIn];
    self.title = titleIn;
    self.message = messageIn;
    
    return self;
}
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andThreshold:(CGFloat)thresholdIn andTrack:(BOOL)trackIn;{
    self = [self initWithIdent:identIn andUUID:uuidIn andMajor:major andMinor:minorIn andPromo:promoIn andTitle:titleIn andMessage:messageIn andTrack:trackIn];
    self.threshold = thresholdIn;
    
    return self;
}

-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andMedia:(NSData *)mediaIn andTrack:(BOOL)trackIn;{
    self = [self initWithIdent:identIn andUUID:uuidIn andMajor:major andMinor:minorIn andPromo:promoIn andTitle:titleIn andMessage:messageIn andTrack:trackIn];
    self.media = mediaIn;
    
    return self;
}

-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andThreshold:(CGFloat)thresholdIn andMedia:(NSData *)mediaIn andTrack:(BOOL)trackIn;{
    self = [self initWithIdent:identIn andUUID:uuidIn andMajor:major andMinor:minorIn andPromo:promoIn andTitle:titleIn andMessage:messageIn andThreshold:thresholdIn andTrack:trackIn];
    self.media = mediaIn;
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.ident forKey:@"ident"];
    [aCoder encodeBool:self.promo forKey:@"promo"];
    [aCoder encodeBool:self.within forKey:@"within"];
    [aCoder encodeBool:self.found forKey:@"found"];
    [aCoder encodeBool:self.track forKey:@"track"];
    [aCoder encodeObject:self.encounters forKey:@"encounters"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeDouble:self.threshold forKey:@"threshold"];
    [aCoder encodeObject:self.media forKey:@"media"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.region forKey:@"region"];
    [aCoder encodeInteger:(self.minor) forKey:@"minor"];
    [aCoder encodeInteger:(self.major) forKey:@"major"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    self.ident = [aDecoder decodeObjectForKey:@"ident"];
    self.encounters = [aDecoder decodeObjectForKey:@"encounters"];
    self.promo = [aDecoder decodeBoolForKey:@"promo"];
    self.found = [aDecoder decodeBoolForKey:@"found"];
    self.within = [aDecoder decodeBoolForKey:@"within"];
    self.track = [aDecoder decodeBoolForKey:@"track"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.message = [aDecoder decodeObjectForKey:@"message"];
    self.threshold = [aDecoder decodeDoubleForKey:@"threshold"];
    self.media = [aDecoder decodeObjectForKey:@"media"];
    self.region = [aDecoder decodeObjectForKey:@"region"];
    self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
    self.major = (NSInteger)[aDecoder decodeIntegerForKey:@"minor"];
    self.minor = (NSInteger)[aDecoder decodeIntegerForKey:@"major"];
    
    return self;
}

-(void)enter{
    [self.encounters insertObject:[[TimeInBeacon alloc] init] atIndex:0];
}

-(void)exit{
    [[self.encounters objectAtIndex:0] setExit:[[NSDate alloc] init]];
}

-(void) track:(NSInteger)rssi{
    [[[self.encounters objectAtIndex:0] distArray] addObject:[NSString stringWithFormat:@"%d", rssi]];
}


@end
