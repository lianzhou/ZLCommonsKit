//
//  JZAlertHUD.m
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/6/22.
//


#import "JZAlertHUD.h"
#import "JZStringMacrocDefine.h"


@interface JZAlertHUD ()

@end

@implementation JZAlertHUD
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message  
     cancelButtonTitle:(NSString *)cancelButtonTitle  
     otherButtonTitles:(NSMutableArray <NSString *> *)otherButtonTitles
         continueBlock:(dispatch_block_t)continueBlock
           cancelBlock:(dispatch_block_t)cancelBlock
           otherBlock:(UIAlertViewCallBackBlock)otherBlock{
    
    [ENAlert alertShowTitle:title  
                    message:message 
          cancelButtonTitle:cancelButtonTitle  
          otherButtonTitles:otherButtonTitles  block:^(NSInteger buttonIndex) { 
              if (buttonIndex==0) {
                  if (cancelBlock) {
                      cancelBlock();
                  }
              }else if(buttonIndex==1){
                  if (continueBlock) {
                      continueBlock();
                  }
              }else{
                  if (otherBlock) {
                      otherBlock(buttonIndex);
                  }
              }
          }];

}
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message  
     cancelButtonTitle:(NSString *)cancelButtonTitle  
     otherButtonTitles:(NSMutableArray <NSString *> *)otherButtonTitles
         continueBlock:(dispatch_block_t)continueBlock
           cancelBlock:(dispatch_block_t)cancelBlock
{
    [self alertShowTitle:title 
                 message:message 
       cancelButtonTitle:cancelButtonTitle 
       otherButtonTitles:otherButtonTitles 
           continueBlock:continueBlock 
             cancelBlock:cancelBlock 
              otherBlock:nil];
}
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message  
     cancelButtonTitle:(NSString *)cancelButtonTitle  
      otherButtonTitle:(NSString *)otherButtonTitle
         continueBlock:(dispatch_block_t)continueBlock
           cancelBlock:(dispatch_block_t)cancelBlock
{
    [self alertShowTitle:title 
                 message:message 
       cancelButtonTitle:cancelButtonTitle 
       otherButtonTitles:[@[otherButtonTitle] mutableCopy] 
           continueBlock:continueBlock 
             cancelBlock:cancelBlock
              otherBlock:nil];
}
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message  
     cancelButtonTitle:(NSString *)cancelButtonTitle  
      otherButtonTitle:(NSString *)otherButtonTitle
         continueBlock:(dispatch_block_t)continueBlock
{
    [self alertShowTitle:title 
                 message:message 
       cancelButtonTitle:cancelButtonTitle 
       otherButtonTitles:[@[otherButtonTitle] mutableCopy] 
           continueBlock:continueBlock 
             cancelBlock:nil 
              otherBlock:nil];
}
+ (void)alertShowMessage:(NSString *)message{
    [self alertShowTitle:@"温馨提示" 
                 message:message 
       cancelButtonTitle:@"取消"
       otherButtonTitles:[@[@"确定"] mutableCopy] 
           continueBlock:nil 
             cancelBlock:nil 
              otherBlock:nil];

}
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message {
    [self alertShowTitle:title 
                 message:message 
       cancelButtonTitle:@"取消" 
       otherButtonTitles:[@[@"确定"] mutableCopy] 
           continueBlock:nil 
             cancelBlock:nil 
              otherBlock:nil];
}
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message
      otherButtonTitle:(NSString *)otherButtonTitle
         continueBlock:(dispatch_block_t)continueBlock{
    [self alertShowTitle:title 
                 message:message 
       cancelButtonTitle:@"取消"
       otherButtonTitles:[@[otherButtonTitle] mutableCopy] 
           continueBlock:continueBlock 
             cancelBlock:nil 
              otherBlock:nil];
}
+ (void)alertShowTitle:(NSString *)title 
               message:(NSString *)message
      otherButtonTitle:(NSString *)otherButtonTitle{
    [self alertShowTitle:title 
                 message:message 
       cancelButtonTitle:@"取消"
       otherButtonTitles:[@[otherButtonTitle] mutableCopy] 
           continueBlock:nil 
             cancelBlock:nil 
              otherBlock:nil];

}

#pragma mark - MBProgressHUD
#pragma mark - 显示
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                     customView:(UIView *)customView
                         toView:(UIView *)view 
                      hideAfter:(NSTimeInterval)afterSecond{
    return [MBProgressHUD showHUDTitle:title 
                            customView:customView 
                                toView:view 
                             hideAfter:afterSecond];
}
+ (MBProgressHUD *)showHUDTitle:(NSString *)title{
    return [MBProgressHUD showHUDTitle:title];
}
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                         toView:(UIView *)view{
    
    NSLog(@"----------++++++%@",NSStringFromClass([[view nextResponder] class]));
    
    return [MBProgressHUD showHUDTitle:title
                                toView:view];
}

+ (MBProgressHUD *)showHUDCustomView:(UIView *)customView 
                              toView:(UIView *)view{
    return [MBProgressHUD showHUDCustomView:customView 
                                     toView:view];
}
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                     customView:(UIView *)customView
                         toView:(UIView *)view{
    return [MBProgressHUD showHUDTitle:title 
                            customView:customView 
                                toView:view];

}
+ (MBProgressHUD *)showHUDTitle:(NSString *)title 
                         toView:(UIView *)view 
                 imageNamedType:(JZHUDImageNamedType)imageNamedType{
    return [MBProgressHUD showHUDTitle:title
                                toView:view 
                        imageNamedType:imageNamedType];
}

#pragma mark - automatic 自动隐藏
+ (MBProgressHUD *)showTipTitle:(NSString *)title{
    return [MBProgressHUD showTipTitle:title];
}
+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                         toView:(UIView *)view{
    return [MBProgressHUD showTipTitle:title 
                                toView:view];
}
+ (MBProgressHUD *)showTipCustomView:(UIView *)customView 
                              toView:(UIView *)view{
    return [MBProgressHUD showTipCustomView:customView
                                     toView:view];
}
+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                     customView:(UIView *)customView
                         toView:(UIView *)view{
    return [MBProgressHUD showTipTitle:title 
                            customView:customView 
                                toView:view];

}
+ (MBProgressHUD *)showTipTitle:(NSString *)title 
                         toView:(UIView *)view 
                 imageNamedType:(JZHUDImageNamedType)imageNamedType{
    return [MBProgressHUD showTipTitle:title
                                toView:view 
                        imageNamedType:imageNamedType];
}

#pragma mark - 隐藏
+(void)hideHUD:(UIView *)view{
    [MBProgressHUD hideHUD:view];
}
@end
