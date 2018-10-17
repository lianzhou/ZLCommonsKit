//
//  UITextView+ZLDeleteBackward.m
//  ZLCommonFoundation
//
//  Created by zhoulian on 17/8/14.
//

#import "UITextView+ZLDeleteBackward.h"
#import "SwizzleManager.h"

NSString * const ZLTextViewDidDeleteBackwardNotification = @"ZLTextViewDidDeleteBackwardNotification";

@implementation UITextView (ZLDeleteBackward)

+ (void)load {
    //交换2个方法中的IMP
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwizzlingMethod([self class], NSSelectorFromString(@"deleteBackward"), @selector(zl_deleteBackward));
    });
}

- (void)zl_deleteBackward {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLTextViewDidDeleteBackwardNotification object:self];

    if ([self.delegate respondsToSelector:@selector(textViewDidDeleteBackward:)])
    {
        id <ZLTextViewDelegate> delegate  = (id<ZLTextViewDelegate>)self.delegate;
        BOOL isDeleteBackward = [delegate textViewDidDeleteBackward:self];
        if (isDeleteBackward) {
            [self zl_deleteBackward];
        }
    }else{
        [self zl_deleteBackward];
    }

}

@end
