//
//  PingTransition.m
//  JMAnimationDemo
//
//  Created by jm on 16/3/24.
//  Copyright © 2016年 JM. All rights reserved.
//

#import "JZVideoTransition.h"
#import "JZAVPlayerViewController.h"
#import "JZSystemMacrocDefine.h"
#import "JZUtilsTools.h"
#import "UIView+YYAdd.h"
#import "JZSystemUtils.h"

@implementation JZVideoTransition {
    CGRect                             _startRect;
     CGSize                             _videoSize;
    CGFloat                             _duration;
    UINavigationControllerOperation     _operation;
}

- (instancetype)initWithAnimationControllerForOperation:(UINavigationControllerOperation)operation startRect:(CGRect)startRect videoSize:(CGSize)videoSize duration:(CGFloat)duration {
    self = [super init];
    if (self) {
        _operation = operation;
        _startRect = startRect;
        _videoSize = videoSize;
        _duration = duration;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController  * _fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * _toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    if (_operation == UINavigationControllerOperationPush) {
        if (_fromVC.edgesForExtendedLayout==UIRectEdgeNone||_toVC.edgesForExtendedLayout==UIRectEdgeNone) {
            _fromVC.view.frame= CGRectMake(0, ([JZSystemUtils obtainStatusHeight] + 44), SCREEN_WIDTH, SCREEN_HEIGHT-([JZSystemUtils obtainStatusHeight] + 44));
            _toVC.view.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            _startRect = CGRectMake(_startRect.origin.x, _startRect.origin.y-([JZSystemUtils obtainStatusHeight] + 44), _startRect.size.width, _startRect.size.height);
        }
    }else{
        if (_fromVC.edgesForExtendedLayout==UIRectEdgeNone||_toVC.edgesForExtendedLayout==UIRectEdgeNone) {
            _fromVC.view.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            _toVC.view.frame= CGRectMake(0, ([JZSystemUtils obtainStatusHeight] + 44), SCREEN_WIDTH, SCREEN_HEIGHT-([JZSystemUtils obtainStatusHeight] + 44));
            
            _startRect = CGRectMake(_startRect.origin.x, _startRect.origin.y, _startRect.size.width, _startRect.size.height);
        }

    }

   __block CGRect startRect;
   __block CGRect endRect;
    startRect = _startRect;
        
    CGSize backViewSize =  [JZUtilsTools imageSizeWithMaxSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) minSize:CGSizeMake(40, 40) originalSize:_videoSize];
       
    endRect = CGRectMake((SCREEN_WIDTH-backViewSize.width)/2, (SCREEN_HEIGHT-backViewSize.height)/2, backViewSize.width, backViewSize.height);
    
    UIView *contView = [transitionContext containerView];
    

    if (_operation == UINavigationControllerOperationPush) {
        [contView addSubview:_fromVC.view];
        [contView addSubview:_toVC.view];

        UIView *backView = [_toVC.view viewWithTag:951];
        UIView *imageView = [_toVC.view viewWithTag:952];
        backView.frame = startRect;
//        backView.layer.frame = startRect;
        imageView.frame = startRect;

        [UIView animateWithDuration:_duration animations:^{
            backView.frame = endRect;
//            backView.layer.frame = endRect;
            imageView.frame = endRect;
        } completion:^(BOOL finished) {
            _toVC.view.backgroundColor = [UIColor yellowColor];
            JZAVPlayerViewController * playerViewController = (JZAVPlayerViewController *)_toVC;
            [playerViewController play];
            [transitionContext completeTransition:YES];    
        }];
    } else {
        NSLog(@"%lu-----%lu",(unsigned long)_fromVC.edgesForExtendedLayout,(unsigned long)_toVC.edgesForExtendedLayout);
        
         _fromVC.view.backgroundColor = [UIColor clearColor];
        
        [contView addSubview:_toVC.view];
        [contView addSubview:_fromVC.view];
        
        UIView *view = [_fromVC.view viewWithTag:159];
        view.alpha = 0;
        [view removeFromSuperview];

        UIView *backView = [_fromVC.view viewWithTag:951];
        UIView *imageView = [_fromVC.view viewWithTag:952];
        imageView.frame = endRect;
        backView.frame = endRect;
        backView.layer.frame = endRect;
        

        [UIView animateWithDuration:_duration animations:^{
            backView.frame = startRect ;
            imageView.frame = startRect;
            backView.layer.frame = startRect;
        } completion:^(BOOL finished) {
            [backView removeAllSubviews];
            [imageView removeAllSubviews];
            [transitionContext completeTransition:YES];
             [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor whiteColor];
        }];
    }
}

@end


