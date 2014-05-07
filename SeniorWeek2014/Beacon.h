/**
 *  Beacon.
 *  Description: Beacon class which contains information about what a Beacon is, what it should do, and what it should say.
 *  @author Calvin Chestnut
 *
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//NSCoding allows the Class to be archived into NSData and unarchived from NSData to a Beacon
@interface Beacon : NSObject <NSCoding>

/**
 * ident.
 * NSString containing region identifier. Also used to identify Beacon in all dictionaries
 */
@property (strong, nonatomic) NSString *ident;
/**
 * title.
 * NSString containing promotion title
 */
@property (strong, nonatomic) NSString *title;
/**
 * message.
 * NSString containing promotion message
 */
@property (strong, nonatomic) NSString *message;
/**
 * encounters.
 * NSMutableArray containing TimeInBeacon instances
 */
@property (strong, nonatomic) NSMutableArray *encounters;
/**
 * media.
 * NSData containing any media for promotion
 */
@property (strong, nonatomic) NSData *media;
/**
 * region.
 * CLBeaconRegion for the Beacon
 */
@property (strong, nonatomic) CLBeaconRegion *region;
/**
 * uuid.
 * NSUUID for the Beacon
 */
@property (strong, nonatomic) NSUUID *uuid;
/**
 * major.
 * NSInteger for the Beacon's major key
 */
@property (nonatomic) NSInteger major;
/**
 * minor.
 * NSInteger for the Beacon's minor key
 */
@property (nonatomic) NSInteger minor;
/**
 * threshold.
 * int containing beacon's rssi threshold
 */
@property int threshold;
/**
 * promo.
 * Bool determines if Beacon contains a promotion
 */
@property BOOL promo;
/**
 * found.
 * Bool determines if Beacon has ever been encountered by the user
 */
@property BOOL found;
/**
 * once.
 * Bool determines if the Beacon should alert the user each time they encounter Beacon or only once
 */
@property BOOL once;
/**
 * within.
 * Bool determines if the user is currently within the Threshold
 */
@property BOOL within;
/**
 * track.
 * Bool determines if the user should track User's rssi while within the threshold
 */
@property BOOL track;

@property BOOL seen;

-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andTrack:(BOOL)trackIn;
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andTrack:(BOOL)trackIn andOnce:(BOOL)onceIn;
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andThreshold:(int)thresholdIn andTrack:(BOOL)trackIn andOnce:(BOOL)onceIn;
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andMedia:(NSData *)mediaIn andTrack:(BOOL)trackIn andOnce:(BOOL)onceIn;
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andThreshold:(int)thresholdIn andMedia:(NSData *)mediaIn andTrack:(BOOL)trackIn andOnce:(BOOL)onceIn;
-(BOOL) isSame: (Beacon *)beaconIn;
-(void) markEnter;
-(void) markExit;
-(void) range:(NSInteger)rssi;
-(void) startManager:(CLLocationManager *)managerIn;

@end
