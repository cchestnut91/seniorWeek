//
//  PBiBeaconManager.m
//  beaconTest
//
//  Created by Andrew Sowers on 4/1/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "PBiBeaconManager.h"



@implementation PBiBeaconManager
@synthesize myBeacons,beacon;

static PBiBeaconManager *sharedPBiBeaconManager = nil;

+(PBiBeaconManager *)sharedCenter{
    if(sharedPBiBeaconManager == nil){
        static dispatch_once_t pred = 0;
        dispatch_once(&pred, ^{
            sharedPBiBeaconManager = [[super allocWithZone:NULL]init];
        });
    }
    return sharedPBiBeaconManager;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedCenter];
}

-(id)initWithIdent:(NSString *)app_id_in andManager:(CLLocationManager *)managerIn{
    if((self = [super init])){
        app_id = app_id_in;
        NSData *beaconData = [[NSData alloc] initWithContentsOfURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"http://experiencepush.com/beacon_portal/beacon_request.php?id='%@'",app_id_in]]];
        NSError *error;
        NSMutableDictionary *beaconsFromJSON;
        if (beaconData){
            beaconsFromJSON = [NSJSONSerialization
                               JSONObjectWithData:beaconData
                               options:NSJSONReadingMutableContainers
                               error:&error];
        }
        myBeacons = [[NSMutableDictionary alloc]init];
        
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSArray *data = beaconsFromJSON[@"beacons"];
            int i=0;
            for ( NSDictionary *serialData in data )
            {
                if ([serialData[@"cur_app_id"] isEqual:app_id]) {
                    BOOL promo = NO;
                    NSData *imgData;
                    if ([serialData[@"method_id"] isEqualToString:@"promo"]){
                        promo = YES;
                    }
                    beacon = [[Beacon alloc] initWithIdent:[NSString stringWithFormat:@"%@", serialData[@"ident"]] andUUID:[[NSUUID alloc] initWithUUIDString:[NSString stringWithFormat:@"%@", serialData[@"UUID"]]] andMajor:(NSInteger)1 andMinor:(NSInteger)1 andPromo:promo andTitle:[NSString stringWithFormat:@"%@", serialData[@"beacon_message"]] andMessage:[NSString stringWithFormat:@"%@", serialData[@"beacon_message_meta"]] andTrack:[serialData[@"track"] boolValue] andOnce:[serialData[@"andOnce"] boolValue]];
                    if (![serialData[@"img_ref"] isKindOfClass:[NSNull class]]){
                        imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:serialData[@"img_ref"]]];
                        [beacon setMedia:imgData];
                    }
                    if (![serialData[@"beacon_range"] isKindOfClass:[NSNull class]]){
                        int threshold = [serialData[@"beacon_range"] intValue];
                        [beacon setThreshold:threshold * -1];
                    } else {
                        [beacon setThreshold:50];
                    }
                    [beacon startManager:managerIn];

                    NSLog(@"%d %@",i,beacon.uuid);
                    [myBeacons setObject:beacon forKey:[beacon ident]];
                    i++;
                }
            }
        }
    }
    return self;
}

-(NSMutableDictionary *)beacons
{
    return myBeacons;
}
@end
