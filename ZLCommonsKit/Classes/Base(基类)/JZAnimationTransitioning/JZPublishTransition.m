//
//  PingTransition.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/24.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "JZPublishTransition.h"
#import "JZSystemMacrocDefine.h"
#import "UIView+JZUIViewExtension.h"

@interface JZPublishTransition()<CAAnimationDelegate> {
    id <UIViewControllerContextTransitioning> _transitionContext;
    UIViewController                    *_fromVC;
    UIViewController                    *_toVC;
    
    CGFloat                             _duration;
    UINavigationControllerOperation     _operation;
    
    CAShapeLayer                        *_circleLayer;//发布按钮上的圆
    UIView                              *_backView;//白色遮罩层
    
    CGRect                              _orignRect;//进度条view坐标
    
    id                                 _target;
    SEL                                _action;
}

@end
@implementation JZPublishTransition

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation orignRect:(CGRect)rect duration:(CGFloat)duration {
    self = [super init];
    if (self) {
        _operation = operation;
        _duration = duration;
        _orignRect = rect;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    _transitionContext = transitionContext;
    
    _fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    _toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contView = [transitionContext containerView];
    
    if (_operation == UINavigationControllerOperationPush) {
        
        [contView addSubview:_fromVC.view];
        [contView addSubview:_toVC.view];
        

        [self creatPushAnimation];

    } else {
    
        [contView addSubview:_toVC.view];
        [contView addSubview:_fromVC.view];
        
        //白色遮罩层
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.tag = 1011;
        _backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [[UIApplication sharedApplication].delegate.window addSubview:_backView];
        
        //发布按钮上的圆动画
        [self creatPopCircleLayerAnimation];
    }

}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {

    if (flag) {
        if (_operation == UINavigationControllerOperationPop) {
            
            if ([animation isKindOfClass:[CAAnimationGroup class]]) {
        
                if ([_circleLayer animationForKey:@"pathAndOpacity"] == animation) {
                    
                    [_circleLayer removeFromSuperlayer];
                    [UIView animateWithDuration:_duration*2/5.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                       _backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
                    } completion:^(BOOL finished) {
                        [self creatPopMaskDismissAnimation];
                        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
                    }];
                }
            }
        } else {
            [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
        }
    }
    
}
- (void)creatPushAnimation {

    _toVC.view.alpha = 0;
    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
    }];
  
}
- (void)creatPopCircleLayerAnimation {
    
    //发布按钮
    UIView *btnView = [_fromVC.navigationController.view viewWithTag:100];
    
    CGRect supRect = [btnView relativePositionTo:_fromVC.navigationController.view];
    //发布按钮上的圆
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    _circleLayer.lineWidth = 3;
    _circleLayer.opacity = 1.0;
    _circleLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(supRect.size.width/2+supRect.origin.x, supRect.size.height/2+supRect.origin.y) radius:0 startAngle:(-M_PI/2) endAngle:(3*M_PI/2) clockwise:YES] CGPath];
    [_backView.layer addSublayer:_circleLayer];

    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
    pathAnim.fromValue = (id)[[UIBezierPath bezierPathWithArcCenter:CGPointMake(supRect.size.width/2+supRect.origin.x, supRect.size.height/2+supRect.origin.y) radius:1 startAngle:(-M_PI/2) endAngle:(3*M_PI/2) clockwise:YES] CGPath];
    pathAnim.toValue = (id)[[UIBezierPath bezierPathWithArcCenter:CGPointMake(supRect.size.width/2+supRect.origin.x, supRect.size.height/2+supRect.origin.y) radius:25 startAngle:(-M_PI/2) endAngle:(3*M_PI/2) clockwise:YES] CGPath];
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.toValue = @0.0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.animations = @[pathAnim,opacityAnim];
    animation.removedOnCompletion = NO;
    animation.duration = _duration*2/5.0;
    animation.delegate = self;
    [_circleLayer addAnimation:animation forKey:@"pathAndOpacity"];
}

- (void)creatPopMaskDismissAnimation {
    
    [_fromVC.view removeFromSuperview];
    
    [UIView animateWithDuration:_duration/5.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
         _backView.frame = _orignRect;
    } completion:^(BOOL finished) {
        if ([_target respondsToSelector:_action]) {
            JZPerformSelectorLeakWarning(
                                         [_target performSelector:_action withObject:self];
                                         );
        }
    }];
}
- (void)addTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}
@end


