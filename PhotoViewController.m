//
//  PhotoViewController.m
//  FQVenues
//
//  Created by pro on 2016/11/28.
//  Copyright © 2016 pro. All rights reserved.
//

#import "PhotoViewController.h"


@interface PhotoViewController ()


@end

@implementation PhotoViewController
@synthesize imageView,label1,label2,photo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   self.imageView.image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photo.url]]];
    self.label1.text = [NSString  stringWithFormat:@"%@,%@",photo.firstName,photo.surname];
    self.label2.text = photo.createdAt;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
