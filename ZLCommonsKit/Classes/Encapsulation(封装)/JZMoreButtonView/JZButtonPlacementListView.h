//
//  JZButtonPlacementListView.h
//  JZViewDemo
//
//  Created by wangjingfei on 2017/9/4.
//  Copyright © 2017年 wangjingfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZThumbUpButton.h"
#import "JZButtonItemModel.h"

@protocol JZButtonClickDelegate <NSObject>

- (void)clickButton:(JZThumbUpButton *)selectBtn withClickButtonType:(JZButtonDisplayType)buttonDisplayType;

@end
@interface JZButtonPlacementListView : UIView

//左边的视图
@property (nonatomic,strong) UIView *leftView;

//按钮之间的间隙 默认是 10.0f
@property (nonatomic,assign) CGFloat btnSpace;

@property (nonatomic,weak) id<JZButtonClickDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withButtonItem:(NSArray *)itemArray;

//修改按钮上的字 图片
- (void)modifyTheWordImageOnTheButton:(NSString *)titleName withButtonImage:(NSString *)imageName withButtonTitleColor:(UIColor *)titleColor withCurrentButtonType:(JZButtonDisplayType)btnDisplayType;

@end
