//
//  MKMapView.h
//  GetOnThatBus
//
//  Created by Richmond on 10/14/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
