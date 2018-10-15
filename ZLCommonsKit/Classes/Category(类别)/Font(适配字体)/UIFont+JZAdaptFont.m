//
//  UIFont+JZAdaptFont.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
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
