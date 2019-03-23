//
//  XDBannerItem.m
//  XDBanner
//
//  Created by 谢兴达 on 2019/2/18.
//  Copyright © 2019 谢兴达. All rights reserved.
//

#import "XDBannerItem.h"
#import <objc/runtime.h>

@interface XDBannerItem ()
@property (nonatomic, strong) UIImageView *itemImage;
@end

@implementation XDBannerItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        [self creatMainUI];
    }
    return self;
}

- (void)creatMainUI {
    
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //毛玻璃视图
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    
    visualEffectView.frame = self.bounds;
    
    visualEffectView.alpha = 0.9;
    
    [self.contentView addSubview:visualEffectView];
    
    _itemImage = [[UIImageView alloc]initWithFrame:self.bounds];
    _itemImage.userInteractionEnabled = YES;
    _itemImage.backgroundColor = [UIColor clearColor];
    _itemImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_itemImage];
}

- (void)configItemBySource:(id)source itemTap:(void (^)(id))itemtap {
    if ([source isKindOfClass:[UIImage class]]) {
        _itemImage.image = source;
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:source];
        
    } else if ([source isKindOfClass:[NSString class]]) {
        UIImage *image = [UIImage imageNamed:source];
        if (image) {
            _itemImage.image = image;
            self.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
        }
    } else if ([source isKindOfClass:[NSData class]]) {
        UIImage *image = [UIImage imageWithData:source];
        if (image) {
            _itemImage.image = image;
            self.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
        }
    }
    
    [_itemImage tapBlock:^(id obj) {
        if (itemtap) {
            itemtap(source);
        }
    }];
}
@end
