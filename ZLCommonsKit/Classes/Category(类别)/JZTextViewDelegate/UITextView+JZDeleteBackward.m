//
//  UITextView+JZDeleteBackward.m
//  e学云
//
//  Created by li_chang_en on 2017/10/20.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "UITextView+JZDeleteBackward.h"
#import "SwizzleManager.h"

NSString * const JZTextViewDidDeleteBackwardNotification = @"JZTextViewDidDeleteBackwardNotification";

@implementation UITextView (JZDeleteBackward)

+ (void)load {
    //交换2个方法中的IMP
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwizzlingMethod([self class], NSSelectorFromString(@"deleteBackward"), @selector(jz_deleteBackward));
    });
}

- (void)jz_deleteBackward {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JZTextViewDidDeleteBackwardNotification object:self];

    if ([self.delegate respondsToSelector:@selector(textViewDidDeleteBackward:)])
    {
        id <JZTextViewDelegate> delegate  = (id<JZTextViewDelegate>)self.delegate;
        BOOL isDeleteBackward = [delegate textViewDidDeleteBackward:self];
        if (isDeleteBackward) {
            [self jz_deleteBackward];
        }
    }else{
        [self jz_deleteBackward];
    }

}

@end
