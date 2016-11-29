//
//  AlbumViewController.m
//  FQVenues
//
//  Created by pro on 2016/11/28.
//  Copyright © 2016 pro. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController
@synthesize venueId, collectionView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    api = [[Api alloc] init];

    
     NSString *api_request = [[api didBuildUrl:[NSString stringWithFormat:@"venues/%@/photos", [self venueId] ] WithParams:[ [NSMutableDictionary alloc] init]] api_request];
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    NSURLSessionTask *task = [session dataTaskWithURL  :[NSURL URLWithString:api_request]];
    [task resume];
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GridCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"gridCell" forIndexPath:indexPath];
    
    
    NSMutableArray *data = [gridItems objectAtIndex:indexPath.section];
    
    Photo *photo = [data objectAtIndex:indexPath.row];
    
    cell.cover.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.url]]];
    
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
        NSMutableArray * photos_temp =[[NSMutableArray alloc]init];
        dispatch_async(dispatch_get_main_queue(),
                                       ^{
                                           NSArray * photo_list = results[@"response"][@"photos"][@"items"];
                                           for (NSDictionary *photo in photo_list) {
                                                Photo *p = [[Photo alloc] init];
                                                [p setIdentifier:photo[@"id"]];
                                                [p setUrl:[NSString stringWithFormat:@"%@width960%@", photo[@"prefix"],photo[@"suffix"]]];
                                               
                                                [p setSource:photo[@"source"][@"name"]];
                                                [p setFirstName:photo[@"user"][@"firstName"] ];
                                                [p setSurname:photo[@"user"][@"lastName"] ];
                                                [p setCreatedAt: photo[@"createdAt"]];
                                                [photos_temp addObject:p];
                                            }
                                           
                                           photos =photos_temp;
                                           
                                           
                                           gridItems = [[NSArray alloc] initWithObjects:photos, nil];
                                           
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showPhoto"]) {
        UICollectionViewCell * cell = (UICollectionViewCell *) sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        NSMutableArray *data = [gridItems objectAtIndex:indexPath.section];
        Photo *photo = [data objectAtIndex:indexPath.row];
        PhotoViewController *photoViewController = (PhotoViewController *) segue.destinationViewController;
        
        photoViewController.photo = photo;
        
        
    }
}


@end
