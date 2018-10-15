//
//  PingTransition.h
//  JMAnimationDemo
//
//  Created by jm on 16/3/24.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "JZBaseAnimatedTransitioning.h"


@interface JZPublishTransition : JZBaseAnimatedTransitioning

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation orignRect:(CGRect)rect duration:(CGFloat)duration;

- (void)addTarget:(id)target action:(SEL)action;
@end
