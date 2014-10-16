//
//  Location.m
//  GetOnThatBus
//
//  Created by Richmond on 10/14/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "Location.h"

@implementation Location

+(Location *)createLocationObject:(NSDictionary *)locationDictionary{
    Location *location = [[Location alloc]init];
    location.name = locationDictionary[@"cta_stop_name"];
    CLLocationCoordinate2D coords;
    coords.latitude = [locationDictionary[@"latitude"] doubleValue];
    coords.longitude = [locationDictionary[@"longitude"] doubleValue];
    location.coords = coords;
    location.routes = locationDictionary[@"routes"];
    if (locationDictionary[@"inter_modal"]) {
        location.interModal = locationDictionary[@"inter_modal"];
    }

    return location;
}
@end
