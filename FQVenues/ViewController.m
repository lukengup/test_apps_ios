//
//  ViewController.m
//  FQVenues
//
//  Created by pro on 2016/11/25.
//  Copyright © 2016 pro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Venues";
   // UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,10,320,30)];

    
    UIImage* imgforRightButton = [UIImage imageNamed:@"map_button.png"];
    CGRect frameimg = CGRectMake(0, 0, imgforRightButton.size.width, imgforRightButton.size.height);
    
    UIButton *rightButton = [[UIButton alloc]  initWithFrame:frameimg];
    
    [rightButton setBackgroundImage:imgforRightButton forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showMap)
         forControlEvents:UIControlEventTouchUpInside];
    [rightButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=mailbutton;
    self.navigationItem.rightBarButtonItem.enabled = false;
    
    
     self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
}

-(void) showMap{
     [self performSegueWithIdentifier:@"showMap" sender:self];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    self.currentLocation = [locations lastObject];
    self.navigationItem.rightBarButtonItem.enabled = true;

    if (self.currentLocation != nil) {
        [self startListingVenuesForLocation:self.currentLocation];
    }
    [self.locationManager stopUpdatingLocation];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showalbum"]) {
        UICollectionViewCell * cell = (UICollectionViewCell *) sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
        NSMutableArray *data = [gridItems objectAtIndex:indexPath.section];
        Venue *venue = [data objectAtIndex:indexPath.row];
        AlbumViewController *albumViewController = (AlbumViewController *) segue.destinationViewController;
        
        albumViewController.venueId = venue.identifier;
        
        
     }
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        
        MapViewController *mapViewController = (MapViewController *) segue.destinationViewController;
        mapViewController.location = self.currentLocation;
       
        
        
    }
}

- (void) startListingVenuesForLocation: (CLLocation *) myLocation {
    double latitude =  myLocation.coordinate.latitude;
    double longitude = myLocation.coordinate.longitude ;
    
    api = [[Api alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dict setObject:[NSString  stringWithFormat:@"%f,%f",latitude,longitude] forKey:@"ll"];
    
    NSString * api_request =  [[api didBuildUrl:@"venues/search" WithParams:dict] api_request];
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    NSURLSessionTask *task = [session dataTaskWithURL  :[NSURL URLWithString:api_request]];
    [task resume];
    [self.collectionView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    UIAlertController * alert = [UIAlertController
                                alertControllerWithTitle:@"Error"
                                message:@"Failed to Get Your Location"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];

    
    [alert addAction:okButton];
  
    
    [self presentViewController:alert animated:YES completion:nil];
    
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"venue_cover" forIndexPath:indexPath];
    
    
    
    NSMutableArray *data = [gridItems objectAtIndex:indexPath.section];
    Venue *venue = [data objectAtIndex:indexPath.row];
    NSString *api_request = [[api didBuildUrl:[NSString stringWithFormat:@"venues/%@/photos", venue.identifier ] WithParams:[ [NSMutableDictionary alloc] init]] api_request];

     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:api_request]];
    
    NSLog(@"%@", venue.identifier);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest: request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    NSError *err;
                    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
                    
                    
                    dispatch_async(dispatch_get_main_queue(),
                    ^{
                    NSArray * items = parsed[@"response"][@"photos"][@"items"];
                        
                        if([items count] != 0 ){
                            long i = 0;
                            if([items count] > 1){
                                i = rand() % ([items count] - 1) +1;
                            }
                    
                            NSDictionary *photo = [items objectAtIndex:i];
                    
                    
                            NSString *image_url = [NSString stringWithFormat:@"%@width960%@", photo[@"prefix"], photo[@"suffix"]];
                    
                            NSLog(@"%@%@", @"Image",image_url);
                            
                            cell.cover.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]]];
                        }
                    
                    });
                    
                    
                    
                    
                    
                    
                }] resume];
    

   
    
    
          cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
    
    
    
       return cell;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [gridItems count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *sectionArray = [gridItems objectAtIndex:section];
    return [sectionArray count];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    responseData=nil;
    responseData=[[NSMutableData alloc] init];
    [responseData setLength:0];
    
    completionHandler(NSURLSessionResponseAllow);
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data {
    
    [responseData appendData:data];
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    if (error) {
        // Handle error
    }
    else {
        NSError *tempError = nil;
        results=(NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&tempError];
        // perform operations for the  NSDictionary response
        NSArray *venues_list = results[@"response"][@"venues"];
        NSMutableArray * venues_temp =[[NSMutableArray alloc]init];
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           for (NSDictionary *venue in venues_list) {
                            Venue *v = [[Venue alloc] init];
                            [v setIdentifier:venue[@"id"]];
            
                            NSDictionary * location = [venue objectForKey: @"location"];
            
                            [v setLatitude: [[location objectForKey:@"lat"] doubleValue]];
                            [v setLongitude: [[location objectForKey:@"lng"] doubleValue]];
                            [v setDistance: [[location objectForKey:@"lng"] intValue]];
        
                            [venues_temp addObject:v];
                           }
                           venues = venues_temp;
        
        //NSLog(@"%lu", [venues count]);
                           gridItems = [[NSArray alloc] initWithObjects:venues, nil];
                           [self.collectionView reloadData];
                       });
    }
}




#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float width = [[UIScreen mainScreen]bounds].size.width;
    return CGSizeMake((width-20)/5, (width-20)/5 );
}

- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


@end
