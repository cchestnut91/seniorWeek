//
//  TransportViewController.m
//  SeniorWeek2014
//
//  Created by Calvin Chestnut on 3/26/14.
//  Copyright (c) 2014 Calvin Chestnut. All rights reserved.
//

#import "TransportViewController.h"
#define METERS_PER_MILE 1609.344

@interface TransportViewController ()

@end

@implementation TransportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    CLLocationCoordinate2D zoomLocation;
    MKCoordinateRegion viewRegion;
    float maxLat;
    float minLat;
    float maxLong;
    float minLong;
    float latAvg = 0.0;
    float longAvg = 0.0;
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    if (_locations.count == 1){
        Location *place = _locations[0];
        
        maxLat = place.latitude.floatValue;
        minLat = place.latitude.floatValue;
        maxLong = place.longitude.floatValue;
        minLong = place.longitude.floatValue;
        latAvg += place.latitude.floatValue;
        longAvg += place.longitude.floatValue;
        
        zoomLocation.latitude = place.latitude.floatValue;
        zoomLocation.longitude = place.longitude.floatValue;
        [annotations addObject:place];
        [_map addAnnotation:place];
    } else {
        Location *place = _locations[0];
        maxLat = place.latitude.floatValue;
        minLat = place.latitude.floatValue;
        maxLong = place.longitude.floatValue;
        minLong = place.longitude.floatValue;
        
        for (int i = 0; i < _locations.count; i++){
            place = _locations[i];
            latAvg += place.latitude.floatValue;
            longAvg += place.longitude.floatValue;
            
            if (place.latitude.floatValue > maxLat){
                maxLat = place.latitude.floatValue;
            }
            if (place.latitude.floatValue < minLat){
                minLat = place.latitude.floatValue;
            }
            if (place.longitude.floatValue > maxLong){
                maxLong = place.longitude.floatValue;
            }
            if (place.longitude.floatValue < minLong){
                minLong = place.longitude.floatValue;
            }
            
            [annotations addObject:place];
            [_map addAnnotation:place];
            
        }
    }
    int count = (int)_locations.count;
    if (self.destination != nil){
        count++;
        
        if (self.destination.latitude.floatValue > maxLat){
            maxLat = self.destination.latitude.floatValue;
        }
        if (self.destination.latitude.floatValue < minLat){
            minLat = self.destination.latitude.floatValue;
        }
        if (self.destination.longitude.floatValue > maxLong){
            maxLong = self.destination.longitude.floatValue;
        }
        if (self.destination.longitude.floatValue < minLong){
            maxLong = self.destination.longitude.floatValue;
        }
        
        latAvg += self.destination.latitude.floatValue;
        longAvg += self.destination.longitude.floatValue;
        [annotations addObject:self.destination];
        [_map addAnnotation:self.destination];
    }
    
    latAvg /= count;
    longAvg /= count;
    
    float deltaLat = maxLat - minLat;
    float deltaLong = maxLong - minLong;
    
    zoomLocation.latitude = latAvg;
    zoomLocation.longitude = longAvg;
    
    viewRegion.center = zoomLocation;
    MKCoordinateSpan span;
    span.latitudeDelta = deltaLat * 2;
    span.longitudeDelta = deltaLong * 2;
    viewRegion.span = span;
    
    //viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE + deltaLat, 0.5*METERS_PER_MILE + deltaLong);
    
    //[_map showAnnotations:annotations animated:NO];
    [_map setMapType:MKMapTypeHybrid];
    [_map setRegion:viewRegion animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
