//
//  Beacon.h
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 4/15/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Beacon : NSObject <NSCoding>

@property (strong, nonatomic) NSString *ident;
@property (strong, nonatomic) NSMutableArray *encounters;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSData *media;
@property (strong, nonatomic) CLBeaconRegion *region;
@property (strong, nonatomic) NSUUID *uuid;
@property (nonatomic) NSInteger major;
@property (nonatomic) NSInteger minor;
@property CGFloat threshold;
@property BOOL promo;
@property BOOL found;
@property BOOL once;
@property BOOL within;
@property BOOL track;

-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andTrack:(BOOL)trackIn;
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTrack:(BOOL)trackIn andOnce:(BOOL)onceIn;
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andTrack:(BOOL)trackIn;
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andThreshold:(CGFloat)thresholdIn andTrack:(BOOL)trackIn;
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andMedia:(NSData *)mediaIn andTrack:(BOOL)trackIn;
-(id) initWithIdent:(NSString *)identIn andUUID:(NSUUID *)uuidIn andMajor:(NSInteger)major andMinor:(NSInteger)minorIn andPromo:(BOOL)promoIn andTitle:(NSString *)titleIn andMessage:(NSString *)messageIn andThreshold:(CGFloat)thresholdIn andMedia:(NSData *)mediaIn andTrack:(BOOL)trackIn;
-(void) enter;
-(void) exit;
-(void) track:(NSInteger)rssi;

@end
