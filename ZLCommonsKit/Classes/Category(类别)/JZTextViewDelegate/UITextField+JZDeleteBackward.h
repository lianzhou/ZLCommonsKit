//
//  UITextField+JZDeleteBackward.h
//  AFNetworking
//
//  Created by li_chang_en on 2017/12/8.
//

#import <UIKit/UIKit.h>

@protocol JZTextFieldDelegate <UITextFieldDelegate>
@optional
- (BOOL)textFieldDidDeleteBackward:(UITextField *)textView;
- (void)jz_textFieldViewDidChange:(UITextField *)textField;
@end

@interface UITextField (JZDeleteBackward)

@property (weak, nonatomic) id<JZTextFieldDelegate> delegate;

@end

extern NSString * const JZTextFieldDidDeleteBackwardNotification;
