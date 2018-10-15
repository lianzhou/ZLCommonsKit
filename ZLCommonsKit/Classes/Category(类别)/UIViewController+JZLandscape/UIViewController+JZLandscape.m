//
//  UIViewController+JZLandscape.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "UIViewController+JZLandscape.h"
#import <SwizzleManager.h>
#import <objc/runtime.h>

@implementation UIViewController (JZLandscape)

+ (void)load{
    
    SwizzlingMethod([self class], @selector(shouldAutorotate), @selector(jz_shouldAutorotate));
    SwizzlingMethod([self class], @selector(supportedInterfaceOrientations), @selector(jz_supportedInterfaceOrientations));
}

- (BOOL)jz_shouldAutorotate{ // 是否支持旋转.
    
    if ([self isKindOfClass:NSClassFromString(@"UITabBarController")]) {
        return ((UITabBarController *)self).selectedViewController.shouldAutorotate;
    }
    
    if ([self isKindOfClass:NSClassFromString(@"UINavigationController")]) {
        return ((UINavigationController *)self).viewControllers.lastObject.shouldAutorotate;
    }
    
    if ([self checkSelfNeedLandscape]) {
        return YES;
    }
    
    if (self.jz_shouldAutoLandscape) {
        return YES;
    }
    
    return [self jz_shouldAutorotate];
}

- (UIInterfaceOrientationMask)jz_supportedInterfaceOrientations{ // 支持旋转的方向.

    if ([self isKindOfClass:NSClassFromString(@"UITabBarController")]) {
        return [((UITabBarController *)self).selectedViewController supportedInterfaceOrientations];
    }
    
    if ([self isKindOfClass:NSClassFromString(@"UINavigationController")]) {
        return [((UINavigationController *)self).viewControllers.lastObject supportedInterfaceOrientations];
    }
    
    if ([self checkSelfNeedLandscape]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    if (self.jz_shouldAutoLandscape) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return [self jz_supportedInterfaceOrientations];
}

- (void)setJz_shouldAutoLandscape:(BOOL)jz_shouldAutoLandscape{
    objc_setAssociatedObject(self, @selector(jz_shouldAutoLandscape), @(jz_shouldAutoLandscape), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)jz_shouldAutoLandscape{
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
