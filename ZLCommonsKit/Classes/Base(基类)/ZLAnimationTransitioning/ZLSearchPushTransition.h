//
//  PingTransition.h
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "ZLBaseAnimatedTransitioning.h"

typedef NS_ENUM(NSInteger, ZLSearchPushAnimationTransitionType) {
    ZLSearchPushAnimationTransitionTypeDefault,             //默认
    ZLSearchPushAnimationTransitionTypeLeft,               //左边
    ZLSearchPushAnimationTransitionTypeRight,              //右边
};

@protocol ZLSearchPushTransitionDelegate

/**
 *  开始位置
 */
-(CGRect)supRect;

@end

@interface ZLSearchPushTransition : ZLBaseAnimatedTransitioning

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation endREct:(CGRect)endRect TransitionType:(ZLSearchPushAnimationTransitionType)transitionType duration:(CGFloat)duration;

- (void)addFirstTarget:(id)target action:(SEL)action;

- (void)addSecondTarget:(id)target action:(SEL)action;

@end
