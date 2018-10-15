//
//  JZContext.h
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//

#import <Foundation/Foundation.h>
#import "JZAppDelegate.h"
#import "JZDataConfig.h"
#import "JZAppConfig.h"

@interface JZContext : NSObject


@property(nonatomic, strong) JZDataConfig *dataConfig;
@property(nonatomic, strong) JZAppConfig *appConfig;

@property(nonatomic, strong) UIApplication *application;

@property(nonatomic, strong) NSDictionary *launchOptions;

//OpenURL model
@property (nonatomic, strong) JZOpenURLItem *openURLItem;

//Notifications Remote or Local
@property (nonatomic, strong) JZNotificationsItem *notificationsItem;

//user Activity Model
@property (nonatomic, strong) JZUserActivityItem *userActivityItem;
//3D-Touch model
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
@property (nonatomic, strong) JZShortcutItem *touchShortcutItem;
#endif


@property (nonatomic, strong) UIViewController * currentViewController;
+ (instancetype)shareInstance;

@end
