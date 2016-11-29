//
//  Location.m
//  FQVenues
//
//  Created by pro on 2016/11/29.
//  Copyright © 2016 pro. All rights reserved.
//

#import "MyLocation.h"


@implementation MyLocation
@synthesize venueId, coordinate;

-(id)initWithCoordinates:(CLLocationCoordinate2D)myCoordinate venueId:(NSString *) myVenueId {
    if ((self = [super init])) {
        venueId = myVenueId;
        coordinate = myCoordinate;
    }
    return self;
}


@end
