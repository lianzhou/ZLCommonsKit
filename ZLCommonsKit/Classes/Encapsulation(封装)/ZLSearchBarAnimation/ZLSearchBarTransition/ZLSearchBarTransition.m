//
//  ZLSearchBarTransition.m
//  PublishAnimationTest
//
//  Created by zhangjiang on 2017/6/16.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import "ZLSearchBarTransition.h"
#import "ZLCustomSearchBar.h"
#import "ZLSystemMacrocDefine.h"

@interface ZLSearchBarTransition() {
    id <UIViewControllerContextTransitioning> _transitionContext;
    
    CGFloat                             _duration;
    BOOL                                _isPresenting;

    CGRect                              _orignRect;//起始坐标
    CGRect                              _endRect;//结束坐标
    
    UIView                              *_toView;
    UIView                              *_fromView;
}


@end
@implementation ZLSearchBarTransition

- (instancetype)initWithAnimationControllerPresentOrDismiss:(BOOL)isPresent orignRect:(CGRect)originRect endREct:(CGRect)endRect duration:(CGFloat)duration {
    self = [super init];
    if (self) {
        _isPresenting = isPresent;
        _duration = duration;
        _orignRect = originRect;
        _endRect = endRect;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    _transitionContext = transitionContext;
    
    UIView *containerView = transitionContext.containerView;
    _toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    _fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];

    
    if (_isPresenting) {
        [containerView addSubview:_fromView];
        [containerView addSubview:_toView];
        
         [self creatPresntAnimation];
        
    } else {
        [containerView addSubview:_toView];
        [containerView addSubview:_fromView];
        
        [self creatDimissAnimation];
    }
}

- (void)creatPresntAnimation {
    
    
    UIView *backView = (UIView *)[_toView viewWithTag:3333];
    ZLCustomSearchBar *searchBar = (ZLCustomSearchBar *)[_toView viewWithTag:1111];
    
    backView.frame = _orignRect;
    searchBar.frame = CGRectMake(_orignRect.origin.x,0, _orignRect.size.width, _orignRect.size.height);
    
    _toView.backgroundColor  = [ZL_KMainColor colorWithAlphaComponent:0];

    [searchBar becomeFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _toView.backgroundColor  = [ZL_KMainColor colorWithAlphaComponent:1];
        backView.frame = _endRect;
        searchBar.frame = CGRectMake(_endRect.origin.x,20, _endRect.size.width, _endRect.size.height-20);
    } completion:^(BOOL finished) {
        [_transitionContext completeTransition:YES];
    }];
    
}
- (void)creatDimissAnimation {
    
    UIView *backView = (UIView *)[_fromView viewWithTag:3333];
    ZLCustomSearchBar *searchBar = (ZLCustomSearchBar *)[_fromView viewWithTag:1111];
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _fromView.backgroundColor  = [ZL_KMainColor colorWithAlphaComponent:0];
        backView.frame = _endRect;
        searchBar.frame = CGRectMake(_endRect.origin.x,0, _endRect.size.width, _endRect.size.height);
    } completion:^(BOOL finished) {
        [_transitionContext completeTransition:YES];
    }];
    
   
}

@end
