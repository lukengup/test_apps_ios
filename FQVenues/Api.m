//
//  Api.m
//  FQVenues
//
//  Created by pro on 2016/11/25.
//  Copyright © 2016 pro. All rights reserved.
//

#import "Api.h"
static NSString * CLIENT_ID = @"S1XJTE3EU4VDYCPSD41HVQRDMLCZZQZAKPZ0O40F131CPEIA";
static NSString * CLIENT_SECRET = @"B4LRRMFACGBUFVTHYVEAG2IA5YNXOPWSCOPEIE0JOWFLRJY4";


@implementation Api
@synthesize api_request;

-(id) init {
    self = [super init];

    return self;
}

-(id) didBuildUrl:(NSString *)module WithParams:(NSMutableDictionary *)params{
    
    NSMutableString *parts = [ NSMutableString string];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMd";
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    for ( NSString * key in params){
        [parts appendFormat:@"%@", [NSString stringWithFormat:@"&%@=%@",key,[params objectForKey:key]]];
        
    }
    
    self.api_request= [NSString  stringWithFormat:@"https://api.foursquare.com/v2/%@?client_id=%@&client_secret=%@%@&v=%@",module,CLIENT_ID, CLIENT_SECRET, parts, date];
    
    NSLog(@"%@", api_request);
    return self;
}








@end
