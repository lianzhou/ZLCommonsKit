//
//  UIScrollView+JZRefresh.m
//  ZLCommonsKit
//
//  Created by zhoulian on 2017/6/5.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "UIScrollView+JZRefresh.h"
#import <objc/runtime.h>
#import "JZRefreshHeader.h"
#import "JZSystemMacrocDefine.h"


@implementation UIScrollView (JZRefresh)

- (void)addRefreshHeaderWithNormal:(BOOL)isNormal Handle:(void (^)())handle {
    JZRefreshHeader * header = [[JZRefreshHeader alloc] init];
    header.isNormal = isNormal;
    header.handle = handle;
    self.JZ_header = header;
    [self insertSubview:header atIndex:0];
    
    header.frame = CGRectMake((SCREEN_WIDTH - SURefreshHeaderHeight)/2, 0, SURefreshHeaderHeight, SURefreshHeaderHeight);
}

#pragma mark - Associate
-(void)setJZ_header:(JZRefreshHeader *)JZ_header{
    objc_setAssociatedObject(self, @selector(JZ_header), JZ_header, OBJC_ASSOCIATION_ASSIGN);
}

- (JZRefreshHeader *)JZ_header {
    return objc_getAssociatedObject(self, @selector(JZ_header));
}

#pragma mark - Swizzle
+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method swizzleMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"JZ_dealloc"));
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

- (void)JZ_dealloc {
    self.JZ_header = nil;
    [self JZ_dealloc];
}




@end
