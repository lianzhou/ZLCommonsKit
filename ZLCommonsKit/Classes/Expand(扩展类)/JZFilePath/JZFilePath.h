//
//  JZFilePath.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! @brief *
 *  沙盒路径类型
 */
typedef NS_ENUM(NSUInteger, JZLocalFilePathType) {
    JZLocalFilePathTypeDocument,
    JZLocalFilePathTypeLibrary,
    JZLocalFilePathTypeTemporary,
    JZLocalFilePathTypePreference,
    JZLocalFilePathTypeCaches,
};

@interface JZFilePath : NSObject

#pragma mark -- 存储plist文件
+ (NSUserDefaults *)standDefault;
+ (void)userDefaultCache:(id<NSCoding>)value key:(id)key;
+ (id<NSCoding>)userDefauleValueForKey:(id)key;

#pragma mark -- 获取系统缓存
+ (NSCache *)shareCache;
+ (void)systemMemoryCacheSet:(id<NSCoding>)value key:(id)key;
+ (void)systemMemoryCacheRemove:(id)key;
+ (id)systemMemoryCacheGetValue:(id)key;

#pragma mark -- 沙盒路径
/*! @brief *
 *  获取Documents目录路径
 */
+ (NSString *)getDocumentPath;
/*! @brief *
 *  获取Library目录路径
 */
+ (NSString *)getLibraryPath;
/*! @brief *
 *  获取Tmp目录路径
 */
+ (NSString *)getTemporaryPath;
/*! @brief *
 *  获取Cache目录路径
 */
+ (NSString *)getCachePath;
/*! @brief *
 *  获取Preference目录路径
 */
+ (NSString *)getPerferencePath;
/*! @brief *
 *  返回文件名为filePath在NSDocumentDirectory中的路径
 */
+ (NSString *)documentDirectoryPath:(NSString *)filePath;
/*! @brief *
 *  返回文件名为filePath在NSLibraryDirectory中的路径
 */
+ (NSString *)libraryDirectoryPath:(NSString *)filePath;
/*! @brief *
 *  返回文件名为filePath在NSTemporaryDirectory中的路径
 */
+ (NSString *)temporaryDirectoryPath:(NSString *)filePath;
/*! @brief *
 *  返回文件名为filePath在NSCachesDirectory中的路径
 */
+ (NSString *)cachesDirectoryPath:(NSString *)filePath;
/*! @brief *
 *  返回文件名为filePath在NSPreferencePanesDirectory中的路径
 */
+ (NSString *)PreferenceDirectoryPath:(NSString *)filePath;
/*! @brief *
 *  创建文件,如果是多级的,则会创建相对应的文件夹
 */
+ (NSString *)creatPathWithFilePath:(NSString *)filePath type:(JZLocalFilePathType)type;
/*! @brief *
 *  获取多级文件路径
 */
+ (NSString *)getPathWithFilePath:(NSString *)filePath type:(JZLocalFilePathType)type;

#pragma mark -- 文件管理类
+ (NSFileManager *)fileManager;
+ (BOOL)fileExist:(NSString*)path;
/*! @brief *
 *  删除文件
 */
+ (void)removeDocumentDirectoryPath:(NSString *)filePath;
/*! @brief *
 *  拷贝文件
 */
+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath isRemoveOld:(BOOL)isRemove;
/*! @brief *
 *  获取文件属性
 */
-(NSDictionary *)getFileAttriutesWithFilePath:(NSString *)filePath;
/*! @brief *
 *  计算文件夹,文件大小
 */
+ (unsigned long long)directoryFileSizeWithPath:(NSString *)filePath;


#pragma mark - 写入和读取
+ (BOOL)writeData:(NSData *)data  toPath:(NSString *)filePath type:(JZLocalFilePathType)type;
+ (NSData *)readDataFromPath:(NSString *)filePath type:(JZLocalFilePathType)type;

#pragma mark - 路径- 语音
+ (NSString *)mainAudioCacheDirectory;
+ (NSString *)mainAudioCacheRemoteDirectory;
#pragma mark -聊天图片路径
+ (NSString *)mainIMImageCacheDirectory;
//视频缓存路径
+ (NSString *)mainVideoCacheRemoteDirectory;
#pragma mark -课件路径
+ (NSString *)mainCourseFileCacheDirectory;
@end
