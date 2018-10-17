//
//  ZLAppDelegate.m
//  Pods
//
//  Created by zhoulian on 17/8/22.
//
//

#import "ZLAppDelegate.h"
#import "ZLModuleManager.h"
#import "ZLContext.h"
#import "ZLExceptionHandler.h"
#import "ZLDataHandler.h"

@implementation ZLAppDelegate


- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@_zl_log.log",[ZLDataHandler toYYYYMMddHHmmss:[NSDate date]]];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions __attribute__((objc_requires_super))
{
    [ZLContext shareInstance].application = application;
    [ZLContext shareInstance].launchOptions = launchOptions;
    [[ZLModuleManager sharedManager] triggerEvent:ZLInitEvent];
  
//#if DEBUG
//    [self redirectNSlogToDocumentFolder];
//#endif
    
//    [[ZLExceptionHandler sharedHandler] addSensorsAnalyticsInstance:[SensorsAnalyticsSDK sharedInstance] ];
    [ZLExceptionHandler sharedHandler];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[ZLModuleManager sharedManager] triggerEvent:ZLWillResignActiveEvent];
}

- (void)applicationDidEnterBackground:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[ZLModuleManager sharedManager] triggerEvent:ZLDidEnterBackgroundEvent];
}

- (void)applicationWillEnterForeground:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[ZLModuleManager sharedManager] triggerEvent:ZLWillEnterForegroundEvent];
}

- (void)applicationDidBecomeActive:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[ZLModuleManager sharedManager] triggerEvent:ZLDidBecomeActiveEvent];
}

- (void)applicationWillTerminate:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[ZLModuleManager sharedManager] triggerEvent:ZLWillTerminateEvent];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation __attribute__((objc_requires_super))
{
    [[ZLContext shareInstance].openURLItem setOpenURL:url];
    [[ZLContext shareInstance].openURLItem setSourceApplication:sourceApplication];
    [[ZLModuleManager sharedManager] triggerEvent:ZLOpenURLEvent];
    return YES;
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[ZLModuleManager sharedManager] triggerEvent:ZLDidReceiveMemoryWarningEvent];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error __attribute__((objc_requires_super))
{
    [[ZLContext shareInstance].notificationsItem setNotificationsError:error];
    [[ZLModuleManager sharedManager] triggerEvent:ZLDidFailToRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken __attribute__((objc_requires_super))
{
    [[ZLContext shareInstance].notificationsItem setDeviceToken: deviceToken];
    [[ZLModuleManager sharedManager] triggerEvent:ZLDidRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo __attribute__((objc_requires_super))
{
    [[ZLContext shareInstance].notificationsItem setUserInfo: userInfo];
    [[ZLModuleManager sharedManager] triggerEvent:ZLDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler __attribute__((objc_requires_super))
{
    [[ZLContext shareInstance].notificationsItem setUserInfo: userInfo];
    [[ZLContext shareInstance].notificationsItem setNotificationResultHander: completionHandler];
    [[ZLModuleManager sharedManager] triggerEvent:ZLDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification __attribute__((objc_requires_super))
{
    [[ZLContext shareInstance].notificationsItem setLocalNotification: notification];
    [[ZLModuleManager sharedManager] triggerEvent:ZLDidReceiveLocalNotificationEvent];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity __attribute__((objc_requires_super))
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[ZLContext shareInstance].userActivityItem setUserActivity: userActivity];
        [[ZLModuleManager sharedManager] triggerEvent:ZLDidUpdateUserActivityEvent];
    }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error __attribute__((objc_requires_super))
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[ZLContext shareInstance].userActivityItem setUserActivityType: userActivityType];
        [[ZLContext shareInstance].userActivityItem setUserActivityError: error];
        [[ZLModuleManager sharedManager] triggerEvent:ZLDidFailToContinueUserActivityEvent];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler __attribute__((objc_requires_super))
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[ZLContext shareInstance].userActivityItem setUserActivity: userActivity];
        [[ZLContext shareInstance].userActivityItem setRestorationHandler: restorationHandler];
        [[ZLModuleManager sharedManager] triggerEvent:ZLContinueUserActivityEvent];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType __attribute__((objc_requires_super))
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[ZLContext shareInstance].userActivityItem setUserActivityType: userActivityType];
        [[ZLModuleManager sharedManager] triggerEvent:ZLWillContinueUserActivityEvent];
    }
    return YES;
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400 

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler __attribute__((objc_requires_super))
{
    [[ZLContext shareInstance].touchShortcutItem setShortcutItem: shortcutItem];
    [[ZLContext shareInstance].touchShortcutItem setScompletionHandler: completionHandler];
    [[ZLModuleManager sharedManager] triggerEvent:ZLQuickActionEvent];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options __attribute__((objc_requires_super))
{
    [[ZLContext shareInstance].openURLItem setOpenURL:url];
    [[ZLContext shareInstance].openURLItem setOptions:options];
    [[ZLModuleManager sharedManager] triggerEvent:ZLOpenURLEvent];
    return YES;
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __attribute__((objc_requires_super)){
    [[ZLContext shareInstance].notificationsItem setNotification: notification];
    [[ZLContext shareInstance].notificationsItem setNotificationPresentationOptionsHandler: completionHandler];
    [[ZLContext shareInstance].notificationsItem setCenter:center];
    [[ZLModuleManager sharedManager] triggerEvent:ZLWillPresentNotificationEvent];
};

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler __attribute__((objc_requires_super)){
    [[ZLContext shareInstance].notificationsItem setNotificationResponse: response];
    [[ZLContext shareInstance].notificationsItem setNotificationCompletionHandler:completionHandler];
    [[ZLContext shareInstance].notificationsItem setCenter:center];
    [[ZLModuleManager sharedManager] triggerEvent:ZLDidReceiveNotificationResponseEvent];
};
#endif

@end

@implementation ZLOpenURLItem

@end

@implementation ZLShortcutItem

@end

@implementation ZLUserActivityItem

@end

@implementation ZLNotificationsItem

@end
