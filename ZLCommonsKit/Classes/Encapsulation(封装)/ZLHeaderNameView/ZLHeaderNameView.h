//
//  ZLTableCellBaseHeaderView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZLHeaderNameItemStyle) {
    ZLHeaderNameItemStyleDefault,	// 上下结构 
    ZLHeaderNameItemStyleValue1,	// 单一结构  
    ZLHeaderNameItemStyleValue2,    // 左右结构 
}; 

@interface ZLHeaderNameItem : NSObject



@property (nonatomic, assign) BOOL clipsToBounds;
@property (nonatomic, assign) ZLHeaderNameItemStyle headerNameItemStyle;

/** 顶部视图的高度 */
@property (nonatomic, assign) CGFloat height;

/** 传入头像userID(网络请求的) */
@property (nonatomic, copy) NSString *userID;

/** 传入头像url(网络请求的) */
@property (nonatomic, copy) NSString *iconUrl;

/** 传入头像图片(本地) */
@property (nonatomic, copy) NSString *localIcon;

/** 传入标题 */
@property (nonatomic, copy) NSString *nameText;

/** 传入日期 */
@property (nonatomic, copy) NSString *dateText;


@property (nonatomic, assign) CGSize  iconSize;
/** 如果category为View的话 需要更新约束需要传入右边视图的size */
@property (nonatomic, assign) CGSize rightViewSize;

@property (nonatomic, strong) UIView *rightView;

@property (nonatomic, copy) void (^headerNameItemChangeData)();


@end

@interface ZLHeaderNameView : UIView

/** 头像 */
@property (nonatomic, strong) UIImageView *iconImgView;

/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;

/** 日期 */
@property (nonatomic, strong) UILabel *dateLabel;



@property (nonatomic, strong) ZLHeaderNameItem *headerNameItem;


@property (nonatomic, copy) void (^headerImageClick)(UIImageView *iconImgView);


- (instancetype)initWithItem:(ZLHeaderNameItem *)item;

@end
