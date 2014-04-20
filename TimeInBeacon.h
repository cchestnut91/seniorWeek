/**
 *  TimeInBeacon.
 *  Description: TimeInBeacon Class which determins when a User entered a region, when they exited, and how they moved while there.
 *  @author Calvin Chestnut
 *
 */

#import <Foundation/Foundation.h>

//NSCoding allows the Class to be archived into NSData and unarchived from NSData to a Beacon
@interface TimeInBeacon : NSObject <NSCoding>

/**
 * enter.
 * NSDate when User entered the region
 */
@property (strong, nonatomic) NSDate *enter;
/**
 * exit.
 * NSDate when User exited the region
 */
@property (strong, nonatomic) NSDate *exit;
/**
 * distArray.
 * NSMutableArray containing rssi for the time the user is within region
 */
@property (strong, nonatomic) NSMutableArray *distArray;

-(id)init;

@end
