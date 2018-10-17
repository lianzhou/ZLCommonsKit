//
//  ZLModuleProtocol.h
//  Pods
//
//  Created by zhoulian on 17/8/22.
//
//

#import <Foundation/Foundation.h>
@class ZLContext;

@protocol ZLModuleProtocol <NSObject>

@optional
- (void)didFinishLaunchingWithOptions:(ZLContext *)context;

- (void)applicationWillResignActive:(ZLContext *)context;

- (void)applicationDidEnterBackground:(ZLContext *)context;

- (void)applicationWillEnterForeground:(ZLContext *)context;

- (void)applicationDidBecomeActive:(ZLContext *)context;

- (void)applicationWillTerminate:(ZLContext *)context;

- (void)applicationSourceApplication:(ZLContext *)context;

- (void)applicationDidReceiveMemoryWarning:(ZLContext *)context;

- (void)applicationDidFailToRegisterForRemoteNotificationsWithError:(ZLContext *)context;

- (void)applicationDidRegisterForRemoteNotificationsWithDeviceToken:(ZLContext *)context;

- (void)applicationDidReceiveRemoteNotificationCompletionHandler:(ZLContext *)context;

- (void)applicationDidReceiveLocalNotification:(ZLContext *)context;

- (void)applicationDidUpdateUserActivity:(ZLContext *)context;

- (void)applicationDidFailToContinueUserActivityWithType:(ZLContext *)context;

- (void)applicationContinueUserActivityRestorationHandler:(ZLContext *)context;

- (void)applicationWillContinueUserActivityWithType:(ZLContext *)context;

- (void)applicationPerformActionForShortcutItemCompletionHandler:(ZLContext *)context;

- (void)applicationOpenURL:(ZLContext *)context;

- (void)applicationUserNotificationCenterWillPresentNotification:(ZLContext *)context;

- (void)applicationUserNotificationCenterDidReceiveNotificationResponse:(ZLContext *)context;

@end
