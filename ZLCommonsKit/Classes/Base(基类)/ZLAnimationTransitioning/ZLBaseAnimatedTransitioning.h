//
//  ZLBaseAnimatedTransitioning.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZLAnimatedTransitioningType) {
    ZLAnimatedTransitioningTypePush =0,//push
    ZLAnimatedTransitioningTypePop     //pop
} ;
@interface ZLBaseAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign)ZLAnimatedTransitioningType  animatedTransitioningType;

-(instancetype)initWithAnimationType:(ZLAnimatedTransitioningType)animatedTransitioningType;

@end
