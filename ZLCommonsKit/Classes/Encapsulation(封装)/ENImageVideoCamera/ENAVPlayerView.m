//
//  ENAVPlayerView.m
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/10.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENAVPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface ENAVPlayerView ()

@property(nonatomic,strong)AVPlayer * videoPlayer;

@end
@implementation ENAVPlayerView

- (instancetype)initWithFrame:(CGRect)frame targetView:(UIView *)targetView movieURL:(NSURL *)movieURL
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建播放器层
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        playerLayer.frame = self.bounds;
        [self.layer addSublayer:playerLayer];
        if (movieURL) {
            self.movieURL = movieURL;
        }
        [targetView addSubview:self];
    }
    return self;
}
- (void)dealloc {
    [self removeObserverFromPlayerItem];
    [self stopVideoPlayer];
    self.videoPlayer = nil;
    NSLog(@"视频预览结束");
}
- (void)stopVideoPlayer{
    if (self.videoPlayer.rate == 1) {
        [self.videoPlayer pause];//如果在播放状态就停止
    }
}

- (void)setMovieURL:(NSURL *)movieURL {
    _movieURL = movieURL;
    [self removeObserverFromPlayerItem];
    [self nextPlayer];
}
- (void)nextPlayer {
    
    if (!CMTIME_IS_INDEFINITE(self.videoPlayer.currentItem.duration)) {
        [self.videoPlayer seekToTime:CMTimeMakeWithSeconds(0, self.videoPlayer.currentItem.duration.timescale)];
        NSLog(@"去播放");
        if (self.hidden) {
            NSLog(@"没有显示！！！！！！");
        }
    }else{
        NSLog(@"无效的时间");
    }
    [self.videoPlayer replaceCurrentItemWithPlayerItem:[self getPlayItem]];
    [self addObserverToPlayerItem];
    if (self.videoPlayer.rate == 0) {
        [self.videoPlayer play];
    }else {
        NSLog(@"正在播放.....");
    }
}

- (void)removeObserverFromPlayerItem{
//    AVPlayerItem *playerItem = self.videoPlayer.currentItem;
//    [playerItem removeObserver:self forKeyPath:@"status"];
//    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addObserverToPlayerItem{
//    AVPlayerItem *playerItem = self.videoPlayer.currentItem;
//    //通过监控它的status也可以获得播放状态
//    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    //监控网络加载情况属性
//    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.videoPlayer.currentItem];

}
-(AVPlayerItem *)getPlayItem {
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:self.movieURL];
    return playerItem;
}
- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver{
//    AVPlayerItem *playerItem=self.videoPlayer.currentItem;
    //这里设置每秒执行一次
//    [self.videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        float current=CMTimeGetSeconds(time);
//        float total=CMTimeGetSeconds([playerItem duration]);
       
//    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
//            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.videoPlayer.currentItem];
}
-(void)playbackFinished:(NSNotification *)notification{
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero]; 
    [self.videoPlayer play];
}
#pragma mark - 懒加载
-(AVPlayer *)videoPlayer{
    if (!_videoPlayer) {
        AVPlayerItem *playerItem=[self getPlayItem];
        _videoPlayer=[AVPlayer playerWithPlayerItem:playerItem];
        
        [self addObserverToPlayerItem];
//        [self addProgressObserver];
        [self addNotification];
    }
    return _videoPlayer;
}

@end
