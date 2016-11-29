//
//  MapViewController.m
//  FQVenues
//
//  Created by pro on 2016/11/29.
//  Copyright © 2016 pro. All rights reserved.
//

#import "MapViewController.h"
#import "MyLocation.h"



@implementation MapViewController
@synthesize location;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.mapView setCenterCoordinate:self.location.coordinate];
    
    Api *api = [[Api alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dict setObject:[NSString  stringWithFormat:@"%f,%f", self.location.coordinate.latitude,self.location.coordinate.longitude] forKey:@"ll"];
    
    NSString * api_request =  [[api didBuildUrl:@"venues/search" WithParams:dict] api_request];

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:api_request]];
    
  
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest: request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    NSError *err;
                    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
                    
                    
                    dispatch_async(dispatch_get_main_queue(),
                                   ^{
                                       NSArray * venues = parsed[@"response"][@"venues"];
                                       for (NSDictionary *venue in venues) {
                                           CLLocationCoordinate2D coordinate;
                                           coordinate.latitude =  [venue[@"location"][@"lat"] doubleValue];
                                           coordinate.longitude = [venue[@"location"][@"lng"] doubleValue];
                                           MyLocation *annotation = [[MyLocation alloc] initWithCoordinates:coordinate venueId:venue[@"id"]];
                                           
                                
                                           [self.mapView addAnnotation:annotation];
                                       }
                                   });
                }] resume];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Location";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"pointer.png"];
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showAlbumsFromMap" sender:view];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlbumsFromMap"]) {
        
    
        MyLocation *myLocation =(MyLocation *) sender;
        
        AlbumViewController *albumViewController = (AlbumViewController *) segue.destinationViewController;
        albumViewController.venueId = myLocation.venueId;
        
        
    }

   }


@end
