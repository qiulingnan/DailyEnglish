//
//  HWBaseWebViewController.h
//  WebView封装
//
//  Created by Hanwen on 2017/12/28.
//  Copyright © 2017年 SK丿希望. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - 尺寸相关
#define HWScreenW [UIScreen mainScreen].bounds.size.width
#define HWScreenH [UIScreen mainScreen].bounds.size.height
#define HWWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;  // 弱引用
#ifdef DEBUG // 开发
#define HWLog(...) NSLog(@"%s %d \n%@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else // 生产
#define HWLog(...) //NSLog(@"%s %d \n%@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#endif
@interface HWBaseWebViewController : UIViewController
/** <#注释#> */
@property(nonatomic, strong) NSURL *url;
@end
