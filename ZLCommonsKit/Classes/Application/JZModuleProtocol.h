//
//  JZModuleProtocol.h
//  Pods
//
//  Created by zhoulian on 17/8/22.
//
//

#import <Foundation/Foundation.h>
@class JZContext;

@protocol JZModuleProtocol <NSObject>

@optional
- (void)didFinishLaunchingWithOptions:(JZContext *)context;

- (void)applicationWillResignActive:(JZContext *)context;

- (void)applicationDidEnterBackground:(JZContext *)context;

- (void)applicationWillEnterForeground:(JZContext *)context;

- (void)applicationDidBecomeActive:(JZContext *)context;

- (void)applicationWillTerminate:(JZContext *)context;

- (void)applicationSourceApplication:(JZContext *)context;

- (void)applicationDidReceiveMemoryWarning:(JZContext *)context;

- (void)applicationDidFailToRegisterForRemoteNotificationsWithError:(JZContext *)context;

- (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(JZContext *)context;

- (void)applicationDidReceiveRemoteNotificationCompletionHandler:(JZContext *)context;

- (void)applicationDidReceiveLocalNotification:(JZContext *)context;

- (void)applicationDidUpdateUserActivity:(JZContext *)context;

- (void)applicationDidFailToContinueUserActivityWithType:(JZContext *)context;

- (void)applicationContinueUserActivityRestorationHandler:(JZContext *)context;

- (void)applicationWillContinueUserActivityWithType:(JZContext *)context;

- (void)applicationPerformActionForShortcutItemCompletionHandler:(JZContext *)context;

- (void)applicationOpenURL:(JZContext *)context;

- (void)applicationUserNotificationCenterWillPresentNotification:(JZContext *)context;

- (void)applicationUserNotificationCenterDidReceiveNotificationResponse:(JZContext *)context;

@end
