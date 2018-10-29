//
//  UIButton+Badge.m
//  ManPlaying
//
//  Created by 邱岭男 on 16/7/15.
//  Copyright © 2016年 邱岭男. All rights reserved.
//

#import "UIButton+Badge.h"

@implementation UIButton (Badge)

- (void)showBadge{
    
    //移除之前的小红点
    [self removeBadge];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect btnFrame = self.frame;
    
    //确定小红点的位置
    CGFloat x = ceilf([UIScreen mainScreen].bounds.size.width) - 20;
    CGFloat y = ceilf(btnFrame.size.height/2) - 5;
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
    
}

- (void)hideBadge{
    
    //移除小红点
    [self removeBadge];
    
}

- (void)removeBadge{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end
