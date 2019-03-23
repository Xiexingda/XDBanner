//
//  XDBannerSetUp.h
//  XDBanner
//
//  Created by 谢兴达 on 2019/2/18.
//  Copyright © 2019 谢兴达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XDBannerStyle) {
    XD_LeftToRight,
    XD_RightToLeft
};

@interface XDBannerSetUp : NSObject
@property (nonatomic, assign) BOOL needAutoChange;
@property (nonatomic, assign) XDBannerStyle style;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) BOOL needPageIndicator;
@property (nonatomic, strong) UIColor *indicatorDefaultColor;
@property (nonatomic, strong) UIColor *indicatorSelectedColor;
@end
