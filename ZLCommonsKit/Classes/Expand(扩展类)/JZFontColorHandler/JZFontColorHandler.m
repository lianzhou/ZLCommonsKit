//
//  JZFontColorHandler.m
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/7/6.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//


#import "JZFontColorHandler.h"

@interface JZFontColorHandler ()

@end

@implementation JZFontColorHandler

#pragma mark -通用字体
//导航栏字体
+(UIFont *)navTitleFont
{
    return [UIFont boldSystemFontOfSize:17.0];
}
//昵称
+(UIFont *)nameFont
{
    return [UIFont systemFontOfSize:14.0];
}

//内容
+(UIFont *)contentFont
{
    return [UIFont systemFontOfSize:15.0];
}

//内容时间
+(UIFont *)contentTimeFont
{
    return [UIFont systemFontOfSize:14.0];
}

+ (UIFont *)commentTimeFont
{
    return [UIFont systemFontOfSize:14.0];
}
#pragma mark -字体颜色

////白色导航栏
//+(UIColor *)navWhiteColor
//{
//    return [UIColor whiteColor];
//}
////黑色导航栏
//+(UIColor *)navBlackColor
//{
//    return UIColorRGB(0x333333);
//}
////内容
//+(UIColor *)contentColor
//{
//    return UIColorRGB(0x333333);
//}
////时间
//+(UIColor *)timeColor
//{
//    return UIColorRGB(0x999999);
//}
////主色:绿色
//+(UIColor *)keyColor
//{
//    return UIColorRGB(0x00af5b);
//}
//
//+(UIColor *)moneyNumberOrangeColor
//{
//    return UIColorRGB(0xff6600);
//}
//
//+(UIColor *)moneyNumberGrayColor
//{
//    return UIColorRGB(0xcccccc);
//}
//
@end
