//
//  XDBanner.h
//  XDBanner
//
//  Created by 谢兴达 on 2019/2/18.
//  Copyright © 2019 谢兴达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDBannerSetUp.h"

@interface XDBanner : UIView
- (instancetype)initWithFrame:(CGRect)frame
                  sourceItems:(NSArray *)sourceitems
                        setUp:(XDBannerSetUp *)setup
                      itemTap:(void(^)(NSInteger index, id item))itemtap
                  currentItem:(void(^)(NSInteger index, id item))currentitem;

//刷新
- (void)xd_refreshBannerBySourceItems:(NSArray *)sourceitems;
@end
