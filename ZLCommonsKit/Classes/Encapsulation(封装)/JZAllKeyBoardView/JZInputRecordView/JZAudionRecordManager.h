//
//  JZAudionRecordManager.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZAudioRecordSettings.h"
@class JZAudionRecordManager;
@protocol JZAudionRecordManagerDelegate <NSObject>

//录音完成之后
- (void)audioManager:(JZAudionRecordManager *)manager didFinishRecord_WithRecordPath:(NSString *)recordPath withDuration:(CGFloat)duration;
//录音失败
- (void)audioManager:(JZAudionRecordManager *)manager recordFailure_withError:(NSError *)error;
//音量变化
- (void)audioManager:(JZAudionRecordManager *)manager soundMouter:(CGFloat)soundMouter;
//取消录音
- (void)audioManagerDidCancle:(JZAudionRecordManager *)manager;
//录音时间太短
- (void)audioManager:(JZAudionRecordManager *)manager didFailedTooShortDuration:(CGFloat)minRecordDuration;
//录音进度
- (void)audioManager:(JZAudionRecordManager *)manager limitDurationProgress:(CGFloat)recordProgress;


@end

@interface JZAudionRecordManager : NSObject
/**
 音量
 */
@property(nonatomic,readonly)CGFloat soundMouter;
/**
  最大录音时间限制
 */
@property(nonatomic,assign)NSTimeInterval limitMaxRecordDuration;
/**
 最小录音时间
 */
@property(nonatomic,assign)NSTimeInterval minRecordDuration;
/**
 录音设置
 */
@property(nonatomic,strong)JZAudioRecordSettings *recordSetting;

@property(nonatomic,assign)BOOL isRecording;

@property(nonatomic,weak)id<JZAudionRecordManagerDelegate>delegate;

+ (instancetype)shareInstance;
- (void)startRecord;
- (void)finishRecord;
- (void)cancelRecord;
- (NSTimeInterval)currentRecordFileDuration;
- (BOOL)checkRecordPermission;



@end
