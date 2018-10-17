//
//  UITextView+ZLDeleteBackward.h
//  ZLCommonFoundation
//
//  Created by zhoulian on 17/8/14.
//

#import <UIKit/UIKit.h>

@protocol ZLTextViewDelegate <UITextViewDelegate>
@optional
- (BOOL)textViewDidDeleteBackward:(UITextView *)textView;
- (void)zl_textViewDidChange:(UITextView *)textView;
@end

@interface UITextView (ZLDeleteBackward)

@property (weak, nonatomic) id<ZLTextViewDelegate> delegate;

@end

extern NSString * const ZLTextViewDidDeleteBackwardNotification;
