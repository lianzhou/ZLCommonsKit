//
//  JZFontColorHandler.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZFontColorHandler : NSObject

#pragma mark -通用字体
//导航栏字体:17
+(UIFont *)navTitleFont;
//昵称:14
+(UIFont *)nameFont;
//内容:15
+(UIFont *)contentFont;
//内容时间:14
+(UIFont *)contentTimeFont;
//评论时间:11
+(UIFont *)commentTimeFont;

#pragma mark -字体颜色
////白色导航栏
//+(UIColor *)navWhiteColor;
////黑色导航栏
//+(UIColor *)navBlackColor;
////内容
//+(UIColor *)contentColor;
////时间
//+(UIColor *)timeColor;
////主色:绿色
//+(UIColor *)keyColor;
////橘黄色的数字
//+(UIColor *)moneyNumberOrangeColor;
////灰色的数字
//+(UIColor *)moneyNumberGrayColor;
//


@end
