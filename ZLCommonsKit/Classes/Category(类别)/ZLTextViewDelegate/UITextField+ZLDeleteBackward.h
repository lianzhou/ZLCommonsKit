//
//  UITextField+ZLDeleteBackward.h
//  ZLCommonFoundation
//
//  Created by zhoulian on 17/8/14.
//

#import <UIKit/UIKit.h>

@protocol ZLTextFieldDelegate <UITextFieldDelegate>
@optional
- (BOOL)textFieldDidDeleteBackward:(UITextField *)textView;
- (void)zl_textFieldViewDidChange:(UITextField *)textField;
@end

@interface UITextField (ZLDeleteBackward)

@property (weak, nonatomic) id<ZLTextFieldDelegate> delegate;

@end

extern NSString * const ZLTextFieldDidDeleteBackwardNotification;
