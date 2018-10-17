//
//  UITextField+ZLDeleteBackward.m
//  ZLCommonFoundation
//
//  Created by zhoulian on 17/8/14.
//

#import "UITextField+ZLDeleteBackward.h"
#import "SwizzleManager.h"

NSString * const ZLTextFieldDidDeleteBackwardNotification = @"ZLTextFieldDidDeleteBackwardNotification";

@implementation UITextField (ZLDeleteBackward)

+ (void)load {
    //交换2个方法中的IMP
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwizzlingMethod([self class], NSSelectorFromString(@"deleteBackward"), @selector(zl_deleteBackward));
    });
}
- (void)zl_deleteBackward {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLTextFieldDidDeleteBackwardNotification object:self];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <ZLTextFieldDelegate> delegate  = (id<ZLTextFieldDelegate>)self.delegate;
        BOOL isDeleteBackward = [delegate textFieldDidDeleteBackward:self];
        if (isDeleteBackward) {
            [self zl_deleteBackward];
        }
    }else{
        [self zl_deleteBackward];
    }
    
}

@end
