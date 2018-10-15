//
//  UIAlertView+JZBlock.m
//  eStudy
//
//  Created by zhoulian on 17/6/23.
//

#import "UIAlertView+JZBlock.h"
#import <objc/runtime.h>

static const void *UIAlertViewKey  = "UIAlertViewJZBlock";

@implementation UIAlertView (JZBlock)

- (void)setAlertViewCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock {
    
    objc_setAssociatedObject(self, &UIAlertViewKey, alertViewCallBackBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewCallBackBlock)alertViewCallBackBlock {
    
    return objc_getAssociatedObject(self, &UIAlertViewKey);
}


@end
