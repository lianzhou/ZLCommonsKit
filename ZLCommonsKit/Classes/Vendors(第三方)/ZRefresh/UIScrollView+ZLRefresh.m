//
//  UIScrollView+ZLRefresh.m
//  ZLCommonsKit
//
//  Created by zhoulian on 2017/6/5.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "UIScrollView+ZLRefresh.h"
#import <objc/runtime.h>
#import "ZLRefreshHeader.h"
#import "ZLSystemMacrocDefine.h"


@implementation UIScrollView (ZLRefresh)

- (void)addRefreshHeaderWithNormal:(BOOL)isNormal Handle:(void (^)())handle {
    ZLRefreshHeader * header = [[ZLRefreshHeader alloc] init];
    header.isNormal = isNormal;
    header.handle = handle;
    self.ZL_header = header;
    [self insertSubview:header atIndex:0];
    
    header.frame = CGRectMake((SCREEN_WIDTH - SURefreshHeaderHeight)/2, 0, SURefreshHeaderHeight, SURefreshHeaderHeight);
}

#pragma mark - Associate
-(void)setZL_header:(ZLRefreshHeader *)ZL_header{
    objc_setAssociatedObject(self, @selector(ZL_header), ZL_header, OBJC_ASSOCIATION_ASSIGN);
}

- (ZLRefreshHeader *)ZL_header {
    return objc_getAssociatedObject(self, @selector(ZL_header));
}

#pragma mark - Swizzle
+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method swizzleMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"ZL_dealloc"));
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

- (void)ZL_dealloc {
    self.ZL_header = nil;
    [self ZL_dealloc];
}




@end
