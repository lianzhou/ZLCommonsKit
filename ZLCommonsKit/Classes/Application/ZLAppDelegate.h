//
//  ZLAppDelegate.h
//  Pods
//
//  Created by zhoulian on 17/8/22.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


_Pragma("clang diagnostic push")
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

@interface ZLAppDelegate : UIResponder<UIApplicationDelegate>


@end

typedef void (^ZLNotificationResultHandler)(UIBackgroundFetchResult);

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
typedef void (^ZLNotificationPresentationOptionsHandler)(UNNotificationPresentationOptions options);
typedef void (^ZLNotificationCompletionHandler)(void);
#endif

@interface ZLNotificationsItem : NSObject

@property (nonatomic, strong) NSError *notificationsError;
@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, weak) ZLNotificationResultHandler notificationResultHander;
@property (nonatomic, strong) UILocalNotification *localNotification;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@property (nonatomic, strong) UNNotification *notification;
@property (nonatomic, strong) UNNotificationResponse *notificationResponse;
@property (nonatomic, weak) ZLNotificationPresentationOptionsHandler notificationPresentationOptionsHandler;
@property (nonatomic, weak) ZLNotificationCompletionHandler notificationCompletionHandler;
@property (nonatomic, strong) UNUserNotificationCenter *center;
#endif

@end

@interface ZLOpenURLItem : NSObject

@property (nonatomic, strong) NSURL *openURL;
@property (nonatomic, strong) NSString *sourceApplication;
@property (nonatomic, strong) NSDictionary *options;

@end

typedef void (^shortcutItemCompletionHandler)(BOOL);

@interface ZLShortcutItem : NSObject

#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
@property(nonatomic, strong) UIApplicationShortcutItem *shortcutItem;
@property(nonatomic, copy) shortcutItemCompletionHandler scompletionHandler;
#endif

@end


typedef void (^restorationHandler)(NSArray *);

@interface ZLUserActivityItem : NSObject

@property (nonatomic, strong) NSString *userActivityType;
@property (nonatomic, strong) NSUserActivity *userActivity;
@property (nonatomic, strong) NSError *userActivityError;
@property (nonatomic, strong) restorationHandler restorationHandler;

_Pragma("clang diagnostic pop")

@end


