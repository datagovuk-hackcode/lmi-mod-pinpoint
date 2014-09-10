//
//  MKMapView+ZoomLevel.h
//  JobHappy
//
//  Created by Harry Jones on 08/02/2014.
//  Copyright (c) 2014 Harry Jones. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end