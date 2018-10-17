//
//  ZLUserDefaults.h
//  ZLCommonsKit
//
//  Created by admin on 2017/12/19.
//

#import <Foundation/Foundation.h>

@interface ZLUserDefaults : NSObject

+ (instancetype)shareInstance;

//标识的key，一般为uid
@property(nonatomic,copy)NSString * notiKey;

+ (NSDictionary *)dictionaryRepresentation;

+ (void)setObject:(id)value forKey:(NSString *)defaultName;
//唯一的值,自动拼接
+ (void)setObject:(id)value forOnlyKey:(NSString *)defaultName;

+ (id)objectForKey:(NSString *)defaultName;

+ (id)objectOnlyForKey:(NSString *)defaultName;

@end
