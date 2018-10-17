//
//  ZLAudioFileUitil.m
//  Chat富文本
//
//  Created by juziwl on 16/3/23.
//  Copyright © 2016年 李长恩. All rights reserved.
//

#import "ZLFilePath.h"
#import "ZLAudioFileUitil.h"
#import "ZLStringMacrocDefine.h"
#import "ZLDataHandler.h"

/* 主缓存目录 */
static NSString *  ZLAudioFileCacheDirectory = @"ZLAudioFileCacheDirectory";

/* 保存转换编码后的音频文件 */
static NSString *  ZLAudioFileCacheSubTempEncodeFileDirectory = @"ZLAudioFileCacheSubTempEncodeFileDirectory";

/* 本地音频Wav文件和远程地址关系表 */
static NSString *  ZLAudioFileRemoteLocalWavFileShipList = @"ZLAudioFileRemoteLocalWavFileShipList.plist";
@implementation ZLAudioFileUitil


#pragma mark - 创建缓存主目录

+ (NSString *)cacheDirectory
{
    /* 创建一个默认路径 */
    NSString *cacheDirectory = [ZLFilePath creatPathWithFilePath:@"ZLFilePathMainAudioCacheDirectory" type:ZLLocalFilePathTypeDocument];
    /* 创建一个存储临时转编码文件的子文件夹 */
    NSString *subTempFileDir = [cacheDirectory stringByAppendingPathComponent:ZLAudioFileCacheSubTempEncodeFileDirectory];
    
    if (![ZLFilePath fileExist:subTempFileDir]) {
        [ZLFilePath creatPathWithFilePath:subTempFileDir type:ZLLocalFilePathTypeDocument];
    }

    
    return cacheDirectory;
}

#pragma mark - 公开方法


/* 创建一条新的录音文件存储路径 */
+ (NSString*)createAudioNewRecordLocalStorePath
{
    NSString *fileName = [NSString stringWithFormat:@"%@.wav",ZLStringCurrentTimeStamp];
    
    return [[self cacheDirectory]stringByAppendingPathComponent:fileName];
}

+ (void)setupAudioFileLocalStorePath:(ZLAudioModel*)audioFile
{
    if (!audioFile) {
        return;
    }
    
    NSString *fileName = nil;
    if ([audioFile.cacheFileName hasSuffix:audioFile.extensionName]) {
        fileName = audioFile.cacheFileName;
    }else{
        fileName = [NSString stringWithFormat:@"%@.%@",audioFile.cacheFileName,audioFile.extensionName];
    }
    
    audioFile.fileName = fileName;
    
    NSString *randomPath = [[self cacheDirectory]stringByAppendingPathComponent:fileName];
    
    audioFile.localStorePath = randomPath;
    
    
//    NSString *string=[NSString stringWithFormat:@"count.caf"];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//获得存储路径，
//    NSString *documentDirectory = [paths objectAtIndex:0];//获得路径的第0个元素
//    NSString *fullPath = [documentDirectory stringByAppendingPathComponent:string];//在第0个元素中添加txt文本
//    audioFile.localStorePath = fullPath;
}

/* 设置一个临时转编码文件的缓存地址 */
+ (void)setupAudioFileTempEncodeFilePath:(ZLAudioModel*)audioFile
{
    if (!audioFile) {
        return;
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",audioFile.cacheFileName,audioFile.tempEncodeFileExtensionName];
    
    audioFile.tempEncodeFileName = fileName;
    
    NSString *tempFilePath = [[[self cacheDirectory]stringByAppendingPathComponent:ZLAudioFileCacheSubTempEncodeFileDirectory]stringByAppendingPathComponent:fileName];
    
    audioFile.tempEncodeFilePath = tempFilePath;
    
}

/* 直接将一个文件的临时编码文件复制到本地缓存文件路径 */
+ (BOOL)saveAudioTempEncodeFileToLocalCacheDir:(ZLAudioModel*)audioFile
{
    if (!audioFile) {
        return NO;
    }
    
    if (!audioFile.tempEncodeFilePath) {
        return NO;
    }
    
    /* 如果没有本地缓存路径，那么创建一个 */
    if (!audioFile.localStorePath) {
        [ZLAudioFileUitil setupAudioFileLocalStorePath:audioFile];
    }
    
   return  [ZLFilePath copyFileFromPath:audioFile.tempEncodeFilePath toPath:audioFile.localStorePath isRemoveOld:audioFile.isDeleteWhileFinishConvertToLocalFormate];
}

/* 远程地址和本地wav文件建立关系 */
+ (BOOL)createRemoteUrl:(NSString*)remoteUrl relationWithLocalWavPath:(NSString*)localWavPath
{
    NSString *shipListFilePath = [[self cacheDirectory]stringByAppendingPathComponent:ZLAudioFileRemoteLocalWavFileShipList];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:shipListFilePath]) {
        
        NSMutableDictionary *shipList = [NSMutableDictionary dictionary];
        [shipList setObject:localWavPath forKey:remoteUrl];
        
        NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:shipList];
        
        return [archieveData writeToFile:shipListFilePath atomically:YES];
    }
    
    NSData *listData = [NSData dataWithContentsOfFile:shipListFilePath];
    NSMutableDictionary *shipListDict = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    
    [shipListDict setObject:localWavPath forKey:remoteUrl];
    
    NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:shipListDict];
    
    return [archieveData writeToFile:shipListFilePath atomically:YES];
}

/* 删掉一个对应关系 */
+ (BOOL)deleteShipForRemoteUrl:(NSString *)remoteUrl
{
    NSString *shipListFilePath = [[self cacheDirectory]stringByAppendingPathComponent:ZLAudioFileRemoteLocalWavFileShipList];
    
    /* 如果关系plist都不存在，那么肯定没有关系了 */
    if (![[NSFileManager defaultManager]fileExistsAtPath:shipListFilePath]) {
        
        return YES;
    }
    
    NSData *listData = [NSData dataWithContentsOfFile:shipListFilePath];
    NSMutableDictionary *shipListDict = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    
    [shipListDict removeObjectForKey:remoteUrl];
    
    NSData *archieveData = [NSKeyedArchiver archivedDataWithRootObject:shipListDict];
    
    return [archieveData writeToFile:shipListFilePath atomically:YES];
}

/* 检测本地有没有对应的wav文件，避免重复下载 */
+ (NSString *)localWavPathForRemoteUrl:(NSString *)remoteUrl
{
    NSString *shipListFilePath = [[self cacheDirectory]stringByAppendingPathComponent:ZLAudioFileRemoteLocalWavFileShipList];
    if (!shipListFilePath) {
        
        return nil;
    }
    
    NSData *listData = [NSData dataWithContentsOfFile:shipListFilePath];
    NSMutableDictionary *shipListDict = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    
    return [shipListDict objectForKey:remoteUrl];
}

/* 删除临时转码文件 */
+ (BOOL)deleteTempEncodeFileWithPath:(NSString *)tempEncodeFilePath
{
    if (!tempEncodeFilePath || [tempEncodeFilePath isEqualToString:@""]) {
        return YES;
    }
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:tempEncodeFilePath]) {
        return YES;
    }
    
    NSError *deleteError = nil;
    [[NSFileManager defaultManager] removeItemAtPath:tempEncodeFilePath error:&deleteError];
    
    if (deleteError) {
        
        NSLog(@"ZLFileUitil 删除文件失败:%@",deleteError);
        
        return NO;
        
    }else{
        
        NSLog(@"ZLFileUitil 删除文件成功:%@",tempEncodeFilePath);
        return YES;
    }
}

/* 删除对应地址的Wav文件 */
+ (BOOL)deleteWavFileByUrl:(NSString *)remoteUrl
{
    if (!remoteUrl) {
        return YES;
    }
    
    /* 获取对应的wav地址 */
    NSString *wavPath = [ZLAudioFileUitil localWavPathForRemoteUrl:remoteUrl];
    
    if (!wavPath) {
        return YES;
    }
    
    /* 删除文件 */
    BOOL deleteFileResult = [self deleteTempEncodeFileWithPath:wavPath];
    
    if (deleteFileResult) {
        
        /* 删掉本地对应关系 */
        [self deleteShipForRemoteUrl:remoteUrl];
        
        return YES;
        
    }else{
        
        return YES;
    }
    
}


/* 将音频文件转为AMR格式，会为其创建AMR编码的临时文件 */
+ (BOOL)convertAudioFileToAMR:(ZLAudioModel *)audioFile
{
    /* 如果没有WAV的缓存路径，那么是不能转的 */
    if (!audioFile.localStorePath) {
        
        NSLog(@"ZLEncodeAndDecode 错误:没有可转码的本地Wav文件路径");
        
        return NO;
    }
    
    /* 设置一个amr临时编码文件的路径 */
    if (!audioFile.tempEncodeFilePath) {
        
        [ZLAudioFileUitil setupAudioFileTempEncodeFilePath:audioFile];
        
    }
    
    if (!audioFile.tempEncodeFilePath) {
        
        NSLog(@"ZLEncodeAndDecode 错误:没有可以保存转码音频文件的路径");
        
        return NO;
    }
    
    /* 开始转换 */
//    int result = [VoiceConverter wavToAmr:audioFile.localStorePath amrSavePath:audioFile.tempEncodeFilePath];
    int result =1;
    if (result) {
        
        NSLog(@"ZLEncodeAndDecode wavToAmr 成功:%@",audioFile.tempEncodeFilePath);
        
    }else{
        
        NSLog(@"ZLEncodeAndDecode wavToAmr 失败:%@",audioFile.tempEncodeFilePath);
        
    }
    
    return result;
}

/* 将音频文件转为WAV格式 */
+ (BOOL)convertAudioFileToWAV:(ZLAudioModel *)audioFile
{
    /* 如果没有临时编码文件的缓存路径，那么是不能转的 */
    if (!audioFile.tempEncodeFilePath) {
        
        NSLog(@"ZLEncodeAndDecode 错误:没有可以用来转码的临时音频文件");
        
        return NO;
    }
    
    /* 设置一个需要转成Wav存储的路径 */
    if (!audioFile.localStorePath) {
        
        [ZLAudioFileUitil setupAudioFileLocalStorePath:audioFile];
        
    }
    
    if (!audioFile.localStorePath) {
        
        NSLog(@"ZLEncodeAndDecode 错误:没有可以用来保存本地Wav文件的路径");
        
        return NO;
    }
    
    /* 开始转换 */
//    int result = [VoiceConverter amrToWav:audioFile.tempEncodeFilePath wavSavePath:audioFile.localStorePath];
    int result =1;

    if (result) {
        
        
        NSLog(@"ZLEncodeAndDecode amrToWav 转码成功:%@",audioFile.localStorePath);
        
        /* 如果设置了转码完成之后将临时编码文件删除 */
        if (audioFile.isDeleteWhileFinishConvertToLocalFormate) {
            
            NSError *removeTempError = nil;
            [[NSFileManager defaultManager] removeItemAtPath:audioFile.tempEncodeFilePath error:&removeTempError];
            
            if (removeTempError) {
                
                NSLog(@"删除临时转码文件失败");
                
                return YES;
                
            }else{
                
                NSLog(@"删除临时转码文件成功");
                
                return YES;
            }
            
        }
        
        return YES;
        
    }else{
        
        NSLog(@"ZLEncodeAndDecode amrToWav faild");
        
        return NO;
        
    }
    
    
    
    
    
    return result;
}


@end
