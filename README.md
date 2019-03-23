# XDBanner
轮播图

# 使用方法
1. 把XDBanner包拉入项目
2. 引入头文件 #import "XDBanner.h"
3. 初始化
```
XDBannerSetUp *setup = [[XDBannerSetUp alloc]init];
setup.style = XD_LeftToRight;
setup.needAutoChange = YES;

_banner = [[XDBanner alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 200)
sourceItems:@[@"banner1.jpg",@"banner2.jpg",@"banner1.jpg"]
setUp:setup
itemTap:^(NSInteger index, id item) {
NSLog(@"%ld",(long)index);
} currentItem:^(NSInteger index, id item) {
NSLog(@"%@---%ld",item, (long)index);
}];

[self.view addSubview:_banner];
```
