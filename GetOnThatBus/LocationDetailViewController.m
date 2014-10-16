//
//  LocationDetailViewController.m
//  GetOnThatBus
//
//  Created by Richmond on 10/14/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *routesLabel;
@property (strong, nonatomic) IBOutlet UILabel *interModalLabel;

@end

@implementation LocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interModalLabel.hidden = YES;
    self.title = self.location.name;
    self.routesLabel.text = self.location.routes;

    if (self.location.interModal) {
        self.interModalLabel.hidden = NO;
        self.interModalLabel.text = self.location.interModal;
    }


    CLLocation *loc = [[CLLocation alloc]initWithCoordinate:self.location.coords altitude:NO horizontalAccuracy:NO verticalAccuracy:NO timestamp:nil];

    [[[CLGeocoder alloc]init] reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         self.addressLabel.text = placemark.name;
     }];


//    NSString *urlString =[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%@,%@&sensor=false", self.location.latitude, self.location.longitude];
//    NSLog(@"%@", urlString);
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//
//    [NSURLConnection sendAsynchronousRequest: request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSLog(@"%@", data);
//        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        self.addressLabel.text = results[@"results"][1][@"formatted_address"];
//    }];
}



@end
