//
//  ZLButtonPlacementListView.h
//  ZLViewDemo
//
//  Created by wangjingfei on 2017/9/4.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLThumbUpButton.h"
#import "ZLButtonItemModel.h"

@protocol ZLButtonClickDelegate <NSObject>

- (void)clickButton:(ZLThumbUpButton *)selectBtn withClickButtonType:(ZLButtonDisplayType)buttonDisplayType;

@end
@interface ZLButtonPlacementListView : UIView

//左边的视图
@property (nonatomic,strong) UIView *leftView;

//按钮之间的间隙 默认是 10.0f
@property (nonatomic,assign) CGFloat btnSpace;

@property (nonatomic,weak) id<ZLButtonClickDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withButtonItem:(NSArray *)itemArray;

//修改按钮上的字 图片
- (void)modifyTheWordImageOnTheButton:(NSString *)titleName withButtonImage:(NSString *)imageName withButtonTitleColor:(UIColor *)titleColor withCurrentButtonType:(ZLButtonDisplayType)btnDisplayType;

@end
