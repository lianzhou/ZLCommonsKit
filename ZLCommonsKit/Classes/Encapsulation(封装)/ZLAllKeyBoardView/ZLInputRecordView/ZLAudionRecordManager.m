//
//  ZLAudionRecordManager.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//


#import "ZLAudionRecordManager.h"
#import <AVFoundation/AVFoundation.h>
#import "ZLFilePath.h"
#import "ZLFilePathMacrocDefine.h"
#import "ZLStringMacrocDefine.h"


@interface ZLAudionRecordManager ()<AVAudioRecorderDelegate>

@property(nonatomic,strong)AVAudioRecorder *audioRecorder;
@property(nonatomic,strong)NSTimer *soundMouterTimer;
@property(nonatomic,assign)NSTimeInterval recordProgress;
@property(nonatomic,copy)NSString *localSavePath;   //本地存储语音路径
@property(nonatomic,assign)CGFloat videoDuration;   //录制语音时间


@end


@implementation ZLAudionRecordManager

+ (instancetype)shareInstance
{
    static ZLAudionRecordManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ZLAudionRecordManager alloc]init];
    });
    return _manager;
}


#pragma mark -初始化设置

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.limitMaxRecordDuration = 0;    //默认无时间限制
        self.minRecordDuration = 1;
    }
    return self;
}

//创建录音对象
- (void)createRecord
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&err];
    if (err) {
        NSLog(@"GJCFAudioRecord audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    //防止快速重复录音
    if (self.audioRecorder.isRecording) {
        NSError *faildError = [NSError errorWithDomain:@"gjcf.AudioManager.com" code:-236 userInfo:@{@"msg": @"GJCFAuidoRecord 正在录音"}];
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:recordFailure_withError:)]) {
            [self.delegate audioManager:self recordFailure_withError:faildError];
        }
        return;
    }
    if (!self.recordSetting) {
        self.recordSetting = [ZLAudioRecordSettings defaultQualitySetting];
    }
    if (self.localSavePath) {
        self.localSavePath = nil;
    }
    if (self.videoDuration) {
        self.videoDuration = 0.0;
    }
    //置空timer
    if (self.soundMouterTimer) {
        [self.soundMouterTimer invalidate];
        self.soundMouterTimer = nil;
    }
    //设置新的录音文件的存储路径
    self.localSavePath = [self createLocalSaveRecordFilePath];
    //开始新的录音实例
    if (self.audioRecorder) {
        if (self.audioRecorder.isRecording) {
            [self.audioRecorder stop];
            [self.audioRecorder deleteRecording];
        }
        self.audioRecorder = nil;
    }
    if (!self.localSavePath) {
        NSLog(@"语音缓存路径是空的");
    }
    NSError *createRecordError = nil;
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:self.localSavePath] settings:self.recordSetting.settingDict error:&createRecordError];
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    if (createRecordError) {
        NSLog(@"创建录音Recorder错误:%@",createRecordError);
        [self startRecordErrorDetail];
        return;
    }
    [self.audioRecorder prepareToRecord];
    
    //创建输入音量更新
    self.soundMouterTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateSoundMouter:) userInfo:nil repeats:YES];
    [self.soundMouterTimer fire];

}



#pragma mark - 录音错误处理
- (void)startRecordErrorDetail
{
    NSError *faildError = [NSError errorWithDomain:@"gjcf.AudioManager.com" code:-238 userInfo:@{@"msg": @"GJCFAuidoRecord启动录音失败"}];
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:recordFailure_withError:)]) {
        [self.delegate audioManager:self recordFailure_withError:faildError];
    }
    
    /* 停止更新 */
    if (self.soundMouterTimer) {
        [self.soundMouterTimer invalidate];
        self.soundMouterTimer = nil;
    }
}
//开始录音
- (void)startRecord
{
    
    [self createRecord];
    if (self.limitMaxRecordDuration >0) {
        _isRecording = [self.audioRecorder recordForDuration:self.limitMaxRecordDuration];
        if (_isRecording) {
            NSLog(@"GJCFAudioRecord Limit start....");
        }else{
            [self startRecordErrorDetail];
        }
        return;
    }
    _isRecording = [self.audioRecorder record];
    if (_isRecording) {
        NSLog(@"GJCFAudioRecord Limit start....");

    }else{
        [self startRecordErrorDetail];
    }

}
//完成录音
- (void)finishRecord
{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
        _isRecording = NO;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:&err];
    [audioSession setActive:NO error:&err];
}
//取消录音
- (void)cancelRecord
{
    if (!self.audioRecorder) {
        return;
    }
    if (!_isRecording) {
        return;
    }
    [self.audioRecorder stop];
    [self.audioRecorder deleteRecording];
    _isRecording = NO;
    self.localSavePath = nil;
    self.videoDuration = 0.0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioManagerDidCancle:)]) {
        [self.delegate audioManagerDidCancle:self];
    }
}

- (NSTimeInterval)currentRecordFileDuration
{
    return self.videoDuration;
}

#pragma mark -音量变化
- (void)updateSoundMouter:(NSTimer *)timer
{
    [self.audioRecorder updateMeters];
    float soundLoudly = [self.audioRecorder peakPowerForChannel:0];
    _soundMouter = pow(10, (0.05 * soundLoudly));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:soundMouter:)]) {
        [self.delegate audioManager:self soundMouter:_soundMouter];
    }
    
    self.videoDuration = self.audioRecorder.currentTime;
    /* 限制录音时间观察进度 */
    if (self.limitMaxRecordDuration > 0) {
        
        self.recordProgress = self.audioRecorder.currentTime;
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:limitDurationProgress:)]) {
            [self.delegate audioManager:self limitDurationProgress:self.recordProgress];
        }

        if (self.audioRecorder.currentTime >= self.limitMaxRecordDuration) {
            
            NSLog(@"时间 Limit %f",self.limitMaxRecordDuration);
            
            [self finishRecord];
            return;
        }
    }

}





#pragma mark -判断麦克风权限
- (BOOL)checkRecordPermission
{
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if (avSession && [avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        __block BOOL isPermission;
        
        [avSession requestRecordPermission:^(BOOL granted) {
            
            if (!granted) {
                
                NSLog(@"去设置允许麦克风权限");
                
            }
            
            isPermission = granted;
            
        }];
        
        return isPermission;
    }
    
    return YES;
}


#pragma mark -本地存储录音路径
- (NSString *)createLocalSaveRecordFilePath
{
    NSString *cacheDirectory = [ZLFilePath documentDirectoryPath:ZLFilePathMainAudioCacheFile];
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4",ZLStringCurrentTimeStamp];
    NSString *localFilePath = [cacheDirectory stringByAppendingPathComponent:fileName];

    NSLog(@"本次语音路径:%@",localFilePath);
    if (![ZLFilePath fileExist:cacheDirectory]) {
        
        [[ZLFilePath fileManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return localFilePath;
}

- (void)dealloc
{
    if (self.soundMouterTimer) {
        [self.soundMouterTimer invalidate];
    }
}



#pragma mark -AVAudioRecorderDelegate
//完成录音
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (self.soundMouterTimer) {
        [self.soundMouterTimer invalidate];
        self.soundMouterTimer = nil;
    }
    if (flag) {
        //如果录音时间小于最小要求时间
        if (self.recordProgress < self.minRecordDuration) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:didFailedTooShortDuration:)]) {
                [self.delegate audioManager:self didFailedTooShortDuration:self.minRecordDuration];
                _isRecording = NO;
            }
            return;
        }
        //正常完成录制
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:didFinishRecord_WithRecordPath:withDuration:)]) {
            _isRecording = NO;
            if (self.localSavePath && self.videoDuration != 0.0) {
               [self.delegate audioManager:self didFinishRecord_WithRecordPath:self.localSavePath withDuration:self.videoDuration];
                
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(audioManagerDidCancle:)]) {
                    [self.delegate audioManagerDidCancle:self];
                }
            }
           
        }
       
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:recordFailure_withError:)]) {
        _isRecording = NO;
        [self.delegate audioManager:self recordFailure_withError:error];
    }
    
}

@end
