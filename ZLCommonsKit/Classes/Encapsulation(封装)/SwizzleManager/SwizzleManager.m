//
//  SwizzleManager.m
//  e学云学生版
//
//  Created by juziwl on 15/11/4.
//  Copyright © 2015年 李长恩. All rights reserved.
//

#import "SwizzleManager.h"
#import "ZLBaseViewController.h"
#import "Aspects.h"
#import "ZLContext.h"
#import <objc/runtime.h>

@implementation SwizzleManager

+ (void)createAllHooks
{
    /**
     *  获取当前currentViewController
     */
    [ZLBaseViewController aspect_hookSelector:@selector(viewWillAppear:)
                              withOptions:AspectPositionBefore 
                               usingBlock:^(id<AspectInfo> info){
                                   
                                   if ([[info.instance class] isSubclassOfClass:[ZLBaseViewController class]]) {
                                       NSLog(@"\n进入界面:[%@ viewWillAppear]\n",[info.instance class]);

                                    NSString *  instanceString =  NSStringFromClass([info.instance class]);
                                       if (![instanceString isEqualToString:@"ZLZLShareSearchViewController"] && ![instanceString isEqualToString:@"ZLAlertViewController"]  && ![instanceString isEqualToString:@"ZLIntegralDeductionRuleOrSelectPayTypeViewController"]) {
                                           ZLBaseViewController* currentViewController = (ZLBaseViewController *)info.instance;
                                           [ZLContext shareInstance].currentViewController = currentViewController;
                                       }                                       
                                   }
                               }error:NULL];
    /**
     *  获取当前currentViewController
     */
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) 
                              withOptions:AspectPositionBefore 
                               usingBlock:^(id<AspectInfo> info){
                                   
                                   if ([[info.instance class] isSubclassOfClass:[ZLBaseViewController class]]) {
                                       NSLog(@"\n进入界面:[%@ viewDidLoad]\n",[info.instance class]);

                                       NSString *  instanceString =  NSStringFromClass([info.instance class]);
                                       if (![instanceString isEqualToString:@"ZLZLShareSearchViewController"] && ![instanceString isEqualToString:@"ZLAlertViewController"] && ![instanceString isEqualToString:@"ZLIntegralDeductionRuleOrSelectPayTypeViewController"]) {
                                           ZLBaseViewController* currentViewController = (ZLBaseViewController *)info.instance;
                                           [ZLContext shareInstance].currentViewController = currentViewController;
                                       }                                       
                                       
                                   }
                                   
                               }error:NULL];

    
    SEL dealloc = NSSelectorFromString(@"dealloc");
    [UIViewController aspect_hookSelector:dealloc 
                              withOptions:AspectPositionBefore 
                               usingBlock:^(id<AspectInfo> info){
                                   
                                   if ([[info.instance class] isSubclassOfClass:[ZLBaseViewController class]]) {
                                       NSLog(@"\n页面释放:[%@ dealloc]\n",[info.instance class]);
                                   }
                               }error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(didReceiveMemoryWarning)
                              withOptions:AspectPositionBefore
                               usingBlock:^(id<AspectInfo> info){
                                   if ([[info.instance class] isSubclassOfClass:[ZLBaseViewController class]]) {
                                       NSLog(@"-------->内存溢出<---------内存溢出的:[%@ didReceiveMemoryWarning]<--------",[info.instance class]);
                                   }
                               }error:NULL];
    
}
//静态就交换静态，实例方法就交换实例方法
void SwizzlingMethod(Class class, SEL originSEL, SEL swizzledSEL)
{
    Method originMethod = class_getInstanceMethod(class, originSEL);
    Method swizzledMethod = nil; 
    
    if (!originMethod)
    {// 处理为类方法
        originMethod = class_getClassMethod(class, originSEL);
        if (!originMethod)
        {
            return;
        }
        swizzledMethod = class_getClassMethod(class, swizzledSEL);
        if (!swizzledMethod)
        {
            return;
        }
    }
    else
    {// 处理实例方法
        swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        if (!swizzledMethod)
        {
            return;
        }
    }
    
    if(class_addMethod(class, originSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)))
    { //自身已经有了就添加不成功，直接交换即可
        class_replaceMethod(class, swizzledSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else
    {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}
@end
