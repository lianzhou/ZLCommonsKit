//
//  UITextField+JZDeleteBackward.m
//  AFNetworking
//
//  Created by li_chang_en on 2017/12/8.
//

#import "UITextField+JZDeleteBackward.h"
#import "SwizzleManager.h"

NSString * const JZTextFieldDidDeleteBackwardNotification = @"JZTextFieldDidDeleteBackwardNotification";

@implementation UITextField (JZDeleteBackward)

+ (void)load {
    //交换2个方法中的IMP
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwizzlingMethod([self class], NSSelectorFromString(@"deleteBackward"), @selector(jz_deleteBackward));
    });
}
- (void)jz_deleteBackward {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JZTextFieldDidDeleteBackwardNotification object:self];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <JZTextFieldDelegate> delegate  = (id<JZTextFieldDelegate>)self.delegate;
        BOOL isDeleteBackward = [delegate textFieldDidDeleteBackward:self];
        if (isDeleteBackward) {
            [self jz_deleteBackward];
        }
    }else{
        [self jz_deleteBackward];
    }
    
}

@end
