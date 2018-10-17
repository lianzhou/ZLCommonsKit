//
//  ZLSearchBarTransition.h
//  PublishAnimationTest
//
//  Created by zhangjiang on 2017/6/16.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZLBaseAnimatedTransitioning.h"

@interface ZLSearchBarTransition : ZLBaseAnimatedTransitioning


- (instancetype)initWithAnimationControllerPresentOrDismiss:(BOOL)isPresent orignRect:(CGRect)originRect endREct:(CGRect)endRect duration:(CGFloat)duration;



@end
