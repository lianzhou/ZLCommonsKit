//
//  ENCameraModel.m
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/10.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENCameraModel.h"
#import <AVFoundation/AVFoundation.h>

@interface ENCameraModel()

@property (nonatomic,assign,readwrite) CGFloat videoHeight; 
@property (nonatomic,assign,readwrite) CGFloat videoWidth; 

@end

@implementation ENCameraModel

- (void)setOutputSettings:(NSDictionary<NSString *,id> *)outputSettings {
    _outputSettings = outputSettings;
    
    if ([outputSettings.allKeys containsObject:AVVideoHeightKey]) {
//        if (self.isPortrait) {
            self.videoHeight = [[outputSettings objectForKey:AVVideoHeightKey] floatValue];
            self.videoWidth = [[outputSettings objectForKey:AVVideoWidthKey] floatValue];
//        }else{
//            self.videoHeight = [[outputSettings objectForKey:AVVideoWidthKey] floatValue];
//            self.videoWidth = [[outputSettings objectForKey:AVVideoHeightKey] floatValue];
//        }

    }
}

@end
