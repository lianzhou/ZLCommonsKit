//
//  PingTransition.h
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "JZBaseAnimatedTransitioning.h"

typedef NS_ENUM(NSInteger, JZSearchPushAnimationTransitionType) {
    JZSearchPushAnimationTransitionTypeDefault,             //默认
    JZSearchPushAnimationTransitionTypeLeft,               //左边
    JZSearchPushAnimationTransitionTypeRight,              //右边
};

@protocol JZSearchPushTransitionDelegate

/**
 *  开始位置
 */
-(CGRect)supRect;

@end

@interface JZSearchPushTransition : JZBaseAnimatedTransitioning

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation endREct:(CGRect)endRect TransitionType:(JZSearchPushAnimationTransitionType)transitionType duration:(CGFloat)duration;

- (void)addFirstTarget:(id)target action:(SEL)action;

- (void)addSecondTarget:(id)target action:(SEL)action;

@end
