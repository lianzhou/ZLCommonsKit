//
//  ZLUserDefaults.m
//  ZLCommonsKit
//
//  Created by admin on 2017/12/19.
//

#import "ZLUserDefaults.h"
#import "ZLStringMacrocDefine.h"
#import "ZLAppConfig.h"

@implementation ZLUserDefaults

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
    [[ZLUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[ZLUserDefaults standardUserDefaults] synchronize];
}
+ (nullable id)objectForKey:(NSString *)defaultName{
   return [[ZLUserDefaults standardUserDefaults] objectForKey:defaultName];
}
+ (nullable id)objectOnlyForKey:(NSString *)defaultName{
    
//    if (ZLStringIsNull([ZLUserDefaults shareInstance].notiKey)) {
        [ZLUserDefaults shareInstance].notiKey = [ZLAppConfig shareInstance].apiConfigItem.userId;
//    }
    return [[ZLUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",[ZLUserDefaults shareInstance].notiKey,defaultName]];
}
+ (void)setObject:(id)value forOnlyKey:(NSString *)defaultName{
    
//    if (ZLStringIsNull([ZLUserDefaults shareInstance].notiKey)) {
        [ZLUserDefaults shareInstance].notiKey = [ZLAppConfig shareInstance].apiConfigItem.userId;
//    }
    [[ZLUserDefaults standardUserDefaults] setObject:value forKey:[NSString stringWithFormat:@"%@_%@",[ZLUserDefaults shareInstance].notiKey,defaultName]];
    [[ZLUserDefaults standardUserDefaults] synchronize];
}




+ (NSUserDefaults *)standardUserDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

@end
