//
//  JZDetailsClickAnimationTransitioning.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZBaseAnimatedTransitioning.h"

@interface JZDetailsClickAnimationTransitioning : JZBaseAnimatedTransitioning

@property (nonatomic,assign) BOOL isPush;

@property (nonatomic,assign) CGRect rect;

@property (nonatomic,assign) NSTimeInterval timeInterval;

- (instancetype)initWithIsPush:(BOOL)isPush withTimeInterval:(NSTimeInterval)timeInterval withSelectedViewRect:(CGRect)rect;


@end
