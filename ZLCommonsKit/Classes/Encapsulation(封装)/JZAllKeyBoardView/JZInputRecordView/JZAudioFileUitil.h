//
//  JZAudioFileUitil.h
//  Chat富文本
//
//  Created by juziwl on 16/3/23.
//  Copyright © 2016年 李长恩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZAudioModel.h"

@interface JZAudioFileUitil : NSObject
/* 设置本地缓存路径 */
+ (void)setupAudioFileLocalStorePath:(JZAudioModel*)audioFile;

/*设置本地缓存路径--和聊天不同不需要时间戳*/
+ (void)setupAudioFileLocalStorePathNoTime:(JZAudioModel*)audioFile;

/*创建一个临时转码文件的缓存地址----和聊天不同不需要时间戳*/
+ (void)setupAudioFileTempEncodeFilePathNoTime:(JZAudioModel*)audioFile;

/* 设置一个临时转编码文件的缓存地址 */
+ (void)setupAudioFileTempEncodeFilePath:(JZAudioModel*)audioFile;

/* 直接将一个文件的临时编码文件复制到本地缓存文件路径 */
+ (BOOL)saveAudioTempEncodeFileToLocalCacheDir:(JZAudioModel*)audioFile;

/* 远程地址和本地wav文件建立关系 */
+ (BOOL)createRemoteUrl:(NSString*)remoteUrl relationWithLocalWavPath:(NSString*)localWavPath;

/* 删掉一个对应关系 */
+ (BOOL)deleteShipForRemoteUrl:(NSString *)remoteUrl;

/* 检测本地有没有对应的wav文件，避免重复下载 */
+ (NSString *)localWavPathForRemoteUrl:(NSString *)remoteUrl;

/* 删除临时转码文件 */
+ (BOOL)deleteTempEncodeFileWithPath:(NSString *)tempEncodeFilePath;

/* 删除对应地址的Wav文件 */
+ (BOOL)deleteWavFileByUrl:(NSString *)remoteUrl;

/* 将音频文件转为AMR格式，会为其创建AMR编码的临时文件 */
+ (BOOL)convertAudioFileToAMR:(JZAudioModel *)audioFile;
/* 将音频文件转为WAV格式 */
+ (BOOL)convertAudioFileToWAV:(JZAudioModel *)audioFile;

/* 创建一条新的录音文件存储路径 */
+ (NSString*)createAudioNewRecordLocalStorePath;


///**
// * 根据远程路径创建Wav格式本地路径
// */
//+ (void)createUserWAVStatisticsPathFolderWith:(JZAudioModel *)audioModel;
///**
// * 根据远程路径创建amr格式本地路径
// */
//+ (void)createUserAMRStatisticsPathFolderWith:(JZAudioModel *)audioModel;
@end
