//
//  PBiBeaconManager.h
//  beaconTest
//
//  Created by Andrew Sowers on 4/1/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"
@interface PBiBeaconManager : NSObject{
    BOOL connectionEstablished;
    NSString * app_id;
}
@property(atomic, strong)NSMutableDictionary *myBeacons;
@property(atomic, strong)Beacon *beacon;
+(PBiBeaconManager *)sharedCenter;
-(id)initWithIdent:(NSString *)app_id;
-(NSMutableDictionary *)beacons;
@end
