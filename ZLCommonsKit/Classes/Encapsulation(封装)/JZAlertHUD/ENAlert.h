//
//  ENAlert.h
//  CustomENAlert
//
//  Created by zhoulian on 15/11/25.
//  Copyright © 2015年 zhoulian. All rights reserved.
//
/*
 
 这个其实还是系统的提示框，只是适配了ios9
 */

#import <Foundation/Foundation.h>
#import "UIAlertView+JZBlock.h"

@interface ENAlert : NSObject

+ (nullable ENAlert *) sharedInstance;

+(void)alertShowTitle:(nullable NSString *)title 
              message:(nullable NSString *)message  
    cancelButtonTitle:(nullable NSString *)cancelButtonTitle  
    otherButtonTitles:(nullable NSMutableArray <NSString *> *)otherButtonTitles
                block:(nullable UIAlertViewCallBackBlock)alertBlock;

@end
