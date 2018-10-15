//
//  JZBaseAnimatedTransitioning.m
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/6/9.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
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
