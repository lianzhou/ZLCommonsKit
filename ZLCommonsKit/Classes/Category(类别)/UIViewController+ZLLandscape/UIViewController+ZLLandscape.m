//
//  UIViewController+ZLLandscape.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "UIViewController+ZLLandscape.h"
#import <SwizzleManager.h>
#import <objc/runtime.h>

@implementation UIViewController (ZLLandscape)

+ (void)load{
    
    SwizzlingMethod([self class], @selector(shouldAutorotate), @selector(zl_shouldAutorotate));
    SwizzlingMethod([self class], @selector(supportedInterfaceOrientations), @selector(zl_supportedInterfaceOrientations));
}

- (BOOL)zl_shouldAutorotate{ // 是否支持旋转.
    
    if ([self isKindOfClass:NSClassFromString(@"UITabBarController")]) {
        return ((UITabBarController *)self).selectedViewController.shouldAutorotate;
    }
    
    if ([self isKindOfClass:NSClassFromString(@"UINavigationController")]) {
        return ((UINavigationController *)self).viewControllers.lastObject.shouldAutorotate;
    }
    
    if ([self checkSelfNeedLandscape]) {
        return YES;
    }
    
    if (self.zl_shouldAutoLandscape) {
        return YES;
    }
    
    return [self zl_shouldAutorotate];
}

- (UIInterfaceOrientationMask)zl_supportedInterfaceOrientations{ // 支持旋转的方向.

    if ([self isKindOfClass:NSClassFromString(@"UITabBarController")]) {
        return [((UITabBarController *)self).selectedViewController supportedInterfaceOrientations];
    }
    
    if ([self isKindOfClass:NSClassFromString(@"UINavigationController")]) {
        return [((UINavigationController *)self).viewControllers.lastObject supportedInterfaceOrientations];
    }
    
    if ([self checkSelfNeedLandscape]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    if (self.zl_shouldAutoLandscape) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return [self zl_supportedInterfaceOrientations];
}

- (void)setZl_shouldAutoLandscape:(BOOL)zl_shouldAutoLandscape{
    objc_setAssociatedObject(self, @selector(zl_shouldAutoLandscape), @(zl_shouldAutoLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zl_shouldAutoLandscape{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)checkSelfNeedLandscape{
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSOperatingSystemVersion operatingSytemVersion = processInfo.operatingSystemVersion;
    
    if (operatingSytemVersion.majorVersion == 8) {
        NSString *className = NSStringFromClass(self.class);
        if ([@[@"AVPlayerViewController", @"AVFullScreenViewController", @"AVFullScreenPlaybackControlsViewController"
               ] containsObject:className]) {
            return YES; 
        }
        
        if ([self isKindOfClass:[UIViewController class]] && [self childViewControllers].count && [self.childViewControllers.firstObject isKindOfClass:NSClassFromString(@"AVPlayerViewController")]) {
            return YES;
        }
    }
    else if (operatingSytemVersion.majorVersion == 9){
        NSString *className = NSStringFromClass(self.class);
        if ([@[@"WebFullScreenVideoRootViewController", @"AVPlayerViewController", @"AVFullScreenViewController"
               ] containsObject:className]) {
            return YES;
        }
        
        if ([self isKindOfClass:[UIViewController class]] && [self childViewControllers].count && [self.childViewControllers.firstObject isKindOfClass:NSClassFromString(@"AVPlayerViewController")]) {
            return YES;
        }
    }
    else if (operatingSytemVersion.majorVersion == 10){
        if ([self isKindOfClass:NSClassFromString(@"AVFullScreenViewController")]) {
            return YES;
        }
    }else{
        if ([self isKindOfClass:NSClassFromString(@"AVFullScreenViewController")]) {
            return YES;
        }
    }
 
    return NO;
}

@end
