//
//  Api.h
//  FQVenues
//
//  Created by pro on 2016/11/25.
//  Copyright © 2016 pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Api : NSObject<NSURLConnectionDelegate>{
   
    NSMutableData *responseData;
    NSDictionary *results;
   
}


-(id) init;
-(id) didBuildUrl: (NSString *)module WithParams : (NSDictionary *) params;


@property  NSString *api_request;


@end
