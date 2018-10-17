//
//  ZLDataConfig.m
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//


#import "ZLDataConfig.h"
#import "ZLStringMacrocDefine.h"

@interface ZLDataConfig ()
@property(nonatomic, strong) NSMutableDictionary *config;

@end

@implementation ZLDataConfig
+ (instancetype)shareInstance
{
    static dispatch_once_t once_t;
    static id ZLDataConfigInstance = nil;
    dispatch_once(&once_t, ^{
        ZLDataConfigInstance = [[self alloc] init];
    });
    return ZLDataConfigInstance;
}
+ (NSString *)stringValue:(NSString *)key
{
    if (![ZLDataConfig shareInstance].config) {
        return nil;
    }
    if (ZLStringIsNull(key)) {
        return nil;
    }
    return (NSString *)[[ZLDataConfig shareInstance].config objectForKey:key];
}

+ (NSDictionary *)dictionaryValue:(NSString *)key
{
    if (![ZLDataConfig shareInstance].config) {
        return nil;
    }
    if (ZLStringIsNull(key)) {
        return nil;
    }
    if (![[[ZLDataConfig shareInstance].config objectForKey:key] isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return (NSDictionary *)[[ZLDataConfig shareInstance].config objectForKey:key];
}

+ (NSArray *)arrayValue:(NSString *)key
{
    if (![ZLDataConfig shareInstance].config) {
        return nil;
    }
    if (ZLStringIsNull(key)) {
        return nil;
    }
    if (![[[ZLDataConfig shareInstance].config objectForKey:key] isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return (NSArray *)[[ZLDataConfig shareInstance].config objectForKey:key];
}

+ (NSInteger)integerValue:(NSString *)key
{
    if (![ZLDataConfig shareInstance].config) {
        return 0;
    }
    if (ZLStringIsNull(key)) {
        return 0;
    }
    return [[[ZLDataConfig shareInstance].config objectForKey:key] integerValue];
}

+ (float)floatValue:(NSString *)key
{
    if (![ZLDataConfig shareInstance].config) {
        return 0.0;
    }
    if (ZLStringIsNull(key)) {
        return 0.0;
    }
    return [(NSNumber *)[[ZLDataConfig shareInstance].config objectForKey:key] floatValue];
}

+ (BOOL)boolValue:(NSString *)key
{
    if (![ZLDataConfig shareInstance].config) {
        return NO;
    }
    if (ZLStringIsNull(key)) {
        return NO;
    }
    return [(NSNumber *)[[ZLDataConfig shareInstance].config objectForKey:key] boolValue];
}
+ (id)get:(NSString *)key
{
    if (![ZLDataConfig shareInstance].config) {
        @throw [NSException exceptionWithName:@"ConfigNotInitialize" reason:@"config not initialize" userInfo:nil];
        
        return nil;
    }
    if (ZLStringIsNull(key)) {
        return nil;
    }
    id v = [[ZLDataConfig shareInstance].config objectForKey:key];
    if (!v) {
        NSLog(@"key为%@ 的object是空值",key);
    }
    return v;
}

+ (BOOL)has:(NSString *)key
{
    if (![ZLDataConfig shareInstance].config) {
        return NO;
    }
    if (ZLStringIsNull(key)) {
        return NO;
    }
    if (![[ZLDataConfig shareInstance].config objectForKey:key]) {
        return NO;
    }
    return YES;
}
+ (void)remove:(NSString *)key {
    
    if (![ZLDataConfig shareInstance].config) {
        return;
    }
    if (ZLStringIsNull(key)) {
        return ;
    }
    if ([[ZLDataConfig shareInstance].config objectForKey:key]) {
        [[ZLDataConfig shareInstance].config removeObjectForKey:ZLIFISNULL(key)];
    }
    return ;
}
+ (void)set:(NSString *)key value:(id)value
{
    if (![ZLDataConfig shareInstance].config) {
        [ZLDataConfig shareInstance].config = [@{} mutableCopy];
    }
    if (ZLStringIsNull(key)) {
        return;
    }
    if (!value) {
        return;
    }
    [[ZLDataConfig shareInstance].config setObject:value forKey:key];
}
+ (void)set:(NSString *)key boolValue:(BOOL)value
{
    if (ZLStringIsNull(key)) {
        return;
    }
    [self set:key value:[NSNumber numberWithBool:value]];
}

+ (void)set:(NSString *)key integerValue:(NSInteger)value
{
    if (ZLStringIsNull(key)) {
        return;
    }
    [self set:key value:[NSNumber numberWithInteger:value]];
}


+ (void)add:(NSDictionary *)parameters
{
    if (![ZLDataConfig shareInstance].config) {
        [ZLDataConfig shareInstance].config = [@{} mutableCopy];
    }
    if (parameters.count > 0) {
        return;
    }
    [[ZLDataConfig shareInstance].config addEntriesFromDictionary:parameters];
}

+ (NSDictionary *) getAll
{
    return [ZLDataConfig shareInstance].config;
}

+ (void)clear
{
    if ([ZLDataConfig shareInstance].config) {
        [[ZLDataConfig shareInstance].config removeAllObjects];
    }
}
- (NSMutableDictionary *)config {
    
    if (!_config) {
        _config = [NSMutableDictionary dictionary];
    }
    return _config;
}
@end
