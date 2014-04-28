/**
 *  Beacon.
 *  Description: Beacon class which contains information about what a Beacon is, what it should do, and what it should say.
 *  @author Calvin Chestnut
 *
 */

#import "Beacon.h"
#import "TimeInBeacon.h"

@implementation Beacon

/**
 * initWithIdent andUUID andMajor andMinor andTrack.
 * Description: Base Beacon init with everything required to create a Beacon and start ranging \n
 * Properties Modified: Beacon object created \n
 * Preconditions: All necessary parameters are supplied \n
 * Post conditions: Beacon object returned \n
 * @author Calvin Chestnut
 * @param identIn NSString with identifier
 * @param uuidIn NSUUID for Beacon
 * @param majorIn NSInteger with Major Key for Beacon
 * @param minorIn NSInteger with Minor Key for Beacon
 * @param trackIn BOOL determining if rssi should be tracked while User is within region
 * @return New Beacon object
 */
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)majorIn andMinor:(NSInteger)minorIn andTrack:(BOOL)trackIn{
    self = [super init];
    self.ident = identIn;
    self.uuid = uuidIn;
    self.major = majorIn;
    self.minor = minorIn;
    self.track = trackIn;
    self.seen = NO;
    self.region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:(CLBeaconMinorValue)self.major minor:(CLBeaconMinorValue)self.minor identifier:self.ident];
    self.encounters = [[NSMutableArray alloc] init];
    
    return self;
}

/**
 * initWithIdent andUUID andMajor andMinor andPromo andTitle andMessage andTrack andOnce.
 * Description: Base Beacon init with everything required to create a Beacon and start ranging, plus extras \n
 * Properties Modified: Beacon object created \n
 * Preconditions: All necessary parameters are supplied \n
 * Post conditions: Beacon object returned \n
 * @author Calvin Chestnut
 * @param identIn NSString with identifier
 * @param uuidIn NSUUID for Beacon
 * @param majorIn NSInteger with Major Key for Beacon
 * @param minorIn NSInteger with Minor Key for Beacon
 * @param trackIn BOOL determining if rssi should be tracked while User is within region
 * @param promoIn BOOL determins if Beacon contains a promotion
 * @param titleIn NSString containing promotion title
 * @param messageIn NSString containing promotion message
 * @param onceIn BOOL determines if promotion should be displayed everytime it is encountered or only the first time
 * @return New Beacon object
 */
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andTrack:(BOOL)trackIn andOnce:(BOOL)onceIn{
    self = [self initWithIdent:identIn andUUID:uuidIn andMajor:major andMinor:minorIn andTrack:trackIn];
    self.promo = promoIn;
    self.once = onceIn;
    self.title = titleIn;
    self.message = messageIn;
    
    return self;
}

/**
 * initWithIdent andUUID andMajor andMinor andPromo andTitle andMessage andThreshold andTrack andOnce.
 * Description: Base Beacon init with everything required to create a Beacon and start ranging, plus extras \n
 * Properties Modified: Beacon object created \n
 * Preconditions: All necessary parameters are supplied \n
 * Post conditions: Beacon object returned \n
 * @author Calvin Chestnut
 * @param identIn NSString with identifier
 * @param uuidIn NSUUID for Beacon
 * @param majorIn NSInteger with Major Key for Beacon
 * @param minorIn NSInteger with Minor Key for Beacon
 * @param trackIn BOOL determining if rssi should be tracked while User is within region
 * @param promoIn BOOL determins if Beacon contains a promotion
 * @param titleIn NSString containing promotion title
 * @param messageIn NSString containing promotion message
 * @param onceIn BOOL determines if promotion should be displayed everytime it is encountered or only the first time
 * @param thresholdIn CGFloat containing threshold for Beacon's within determination
 * @return New Beacon object
 */
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andThreshold:(CGFloat)thresholdIn andTrack:(BOOL)trackIn andOnce:(BOOL)onceIn{
    self = [self initWithIdent:identIn andUUID:uuidIn andMajor:major andMinor:minorIn andPromo:promoIn andTitle:titleIn andMessage:messageIn andTrack:trackIn andOnce:onceIn];
    self.threshold = thresholdIn;
    
    return self;
}

/**
 * initWithIdent andUUID andMajor andMinor andPromo andTitle andMessage andMedia andTrack andOnce.
 * Description: Base Beacon init with everything required to create a Beacon and start ranging, plus extras \n
 * Properties Modified: Beacon object created \n
 * Preconditions: All necessary parameters are supplied \n
 * Post conditions: Beacon object returned \n
 * @author Calvin Chestnut
 * @param identIn NSString with identifier
 * @param uuidIn NSUUID for Beacon
 * @param majorIn NSInteger with Major Key for Beacon
 * @param minorIn NSInteger with Minor Key for Beacon
 * @param trackIn BOOL determining if rssi should be tracked while User is within region
 * @param promoIn BOOL determins if Beacon contains a promotion
 * @param titleIn NSString containing promotion title
 * @param messageIn NSString containing promotion message
 * @param onceIn BOOL determines if promotion should be displayed everytime it is encountered or only the first time
 * @param mediaIn NSData containing media to be displayed with Promotion
 * @return New Beacon object
 */
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andMedia:(NSData *)mediaIn andTrack:(BOOL)trackIn andOnce:(BOOL)onceIn{
    self = [self initWithIdent:identIn andUUID:uuidIn andMajor:major andMinor:minorIn andPromo:promoIn andTitle:titleIn andMessage:messageIn andTrack:trackIn andOnce:onceIn];
    self.media = mediaIn;
    
    return self;
}

/**
 * initWithIdent andUUID andMajor andMinor andPromo andTitle andMessage andThreshold andMedia andTrack andOnce.
 * Description: Base Beacon init with everything required to create a Beacon and start ranging, plus extras \n
 * Properties Modified: Beacon object created \n
 * Preconditions: All necessary parameters are supplied \n
 * Post conditions: Beacon object returned \n
 * @author Calvin Chestnut
 * @param identIn NSString with identifier
 * @param uuidIn NSUUID for Beacon
 * @param majorIn NSInteger with Major Key for Beacon
 * @param minorIn NSInteger with Minor Key for Beacon
 * @param trackIn BOOL determining if rssi should be tracked while User is within region
 * @param promoIn BOOL determins if Beacon contains a promotion
 * @param titleIn NSString containing promotion title
 * @param messageIn NSString containing promotion message
 * @param onceIn BOOL determines if promotion should be displayed everytime it is encountered or only the first time
 * @param thresholdIn CGFloat containing threshold for Beacon's within determination
 * @param mediaIn NSData containing media to be displayed with promotion
 * @return New Beacon object
 */
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andThreshold:(CGFloat)thresholdIn andMedia:(NSData *)mediaIn andTrack:(BOOL)trackIn andOnce:(BOOL)onceIn{
    self = [self initWithIdent:identIn andUUID:uuidIn andMajor:major andMinor:minorIn andPromo:promoIn andTitle:titleIn andMessage:messageIn andThreshold:thresholdIn andTrack:trackIn andOnce:onceIn];
    self.media = mediaIn;
    
    return self;
}

-(BOOL) isSame:(Beacon *)beaconIn {
    BOOL ret = NO;
    if ([self.ident isEqualToString:beaconIn.ident] && [self.message isEqualToString:beaconIn.message] && [self.title isEqualToString:beaconIn.title] && self.major == beaconIn.major && self.minor == beaconIn.minor && [self.uuid.UUIDString isEqualToString:beaconIn.uuid.UUIDString] && self.promo == beaconIn.promo){
        ret = YES;
    }
    return ret;
}

/**
 * encodeWithCoder.
 * Description: Allows Object and properties to be saved as NSData \n
 * Properties Modified: Beacon object properties encoded by NSCoder \n
 * Preconditions: none \n
 * Post conditions: Beacon object encoded by NSCoder \n
 * @author Calvin Chestnut
 * @param aCoder NSCoder compiling object into NSData
 * @return void
 */
-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.ident forKey:@"ident"];
    [aCoder encodeBool:self.promo forKey:@"promo"];
    [aCoder encodeBool:self.within forKey:@"within"];
    [aCoder encodeBool:self.found forKey:@"found"];
    [aCoder encodeBool:self.track forKey:@"track"];
    [aCoder encodeBool:self.seen forKey:@"seen"];
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

/**
 * initWithCoder.
 * Description: Creates Beacon object from NSData with given NSCoder \n
 * Properties Modified: Beacon object created \n
 * Preconditions: NSData with Beacon object has been saved \n
 * Post conditions: Beacon object created by NSCoder \n
 * @author Calvin Chestnut
 * @param aDecoder NSCoder compiling object from NSData
 * @return Beacon object
 */
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    self.ident = [aDecoder decodeObjectForKey:@"ident"];
    self.encounters = [aDecoder decodeObjectForKey:@"encounters"];
    self.promo = [aDecoder decodeBoolForKey:@"promo"];
    self.seen = [aDecoder decodeBoolForKey:@"seen"];
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

/**
 * enter.
 * Description: Marks that user has entered the given region \n
 * Properties Modified: encounters \n
 * Preconditions: encounters initialized \n
 * Post conditions: New instance of TimeInBeacon put into encounters \n
 * @author Calvin Chestnut
 * @return void
 */
-(void)markEnter{
    [self.encounters insertObject:[[TimeInBeacon alloc] init] atIndex:0];
}

/**
 * exit.
 * Description: Marks that user has left the given region \n
 * Properties Modified: encounters \n
 * Preconditions: encounters and object at 0 index has been entered by not exited \n
 * Post conditions: TimeInBeacon object exit time set \n
 * @author Calvin Chestnut
 * @return void
 */
-(void)markExit{
    [[self.encounters objectAtIndex:0] setExit:[[NSDate alloc] init]];
}

/**
 * track.
 * Description: Marks user's distance from beacon in TimeInRegion object within encounters \n
 * Properties Modified: encounters \n
 * Preconditions: TimeInBeacon at position 0 has been entered but not exited initialized \n
 * Post conditions: distance from beacon saved in NSArray \n
 * @author Calvin Chestnut
 * @param rssi NSInteger containing rssi from Beacon to device
 * @return void
 */
-(void) range:(NSInteger)rssi{
    [[[self.encounters objectAtIndex:0] distArray] addObject:[NSString stringWithFormat:@"%ld", (long)rssi]];
}

-(void) startManager:(CLLocationManager *)managerIn{
    [managerIn startMonitoringForRegion:self.region];
}


@end
