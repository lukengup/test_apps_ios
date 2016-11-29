//
//  Location.h
//  FQVenues
//
//  Created by pro on 2016/11/29.
//  Copyright © 2016 pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>



@interface MyLocation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *venueId;
   
}

@property (nonatomic, readonly) NSString *venueId;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
-(id)initWithCoordinates:(CLLocationCoordinate2D)coordinate venueId:(NSString *) venueId;


@end
