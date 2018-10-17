//
//  ZLAnimationTextField.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLAnimationTextFieldConfig : NSObject


/**
 * "X" 号
 */
@property (nonatomic, assign) BOOL clearsOnBeginEditing;

/**
 * 右边的按钮
 */
@property (nonatomic, assign) BOOL isShowRightButton;     // default is NO
@property (nonatomic, assign) BOOL secureTextEntry;       // default is NO


/**
 * placeholder
 */
@property (nonatomic, copy) NSString *placeholder;

@end

@class ZLAnimationTextField;
@protocol ZLAnimationTextFieldDelegate <NSObject>
@optional

-(void)animationTextField:(ZLAnimationTextField *)animationTextField rightButtonClick:(UIButton *)sender;

@end


@interface ZLAnimationTextField : UIView

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIView      * leftView; 
@property (nonatomic, copy)   NSString    * text;

@property (nonatomic, assign) UITextFieldViewMode  leftViewMode; 


@property (nonatomic, assign) BOOL rightSelected;

@property (nonatomic, weak) id <ZLAnimationTextFieldDelegate> delegate;

- (instancetype)initWithConfig:(ZLAnimationTextFieldConfig *)config;


@end
