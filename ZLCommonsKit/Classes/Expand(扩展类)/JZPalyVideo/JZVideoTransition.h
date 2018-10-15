//
//  PingTransition.h
//  JMAnimationDemo
//
//  Created by jm on 16/3/24.
//  Copyright © 2016年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JZVideoTransition : NSObject <UIViewControllerAnimatedTransitioning,CAAnimationDelegate>


- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation startRect:(CGRect)startRect videoSize:(CGSize)videoSize duration:(CGFloat)duration;


@end
