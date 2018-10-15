//
//  JZFlurBackView.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/7/10.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXBlurView.h"

@class JZFlurBackView;
@protocol JZFlurBackViewDelegate <NSObject>

@optional

- (void)flurBackViewhiden:(JZFlurBackView *)flurBackView;


@end


@interface JZFlurBackView : NSObject

+ (instancetype)sharenInstance;

@property(nonatomic, assign)id<JZFlurBackViewDelegate>delegate;
/**
 可改变大小的抹灰层
 */
@property(nonatomic,strong)UIView *changeBlackView;

/**
 正常的抹灰层
 */
@property(nonatomic,strong)UIView *normalBackView;

/**
 毛玻璃抹灰层
 */
@property(nonatomic,strong)UIView *blurBackView;
@end
