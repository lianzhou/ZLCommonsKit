//
//  ENAVPlayerView.h
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/10.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ENAVPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame targetView:(UIView *)targetView movieURL:(NSURL *)movieURL;

@property (nonatomic, strong) NSURL *movieURL;

- (void)stopVideoPlayer;

@end
