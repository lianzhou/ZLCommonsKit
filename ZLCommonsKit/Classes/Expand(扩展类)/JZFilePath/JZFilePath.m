//
//  JZFilePath.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "JZFilePath.h"
#import "JZSystemMacrocDefine.h"
#import "JZStringMacrocDefine.h"
#import "JZCollectionUtils.h"
#import "JZAppConfig.h"


@implementation JZFilePath


#pragma mark -- 存储plist文件
+ (NSUserDefaults *)standDefault
{
    return [NSUserDefaults standardUserDefaults];
    
}
+ (void)userDefaultCache:(id<NSCoding>)value key:(id)key
{
    if (JZCheckKeyValueHasNull(key, value)) {
        return;
    }
    [[JZFilePath standDefault] setObject:value forKey:key];
}
+ (id<NSCoding>)userDefauleValueForKey:(id)key
{
    if (JZCheckObjectNull(key)) {
        return nil;
    }
    return [[JZFilePath standDefault] valueForKey:key];
}


#pragma mark -- 获取系统缓存
+ (NSCache *)shareCache
{
    static NSCache *_NSCacheInstance = nil;
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_NSCacheInstance) {
            _NSCacheInstance = [[NSCache alloc]init];
        }
    });
    return _NSCacheInstance;
}
+ (void)systemMemoryCacheSet:(id<NSCoding>)value key:(id)key
{
    if (JZCheckKeyValueHasNull(value, key)) {
        return;
    }
    [[JZFilePath shareCache]setObject:value forKey:key];
}

+ (void)systemMemoryCacheRemove:(id)key
{
    if (JZCheckObjectNull(key)) {
        return;
    }
    [[JZFilePath shareCache]removeObjectForKey:key];
}

+ (id)systemMemoryCacheGetValue:(id)key
{
    if (JZCheckObjectNull(key)) {
        return nil;
    }
    return [[JZFilePath shareCache]objectForKey:key];
}

+ (BOOL)systemMemoryCacheEmptyValue:(id)key
{
    if (JZCheckObjectNull(key)) {
        return NO;
    }
    return [JZFilePath systemMemoryCacheGetValue:key] == nil;
}


#pragma mark -- 沙盒路径
/*! @brief *
 *  获取Documents目录路径
 */
+ (NSString *)getDocumentPath
{
    //在根目录下找Documents目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path lastObject];
    return documentDirectory;

}
/*! @brief *
 *  获取Library目录路径
 */
+ (NSString *)getLibraryPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *librayDirectory = [path lastObject];
    return librayDirectory;
}
/*! @brief *
 *  获取Tmp目录路径
 */
+ (NSString *)getTemporaryPath
{
    return  NSTemporaryDirectory();
}
/*! @brief *
 *  获取Cache目录路径
 */
+ (NSString *)getCachePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [path lastObject];
    return cachePath;
}
/*! @brief *
 *  获取Preference目录路径
 */
+ (NSString *)getPerferencePath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSUserDomainMask, YES);
    NSString *preferencePath = [path lastObject];
    return preferencePath;
}
/*! @brief *
 *  返回文件名为filePath在NSDocumentDirectory中的路径
 */
+ (NSString *)documentDirectoryPath:(NSString *)filePath
{
    if (JZStringIsNull(filePath)) {
        return nil;
    }
    return [[self getDocumentPath] stringByAppendingPathComponent:filePath];
}
/*! @brief *
 *  返回文件名为filePath在NSLibraryDirectory中的路径
 */
+ (NSString *)libraryDirectoryPath:(NSString *)filePath
{
    if (JZStringIsNull(filePath)) {
        return nil;
    }
    return [[self getLibraryPath] stringByAppendingPathComponent:filePath];
}
/*! @brief *
 *  返回文件名为filePath在NSTemporaryDirectory中的路径
 */
+ (NSString *)temporaryDirectoryPath:(NSString *)filePath
{
    if (JZStringIsNull(filePath)) {
        return nil;
    }
    return [[self getTemporaryPath] stringByAppendingPathComponent:filePath];
}
/*! @brief *
 *  返回文件名为filePath在NSCachesDirectory中的路径
 */
+ (NSString *)cachesDirectoryPath:(NSString *)filePath
{
    if (JZStringIsNull(filePath)) {
        return nil;
    }
    return [[self getCachePath] stringByAppendingPathComponent:filePath];
}
/*! @brief *
 *  返回文件名为filePath在NSPreferencePanesDirectory中的路径
 */
+ (NSString *)PreferenceDirectoryPath:(NSString *)filePath
{
    if (JZStringIsNull(filePath)) {
        return nil;
    }
    return [[self getPerferencePath] stringByAppendingPathComponent:filePath];
}
/*! @brief *
 *  创建文件,如果是多级的,则会创建相对应的文件夹
 */
+ (NSString *)creatPathWithFilePath:(NSString *)filePath type:(JZLocalFilePathType)type
{
    if (JZStringIsNull(filePath)) {
        return nil;
    }
    NSFileManager *fileManager = [JZFilePath fileManager];
    
    NSString *rootPath;
    switch (type) {
        case JZLocalFilePathTypeDocument:
        {
            rootPath = [self getDocumentPath];
        }
            break;
        case JZLocalFilePathTypeLibrary:
        {
            rootPath = [self getLibraryPath];
        }
            break;
        case JZLocalFilePathTypeTemporary:
        {
            rootPath = [self getTemporaryPath];
        }
            break;
        case JZLocalFilePathTypePreference:
        {
            rootPath = [self getPerferencePath];
        }
            break;
        case JZLocalFilePathTypeCaches:
        {
            rootPath = [self getCachePath];
        }
            break;
        default:
            break;
    }
    

    NSString *realFileDirect;
    if ([filePath hasPrefix:rootPath]) {
        realFileDirect = filePath;
    }else{
        realFileDirect = [rootPath stringByAppendingPathComponent:filePath];
    }
    if (![JZFilePath fileExist:realFileDirect]) {
        
        [fileManager createDirectoryAtPath:realFileDirect withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return realFileDirect;
}
/*! @brief *
 *  获取文件路径
 */
+ (NSString *)getPathWithFilePath:(NSString *)filePath type:(JZLocalFilePathType)type {
    
    if (JZStringIsNull(filePath)) {
        return nil;
    }
    NSString *rootPath;
    switch (type) {
        case JZLocalFilePathTypeDocument:
        {
            rootPath = [self getDocumentPath];
        }
            break;
        case JZLocalFilePathTypeLibrary:
        {
            rootPath = [self getLibraryPath];
        }
            break;
        case JZLocalFilePathTypeTemporary:
        {
            rootPath = [self getTemporaryPath];
        }
            break;
        case JZLocalFilePathTypePreference:
        {
            rootPath = [self getPerferencePath];
        }
            break;
        case JZLocalFilePathTypeCaches:
        {
            rootPath = [self getCachePath];
        }
            break;
        default:
            break;
    }

    NSString  *pathString = [NSString stringWithFormat:@"%@%@",rootPath,filePath];
    return pathString;
    
}

#pragma mark -- 文件管理类
+ (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}
+ (BOOL)fileExist:(NSString*)path
{
    if (JZStringIsNull(path)) {
        return NO;
    }
    return [[JZFilePath fileManager] fileExistsAtPath:path];
}
/*! @brief *
 *  删除文件
 */
+ (void)removeDocumentDirectoryPath:(NSString *)filePath
{
    if ([self fileExist:filePath]) {
        NSError * error;
        [[JZFilePath fileManager] removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
}
/*! @brief *
 *  拷贝文件
 */
+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath isRemoveOld:(BOOL)isRemove
{
    if (JZStringIsNull(fromPath) || JZStringIsNull(toPath) ) {
        return NO;
    }
    if (![self fileExist:fromPath]) {
        return NO;
    }
    
    
    BOOL isExist = [[self fileManager] fileExistsAtPath:toPath];
    if (isExist) {
        //先删除原来的再拷贝
        [[self fileManager] removeItemAtPath:toPath error:nil];
    }

    BOOL copyResult = [[self fileManager] copyItemAtPath:fromPath toPath:toPath error:nil];
    if (copyResult) {
        
        if (isRemove) {
            return [[self fileManager] removeItemAtPath:fromPath error:nil];
        }
        return YES;
        
    }else{
        return NO;
    }
}
/*! @brief *
 *  获取文件属性
 */
-(NSDictionary *)getFileAttriutesWithFilePath:(NSString *)filePath
{
    
    NSDictionary *fileAttributes = [[JZFilePath fileManager] attributesOfItemAtPath:filePath error:nil];
    return fileAttributes;
}
/*! @brief *
 *  计算文件夹,文件大小
 */
+ (unsigned long long)directoryFileSizeWithPath:(NSString *)filePath
{
    
    unsigned long long size = 0;

    // 是否为文件夹
    BOOL isDirectory = NO;
    
    // 路径是否存在
    BOOL exists = [[JZFilePath fileManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!exists) return size;
    
    if (isDirectory) {//文件夹
        NSDirectoryEnumerator *enumerator = [[JZFilePath fileManager] enumeratorAtPath:filePath];
        for (NSString *subpath in enumerator) {

            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            
            size += [[JZFilePath fileManager] attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
    } else { // 文件
        size = [[JZFilePath fileManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    
    return size;
}

#pragma mark - 写入和读取
+ (BOOL)writeData:(NSData *)data  toPath:(NSString *)filePath type:(JZLocalFilePathType)type
{
    if (JZStringIsNull(filePath)) {
        return NO;
    }
    
    NSString  *pathString = [self getPathWithFilePath:filePath type:type];
    BOOL success = [data writeToFile:pathString atomically:YES];
    return success;
}
+ (NSData *)readDataFromPath:(NSString *)filePath type:(JZLocalFilePathType)type {
    
    if (JZStringIsNull(filePath)) {
        return nil;
    }
    
    NSString  *pathString = [self getPathWithFilePath:filePath type:type];
    NSData *data = [[NSData alloc] initWithContentsOfFile:pathString];
    return data;
}

#pragma mark ------IM--------
#pragma mark - 路径- 语音
+ (NSString *)mainAudioCacheDirectory {
 
    NSString *filePath = [JZFilePath documentDirectoryPath:@"JZFilePathMainAudioCacheDirectory"];
    if (![JZFilePath fileExist:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
}

+ (NSString *)mainVideoCacheRemoteDirectory {
    NSString *filePath = [JZFilePath documentDirectoryPath:@"JZFilePathMainVideoCacheRemoteDirectory"];
    if (![JZFilePath fileExist:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
    
}
+ (NSString *)mainAudioCacheRemoteDirectory {
    NSString *filePath = [JZFilePath documentDirectoryPath:@"JZFilePathMainAudioCacheRemoteDirectory"];
    if (![JZFilePath fileExist:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
    
}


+ (NSString *)mainIMImageCacheDirectory {
    NSString *filePath = [JZFilePath temporaryDirectoryPath:@"JZFilePathMainImageCacheDirectory"];

    if (![JZFilePath fileExist:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}
#pragma mark -课件路径
+ (NSString *)mainCourseFileCacheDirectory {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *directoryPath = [NSString stringWithFormat:@"%@/JZFilePathMainCourseFileCacheDirectory",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    
    if (![fileManager fileExistsAtPath:directoryPath]) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *userId = [JZAppConfig shareInstance].apiConfigItem.userId;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",JZIFISNULL(directoryPath),JZIFISNULL(userId)];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

@end
