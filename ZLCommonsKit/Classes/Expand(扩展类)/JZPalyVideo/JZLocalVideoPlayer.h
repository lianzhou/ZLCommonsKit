//
//  JZLocalVideoPlayer.h
//  e学云
//
//  Created by zhangjiang on 2017/4/11.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZLocalVideoPlayer : NSObject


+ (instancetype)sharedInstance;

- (void)playWithUrl:(NSURL *)url showView:(UIView *)showView backView:(UIView *)backView size:(CGSize)videoSize;

- (void)stop;

@property (nonatomic, copy) void (^downloadSuccessBlock)();

@end
