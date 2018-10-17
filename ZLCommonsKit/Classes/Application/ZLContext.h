//
//  ZLContext.h
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//

#import <Foundation/Foundation.h>
#import "ZLAppDelegate.h"
#import "ZLDataConfig.h"
#import "ZLAppConfig.h"

@interface ZLContext : NSObject


@property(nonatomic, strong) ZLDataConfig *dataConfig;
@property(nonatomic, strong) ZLAppConfig *appConfig;

@property(nonatomic, strong) UIApplication *application;

@property(nonatomic, strong) NSDictionary *launchOptions;

//OpenURL model
@property (nonatomic, strong) ZLOpenURLItem *openURLItem;

//Notifications Remote or Local
@property (nonatomic, strong) ZLNotificationsItem *notificationsItem;

//user Activity Model
@property (nonatomic, strong) ZLUserActivityItem *userActivityItem;
//3D-Touch model
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
@property (nonatomic, strong) ZLShortcutItem *touchShortcutItem;
#endif


@property (nonatomic, strong) UIViewController * currentViewController;
+ (instancetype)shareInstance;

@end
