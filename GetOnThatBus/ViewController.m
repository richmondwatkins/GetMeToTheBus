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
#import "LocationDetailViewController.h"
@interface ViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *locations;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property Location *selectedLocation;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
    self.locations = [[NSMutableArray alloc]init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for(NSDictionary *loc in results[@"row"]){
            NSString *lng = loc[@"longitude"];
            if (lng.intValue < 0) {
                Location *location = [[Location alloc]init];
                location.name = loc[@"cta_stop_name"];
                location.latitude = loc[@"latitude"];
                location.longitude = loc[@"longitude"];
                location.routes = loc[@"routes"];
                location.address = loc[@"_address"];
                if (loc[@"inter_modal"]) {
                    location.interModal = loc[@"inter_modal"];
                }
                [self.locations addObject:location];
            }
        }

        [self addBusLocationPins];
    }];
}
- (IBAction)toggleSegmentControl:(UISegmentedControl *)segmentControl {

    if (segmentControl.selectedSegmentIndex) {
        self.mapView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else{
        self.mapView.hidden = NO;
        self.tableView.hidden = YES;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    Location *location = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = location.name;

    return cell;
}

-(void)addBusLocationPins{
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    for(Location *location in self.locations){
        CLLocationCoordinate2D coord;

        coord.latitude = [location.latitude doubleValue];
        coord.longitude = [location.longitude doubleValue];

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = location.name;
        annotation.subtitle = location.routes;
        annotation.coordinate = coord;
        [annotationArray addObject:annotation];
        [self.mapView addAnnotation:annotation];
    }

    [self.mapView showAnnotations:self.mapView.annotations animated:YES];

}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{

    for(Location *location in self.locations){
        if ([location.name isEqualToString:view.annotation.title]) {
            self.selectedLocation = location;
        }
    }
    [self performSegueWithIdentifier:@"locationDetail" sender:self];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    BOOL isInterModal = NO;
    for(Location *location in self.locations){
        if ([location.name isEqualToString:annotation.title]) {
            if (location.interModal) {
                isInterModal = YES;
            }
        }
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView  = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    if (isInterModal) {
        pin.image = [UIImage imageNamed:@"inter-modal"];
    }else{
        pin.image = [UIImage imageNamed:@"non-inter-modal"];
    }

    return pin;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    LocationDetailViewController *locationDetailCtrl = [segue destinationViewController];

    if ([segue.identifier isEqualToString:@"locationDetail"]) {
        locationDetailCtrl.location = self.selectedLocation;
    }else if([segue.identifier isEqualToString:@"TableView"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        locationDetailCtrl.location = [self.locations objectAtIndex:indexPath.row];
    }
}

@end
