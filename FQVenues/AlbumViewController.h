//
//  AlbumViewController.h
//  FQVenues
//
//  Created by pro on 2016/11/28.
//  Copyright © 2016 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridCell.h"
#import "Api.h"
#import "Photo.h"
#import "PhotoViewController.h"



@interface AlbumViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NSURLSessionDataDelegate,NSURLSessionTaskDelegate> {
        NSMutableData *responseData;
        NSDictionary *results;
        NSMutableArray *photos;
        NSArray * gridItems;
        Api * api;

}

@property (nonatomic) NSString * venueId;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end
