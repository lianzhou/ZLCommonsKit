//
//  JZDataConfig.m
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//


#import "JZDataConfig.h"
#import "JZStringMacrocDefine.h"

@interface JZDataConfig ()
@property(nonatomic, strong) NSMutableDictionary *config;

@end

@implementation JZDataConfig
+ (instancetype)shareInstance
{
    static dispatch_once_t once_t;
    static id JZDataConfigInstance = nil;
    dispatch_once(&once_t, ^{
        JZDataConfigInstance = [[self alloc] init];
    });
    return JZDataConfigInstance;
}
+ (NSString *)stringValue:(NSString *)key
{
    if (![JZDataConfig shareInstance].config) {
        return nil;
    }
    if (JZStringIsNull(key)) {
        return nil;
    }
    return (NSString *)[[JZDataConfig shareInstance].config objectForKey:key];
}

+ (NSDictionary *)dictionaryValue:(NSString *)key
{
    if (![JZDataConfig shareInstance].config) {
        return nil;
    }
    if (JZStringIsNull(key)) {
        return nil;
    }
    if (![[[JZDataConfig shareInstance].config objectForKey:key] isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return (NSDictionary *)[[JZDataConfig shareInstance].config objectForKey:key];
}

+ (NSArray *)arrayValue:(NSString *)key
{
    if (![JZDataConfig shareInstance].config) {
        return nil;
    }
    if (JZStringIsNull(key)) {
        return nil;
    }
    if (![[[JZDataConfig shareInstance].config objectForKey:key] isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return (NSArray *)[[JZDataConfig shareInstance].config objectForKey:key];
}

+ (NSInteger)integerValue:(NSString *)key
{
    if (![JZDataConfig shareInstance].config) {
        return 0;
    }
    if (JZStringIsNull(key)) {
        return 0;
    }
    return [[[JZDataConfig shareInstance].config objectForKey:key] integerValue];
}

+ (float)floatValue:(NSString *)key
{
    if (![JZDataConfig shareInstance].config) {
        return 0.0;
    }
    if (JZStringIsNull(key)) {
        return 0.0;
    }
    return [(NSNumber *)[[JZDataConfig shareInstance].config objectForKey:key] floatValue];
}

+ (BOOL)boolValue:(NSString *)key
{
    if (![JZDataConfig shareInstance].config) {
        return NO;
    }
    if (JZStringIsNull(key)) {
        return NO;
    }
    return [(NSNumber *)[[JZDataConfig shareInstance].config objectForKey:key] boolValue];
}
+ (id)get:(NSString *)key
{
    if (![JZDataConfig shareInstance].config) {
        @throw [NSException exceptionWithName:@"ConfigNotInitialize" reason:@"config not initialize" userInfo:nil];
        
        return nil;
    }
    if (JZStringIsNull(key)) {
        return nil;
    }
    id v = [[JZDataConfig shareInstance].config objectForKey:key];
    if (!v) {
        NSLog(@"key为%@ 的object是空值",key);
    }
    return v;
}

+ (BOOL)has:(NSString *)key
{
    if (![JZDataConfig shareInstance].config) {
        return NO;
    }
    if (JZStringIsNull(key)) {
        return NO;
    }
    if (![[JZDataConfig shareInstance].config objectForKey:key]) {
        return NO;
    }
    return YES;
}
+ (void)remove:(NSString *)key {
    
    if (![JZDataConfig shareInstance].config) {
        return;
    }
    if (JZStringIsNull(key)) {
        return ;
    }
    if ([[JZDataConfig shareInstance].config objectForKey:key]) {
        [[JZDataConfig shareInstance].config removeObjectForKey:JZIFISNULL(key)];
    }
    return ;
}
+ (void)set:(NSString *)key value:(id)value
{
    if (![JZDataConfig shareInstance].config) {
        [JZDataConfig shareInstance].config = [@{} mutableCopy];
    }
    if (JZStringIsNull(key)) {
        return;
    }
    if (!value) {
        return;
    }
    [[JZDataConfig shareInstance].config setObject:value forKey:key];
}
+ (void)set:(NSString *)key boolValue:(BOOL)value
{
    if (JZStringIsNull(key)) {
        return;
    }
    [self set:key value:[NSNumber numberWithBool:value]];
}

+ (void)set:(NSString *)key integerValue:(NSInteger)value
{
    if (JZStringIsNull(key)) {
        return;
    }
    [self set:key value:[NSNumber numberWithInteger:value]];
}


+ (void)add:(NSDictionary *)parameters
{
    if (![JZDataConfig shareInstance].config) {
        [JZDataConfig shareInstance].config = [@{} mutableCopy];
    }
    if (parameters.count > 0) {
        return;
    }
    [[JZDataConfig shareInstance].config addEntriesFromDictionary:parameters];
}

+ (NSDictionary *) getAll
{
    return [JZDataConfig shareInstance].config;
}

+ (void)clear
{
    if ([JZDataConfig shareInstance].config) {
        [[JZDataConfig shareInstance].config removeAllObjects];
    }
}
- (NSMutableDictionary *)config {
    
    if (!_config) {
        _config = [NSMutableDictionary dictionary];
    }
    return _config;
}
@end
