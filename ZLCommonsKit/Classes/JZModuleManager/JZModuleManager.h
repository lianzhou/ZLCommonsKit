//
//  JZModuleManager.h
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JZModuleEventType)
{
    JZSetupEvent = 0,
    JZInitEvent,
    JZTearDownEvent,
    JZSplashEvent,
    JZQuickActionEvent,
    JZWillResignActiveEvent,
    JZDidEnterBackgroundEvent,
    JZWillEnterForegroundEvent,
    JZDidBecomeActiveEvent,
    JZWillTerminateEvent,
    JZUnmountEvent,
    JZOpenURLEvent,
    JZSourceApplication,
    JZDidReceiveMemoryWarningEvent,
    JZDidFailToRegisterForRemoteNotificationsEvent,
    JZDidRegisterForRemoteNotificationsEvent,
    JZDidReceiveRemoteNotificationEvent,
    JZDidReceiveLocalNotificationEvent,
    JZWillPresentNotificationEvent,
    JZDidReceiveNotificationResponseEvent,
    JZWillContinueUserActivityEvent,
    JZContinueUserActivityEvent,
    JZDidFailToContinueUserActivityEvent,
    JZDidUpdateUserActivityEvent,
    JZDidCustomEvent = 1000
    
};
extern NSString * JZ_ModuleEventSelectors   [];

@interface JZModuleManager : NSObject

+ (instancetype)sharedManager;
- (void)triggerEvent:(JZModuleEventType)eventType;
- (void)handleModuleEvent:(NSString *)selectorStr protocol:(Protocol *)protocol;
@end
