//
//  JZDropDownItem.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/7/11.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JZDropDownItem;
typedef void(^dropItemSelectedBlock)(NSUInteger idex,JZDropDownItem * dropDownItem);

@interface JZDropDownCellConfig : NSObject

@property(nonatomic,assign) CGFloat cellHeight;
@property(nonatomic,copy) NSString * cellName;
@property(nonatomic,copy) NSString * cellIdentifier;

@end



@interface JZDropDownItem : NSObject

/**
 标题
 */
@property(nonatomic,copy)NSString *title;

/**
 图片
 */
@property(nonatomic,copy)NSString *iconName;

/**
 是否选中
 */
@property(nonatomic,assign)BOOL isSelected;

/**
 是否显示图标
 */
@property(nonatomic,assign)BOOL isShowIcon;
/**
 cell的配置
 */
@property(nonatomic,strong) JZDropDownCellConfig * info;
/**
 自定义数据
 */
@property(nonatomic,strong) id customData;

/**
 是否自动隐藏
 */
@property(nonatomic,assign)BOOL isHidenCell;


@property(nonatomic,copy)dropItemSelectedBlock dropSelectedBlcok;


/**
 构造器方法

 @param title item的标题
 @param iconName item的图标
 @param dropSelectedBlcok 点击回调
 @return self
 */
+(instancetype)downItemWithTitle:(NSString *)title withIconName:(NSString *)iconName withSelectedBlock:(dropItemSelectedBlock)dropSelectedBlcok;

+(instancetype)downItemWithTitle:(NSString *)title withIconName:(NSString *)iconName;

/**
 只有文字,没有图标的item创建

 @param title item的标题
 @param dropSelectedBlcok 点击回调
 @return self
 */
+(instancetype)downItemWithTitle:(NSString *)title withSelectedBlock:(dropItemSelectedBlock)dropSelectedBlcok;

+(instancetype)downItemWithTitle:(NSString *)title;
@end
