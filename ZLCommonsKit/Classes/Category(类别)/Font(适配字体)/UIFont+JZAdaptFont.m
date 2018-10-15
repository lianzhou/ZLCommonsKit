//
//  UIFont+JZAdaptFont.m
//  eStudy
//
//  Created by 马金丽 on 17/7/6.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import "UIFont+JZAdaptFont.h"
#import <objc/runtime.h>
#import "JZSystemMacrocDefine.h"


@implementation UIFont (JZAdaptFont)
+ (void)load
{
//    Method newMethod = class_getClassMethod([self class], @selector(changeFont:));
//    Method oldMethod = class_getClassMethod([self class], @selector(systemFontOfSize:));
//    method_exchangeImplementations(newMethod, oldMethod);
}



+(UIFont *)changeFont:(CGFloat)changeFont
{
    UIFont *newFont = nil;
    if (JZ_IPHONE_6p) {
        newFont = [UIFont changeFont:changeFont + 3];
    }else{
        newFont = [UIFont changeFont:changeFont];
    }
    return newFont;
}
@end
