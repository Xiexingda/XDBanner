//
//  XDBanner.m
//  XDBanner
//
//  Created by 谢兴达 on 2019/2/18.
//  Copyright © 2019 谢兴达. All rights reserved.
//

#import "XDBanner.h"
#import "XDBannerItem.h"

typedef NS_ENUM(NSInteger, DraggingStatus) {
    D_Default,
    D_Dragging
};

static NSString *itemID = @"XDBannerItemIDF";
typedef void(^ItemBlock)(NSInteger index, id item);

@interface XDBanner ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *itemSource;
@property (nonatomic, strong) NSArray *itemSourceOriginal;
@property (nonatomic, strong) XDBannerSetUp *setUp; //配置
@property (nonatomic,   copy) ItemBlock tapBlock;//点击回调
@property (nonatomic,   copy) ItemBlock nowBlock;//当前回调
@property (nonatomic, strong) UICollectionView *bannerView;                 //banner
@property (nonatomic, strong) UICollectionViewFlowLayout *bannerLayout;     //布局
@property (nonatomic, strong) UIPageControl *pageIndicator;                 //指示器
@property (nonatomic, assign) __block NSInteger bufferIndex;
@property (nonatomic, strong) dispatch_source_t time;
@property (nonatomic, assign) DraggingStatus status;
@end

@implementation XDBanner
- (void)dealloc {
    [self endTime];
}

- (UICollectionViewFlowLayout *)bannerLayout {
    if (!_bannerLayout) {
        _bannerLayout = [[UICollectionViewFlowLayout alloc]init];
    }
    return _bannerLayout;
}

- (UIPageControl *)pageIndicator {
    if (!_pageIndicator) {
        _pageIndicator = [[UIPageControl alloc]init];
        _pageIndicator.userInteractionEnabled = NO;
    }
    return _pageIndicator;
}

- (NSArray *)sourceHandle:(NSArray *)source {
    if (!source || source.count <= 0) {
        return source;
    }
    NSMutableArray *formArray = source.mutableCopy;
    [formArray insertObject:source.lastObject atIndex:0];
    [formArray addObject:source.firstObject];
    return formArray.copy;
}

- (instancetype)initWithFrame:(CGRect)frame sourceItems:(NSArray *)sourceitems setUp:(XDBannerSetUp *)setup itemTap:(void (^)(NSInteger, id))itemtap currentItem:(void (^)(NSInteger, id))currentitem {
    self = [super initWithFrame:frame];
    if (self) {
        self.itemSourceOriginal = sourceitems;
        self.itemSource = [self sourceHandle:sourceitems];
        self.setUp = setup ? setup : [[XDBannerSetUp alloc]init];
        self.tapBlock = itemtap;
        self.nowBlock = currentitem;
        self.bufferIndex = 1;
        [self creatBanner];
        [self creatPageIndicator];
        [self bannerStatusHandle];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (!_bannerView) {
        return;
    }
    self.bannerView.frame = self.bounds;
    self.pageIndicator.frame = CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50);
    [self.bannerView reloadData];
}

- (void)creatBanner {
    self.bannerLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.bannerLayout.minimumLineSpacing = 0;
    self.bannerLayout.minimumInteritemSpacing = 0;
    
    self.bannerLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.bannerView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.bannerLayout];
    self.bannerView.delegate = self;
    self.bannerView.dataSource = self;
    self.bannerView.pagingEnabled = YES;
    self.bannerView.decelerationRate = 0.8;
    self.bannerView.showsHorizontalScrollIndicator = NO;
    self.bannerView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.bannerView];
    
    [self.bannerView registerClass:[XDBannerItem class] forCellWithReuseIdentifier:itemID];
    
    if (self.itemSourceOriginal && self.itemSourceOriginal.count > 0) {
        //让初始状态从第二个item开始
        [self.bannerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self loopMethod];
    }
}

- (void)creatPageIndicator {
    [self addSubview:self.pageIndicator];
    self.pageIndicator.frame = CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50);
    self.pageIndicator.currentPage = 0;
    self.pageIndicator.pageIndicatorTintColor = self.setUp.indicatorDefaultColor;
    self.pageIndicator.currentPageIndicatorTintColor = self.setUp.indicatorSelectedColor;
}

- (void)xd_refreshBannerBySourceItems:(NSArray *)sourceitems {
    self.itemSourceOriginal = sourceitems;
    self.pageIndicator.hidden = self.setUp.needPageIndicator ? sourceitems.count > 1 ? NO : YES : YES;
    self.itemSource = [self sourceHandle:sourceitems];
    [self.bannerView reloadData];
    [self loopMethod];
    [self bannerStatusHandle];
}

- (void)bannerStatusHandle {
    self.pageIndicator.numberOfPages = self.itemSourceOriginal.count;
    if (self.itemSourceOriginal && self.itemSourceOriginal.count > 1) {
        self.bannerView.scrollEnabled = YES;
        self.pageIndicator.hidden = !self.setUp.needPageIndicator;
        [self startTime];
        
    } else {
        self.bannerView.scrollEnabled = NO;
        self.pageIndicator.hidden = YES;
        [self endTime];
    }
}

- (void)loopMethod {
    if (!self.itemSourceOriginal || self.itemSourceOriginal <= 0) {return;}
    CGFloat c_w = CGRectGetWidth(self.frame);
    
    if (self.bannerView.contentOffset.x <= 0) {
        self.bannerView.contentOffset = CGPointMake(c_w * (self.itemSource.count - 2), 0);
        
    } else if (self.bannerView.contentOffset.x >= (self.itemSource.count - 1) * c_w) {
        self.bannerView.contentOffset = CGPointMake(c_w, 0);
    }
    
    NSInteger page_forward = floor(self.bannerView.contentOffset.x/c_w);     //前页
    NSInteger page_later   = ceil(self.bannerView.contentOffset.x/c_w);      //后页
    
    if (_bufferIndex < page_forward) {
        _bufferIndex = page_forward;
        [self hasChangedToIndex:page_forward];
        
        
    } else if (_bufferIndex > page_later) {
        _bufferIndex = page_later;
        [self hasChangedToIndex:page_later];
    }
}

- (void)hasChangedToIndex:(NSUInteger)index {
    if (self.nowBlock) {
        self.nowBlock(index-1, self.itemSourceOriginal[index-1]);
    }
    self.pageIndicator.currentPage = index-1;
}

- (void)startTime {
    if (_time || !self.setUp.needAutoChange) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.time = dispatch_source_create(&_dispatch_source_type_timer, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.time, dispatch_time(DISPATCH_TIME_NOW, self.setUp.duration*NSEC_PER_SEC), self.setUp.duration*NSEC_PER_SEC, 0*NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.time, ^{
        NSInteger currentIndex = 0;
        if (weakSelf.setUp.style == XD_RightToLeft) {
            currentIndex = weakSelf.bufferIndex + 1;
            
        } else if (weakSelf.setUp.style == XD_LeftToRight) {
            currentIndex = weakSelf.bufferIndex - 1;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
        //滚动到下一张
        [weakSelf.bannerView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    });
    
    dispatch_resume(self.time);
}

//结束计时器
- (void)endTime {
    if (!self.time) {
        return;
    }
    dispatch_source_cancel(self.time);
    self.time = nil;
}

#pragma mark
#pragma mark -- datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDBannerItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    [item configItemBySource:self.itemSource[indexPath.row] index:indexPath itemTap:self.tapBlock];
    return item;
}

#pragma mark
#pragma mark -- delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.status == D_Dragging) {
        [self loopMethod];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.status = D_Dragging;
    [self endTime];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.status = D_Default;
    [self startTime];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loopMethod];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self loopMethod];
}
@end
