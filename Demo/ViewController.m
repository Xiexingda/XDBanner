//
//  ViewController.m
//  Demo
//
//  Created by 谢兴达 on 2019/3/23.
//  Copyright © 2019 谢兴达. All rights reserved.
//

#import "ViewController.h"
#import "XDBanner.h"

@interface ViewController ()
@property (nonatomic, strong) XDBanner *banner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XDBannerSetUp *setup = [[XDBannerSetUp alloc]init];
    setup.style = XD_LeftToRight;
    setup.needAutoChange = YES;
    CGRect rect = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200);
    _banner = [[XDBanner alloc]initWithFrame:rect
                                 sourceItems:@[@"banner1.jpg",@"banner2.jpg",@"banner1.jpg",@"banner2.jpg",@"banner1.jpg",@"banner2.jpg",@"banner1.jpg"]
                                       setUp:setup
                                     itemTap:^(NSInteger index, id item) {
                                         NSLog(@"tap:%@---%ld",item, (long)index);
                                     } currentItem:^(NSInteger index, id item) {
                                         NSLog(@"%@---%ld",item, (long)index);
                                     }];
    [self.view addSubview:_banner];
}


@end

