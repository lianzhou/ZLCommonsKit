//
//  ZLDetailsClickAnimationTransitioning.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLDetailsClickAnimationTransitioning.h"
#import "ZLSystemMacrocDefine.h"

@implementation ZLDetailsClickAnimationTransitioning
- (instancetype)initWithIsPush:(BOOL)isPush withTimeInterval:(NSTimeInterval)timeInterval withSelectedViewRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        _isPush = isPush;
        _rect = rect;
        _timeInterval = timeInterval;
    }
    return self;
}
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    if (_timeInterval) {
        return _timeInterval;
    }
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewCtrl = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewCtrl = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromViewCtrl.view;
    UIView *toView = toViewCtrl.view;
    
    if (_isPush) {
        [[transitionContext containerView] addSubview:toView];
        [[transitionContext containerView] addSubview:fromView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:bgView];
        
        UIView *currentView = [[UIView alloc] initWithFrame:_rect];
        currentView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:currentView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            currentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);;
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
            [[transitionContext containerView] exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
            [transitionContext completeTransition:YES];
        }];
    }else{
        [[transitionContext containerView] addSubview:toView];
        [[transitionContext containerView] addSubview:fromView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
