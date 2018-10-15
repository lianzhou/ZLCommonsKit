//
//  NSObject+JZUnrecognizedSelectorSafe.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "NSObject+JZUnrecognizedSelectorSafe.h"
#import <objc/runtime.h>
#import "SwizzleManager.h"

@interface _UnregSelObjectProxy : NSObject
+ (instancetype) sharedInstance;
@end

@implementation _UnregSelObjectProxy
+ (instancetype) sharedInstance{
    
    static _UnregSelObjectProxy *instance=nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        instance = [[_UnregSelObjectProxy alloc] init];
    });
    return instance;
}

+ (BOOL) resolveInstanceMethod:(SEL)selector {
    
    class_addMethod([self class], selector,(IMP)emptyMethodIMP,"v@:");
    return YES;
}

void emptyMethodIMP(){
    
}

@end


@implementation NSObject (JZUnrecognizedSelectorSafe)

//#ifdef DEBUG
//
//#else
//+(void)load{
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleMSFS];
//        [self swizzleFI];
//    });
//    
//}
//#endif

+(void)swizzleMSFS{
    
    SEL originalSelector = @selector(methodSignatureForSelector:);
    SEL swizzledSelector = @selector(zy_methodSignatureForSelector:);
    SwizzlingMethod([self class], originalSelector, swizzledSelector);
}

+(void)swizzleFI{
    
    SEL originalSelector = @selector(forwardInvocation:);
    SEL swizzledSelector = @selector(zy_forwardInvocation:);
    SwizzlingMethod([self class], originalSelector, swizzledSelector);
}
- (NSMethodSignature *)zy_methodSignatureForSelector:(SEL)sel{
    
    NSMethodSignature *sig;
    sig = [self zy_methodSignatureForSelector:sel];
    if (sig) {
        return sig;
    }
    
    sig = [[_UnregSelObjectProxy sharedInstance] zy_methodSignatureForSelector:sel];
    if (sig){
        return sig;
    }
    
    return nil;
}

- (void)zy_forwardInvocation:(NSInvocation *)anInvocation{
    
    [anInvocation invokeWithTarget:[_UnregSelObjectProxy sharedInstance] ];
    NSLog(@"******* 没有找到此方法 [%@ %@] ",NSStringFromClass([self class]),NSStringFromSelector(anInvocation.selector) );
}

@end
