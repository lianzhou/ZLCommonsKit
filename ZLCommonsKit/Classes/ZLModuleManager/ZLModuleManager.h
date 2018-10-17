//
//  ZLModuleManager.h
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZLModuleEventType)
{
    ZLSetupEvent = 0,
    ZLInitEvent,
    ZLTearDownEvent,
    ZLSplashEvent,
    ZLQuickActionEvent,
    ZLWillResignActiveEvent,
    ZLDidEnterBackgroundEvent,
    ZLWillEnterForegroundEvent,
    ZLDidBecomeActiveEvent,
    ZLWillTerminateEvent,
    ZLUnmountEvent,
    ZLOpenURLEvent,
    ZLSourceApplication,
    ZLDidReceiveMemoryWarningEvent,
    ZLDidFailToRegisterForRemoteNotificationsEvent,
    ZLDidRegisterForRemoteNotificationsEvent,
    ZLDidReceiveRemoteNotificationEvent,
    ZLDidReceiveLocalNotificationEvent,
    ZLWillPresentNotificationEvent,
    ZLDidReceiveNotificationResponseEvent,
    ZLWillContinueUserActivityEvent,
    ZLContinueUserActivityEvent,
    ZLDidFailToContinueUserActivityEvent,
    ZLDidUpdateUserActivityEvent,
    ZLDidCustomEvent = 1000
    
};
extern NSString * ZL_ModuleEventSelectors   [];

@interface ZLModuleManager : NSObject

+ (instancetype)sharedManager;
- (void)triggerEvent:(ZLModuleEventType)eventType;
- (void)handleModuleEvent:(NSString *)selectorStr protocol:(Protocol *)protocol;
@end
