//
//  JZAppDelegate.m
//  Pods
//
//  Created by zhoulian on 17/8/22.
//
//

#import "JZAppDelegate.h"
#import "JZModuleManager.h"
#import "JZContext.h"
#import "JZExceptionHandler.h"
#import "JZDataHandler.h"

@implementation JZAppDelegate


- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@_jz_log.log",[JZDataHandler toYYYYMMddHHmmss:[NSDate date]]];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions __attribute__((objc_requires_super))
{
    [JZContext shareInstance].application = application;
    [JZContext shareInstance].launchOptions = launchOptions;
    [[JZModuleManager sharedManager] triggerEvent:JZInitEvent];
  
//#if DEBUG
//    [self redirectNSlogToDocumentFolder];
//#endif
    
//    [[JZExceptionHandler sharedHandler] addSensorsAnalyticsInstance:[SensorsAnalyticsSDK sharedInstance] ];
    [JZExceptionHandler sharedHandler];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[JZModuleManager sharedManager] triggerEvent:JZWillResignActiveEvent];
}

- (void)applicationDidEnterBackground:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[JZModuleManager sharedManager] triggerEvent:JZDidEnterBackgroundEvent];
}

- (void)applicationWillEnterForeground:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[JZModuleManager sharedManager] triggerEvent:JZWillEnterForegroundEvent];
}

- (void)applicationDidBecomeActive:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[JZModuleManager sharedManager] triggerEvent:JZDidBecomeActiveEvent];
}

- (void)applicationWillTerminate:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[JZModuleManager sharedManager] triggerEvent:JZWillTerminateEvent];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation __attribute__((objc_requires_super))
{
    [[JZContext shareInstance].openURLItem setOpenURL:url];
    [[JZContext shareInstance].openURLItem setSourceApplication:sourceApplication];
    [[JZModuleManager sharedManager] triggerEvent:JZOpenURLEvent];
    return YES;
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application __attribute__((objc_requires_super))
{
    [[JZModuleManager sharedManager] triggerEvent:JZDidReceiveMemoryWarningEvent];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error __attribute__((objc_requires_super))
{
    [[JZContext shareInstance].notificationsItem setNotificationsError:error];
    [[JZModuleManager sharedManager] triggerEvent:JZDidFailToRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken __attribute__((objc_requires_super))
{
    [[JZContext shareInstance].notificationsItem setDeviceToken: deviceToken];
    [[JZModuleManager sharedManager] triggerEvent:JZDidRegisterForRemoteNotificationsEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo __attribute__((objc_requires_super))
{
    [[JZContext shareInstance].notificationsItem setUserInfo: userInfo];
    [[JZModuleManager sharedManager] triggerEvent:JZDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler __attribute__((objc_requires_super))
{
    [[JZContext shareInstance].notificationsItem setUserInfo: userInfo];
    [[JZContext shareInstance].notificationsItem setNotificationResultHander: completionHandler];
    [[JZModuleManager sharedManager] triggerEvent:JZDidReceiveRemoteNotificationEvent];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification __attribute__((objc_requires_super))
{
    [[JZContext shareInstance].notificationsItem setLocalNotification: notification];
    [[JZModuleManager sharedManager] triggerEvent:JZDidReceiveLocalNotificationEvent];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80000
- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity __attribute__((objc_requires_super))
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[JZContext shareInstance].userActivityItem setUserActivity: userActivity];
        [[JZModuleManager sharedManager] triggerEvent:JZDidUpdateUserActivityEvent];
    }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error __attribute__((objc_requires_super))
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[JZContext shareInstance].userActivityItem setUserActivityType: userActivityType];
        [[JZContext shareInstance].userActivityItem setUserActivityError: error];
        [[JZModuleManager sharedManager] triggerEvent:JZDidFailToContinueUserActivityEvent];
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler __attribute__((objc_requires_super))
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[JZContext shareInstance].userActivityItem setUserActivity: userActivity];
        [[JZContext shareInstance].userActivityItem setRestorationHandler: restorationHandler];
        [[JZModuleManager sharedManager] triggerEvent:JZContinueUserActivityEvent];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType __attribute__((objc_requires_super))
{
    if([UIDevice currentDevice].systemVersion.floatValue > 8.0f){
        [[JZContext shareInstance].userActivityItem setUserActivityType: userActivityType];
        [[JZModuleManager sharedManager] triggerEvent:JZWillContinueUserActivityEvent];
    }
    return YES;
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400 

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler __attribute__((objc_requires_super))
{
    [[JZContext shareInstance].touchShortcutItem setShortcutItem: shortcutItem];
    [[JZContext shareInstance].touchShortcutItem setScompletionHandler: completionHandler];
    [[JZModuleManager sharedManager] triggerEvent:JZQuickActionEvent];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options __attribute__((objc_requires_super))
{
    [[JZContext shareInstance].openURLItem setOpenURL:url];
    [[JZContext shareInstance].openURLItem setOptions:options];
    [[JZModuleManager sharedManager] triggerEvent:JZOpenURLEvent];
    return YES;
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __attribute__((objc_requires_super)){
    [[JZContext shareInstance].notificationsItem setNotification: notification];
    [[JZContext shareInstance].notificationsItem setNotificationPresentationOptionsHandler: completionHandler];
    [[JZContext shareInstance].notificationsItem setCenter:center];
    [[JZModuleManager sharedManager] triggerEvent:JZWillPresentNotificationEvent];
};

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler __attribute__((objc_requires_super)){
    [[JZContext shareInstance].notificationsItem setNotificationResponse: response];
    [[JZContext shareInstance].notificationsItem setNotificationCompletionHandler:completionHandler];
    [[JZContext shareInstance].notificationsItem setCenter:center];
    [[JZModuleManager sharedManager] triggerEvent:JZDidReceiveNotificationResponseEvent];
};
#endif

@end

@implementation JZOpenURLItem

@end

@implementation JZShortcutItem

@end

@implementation JZUserActivityItem

@end

@implementation JZNotificationsItem

@end
