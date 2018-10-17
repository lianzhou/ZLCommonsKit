//
//  ZLDropDownListView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLDropDownItem.h"

typedef NS_ENUM(NSUInteger , ZLDropDownListViewShowType) {
    ZLDropDownListViewShowTypeNormal = 0,
    ZLDropDownListViewShowTypeCenter,   //居中
    ZLDropDownListViewShowTypeLeft, 
    ZLDropDownListViewShowTypeRight,
};

@class ZLDropDownListView;

@protocol ZLDropDownListViewDelegate <NSObject>

@optional
- (void)dropDownListView:(ZLDropDownListView *)dropDownListView withSelectedItem:(ZLDropDownItem *)selectedItem withIndx:(NSInteger)index;


@end


@interface ZLDropDownConfig : NSObject


@property(nonatomic,assign) CGFloat cornerRadius;

@property(nonatomic,assign) CGFloat dropDownViewTop;

@property(nonatomic,assign) CGFloat dropDownViewLeft;

@property(nonatomic,assign) CGFloat dropDownViewWidth;
@property(nonatomic,assign) CGFloat dropDownViewMAXHeight;

@property(nonatomic,assign) BOOL isShowArrow;

@property(nonatomic,strong) NSMutableArray <ZLDropDownItem *>*dropDownItems;

@property(nonatomic,strong)UIColor * bgViewColor;

@end

@interface ZLDropDownListView : UIView

@property (nonatomic,assign) BOOL isShow;

@property(nonatomic,weak)id<ZLDropDownListViewDelegate>delegate;


- (instancetype)initWithConfig:(ZLDropDownConfig *)dropDownConfig;

- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)targetButtonItem dropDownListViewShowType:(ZLDropDownListViewShowType)dropDownListViewShowType;

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView dropDownListViewShowType:(ZLDropDownListViewShowType)dropDownListViewShowType;

- (void)animateShowOrHiden;

@end
