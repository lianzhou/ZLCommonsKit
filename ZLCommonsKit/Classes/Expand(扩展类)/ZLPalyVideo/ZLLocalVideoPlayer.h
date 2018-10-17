//
//  ZLLocalVideoPlayer.h
//  
//
//  Created by zhoulian on 2017/4/11.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLLocalVideoPlayer : NSObject


+ (instancetype)sharedInstance;

- (void)playWithUrl:(NSURL *)url showView:(UIView *)showView backView:(UIView *)backView size:(CGSize)videoSize;

- (void)stop;

@property (nonatomic, copy) void (^downloadSuccessBlock)();

@end
