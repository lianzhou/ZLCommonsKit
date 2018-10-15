//
//  JZModuleManager.m
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//


#import "JZModuleManager.h"
#import "JZStringMacrocDefine.h"
#import "JZModuleProtocol.h"
#import "JZContext.h"

static  NSString *kSetupSelector = @"modSetUp:";

//提示信息
NSString * JZ_ModuleEventSelectors[] =
{
    [JZInitEvent]                  = @"didFinishLaunchingWithOptions:",
    [JZWillResignActiveEvent]      = @"applicationWillResignActive:",
    [JZDidEnterBackgroundEvent]    = @"applicationDidEnterBackground:",
    [JZWillEnterForegroundEvent]   = @"applicationWillEnterForeground:",
    [JZDidBecomeActiveEvent]       = @"applicationDidBecomeActive:",
    [JZWillTerminateEvent]         = @"applicationWillTerminate:",
    [JZSourceApplication]               = @"applicationSourceApplication:",
    [JZDidUpdateUserActivityEvent]            = @"applicationDidUpdateUserActivity:",
    [JZDidFailToContinueUserActivityEvent]    = @"applicationDidFailToContinueUserActivityWithType:",
    [JZContinueUserActivityEvent]             = @"applicationContinueUserActivityRestorationHandler:",
    [JZWillContinueUserActivityEvent]         = @"applicationWillContinueUserActivityWithType:",
    [JZQuickActionEvent]                      = @"applicationPerformActionForShortcutItemCompletionHandler:",
    [JZOpenURLEvent]                          = @"applicationOpenURL:",
    [JZWillPresentNotificationEvent]          = @"applicationUserNotificationCenterWillPresentNotification:",
    [JZDidReceiveNotificationResponseEvent]   = @"applicationUserNotificationCenterDidReceiveNotificationResponse:",
    [JZDidReceiveMemoryWarningEvent]                   = @"applicationDidReceiveMemoryWarning:",
    [JZDidFailToRegisterForRemoteNotificationsEvent]   = @"applicationDidFailToRegisterForRemoteNotificationsWithError:",
    [JZDidRegisterForRemoteNotificationsEvent]         = @"applicationDidRegisterForRemoteNotificationsWithDeviceToken:",
    [JZDidReceiveRemoteNotificationEvent]              = @"applicationDidReceiveRemoteNotificationCompletionHandler:",
    [JZDidReceiveLocalNotificationEvent]               = @"applicationDidReceiveLocalNotification:",

};

@interface JZModuleManager ()

@end

@implementation JZModuleManager
+ (instancetype)sharedManager
{
    static dispatch_once_t once_t;
    static id JZModuleManagerInstance = nil;
    dispatch_once(&once_t, ^{
        JZModuleManagerInstance = [[[self class] alloc] init];
    });
    return JZModuleManagerInstance;
}

- (void)triggerEvent:(JZModuleEventType)eventType
{
    NSString * selectorStr = JZ_ModuleEventSelectors[eventType];
    if (JZStringIsNull(selectorStr)) {
        return;
    }
    [self handleModuleEvent:selectorStr protocol:@protocol(JZModuleProtocol)];

}

- (void)handleModuleEvent:(NSString *)selectorStr protocol:(Protocol *)protocol
{
    NSString * protocolStr = NSStringFromProtocol(protocol);
    if (JZStringIsNull(protocolStr)) {
        return;
    }
    NSMutableArray * modules =  [[JZContext shareInstance].appConfig moduleServicesWithProtocol:protocol];
    
    SEL seletor = NSSelectorFromString(selectorStr);
    [modules enumerateObjectsUsingBlock:^(id<NSObject> moduleInstance, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([moduleInstance respondsToSelector:seletor]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [moduleInstance performSelector:seletor withObject:[JZContext shareInstance]];
#pragma clang diagnostic pop
                        
        }
    }];
}

@end
