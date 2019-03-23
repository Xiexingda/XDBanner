//
//  UIView+XDBannerHandle.h
//  XDBanner
//
//  Created by 谢兴达 on 2019/2/18.
//  Copyright © 2019 谢兴达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XDBannerHandle)
//点击手势
- (void)tapBlock:(void(^)(id obj))block;
@end
