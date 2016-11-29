//
//  Venue.h
//  FQVenues
//
//  Created by pro on 2016/11/25.
//  Copyright © 2016 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject
@property (nonatomic) NSString *identifier;
@property (assign) double latitude;
@property (assign) double longitude;
@property (assign) int distance;
@property (nonatomic) NSString *displayPhoto;


@end
