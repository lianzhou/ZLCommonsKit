//
//  ZLAudioRecordSettings.m
//  Chat富文本
//
//  Created by zhoulian on 16/3/23.
//  Copyright © 2016年 zhoulian. All rights reserved.
//

#import "ZLAudioRecordSettings.h"
#import <AVFoundation/AVFoundation.h>

@implementation ZLAudioRecordSettings
- (id)initWithSampleRate:(CGFloat)rate
             withFormate:(NSInteger)formateID
            withBitDepth:(NSInteger)bitDepth
            withChannels:(NSInteger)channels
            withPCMIsBig:(BOOL)isBig
          withPCMIsFloat:(BOOL)isFloat
             withQuality:(NSInteger)quality
{
    if (self = [super init]) {
        
        self.sampleRate = rate;
        self.Formate = formateID;
        self.LinearPCMBitDepth = bitDepth;
        self.numberOfChnnels = channels;
        self.LinearPCMIsBigEndian = isBig;
        self.LinearPCMIsFloat = isFloat;
        self.EncoderAudioQuality = quality;
    }
    return self;
}


+ (ZLAudioRecordSettings *)defaultQualitySetting
{
    ZLAudioRecordSettings *settings = [[self alloc]initWithSampleRate:8000.0f withFormate:kAudioFormatMPEG4AAC withBitDepth:16 withChannels:1 withPCMIsBig:NO withPCMIsFloat:NO withQuality:AVAudioQualityMedium];
    
    return settings;
}

+ (ZLAudioRecordSettings *)lowQualitySetting
{
    ZLAudioRecordSettings *settings = [[self alloc]initWithSampleRate:8000.0f withFormate:kAudioFormatLinearPCM withBitDepth:16 withChannels:1 withPCMIsBig:NO withPCMIsFloat:NO withQuality:AVAudioQualityLow];
    
    return settings;
}

+ (ZLAudioRecordSettings *)highQualitySetting
{
    ZLAudioRecordSettings *settings = [[self alloc]initWithSampleRate:8000.0f withFormate:kAudioFormatLinearPCM withBitDepth:16 withChannels:1 withPCMIsBig:NO withPCMIsFloat:NO withQuality:AVAudioQualityHigh];
    
    return settings;
}

+ (ZLAudioRecordSettings *)MaxQualitySetting
{
    ZLAudioRecordSettings *settings = [[self alloc]initWithSampleRate:8000.0f withFormate:kAudioFormatLinearPCM withBitDepth:16 withChannels:1 withPCMIsBig:NO withPCMIsFloat:NO withQuality:AVAudioQualityMax];
    
    return settings;
}

- (NSDictionary *)settingDict
{
    NSDictionary *aSettingDict = @{
                                   AVSampleRateKey: @(self.sampleRate),
                                   AVFormatIDKey:@(self.Formate),
                                   AVLinearPCMBitDepthKey:@(self.LinearPCMBitDepth),
                                   AVNumberOfChannelsKey:@(self.numberOfChnnels),
                                   AVLinearPCMIsBigEndianKey:@(self.LinearPCMIsBigEndian),
                                   AVLinearPCMIsFloatKey:@(self.LinearPCMIsFloat),
                                   AVEncoderAudioQualityKey:@(self.EncoderAudioQuality)
                                   
                                   };
    
    return aSettingDict;
}

@end
