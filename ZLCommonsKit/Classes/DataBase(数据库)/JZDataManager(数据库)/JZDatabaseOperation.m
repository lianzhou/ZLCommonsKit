//
//  JZDatabaseOperation.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZDatabaseOperation.h"
#import "JZStringMacrocDefine.h"

@implementation JZDatabaseOperation

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString *userDBDir = @"database";

        NSString *dbDir = [self cacheDirectoryPath:userDBDir];
        BOOL isDir = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbDir isDirectory:&isDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dbDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *dbName = [NSString stringWithFormat:@"database.db"];
        
        _dbPath = [dbDir stringByAppendingPathComponent:dbName];
        
    }
    return self;
}
- (NSString *)cacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)cacheDirectoryPath:(NSString *)file
{
    if ([JZStringUitil stringIsNull:file]) {
        return nil;
    }
    return [[self cacheDirectory]stringByAppendingPathComponent:file];
}

@end
