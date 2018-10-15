//
//  JZContext.m
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//


#import "JZContext.h"

@interface JZContext ()

@end

@implementation JZContext

+ (instancetype)shareInstance
{
    static dispatch_once_t once_t;
    static id JZContextInstance = nil;
    dispatch_once(&once_t, ^{
        JZContextInstance = [[[self class] alloc] init];
        if ([JZContextInstance isKindOfClass:[JZContext class]]) {
            ((JZContext *) JZContextInstance).dataConfig = [JZDataConfig shareInstance];
            ((JZContext *) JZContextInstance).appConfig = [JZAppConfig shareInstance];
        }
    });
    return JZContextInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.openURLItem = [[JZOpenURLItem alloc] init];
        self.notificationsItem = [[JZNotificationsItem alloc] init];
        self.userActivityItem = [[JZUserActivityItem alloc]init];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 80400
        self.touchShortcutItem = [[JZShortcutItem alloc]init];
#endif
    }
    
    return self;
}

@end
