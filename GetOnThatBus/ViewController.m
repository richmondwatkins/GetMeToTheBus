//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Richmond on 10/14/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "Location.h"
@interface ViewController () <MKMapViewDelegate>
@property NSMutableArray *locations;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locations = [[NSMutableArray alloc]init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for(NSDictionary *loc in results[@"row"]){
            NSLog(@"%@", loc);
            Location *location = [[Location alloc]init];
            location.name = loc[@"cta_stop_name"];
            location.latitude = loc[@"latitude"];
            location.longitude = loc[@"longitude"];
            [self.locations addObject:location];
        }

        [self addBusLocationPins];
    }];
}

-(void)addBusLocationPins{
    for(Location *location in self.locations){
        CLLocationCoordinate2D coord;

        coord.latitude = [location.latitude doubleValue];
        coord.longitude = [location.longitude doubleValue];

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = location.name;
        annotation.coordinate = coord;
        [self.mapView addAnnotation:annotation];
    }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView  = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pin;
}

@end
