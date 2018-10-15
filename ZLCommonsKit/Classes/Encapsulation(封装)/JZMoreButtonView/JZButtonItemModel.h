//
//  JZButtonItemModel.h
//  JZViewDemo
//
//  Created by wangjingfei on 2017/9/4.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JZThumbUpButton.h"

typedef NS_ENUM(NSInteger,JZButtonDisplayType) {
    JZButtonDisplayTypeExceptional = 0,//打赏
    JZButtonDisplayTypeSendGifts ,//送礼物
    JZButtonDisplayTypeComment,//评论
    JZButtonDisplayTypeThumbUp,//点赞
};
@interface JZButtonItemModel : NSObject

//类型（打赏、送礼物、评论、点赞）
@property (nonatomic,assign) JZButtonDisplayType btnDisplayType;
//
////是否有动画
//@property (nonatomic,assign) ClickAnimationType clickAnimationType;

//按钮的大小 默认大小是CGSizeMake(50,40)
@property (nonatomic,assign) CGSize btnSize;

//按钮上的字体颜色 默认颜色是 UIColorHex(0x666666) 
@property (nonatomic,strong) UIColor *btnTitleColor;

//按钮上字体的大小 默认字体大小是9.0f
@property (nonatomic,assign) CGFloat btnTitleSize;

@end
