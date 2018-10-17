//
//  ZLLocalVideoPlayer.m
//  
//
//  Created by zhoulian on 2017/4/11.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLLocalVideoPlayer.h"
#import "ZLAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZLSystemMacrocDefine.h"
#import "ZLContext.h"
#import "ALActionSheetView.h"
#import "ZLAlertHUD.h"

#define TRANSFORM_TIME   0.35

@interface ZLLocalVideoPlayer ()<NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>

//视频播放
@property (nonatomic, strong) AVPlayer       *player;
@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
@property (nonatomic, strong) AVPlayerLayer  *currentPlayerLayer;


//解决播放闪屏问题
@property (nonatomic,strong)  AVPlayer          *player1;
@property (nonatomic, strong) AVPlayerItem      *playerItem1;
@property (nonatomic, strong) AVPlayerLayer     *playerLayer1;


@property (nonatomic, weak)   UIView         *showView;

@property (nonatomic, weak)   UIView         *backView;

@property (nonatomic, copy  ) NSString       *videoUrlString;

@property (nonatomic,assign)CGSize          videoSize;

@property (nonatomic, strong) CAShapeLayer    *processLayer;//进度条

@property (nonatomic,strong) NSURLSessionDownloadTask *task;


@property (nonatomic, strong) NSURLSession     *session;

@property (nonatomic, copy) NSURL           *pathUrl;

@end


@implementation ZLLocalVideoPlayer

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id _sInstance;
    dispatch_once(&onceToken, ^{
        _sInstance = [[self alloc] init];
    });
    
    return _sInstance;
}

- (void)releasePlayerLayer
{
    if (!self.currentPlayerItem) {
        return;
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [self.processLayer removeFromSuperlayer];
    [self.currentPlayerLayer removeFromSuperlayer];
    [self.playerLayer1 removeFromSuperlayer];
    self.currentPlayerItem = nil;
    self.player = nil;
    self.currentPlayerLayer = nil;
    self.processLayer = nil;
    self.showView = nil;
    
    self.playerItem1 = nil;
    self.player1 = nil;
    self.playerLayer1 = nil;
    
    //关闭下载
    if (self.session) {
        [self.session invalidateAndCancel];
    }
    [self setSession:nil];
    self.task = nil;
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)stop
{
    [self.task suspend];
    [self.task suspend];
    [self.task cancel];
    [self.task cancel];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.processLayer removeFromSuperlayer];
    [self.player pause];
    [self.player1 pause];
    [self releasePlayerLayer];

}
- (void)playWithUrl:(NSURL *)url showView:(UIView *)showView backView:(UIView *)backView size:(CGSize)videoSize
{
    
    [self.task suspend];
    [self.task suspend];
    [self.task cancel];
    [self.task cancel];
    
    _backView = backView;
    _showView = showView;
    _videoUrlString = [url absoluteString];
    _videoSize = videoSize;
    _pathUrl = url;
    
   
    if ([url.absoluteString hasPrefix:@"http"] || [url.absoluteString hasPrefix:@"https"]) {
        
        //下载
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        _task = [_session downloadTaskWithURL:url];
        [_task resume];
        
        
        //进度条
        _processLayer = [[CAShapeLayer alloc] init];
        _processLayer.backgroundColor = [UIColor cyanColor].CGColor;
        _processLayer.lineWidth = 2;
        _processLayer.strokeColor = [UIColor whiteColor].CGColor;
        _processLayer.fillColor = [UIColor clearColor].CGColor;
        
        [backView.layer addSublayer:_processLayer];
        
    } else {  //如果是ios  < 7 或者是本地资源，直接播放
        
        [self videoStartPlay:url];
    }
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [backView addGestureRecognizer:longPressGesture];
    
}

#pragma mark -- 视频播放
- (void)videoStartPlay:(NSURL *)url {
    
    [self.player pause];
//    [self releasePlayerLayer];
    
    _currentPlayerItem = [AVPlayerItem playerItemWithURL:url];
    
    _player = [AVPlayer playerWithPlayerItem:_currentPlayerItem];
    _currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    // 设置画面缩放模式
    _currentPlayerLayer.videoGravity = AVLayerVideoGravityResize;
    _currentPlayerLayer.frame = CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height) ;
    _currentPlayerLayer.backgroundColor = [UIColor clearColor].CGColor;
    _showView.layer.masksToBounds = YES;
    [_showView.layer addSublayer:self.currentPlayerLayer];
    
    _videoSize = CGSizeMake(_showView.frame.size.width, _showView.frame.size.height);
    
    // 开始播放
    [_player play];
    
    
    //删除按钮
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    [self transformVideoPlayView:orientation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //删除按钮
        UIView *deleteBtn = [_backView viewWithTag:953];
        
        if (UIDeviceOrientationIsLandscape(orientation)) {
            deleteBtn.frame = CGRectMake(SCREEN_HEIGHT-70, 15, 55, 30);
            deleteBtn.layer.frame = CGRectMake(SCREEN_HEIGHT-70, 15, 55, 30);
        } else {
            deleteBtn.frame = CGRectMake(SCREEN_WIDTH-70, 15, 55, 30);
            deleteBtn.layer.frame = CGRectMake(SCREEN_WIDTH-70, 15, 55, 30);
        }
    });
    //通过通知监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerItem];
    
}

#pragma mark -- NSURLSessionDeleate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
    NSString *movePath =  [[ZLFilePath mainVideoCacheRemoteDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[_videoUrlString md5String]]];

  
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:movePath] error:nil];
    
    if (self.downloadSuccessBlock) {
        self.downloadSuccessBlock();
    }
    
    UIViewController *controller = [ZLContext shareInstance].currentViewController;
    if ([controller isKindOfClass:[ZLAVPlayerViewController class]]) {
        //开启播放
        [_processLayer removeFromSuperlayer];
        if ([[NSFileManager defaultManager] fileExistsAtPath:movePath]) {
            [self videoStartPlay:[NSURL fileURLWithPath:movePath]];
        } else {
            [self videoStartPlay:[NSURL URLWithString:self.videoUrlString]];
        }
    }
    
}

//下载进度代理
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //bytesWritten本次得到的数据大小
    //totalBytesWritten从开始下载到现在已经得到的数据大小。
    //totalBytesExpectedToWrite本次下载文件的总大小。
    float process = (float)totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"---进度条---%f",floor(process*100) / 100);
    
    
    //    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    //    if (UIDeviceOrientationIsLandscape(orientation)) {
    //         _processLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_HEIGHT/2, SCREEN_WIDTH/2) radius:21 startAngle:-(M_PI_2) endAngle:(3*M_PI_2)*process clockwise:true] CGPath];
    //    } else {
    _processLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) radius:21 startAngle:-(M_PI_2) endAngle:(3*M_PI_2)*process clockwise:true] CGPath];
    //    }
    
}

-(void) longPress: (UILongPressGestureRecognizer *) gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        ALActionSheetView *sheetView=[[ALActionSheetView alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"保存视频"] handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex) {
            if (buttonIndex == 0)
            {
                NSString *movePath = nil;
                if ([_videoUrlString hasPrefix:@"http"] || [_videoUrlString hasPrefix:@"https"]) {
                    movePath =  [[ZLFilePath mainVideoCacheRemoteDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[_videoUrlString md5String]]];
                } else {
                    movePath =  _videoUrlString;
                }
                NSString * moveDownPath = [NSURL URLWithString:movePath].path;
                if ([[NSFileManager defaultManager] fileExistsAtPath:moveDownPath]) {
                    [self saveToPhotosAlbum:moveDownPath];
                }
            }
        }];
        [sheetView show];
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        
    }
    else {
        
    }
}
#pragma mark -- 视频保存
-(void)saveToPhotosAlbum:(NSString *)path
{
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
        
        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}
// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [ZLAlertHUD showTipTitle:[NSString stringWithFormat:@"保存失败:%@",error.localizedDescription]];
    }else{
        [ZLAlertHUD showTipTitle:@"保存成功"];
    }
    
}

- (void)appDidEnterBackground
{
    UIViewController *controller = [ZLContext shareInstance].currentViewController;
    if ([controller isKindOfClass:[ZLAVPlayerViewController class]]) {
        if (!self.currentPlayerItem) {
            return;
        }
        [self.player pause];
        [self.player1 pause];
        
    }
    
}
- (void)appDidEnterPlayGround
{
    UIViewController *controller = [ZLContext shareInstance].currentViewController;
    if ([controller isKindOfClass:[ZLAVPlayerViewController class]]) {
        if (!self.currentPlayerItem) {
            return;
        }
        [self.player play];
        [self.player1 play];
        
    }
}

- (void)playerItemDidPlayToEnd:(NSNotification *)notification
{
    UIViewController *controller = [ZLContext shareInstance].currentViewController;
    if ([controller isKindOfClass:[ZLAVPlayerViewController class]]) {
        //循环播放
        
        WEAKSELF
        
//        if (ZL_IOS8) {
//            if (!weakSelf.player1) {//解决闪屏问题
//                weakSelf.playerItem1 = [AVPlayerItem playerItemWithURL:weakSelf.pathUrl];
//                
//                weakSelf.player1 = [AVPlayer playerWithPlayerItem:weakSelf.playerItem1];
//                weakSelf.playerLayer1 = [AVPlayerLayer playerLayerWithPlayer:weakSelf.player1];
//                
//                weakSelf.playerLayer1.frame = CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height) ;
//                
//                // 设置画面缩放模式
//                weakSelf.playerLayer1.videoGravity = AVLayerVideoGravityResize;
//                
//                _playerLayer1.backgroundColor = [UIColor clearColor].CGColor;
//                _showView.layer.masksToBounds = YES;
//                [_showView.layer addSublayer:_playerLayer1];
//                
//                [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerItem];
//                [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:weakSelf.playerItem1];
//                
//                [weakSelf.player pause];
//                [weakSelf.player1 play];
//            } else {
//                // 开始播放
//                [weakSelf.player1 pause];
//                [weakSelf.playerItem1 seekToTime:kCMTimeZero];
//                [weakSelf.player1 play];
//            }
//        } else {
            // 开始播放
            [weakSelf.player pause];
            [weakSelf.currentPlayerItem seekToTime:kCMTimeZero];
            [weakSelf.player play];
//        }
    }
}

- (void)orientationDidChange:(NSNotification *)notification {
    
    UIViewController *controller = [ZLContext shareInstance].currentViewController;
    if ([controller isKindOfClass:[ZLAVPlayerViewController class]]) {
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        
        [self transformVideoPlayView:orientation];
    }
}

- (void)transformVideoPlayView:(UIDeviceOrientation)orientation {
    //黑色背景
    UIView *blackView =  [_backView viewWithTag:159];
    //图片
    UIView *imageView = [_backView viewWithTag:952];
    //删除按钮
    UIView *deleteBtn = [_backView viewWithTag:953];
    //    deleteBtn.hidden = YES;
    
    if (UIDeviceOrientationIsLandscape(orientation)) {
        
        [UIView animateWithDuration:TRANSFORM_TIME delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            _backView.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
            //必须在旋转过后必须给self.view赋值,否知坐标不对
            _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            //需要判断视频时横的还是竖的录制
            if (_videoSize.width > _videoSize.height) {//横屏
                _showView.frame = CGRectMake(0, 0, SCREEN_HEIGHT,SCREEN_WIDTH);
                imageView.frame = CGRectMake(0, 0, SCREEN_HEIGHT,SCREEN_WIDTH);
                blackView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            } else {//竖屏
                CGFloat height = SCREEN_WIDTH;  //320
                CGFloat width = SCREEN_WIDTH/(SCREEN_HEIGHT/SCREEN_WIDTH);  // 180
                _showView.frame = CGRectMake((SCREEN_HEIGHT-width)/2, (SCREEN_WIDTH-height)/2, width, height);
                imageView.frame = CGRectMake((SCREEN_HEIGHT-width)/2, (SCREEN_WIDTH-height)/2, width, height);
                blackView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            }
            
            _currentPlayerLayer.frame = CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height);
            _playerLayer1.frame = CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height);
            
            deleteBtn.frame = CGRectMake(SCREEN_HEIGHT-70, 15, 55, 30);
            deleteBtn.layer.frame = CGRectMake(SCREEN_HEIGHT-70, 15, 55, 30);
            
        } completion:^(BOOL finished) {
            
        }];
    }else if (orientation==UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown){
        
        [UIView animateWithDuration:TRANSFORM_TIME delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            _backView.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
            //必须在旋转过后必须给self.view赋值,否知坐标不对
            _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            blackView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            imageView.frame = CGRectMake((SCREEN_WIDTH-_videoSize.width)/2, (SCREEN_HEIGHT-_videoSize.height)/2, _videoSize.width, _videoSize.height);
            
            
            _showView.frame = CGRectMake((SCREEN_WIDTH-_videoSize.width)/2, (SCREEN_HEIGHT-_videoSize.height)/2, _videoSize.width, _videoSize.height);
            _currentPlayerLayer.frame = CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height);
            _playerLayer1.frame = CGRectMake(0, 0, _showView.frame.size.width, _showView.frame.size.height);
            
            deleteBtn.frame = CGRectMake(SCREEN_WIDTH-70, 15, 55, 30);
            deleteBtn.layer.frame = CGRectMake(SCREEN_WIDTH-70, 15, 55, 30);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end
