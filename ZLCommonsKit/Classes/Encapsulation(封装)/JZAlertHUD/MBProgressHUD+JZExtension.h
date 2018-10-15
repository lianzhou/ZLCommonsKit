//
//  MBProgressHUD+JZExtension.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.

#import <MBProgressHUD/MBProgressHUD.h>
/**
 *  HUD的图片类型
 */
typedef NS_ENUM(NSInteger, JZHUDImageNamedType) {
    JZHUDImageNamedTypeSuccessful, //成功
    JZHUDImageNamedTypeError,      //失败
    JZHUDImageNamedTypeWarning,    //提醒
};

@interface MBProgressHUD (JZExtension)

#pragma mark - 显示

+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                  customView:(UIView *)customView
                      toView:(UIView *)view 
                   hideAfter:(NSTimeInterval)afterSecond;
+ (MBProgressHUD *)showHUDTitle:(NSString *)title;
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                         toView:(UIView *)view ;
+ (MBProgressHUD *)showHUDCustomView:(UIView *)customView 
                              toView:(UIView *)view ;
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                     customView:(UIView *)customView
                         toView:(UIView *)view;
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                         toView:(UIView *)view 
                 imageNamedType:(JZHUDImageNamedType)imageNamedType;

#pragma mark - automatic 自动隐藏
+ (MBProgressHUD *)showTipTitle:(NSString *)title;
+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                         toView:(UIView *)view ;
+ (MBProgressHUD *)showTipCustomView:(UIView *)customView 
                              toView:(UIView *)view;
+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                     customView:(UIView *)customView
                         toView:(UIView *)view;
+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                         toView:(UIView *)view 
                 imageNamedType:(JZHUDImageNamedType)imageNamedType;

#pragma mark - 隐藏
+(void)hideHUD:(UIView *)view;


@end
