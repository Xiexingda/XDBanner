//
//  XDBannerItem.m
//  XDBanner
//
//  Created by 谢兴达 on 2019/2/18.
//  Copyright © 2019 谢兴达. All rights reserved.
//

#import "XDBannerItem.h"
#import "UIImageView+WebCache.h"

@interface XDBannerItem ()
@property (nonatomic, strong) UIImageView *itemImage;
@end

@implementation XDBannerItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
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

- (void)configItemBySource:(id)source index:(NSIndexPath *)index itemTap:(void (^)(NSInteger, id))itemtap {
    __weak typeof(self) weakSelf = self;
    if ([source isKindOfClass:[UIImage class]]) {
        _itemImage.image = source;
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:source];
        
    } else if ([source isKindOfClass:[NSString class]]) {
        [_itemImage sd_setImageWithURL:[NSURL URLWithString:source] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                UIImage *image = [UIImage imageNamed:source];
                if (image) {
                    weakSelf.itemImage.image = image;
                    weakSelf.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
                }
            } else {
                weakSelf.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
            }
        }];
        
    } else if ([source isKindOfClass:[NSData class]]) {
        UIImage *image = [UIImage imageWithData:source];
        if (image) {
            _itemImage.image = image;
            self.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
        }
    }
    
    [_itemImage tapBlock:^(id obj) {
        if (itemtap) {
            itemtap(index.row - 1 ,source);
        }
    }];
}
@end
