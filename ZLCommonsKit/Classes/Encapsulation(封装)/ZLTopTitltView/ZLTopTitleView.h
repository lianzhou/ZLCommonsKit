//
//  ZLTopTitleView.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnButtonClickBlock)(void);

@interface ZLTopTitleView : UIView

//返回按钮
@property (nonatomic,strong) UIButton *returnBtn;

//标题的字体大小
@property (nonatomic, assign) CGFloat titleFontSize;

//标题的字体颜色
@property (nonatomic, strong) UIColor *titleNameColor;

//设置返回键的图标
@property (nonatomic, copy) NSString *returnImageName;

//学生如何找回密码
@property (nonatomic,strong) UIButton *resetPasswordBtn;

/**
 创建头的返回按钮和标题

 @param frame frame
 @param titleName 标题名称
 @param btnClickBlock 返回按钮的点击事件
 @return 对象
 */
- (instancetype)initWithFrame:(CGRect)frame withTitleName:(NSString *)titleName withButtonClick:(ReturnButtonClickBlock)btnClickBlock;


@end
