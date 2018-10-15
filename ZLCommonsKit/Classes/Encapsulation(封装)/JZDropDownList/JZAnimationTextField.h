//
//  JZAnimationTextField.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/6/27.
//

#import <UIKit/UIKit.h>

@interface JZAnimationTextFieldConfig : NSObject


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

@class JZAnimationTextField;
@protocol JZAnimationTextFieldDelegate <NSObject>
@optional

-(void)animationTextField:(JZAnimationTextField *)animationTextField rightButtonClick:(UIButton *)sender;

@end


@interface JZAnimationTextField : UIView

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIView      * leftView; 
@property (nonatomic, copy)   NSString    * text;

@property (nonatomic, assign) UITextFieldViewMode  leftViewMode; 


@property (nonatomic, assign) BOOL rightSelected;

@property (nonatomic, weak) id <JZAnimationTextFieldDelegate> delegate;

- (instancetype)initWithConfig:(JZAnimationTextFieldConfig *)config;


@end
