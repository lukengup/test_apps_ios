//
//  MapViewController.h
//  FQVenues
//
//  Created by pro on 2016/11/29.
//  Copyright © 2016 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CLLocation.h>
#import "Venue.h"
#import "AlbumViewController.h"
#import "Api.h"

@interface MapViewController : UIViewController<MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property(nonatomic, weak) CLLocation *location;




@end
