//
//  PingTransition.m
//  KYPingTransition
//
//  Created by Kitten Yang on 1/30/15.
//  Copyright (c) 2015 Kitten Yang. All rights reserved.
//

#import "JZSearchPushTransition.h"
#import "JZSystemMacrocDefine.h"

@interface JZSearchPushTransition ()<CAAnimationDelegate>
{
    
    UIViewController<JZSearchPushTransitionDelegate> * _fromVC;
    UIViewController<JZSearchPushTransitionDelegate> *_toVC;
    UIView                                      *_containerView;
    
    CGRect                                      _startRect;
    CGRect                                      _endRect;
    CGFloat                                     _duration;
    UINavigationControllerOperation             _operation;
    id<UIViewControllerContextTransitioning>    _transitionContext;
    
    JZSearchPushAnimationTransitionType         _transitionType;
    
    
    id                                          _firstTarget;
    SEL                                         _firstAction;
    
    id                                          _secondTarget;
    SEL                                         _secondAction;
}

@property (nonatomic,weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation JZSearchPushTransition

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation endREct:(CGRect)endRect TransitionType:(JZSearchPushAnimationTransitionType)transitionType duration:(CGFloat)duration {
    self = [super init];
    if (self) {
        _operation = operation;
        _endRect = endRect;
        _duration = duration;
        _transitionType = transitionType;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return  _duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    _transitionContext = transitionContext;
    
    _fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    _toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    if ([_fromVC respondsToSelector:@selector(supRect)]) {
        _startRect = [_fromVC supRect];
    }else{
        if ([_toVC respondsToSelector:@selector(supRect)]) {
            _startRect = [_toVC supRect];
        }else{
            NSCAssert(NO, @"没有实现[supRect]");
        }
    }

    _containerView = [transitionContext containerView];
    
    if (_transitionType == JZSearchPushAnimationTransitionTypeLeft || _transitionType == JZSearchPushAnimationTransitionTypeRight) {
        [self creatLeftAndRightTransitionAnimation];
    }  else {
        [self creatDefaultTransitionAnimation];
    }
    
}
- (void)creatDefaultTransitionAnimation {
    
    if (_operation == UINavigationControllerOperationPush) {
        [_containerView addSubview:_fromVC.view];
        [_containerView addSubview:_toVC.view];
        [self creatPushAnimation];
        
    } else {
        [_containerView addSubview:_toVC.view];
        [_containerView addSubview:_fromVC.view];
        [self creatPopAnimation];
    }
}
- (void)creatPushAnimation {
    
    if (_firstTarget) {
        if ([_firstTarget respondsToSelector:_firstAction]) {
            JZPerformSelectorLeakWarning(
                                         [_firstTarget performSelector:_firstAction withObject:self];
                                         );
        }
    }
    
    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (_secondTarget) {
            if ([_secondTarget respondsToSelector:_firstAction]) {
                JZPerformSelectorLeakWarning(
                                             [_secondTarget performSelector:_secondAction withObject:self];
                                             );
            }
        }
    } completion:^(BOOL finished) {
        [_transitionContext completeTransition:YES];
    }];
    
}

- (void)creatPopAnimation {
    
    if (_firstTarget) {
        if ([_firstTarget respondsToSelector:_firstAction]) {
            JZPerformSelectorLeakWarning(
                                         [_firstTarget performSelector:_firstAction withObject:self];
                                         );
        }    }
    
    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (_secondTarget) {
            if ([_secondTarget respondsToSelector:_firstAction]) {
                JZPerformSelectorLeakWarning(
                                             [_secondTarget performSelector:_secondAction withObject:self];
                                             );
            }
        }
    } completion:^(BOOL finished) {
        [_transitionContext completeTransition:YES];
    }];
    
}

- (void)creatLeftAndRightTransitionAnimation {
    //    UIButton *abutton = [[UIButton alloc]initWithFrame:_startRect];
    //    abutton.backgroundColor = [UIColor whiteColor];
    //    abutton.alpha = 1;
    //    abutton.layer.cornerRadius = _startRect.size.width/2;
    //    [_toVC.view addSubview:abutton];
    
    UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithOvalInRect:_startRect];;
    if (_fromVC.edgesForExtendedLayout==UIRectEdgeNone) {
        _fromVC.view.frame= CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _toVC.view.frame= CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_startRect.origin.x, _startRect.origin.y-64, _startRect.size.width, _startRect.size.height)];
    }
    
    //    [UIView animateWithDuration:[self transitionDuration:_transitionContext] delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
    //        abutton.transform = CGAffineTransformScale(abutton.transform, 0.1, 0.1);
    //        abutton.alpha = 0;
    //    } completion:^(BOOL finished) {
    //        if (finished) {
    //            abutton.transform = CGAffineTransformIdentity;
    //        }
    //    }];
    
    CGPoint finalPoint;
    //判断触发点在那个象限
    if(_startRect.origin.x > (_toVC.view.bounds.size.width / 2)){
        if (_startRect.origin.y < (_toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(_startRect.origin.x/2 - 0, _startRect.origin.y/2 - CGRectGetMaxY(_toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(_startRect.origin.x/2 - 0, _startRect.origin.y/2 - 0);
        }
    }else{
        if (_startRect.origin.y < (_toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(_startRect.origin.x/2- CGRectGetMaxX(_toVC.view.bounds), _startRect.origin.y/2 - CGRectGetMaxY(_toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(_startRect.origin.x/2 - CGRectGetMaxX(_toVC.view.bounds), _startRect.origin.y/2 - 0);
        }
    }
    
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(_startRect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    if (_operation == UINavigationControllerOperationPush) {
        [_containerView addSubview:_fromVC.view];
        [_containerView addSubview:_toVC.view];
        
        maskLayer.path = maskFinalBP.CGPath;
        _toVC.view.layer.mask = maskLayer;
        
        pingAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
        pingAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    } else {
        [_containerView addSubview:_toVC.view];
        [_containerView addSubview:_fromVC.view];
        
        maskLayer.path = maskStartBP.CGPath;
        _fromVC.view.layer.mask = maskLayer;
        
        pingAnimation.fromValue = (__bridge id)(maskFinalBP.CGPath);
        pingAnimation.toValue   = (__bridge id)(maskStartBP.CGPath);
    }
    
    pingAnimation.duration = [self transitionDuration:_transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pingAnimation.delegate = self;
    [maskLayer addAnimation:pingAnimation forKey:@"path"];
}
#pragma mark - CABasicAnimation的Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
    [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    
}

- (void)addFirstTarget:(id)target action:(SEL)action {
    _firstTarget = target;
    _firstAction = action;
}
- (void)addSecondTarget:(id)target action:(SEL)action {
    _secondTarget = target;
    _secondAction = action;
}
@end





