/**
 *  EventTableViewController.
 *  Description: Main View for Senior Week Application by Push Interactive. Contains code to search for and react to Beacons\n Beacon functionality could potentially be moved to another Class.
 *  @author Calvin Chestnut
 *
 */

#import <UIKit/UIKit.h>
#import "sharedEventList.h"
#import <CoreLocation/CoreLocation.h>
#import "SerialGATT.h"
#import "PromoViewController.h"

#define RSSI_THRESHOLD -60  // boundry signal strength

@class CBPeripheral;
@class SerialGATT;

@interface EventTableViewController : UITableViewController <CLLocationManagerDelegate, BTSmartSensorDelegate>{
    NSMutableDictionary *beaconDict;
};

/**
 * promoView.
 * PromoViewController which displays information about specific promotion
 */
@property (strong, nonatomic) PromoViewController *promoView;
/**
 * menuButton.
 * Help Button which sits in NavigationBar
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
/**
 * promoButton.
 * Promos button which shows all available promotions
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *promoButton;
/**
 * locationManager.
 * CLLocationManager which acts as default location manager
 */
@property (strong, nonatomic) CLLocationManager *locationManager;
/**
 * beacons.
 * NSMutableDictionary which stores Beacons to be searched for
 */
@property (strong, nonatomic) NSMutableDictionary *beacons;
/**
 * promos.
 * NSMutableDictionary which stores promotions available in the User's current location
 */
@property (strong, nonatomic) NSMutableDictionary *promos;
/**
 * archivePath.
 * NSString which holds path to plist containing Beacon information stored
 */
@property (strong, nonatomic) NSString *archivePath;
@property (strong, nonatomic) NSString *docDirectory;

/**
 * sensor.
 * SerialGATT, not sure what this does
 */
@property (strong, nonatomic) SerialGATT *sensor;


@end
