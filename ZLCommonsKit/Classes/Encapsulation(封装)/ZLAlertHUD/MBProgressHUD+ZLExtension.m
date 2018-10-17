//
//  MBProgressHUD+ZLExtension.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "MBProgressHUD+ZLExtension.h"
#import "ZLStringMacrocDefine.h"
#import "NSBundle+ZLCommonsKit.h"
#import "ZLSystemMacrocDefine.h"

static CGFloat ZL_HUD_FONT_SIZE = 13.0f;
NSTimeInterval ZLMBProgressHUDHideTimeInterval = 1.5f;

@implementation MBProgressHUD (ZLExtension)

#pragma mark - 显示
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                  customView:(UIView *)customView
                      toView:(UIView *)view 
                   hideAfter:(NSTimeInterval)afterSecond{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = UIColorRGBA(0, 0, 0, 0.7);
    hud.contentColor = [UIColor whiteColor];
//    hud.style =  MBProgressHUDBackgroundStyleSolidColor;
    if (customView) {
        hud.customView = customView;
        hud.mode = MBProgressHUDModeCustomView;
    }
    if (!ZLStringIsNull(title)) {
        hud.detailsLabel.text = title;
        hud.detailsLabel.font = [UIFont systemFontOfSize:ZL_HUD_FONT_SIZE];
        if (!customView) {
            hud.mode = MBProgressHUDModeIndeterminate;
        }
    }
    hud.removeFromSuperViewOnHide = YES;

    if (afterSecond>0) {
        [hud hideAnimated:YES afterDelay:afterSecond];
    }else{
//        [[ZLContext shareInstance].UIConfig.HUDConfig configAddHUD:hud toView:view];
    }
    return hud;
}
+ (MBProgressHUD *)showHUDTitle:(NSString *)title{
    return [MBProgressHUD showHUDTitle:title customView:nil toView:nil  hideAfter:-1];
}
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                      toView:(UIView *)view 
{
    return [MBProgressHUD showHUDTitle:title customView:nil toView:view  hideAfter:-1];
}
+ (MBProgressHUD *)showHUDCustomView:(UIView *)customView 
                           toView:(UIView *)view 
{
    return [MBProgressHUD showHUDTitle:nil customView:customView toView:view  hideAfter:-1];
}
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                  customView:(UIView *)customView
                      toView:(UIView *)view{
    return [MBProgressHUD showHUDTitle:title customView:customView toView:view  hideAfter:-1];
}

+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                      toView:(UIView *)view 
              imageNamedType:(ZLHUDImageNamedType)imageNamedType{
    NSString *imageNamed = [self imageNamedWithHUDType:imageNamedType];
    
    UIImageView * customImageView = [[UIImageView alloc] initWithImage:[NSBundle bundlePlaceholderName:imageNamed]];
  return  [MBProgressHUD showHUDTitle:title customView:customImageView toView:view  hideAfter:-1];
}
#pragma mark - automatic 自动隐藏
+ (MBProgressHUD *)showTipTitle:(NSString *)title{
    return [MBProgressHUD showTipTitle:title customView:nil toView:nil];
}
+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                         toView:(UIView *)view 
{
    return [MBProgressHUD showTipTitle:title customView:nil toView:view];
}
+ (MBProgressHUD *)showTipCustomView:(UIView *)customView 
                              toView:(UIView *)view 
{
    return [MBProgressHUD showTipTitle:nil customView:customView toView:view];
}
+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                     customView:(UIView *)customView
                         toView:(UIView *)view{
    MBProgressHUD * hud = [MBProgressHUD showHUDTitle:title customView:customView toView:view  hideAfter:ZLMBProgressHUDHideTimeInterval];
    if (view) {
        hud.mode = MBProgressHUDModeCustomView;
    }else if (!ZLStringIsNull(title)) {
        hud.mode = MBProgressHUDModeText;
    }
    return hud;
}

+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                         toView:(UIView *)view 
                 imageNamedType:(ZLHUDImageNamedType)imageNamedType{
    
    NSString *imageNamed = [self imageNamedWithHUDType:imageNamedType];
    UIImageView * customImageView = [[UIImageView alloc] initWithImage:[NSBundle bundlePlaceholderName:imageNamed]];
    return  [MBProgressHUD showHUDTitle:title customView:customImageView toView:view  hideAfter:ZLMBProgressHUDHideTimeInterval];
}
#pragma mark - 隐藏

+(void)hideHUD:(UIView *)view{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}


+ (NSString *)imageNamedWithHUDType:(ZLHUDImageNamedType)imageNamedType {
    NSString *imageNamed = nil;
    if (imageNamedType == ZLHUDImageNamedTypeSuccessful) {
        imageNamed = @"lce_hud_icon_success";
    } else if (imageNamedType == ZLHUDImageNamedTypeError) {
        imageNamed = @"lce_hud_error";
    } else if (imageNamedType == ZLHUDImageNamedTypeWarning) {
        imageNamed = @"lce_hud_warning";
    }
    return imageNamed;
}

@end
