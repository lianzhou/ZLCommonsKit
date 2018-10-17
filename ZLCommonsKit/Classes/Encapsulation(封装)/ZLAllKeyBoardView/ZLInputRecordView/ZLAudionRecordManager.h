//
//  ZLAudionRecordManager.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLAudioRecordSettings.h"
@class ZLAudionRecordManager;
@protocol ZLAudionRecordManagerDelegate <NSObject>

//录音完成之后
- (void)audioManager:(ZLAudionRecordManager *)manager didFinishRecord_WithRecordPath:(NSString *)recordPath withDuration:(CGFloat)duration;
//录音失败
- (void)audioManager:(ZLAudionRecordManager *)manager recordFailure_withError:(NSError *)error;
//音量变化
- (void)audioManager:(ZLAudionRecordManager *)manager soundMouter:(CGFloat)soundMouter;
//取消录音
- (void)audioManagerDidCancle:(ZLAudionRecordManager *)manager;
//录音时间太短
- (void)audioManager:(ZLAudionRecordManager *)manager didFailedTooShortDuration:(CGFloat)minRecordDuration;
//录音进度
- (void)audioManager:(ZLAudionRecordManager *)manager limitDurationProgress:(CGFloat)recordProgress;


@end

@interface ZLAudionRecordManager : NSObject
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
@property(nonatomic,strong)ZLAudioRecordSettings *recordSetting;

@property(nonatomic,assign)BOOL isRecording;

@property(nonatomic,weak)id<ZLAudionRecordManagerDelegate>delegate;

+ (instancetype)shareInstance;
- (void)startRecord;
- (void)finishRecord;
- (void)cancelRecord;
- (NSTimeInterval)currentRecordFileDuration;
- (BOOL)checkRecordPermission;



@end
