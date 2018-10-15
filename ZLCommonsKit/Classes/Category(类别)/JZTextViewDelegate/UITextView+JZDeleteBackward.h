//
//  UITextView+JZDeleteBackward.h
//  e学云
//
//  Created by li_chang_en on 2017/10/20.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JZTextViewDelegate <UITextViewDelegate>
@optional
- (BOOL)textViewDidDeleteBackward:(UITextView *)textView;
- (void)jz_textViewDidChange:(UITextView *)textView;
@end

@interface UITextView (JZDeleteBackward)

@property (weak, nonatomic) id<JZTextViewDelegate> delegate;

@end

extern NSString * const JZTextViewDidDeleteBackwardNotification;
