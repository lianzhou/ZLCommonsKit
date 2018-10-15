//
//  JZBaseAnimatedTransitioning.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//


#import "JZBaseAnimatedTransitioning.h"

@interface JZBaseAnimatedTransitioning ()

@end

@implementation JZBaseAnimatedTransitioning
-(instancetype)initWithAnimationType:(JZAnimatedTransitioningType)animatedTransitioningType
{
    if (self=[super init]) {
        self.animatedTransitioningType=animatedTransitioningType;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
}

@end
