//
//  XDBannerSetUp.m
//  XDBanner
//
//  Created by 谢兴达 on 2019/2/18.
//  Copyright © 2019 谢兴达. All rights reserved.
//

#import "XDBannerSetUp.h"

@implementation XDBannerSetUp
- (instancetype)init {
    self = [super init];
    if (self) {
        _needAutoChange = YES;
        _needPageIndicator = YES;
        _style = XD_RightToLeft;
        _duration = 4.0;
        _indicatorDefaultColor = [UIColor lightGrayColor];
        _indicatorSelectedColor = [UIColor orangeColor];
    }
    return self;
}
@end
