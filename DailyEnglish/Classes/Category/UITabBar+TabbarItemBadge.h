//
//  UITabBar+TabbarItemBadge.h
//  ManPlaying
//
//  Created by 邱岭男 on 16/7/15.
//  Copyright © 2016年 邱岭男. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (TabbarItemBadge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
