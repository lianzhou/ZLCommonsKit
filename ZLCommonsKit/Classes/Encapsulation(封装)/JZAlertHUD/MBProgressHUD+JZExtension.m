//
//  MBProgressHUD+JZExtension.m
//  eStudy
//
//  Created by zhoulian on 17/6/22.
//

#import "MBProgressHUD+JZExtension.h"
#import "JZStringMacrocDefine.h"
#import "NSBundle+JZCommonsKit.h"
#import "JZSystemMacrocDefine.h"

static CGFloat JZ_HUD_FONT_SIZE = 13.0f;
NSTimeInterval JZMBProgressHUDHideTimeInterval = 1.5f;

@implementation MBProgressHUD (JZExtension)

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
    if (!JZStringIsNull(title)) {
        hud.detailsLabel.text = title;
        hud.detailsLabel.font = [UIFont systemFontOfSize:JZ_HUD_FONT_SIZE];
        if (!customView) {
            hud.mode = MBProgressHUDModeIndeterminate;
        }
    }
    hud.removeFromSuperViewOnHide = YES;

    if (afterSecond>0) {
        [hud hideAnimated:YES afterDelay:afterSecond];
    }else{
//        [[JZContext shareInstance].UIConfig.HUDConfig configAddHUD:hud toView:view];
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
              imageNamedType:(JZHUDImageNamedType)imageNamedType{
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
    MBProgressHUD * hud = [MBProgressHUD showHUDTitle:title customView:customView toView:view  hideAfter:JZMBProgressHUDHideTimeInterval];
    if (view) {
        hud.mode = MBProgressHUDModeCustomView;
    }else if (!JZStringIsNull(title)) {
        hud.mode = MBProgressHUDModeText;
    }
    return hud;
}

+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                         toView:(UIView *)view 
                 imageNamedType:(JZHUDImageNamedType)imageNamedType{
    
    NSString *imageNamed = [self imageNamedWithHUDType:imageNamedType];
    UIImageView * customImageView = [[UIImageView alloc] initWithImage:[NSBundle bundlePlaceholderName:imageNamed]];
    return  [MBProgressHUD showHUDTitle:title customView:customImageView toView:view  hideAfter:JZMBProgressHUDHideTimeInterval];
}
#pragma mark - 隐藏

+(void)hideHUD:(UIView *)view{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}


+ (NSString *)imageNamedWithHUDType:(JZHUDImageNamedType)imageNamedType {
    NSString *imageNamed = nil;
    if (imageNamedType == JZHUDImageNamedTypeSuccessful) {
        imageNamed = @"lce_hud_icon_success";
    } else if (imageNamedType == JZHUDImageNamedTypeError) {
        imageNamed = @"lce_hud_error";
    } else if (imageNamedType == JZHUDImageNamedTypeWarning) {
        imageNamed = @"lce_hud_warning";
    }
    return imageNamed;
}

@end
