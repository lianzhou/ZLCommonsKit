//
//  JZDropDownListView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZDropDownItem.h"

typedef NS_ENUM(NSUInteger , JZDropDownListViewShowType) {
    JZDropDownListViewShowTypeNormal = 0,
    JZDropDownListViewShowTypeCenter,   //居中
    JZDropDownListViewShowTypeLeft, 
    JZDropDownListViewShowTypeRight,
};

@class JZDropDownListView;

@protocol JZDropDownListViewDelegate <NSObject>

@optional
- (void)dropDownListView:(JZDropDownListView *)dropDownListView withSelectedItem:(JZDropDownItem *)selectedItem withIndx:(NSInteger)index;


@end


@interface JZDropDownConfig : NSObject


@property(nonatomic,assign) CGFloat cornerRadius;

@property(nonatomic,assign) CGFloat dropDownViewTop;

@property(nonatomic,assign) CGFloat dropDownViewLeft;

@property(nonatomic,assign) CGFloat dropDownViewWidth;
@property(nonatomic,assign) CGFloat dropDownViewMAXHeight;

@property(nonatomic,assign) BOOL isShowArrow;

@property(nonatomic,strong) NSMutableArray <JZDropDownItem *>*dropDownItems;

@property(nonatomic,strong)UIColor * bgViewColor;

@end

@interface JZDropDownListView : UIView

@property (nonatomic,assign) BOOL isShow;

@property(nonatomic,weak)id<JZDropDownListViewDelegate>delegate;


- (instancetype)initWithConfig:(JZDropDownConfig *)dropDownConfig;

- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)targetButtonItem dropDownListViewShowType:(JZDropDownListViewShowType)dropDownListViewShowType;

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView dropDownListViewShowType:(JZDropDownListViewShowType)dropDownListViewShowType;

- (void)animateShowOrHiden;

@end
