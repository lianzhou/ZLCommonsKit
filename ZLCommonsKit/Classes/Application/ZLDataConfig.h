//
//  ZLDataConfig.h
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/8/22.
//
//

#import <Foundation/Foundation.h>

@interface ZLDataConfig : NSObject

+ (instancetype)shareInstance;

+ (id)get:(NSString *)key;

+ (BOOL)has:(NSString *)key;

+ (void)add:(NSDictionary *)parameters;

+ (void)remove:(NSString *)key;

+ (NSMutableDictionary *)getAll;

+ (NSString *)stringValue:(NSString *)key;

+ (NSDictionary *)dictionaryValue:(NSString *)key;

+ (NSInteger)integerValue:(NSString *)key;

+ (float)floatValue:(NSString *)key;

+ (BOOL)boolValue:(NSString *)key;

+ (NSArray *)arrayValue:(NSString *)key;

+ (void)set:(NSString *)key value:(id)value;

+ (void)set:(NSString *)key boolValue:(BOOL)value;

+ (void)set:(NSString *)key integerValue:(NSInteger)value;

+ (void)clear;


@end
