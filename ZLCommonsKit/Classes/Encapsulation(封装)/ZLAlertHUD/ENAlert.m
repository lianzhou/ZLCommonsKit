//
//  ENAlert.m
//  CustomENAlert
//
//  Created by zhoulian on 15/11/25.
//  Copyright © 2015年 zhoulian. All rights reserved.
//

#import "ENAlert.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "ZLStringMacrocDefine.h"
#import "ZLContext.h"
#import "ZLSystemMacrocDefine.h"

@implementation ENAlert

#define EN_IOS9  [[[UIDevice currentDevice] systemVersion] floatValue]>=9.0f

+ (ENAlert *) sharedInstance{
    static ENAlert *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ENAlert alloc] init];
    });
    return instance;
}
+(void)alertShowTitle:(nullable NSString *)title 
              message:(nullable NSString *)message  
    cancelButtonTitle:(nullable NSString *)cancelButtonTitle  
    otherButtonTitles:(nullable NSMutableArray <NSString *> *)otherButtonTitles
                block:(nullable UIAlertViewCallBackBlock)alertBlock
{
    [[ENAlert sharedInstance] alertShowTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles block:alertBlock];
}
-(void)alertShowTitle:(nullable NSString *)title 
              message:(nullable NSString *)message  
    cancelButtonTitle:(nullable NSString *)cancelButtonTitle  
    otherButtonTitles:(nullable NSMutableArray <NSString *> *)otherButtonTitles
                block:(nullable UIAlertViewCallBackBlock)alertBlock
{
    if (ZL_IOS8) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:ZLIFISNULL(message)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        if (!ZLStringIsNull(cancelButtonTitle)) {
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      alertBlock(0);
                                                                  }];
            [alert addAction:defaultAction];
            
        }
        [otherButtonTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull otherButton, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:otherButton
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      alertBlock(idx+1);
                                                                  }];
            [alert addAction:defaultAction];
            
        }];
        [[ZLContext shareInstance].currentViewController presentViewController:alert animated:YES completion:nil];
    }else{
        NSString * otherButtonList = @"";
        if (otherButtonTitles.count>0) {
            otherButtonList = [otherButtonTitles componentsJoinedByString:@","];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelButtonTitle
                                                  otherButtonTitles:otherButtonList, nil];
        alertView.delegate = self;
        [alertView show];
        alertView.alertViewCallBackBlock = alertBlock;
        
//#endif
    }
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.cancelButtonIndex < 0) {
        if (alertView.alertViewCallBackBlock) {
            alertView.alertViewCallBackBlock(buttonIndex+1);
        }
    }else{
        if (alertView.alertViewCallBackBlock) {
            alertView.alertViewCallBackBlock(buttonIndex);
        }
    }
}

@end
