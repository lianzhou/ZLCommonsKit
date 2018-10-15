//
//  JZBaseAnimatedTransitioning.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/6/9.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JZAnimatedTransitioningType) {
    JZAnimatedTransitioningTypePush =0,//push
    JZAnimatedTransitioningTypePop     //pop
} ;
@interface JZBaseAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign)JZAnimatedTransitioningType  animatedTransitioningType;

-(instancetype)initWithAnimationType:(JZAnimatedTransitioningType)animatedTransitioningType;

@end
