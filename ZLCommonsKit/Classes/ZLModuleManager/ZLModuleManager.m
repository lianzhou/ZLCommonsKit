//
//  ZLModuleManager.m
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//


#import "ZLModuleManager.h"
#import "ZLStringMacrocDefine.h"
#import "ZLModuleProtocol.h"
#import "ZLContext.h"

static  NSString *kSetupSelector = @"modSetUp:";

//提示信息
NSString * ZL_ModuleEventSelectors[] =
{
    [ZLInitEvent]                  = @"didFinishLaunchingWithOptions:",
    [ZLWillResignActiveEvent]      = @"applicationWillResignActive:",
    [ZLDidEnterBackgroundEvent]    = @"applicationDidEnterBackground:",
    [ZLWillEnterForegroundEvent]   = @"applicationWillEnterForeground:",
    [ZLDidBecomeActiveEvent]       = @"applicationDidBecomeActive:",
    [ZLWillTerminateEvent]         = @"applicationWillTerminate:",
    [ZLSourceApplication]               = @"applicationSourceApplication:",
    [ZLDidUpdateUserActivityEvent]            = @"applicationDidUpdateUserActivity:",
    [ZLDidFailToContinueUserActivityEvent]    = @"applicationDidFailToContinueUserActivityWithType:",
    [ZLContinueUserActivityEvent]             = @"applicationContinueUserActivityRestorationHandler:",
    [ZLWillContinueUserActivityEvent]         = @"applicationWillContinueUserActivityWithType:",
    [ZLQuickActionEvent]                      = @"applicationPerformActionForShortcutItemCompletionHandler:",
    [ZLOpenURLEvent]                          = @"applicationOpenURL:",
    [ZLWillPresentNotificationEvent]          = @"applicationUserNotificationCenterWillPresentNotification:",
    [ZLDidReceiveNotificationResponseEvent]   = @"applicationUserNotificationCenterDidReceiveNotificationResponse:",
    [ZLDidReceiveMemoryWarningEvent]                   = @"applicationDidReceiveMemoryWarning:",
    [ZLDidFailToRegisterForRemoteNotificationsEvent]   = @"applicationDidFailToRegisterForRemoteNotificationsWithError:",
    [ZLDidRegisterForRemoteNotificationsEvent]         = @"applicationDidRegisterForRemoteNotificationsWithDeviceToken:",
    [ZLDidReceiveRemoteNotificationEvent]              = @"applicationDidReceiveRemoteNotificationCompletionHandler:",
    [ZLDidReceiveLocalNotificationEvent]               = @"applicationDidReceiveLocalNotification:",

};

@interface ZLModuleManager ()

@end

@implementation ZLModuleManager
+ (instancetype)sharedManager
{
    static dispatch_once_t once_t;
    static id ZLModuleManagerInstance = nil;
    dispatch_once(&once_t, ^{
        ZLModuleManagerInstance = [[[self class] alloc] init];
    });
    return ZLModuleManagerInstance;
}

- (void)triggerEvent:(ZLModuleEventType)eventType
{
    NSString * selectorStr = ZL_ModuleEventSelectors[eventType];
    if (ZLStringIsNull(selectorStr)) {
        return;
    }
    [self handleModuleEvent:selectorStr protocol:@protocol(ZLModuleProtocol)];

}

- (void)handleModuleEvent:(NSString *)selectorStr protocol:(Protocol *)protocol
{
    NSString * protocolStr = NSStringFromProtocol(protocol);
    if (ZLStringIsNull(protocolStr)) {
        return;
    }
    NSMutableArray * modules =  [[ZLContext shareInstance].appConfig moduleServicesWithProtocol:protocol];
    
    SEL seletor = NSSelectorFromString(selectorStr);
    [modules enumerateObjectsUsingBlock:^(id<NSObject> moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([moduleInstance respondsToSelector:seletor]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [moduleInstance performSelector:seletor withObject:[ZLContext shareInstance]];
#pragma clang diagnostic pop
                        
        }
    }];
}

@end
