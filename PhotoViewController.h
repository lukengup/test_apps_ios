//
//  PhotoViewController.h
//  FQVenues
//
//  Created by pro on 2016/11/28.
//  Copyright © 2016 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property Photo * photo;

@end
