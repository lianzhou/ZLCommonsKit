
//
//  UILabel+JZLabelAdaptFont.m
//  eStudy
//
//  Created by 马金丽 on 17/7/6.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import "UILabel+JZLabelAdaptFont.h"
#import <objc/runtime.h>

@implementation UILabel (JZLabelAdaptFont)

+ (void)load
{
//    //得到类的实例方法--XIB上字体适配
//    Method newMethod = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method oldMethod = class_getInstanceMethod([self class], @selector(changeInitWithCoder:));
//    method_exchangeImplementations(oldMethod, newMethod);
//    
//    //纯代码创建
//    Method oldinitMethod = class_getInstanceMethod([self class], @selector(initWithFrame:));
//    
//    Method newinitMethod = class_getInstanceMethod([self class], @selector(newinitWithFrame:));
//    
//    method_exchangeImplementations(newinitMethod, oldinitMethod);
}



- (instancetype)changeInitWithCoder:(NSCoder *)aDecoder
{
    [self changeInitWithCoder:aDecoder];
    if (self) {
        self.font = [UIFont systemFontOfSize:self.font.pointSize];
    }
    return self;
}


- (instancetype)newinitWithFrame:(CGRect)frame
{
    [self newinitWithFrame:frame];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(new_setTextFont:) name:@"text_font" object:nil];
    }
    return self;
}

- (void)new_setTextFont:(NSNotification *)notication
{
    NSDictionary *resultDict = notication.userInfo;
    self.font = [UIFont systemFontOfSize:[[resultDict objectForKey:@"fontsize"]floatValue]];
}
@end
