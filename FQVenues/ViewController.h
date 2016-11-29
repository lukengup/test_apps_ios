//
//  ViewController.h
//  FQVenues
//
//  Created by pro on 2016/11/25.
//  Copyright © 2016 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Api.h"
#import "GridCell.h"
#import "Venue.h"
#import "AlbumViewController.h"
#import "MapViewController.h"



@interface ViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NSURLSessionDataDelegate,NSURLSessionTaskDelegate, CLLocationManagerDelegate> {
    
    NSMutableData *responseData;
    NSDictionary *results;
    NSMutableArray *venues;
    NSArray * gridItems;
    Api * api;
  
   
   
    
    
}



-(void) startListingVenuesForLocation: (CLLocation *)currentLocation;

@property(strong)   CLLocation *currentLocation;
@property(strong)  CLLocationManager * locationManager;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end

