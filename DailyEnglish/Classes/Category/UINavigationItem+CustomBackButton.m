//
//  UINavigationItem+CustomBackButton.m
//  ManPlaying
//
//  Created by 邱岭男 on 16/8/4.
//  Copyright © 2016年 邱岭男. All rights reserved.
//

#import "UINavigationItem+CustomBackButton.h"
#import <objc/runtime.h>

@implementation UINavigationItem (CustomBackButton)

-(UIBarButtonItem *)backBarButtonItem{
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
}

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethodImp = class_getInstanceMethod(self, @selector(backBarButtonItem));
        Method destMethodImp = class_getInstanceMethod(self, @selector(myCustomBackButton_backBarbuttonItem));
        method_exchangeImplementations(originalMethodImp, destMethodImp);
    });
}

static char kCustomBackButtonKey;
-(UIBarButtonItem *)myCustomBackButton_backBarbuttonItem{
    UIBarButtonItem *item = [self myCustomBackButton_backBarbuttonItem];
    if (item) {
        return item;
    }
    item = objc_getAssociatedObject(self, &kCustomBackButtonKey);
    if (!item) {
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
        objc_setAssociatedObject(self, &kCustomBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

- (void)dealloc {
    objc_removeAssociatedObjects(self);
}

@end
