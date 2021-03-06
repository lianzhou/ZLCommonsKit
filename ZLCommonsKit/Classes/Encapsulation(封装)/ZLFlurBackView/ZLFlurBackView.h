//
//  ZLFlurBackView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXBlurView.h"

@class ZLFlurBackView;
@protocol ZLFlurBackViewDelegate <NSObject>

@optional

- (void)flurBackViewhiden:(ZLFlurBackView *)flurBackView;


@end


@interface ZLFlurBackView : NSObject

+ (instancetype)sharenInstance;

@property(nonatomic, assign)id<ZLFlurBackViewDelegate>delegate;
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
