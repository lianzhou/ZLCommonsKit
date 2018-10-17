//
//  ZLAlertHUD.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+ZLExtension.h"
#import "ENAlert.h"


@interface ZLAlertHUD : NSObject


+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message  
     cancelButtonTitle:(NSString *)cancelButtonTitle  
     otherButtonTitles:(NSMutableArray <NSString *> *)otherButtonTitles
         continueBlock:(dispatch_block_t)continueBlock
           cancelBlock:(dispatch_block_t)cancelBlock
            otherBlock:(UIAlertViewCallBackBlock)otherBlock;

+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message  
     cancelButtonTitle:(NSString *)cancelButtonTitle  
     otherButtonTitles:(NSMutableArray <NSString *> *)otherButtonTitles
         continueBlock:(dispatch_block_t)continueBlock
           cancelBlock:(dispatch_block_t)cancelBlock;

+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message  
     cancelButtonTitle:(NSString *)cancelButtonTitle  
      otherButtonTitle:(NSString *)otherButtonTitle
         continueBlock:(dispatch_block_t)continueBlock
           cancelBlock:(dispatch_block_t)cancelBlock;

+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message  
     cancelButtonTitle:(NSString *)cancelButtonTitle  
      otherButtonTitle:(NSString *)otherButtonTitle
         continueBlock:(dispatch_block_t)continueBlock;

+ (void)alertShowMessage:(NSString *)message;
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message;
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message
      otherButtonTitle:(NSString *)otherButtonTitle
         continueBlock:(dispatch_block_t)continueBlock;
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message
      otherButtonTitle:(NSString *)otherButtonTitle;

#pragma mark - MBProgressHUD
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
                 imageNamedType:(ZLHUDImageNamedType)imageNamedType;

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
                 imageNamedType:(ZLHUDImageNamedType)imageNamedType;

#pragma mark - 隐藏
+(void)hideHUD:(UIView *)view;
@end
