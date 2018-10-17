//
//  ZLAudioModel.m
//  Chat富文本
//
//  Created by juziwl on 16/3/23.
//  Copyright © 2016年 李长恩. All rights reserved.
//

#import "ZLAudioModel.h"
#import "ZLAudioFileUitil.h"
#import "ZLDataHandler.h"
#import "ZLStringMacrocDefine.h"

@implementation ZLAudioModel
- (id)init
{
    if (self = [super init]) {
        
        self.isUploadTempEncodeFile = YES;
        self.isNeedConvertEncodeToSave = YES;
        self.isDeleteWhileFinishConvertToLocalFormate = YES;
        self.shouldPlayWhileFinishDownload = NO;
        
        _uniqueIdentifier = [ZLDataHandler currentTimeString];
        
        /* 设定默认文件后缀 */
        self.extensionName = @"mp4";
        self.tempEncodeFileExtensionName = @"amr";
        
        self.mimeType = @"audio/amr";
    }
    return self;
}


/* 删除临时编码文件 */
- (void)deleteTempEncodeFile
{
    if (self.tempEncodeFilePath && ![self.localStorePath isEqualToString:@""]) {
        
        [ZLAudioFileUitil deleteTempEncodeFileWithPath:self.tempEncodeFilePath];
    }
}

- (NSString *)cacheFileName
{

    if (ZLStringIsNull(self.remotePath)) {
        return [ZLDataHandler currentTimeString];
    }else{
        return [self.remotePath stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    }
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"文件Wav路径:%@ 远程路径:%@ 临时转码文件路径:%@",self.localStorePath,self.remotePath,self.tempEncodeFilePath];
}

/* 删除本地wav格式文件 */
- (void)deleteWavFile
{
    if (self.localStorePath && ![self.localStorePath isEqualToString:@""]) {
        
        [ZLAudioFileUitil deleteTempEncodeFileWithPath:self.localStorePath];
        
        /* 将远程路径和本地wav文件的关系也删掉 */
        if (self.remotePath) {
            
            [ZLAudioFileUitil deleteShipForRemoteUrl:self.remotePath];
        }
    }
}
/**
 *  转成int 类型的
 */
+ (int)audioDurationFromInt:(NSTimeInterval)duration{
    
    int audioDuration = [[NSNumber numberWithDouble:ceil(duration)] intValue];
    
    return audioDuration>60?60:audioDuration;
}

@end
