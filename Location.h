//
//  Location.h
//  GetOnThatBus
//
//  Created by Richmond on 10/14/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject //<MKAnnotation>
@property NSString *name;
@property NSString *longitude;
@property NSString *latitude;
@property NSString *routes;
@property NSString *address;
@property NSString *interModal;

-(Location *)createLocationObject:(NSDictionary *)locationDictionary;
@end
