//
//  JZDetailsClickAnimationTransitioning.h
//  eStudy
//
//  Created by wangjingfei on 2017/6/21.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import "JZBaseAnimatedTransitioning.h"

@interface JZDetailsClickAnimationTransitioning : JZBaseAnimatedTransitioning

@property (nonatomic,assign) BOOL isPush;

@property (nonatomic,assign) CGRect rect;

@property (nonatomic,assign) NSTimeInterval timeInterval;

- (instancetype)initWithIsPush:(BOOL)isPush withTimeInterval:(NSTimeInterval)timeInterval withSelectedViewRect:(CGRect)rect;


@end
