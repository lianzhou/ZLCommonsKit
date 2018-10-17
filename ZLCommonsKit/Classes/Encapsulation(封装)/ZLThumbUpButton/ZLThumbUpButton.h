//
//  ZLThumbUpButton.h
//  BtnDemo
//
//  Created by wangjingfei on 2017/6/12.
//  Copyright © 2017年 wangXiao. All rights reserved.
//

#import <UIKit/UIKit.h>


//按钮点击是否有动画
typedef NS_ENUM(NSInteger,ClickAnimationType) {
    ClickAnimationTypeNormal = 0,//点击无动画
    ClickAnimationTypeAnimation,//点击有动画
};
@interface ZLThumbUpButton : UIButton

@property (nonatomic,assign) ClickAnimationType clickType;

//选中按钮
- (void)selectChangeCurrentBtnImg:(NSString *)imgName withSelectAniImage:(NSString *)imgStr withTitleColor:(UIColor *)titleColor  withTitleName:(NSString *)titleName withClickBtn:(ClickAnimationType)clickType;

//取消选中
- (void)deselectChangeCurrentBtnImg:(NSString *)imgName  withAnimationArray:(NSArray *)imgArray withTitleColor:(UIColor *)titleColor  withTitleName:(NSString *)titleName withClickBtn:(ClickAnimationType)clickType;
/**
 点击按钮只修改图片
 
 @param imgName button图片的修改
 */
- (void)selectCurrentBtnImgChange:(NSString *)imgName;


/**
 点击按钮只修改汉字和汉字的颜色
 
 @param titleName button字的修改
 @param titleColor button字体颜色修改
 */
- (void)selectCurrentBtnTitleChange:(NSString *)titleName withBtnTitltColor:(UIColor *)titleColor;


/**
 点击按钮只修改图片、字体颜色、字的修改
 
 @param imgName 修改button上显示的图片
 @param titleColor button字体颜色修改
 @param titleName button字的修改
 */
- (void)selectCurrentBtnImgChange:(NSString *)imgName withBtnTitltColor:(UIColor *)titleColor withCurrentBtnTitleChange:(NSString *)titleName;


@end
