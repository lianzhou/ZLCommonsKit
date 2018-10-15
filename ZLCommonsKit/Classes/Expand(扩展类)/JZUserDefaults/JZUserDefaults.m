//
//  JZUserDefaults.m
//  JZCommonsKit
//
//  Created by admin on 2017/12/19.
//

#import "JZUserDefaults.h"
#import "JZStringMacrocDefine.h"
#import "JZAppConfig.h"

@implementation JZUserDefaults

+ (instancetype)shareInstance
{
    static dispatch_once_t once_t;
    static id userDefaults = nil;
    dispatch_once(&once_t, ^{
        userDefaults = [[self alloc] init];
    });
    return userDefaults;
}

+ (NSDictionary *)dictionaryRepresentation{
    return [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName{
    [[JZUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[JZUserDefaults standardUserDefaults] synchronize];
}
+ (nullable id)objectForKey:(NSString *)defaultName{
   return [[JZUserDefaults standardUserDefaults] objectForKey:defaultName];
}
+ (nullable id)objectOnlyForKey:(NSString *)defaultName{
    
//    if (JZStringIsNull([JZUserDefaults shareInstance].notiKey)) {
        [JZUserDefaults shareInstance].notiKey = [JZAppConfig shareInstance].apiConfigItem.userId;
//    }
    return [[JZUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",[JZUserDefaults shareInstance].notiKey,defaultName]];
}
+ (void)setObject:(id)value forOnlyKey:(NSString *)defaultName{
    
//    if (JZStringIsNull([JZUserDefaults shareInstance].notiKey)) {
        [JZUserDefaults shareInstance].notiKey = [JZAppConfig shareInstance].apiConfigItem.userId;
//    }
    [[JZUserDefaults standardUserDefaults] setObject:value forKey:[NSString stringWithFormat:@"%@_%@",[JZUserDefaults shareInstance].notiKey,defaultName]];
    [[JZUserDefaults standardUserDefaults] synchronize];
}




+ (NSUserDefaults *)standardUserDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

@end
