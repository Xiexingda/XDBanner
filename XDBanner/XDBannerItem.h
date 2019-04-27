//
//  XDBannerItem.h
//  XDBanner
//
//  Created by 谢兴达 on 2019/2/18.
//  Copyright © 2019 谢兴达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XDBannerHandle.h"

@interface XDBannerItem : UICollectionViewCell
- (void)configItemBySource:(id)source index:(NSIndexPath *)index itemTap:(void(^)(NSInteger index,id source))itemtap;
@end

