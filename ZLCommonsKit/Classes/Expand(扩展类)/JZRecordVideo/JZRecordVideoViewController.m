//
//  JZRecordVideoViewController.m
//  e学云
//
//  Created by Mac mini on 2017/4/3.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "JZRecordVideoViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <GPUImage/GPUImage.h>
#import <CoreMotion/CoreMotion.h>
#import "JZSystemMacrocDefine.h"
#import "JZContext.h"
#import "JZAlertHUD.h"

#define FilterViewHeight 95
#define VIDEO_RECORD_TIME 15

typedef NS_ENUM(NSInteger, RecordDeviceOrientation) {
    RecordDeviceOrientationUnknown,
    RecordDeviceOrientationPortrait,
    RecordDeviceOrientationPortraitUpsideDown,
    RecordDeviceOrientationLandscapeLeft,
    RecordDeviceOrientationLandscapeRight,
    RecordDeviceOrientationFaceUp,
    RecordDeviceOrientationFaceDown
};

@interface JZRecordVideoViewController ()
{
    
    UIView          *_gestureView;
    NSTimer         *_timer;
    NSInteger       _count;
    NSInteger       _timeLength;//录制时间
    
}

@property (nonatomic,assign) BOOL               isRecord;//判断是否在录制界面

@property (nonatomic,strong) NSString           *pathToMovie;//视频路径

@property (nonatomic,strong) UILabel            *promptLabel;//提示语label

@property (nonatomic,strong) CAShapeLayer       *shapeLayer;//背景圆

@property (nonatomic,strong) CAShapeLayer       *shapeOutLayer;//外圆

@property (nonatomic,strong) UIButton           *repeatRecordBtn;//重录

@property (nonatomic,strong) UIButton           *flashLampBtn;//闪光灯

@property (nonatomic,strong) UIButton           *rotateBtn;//旋转摄像头

@property (nonatomic,strong) UIButton           *backBtn;//关闭

@property (nonatomic,strong) UIButton           *completeBtn;//完成

@property (nonatomic,strong) UIImageView        *cameraPicture;//拍照图片
@property (nonatomic,strong) UIImage            *cPicture;//拍照图片


//视频录制
@property(nonatomic,strong) GPUImageView        *filterView;
@property (nonatomic,strong) GPUImageMovieWriter *writer;
@property (nonatomic,weak)  GPUImageOutput<GPUImageInput> *filter;

@property (nonatomic,strong) GPUImageStillCamera  *imageCamera;

//视频回放
@property (nonatomic,strong)  AVPlayer          *player;
@property (nonatomic, strong) AVPlayerItem      *playerItem;
@property (nonatomic, strong) AVPlayerLayer     *playerLayer;

//解决闪屏问题
@property (nonatomic,strong)  AVPlayer          *player1;
@property (nonatomic, strong) AVPlayerItem      *playerItem1;
@property (nonatomic, strong) AVPlayerLayer     *playerLayer1;


@property (nonatomic, assign) CGSize            videoSize;

@property (nonatomic, assign) RecordDeviceOrientation      orientation;

@property (nonatomic, strong) CMMotionManager * motionManager;


@end

@implementation JZRecordVideoViewController

- (void)dealloc {    
    
    [self.imageCamera removeAllTargets];
    [self.filter removeAllTargets];
    
    _imageCamera.audioEncodingTarget = nil;
    
    _filterView = nil;
    
    _writer = nil;
    _filter = nil;
    
    _imageCamera = nil;
    _pathToMovie = nil;
    
    _cPicture = nil;
    _cameraPicture=nil;
    
    [_timer invalidate];
    _timer = nil;
    [_shapeOutLayer removeAnimationForKey:@"looping"];
    [_shapeOutLayer removeAllAnimations];
    
    [self releasePlayObject];
    [self setPlayObjectNull];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_motionManager stopDeviceMotionUpdates];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
    
    
    //创建最终预览View
    _filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_filterView setInputRotation:kGPUImageRotateRight atIndex:0];
    _filterView.fillMode=kGPUImageFillModePreserveAspectRatio;//显示模式分为三种
    [self.view addSubview:_filterView];
    
    //照相机
    self.imageCamera=[[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    
    self.imageCamera.outputImageOrientation=UIDeviceOrientationLandscapeLeft;
    //该句可防止允许声音通过的情况下，避免录制第一帧黑屏闪屏
    [self.imageCamera addAudioInputsAndOutputs];
    
    
    //初始化滤镜
    [self creatFilter];
    
    //创建btn
    [self creatBtnSubview];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnClick) name:UIApplicationDidEnterBackgroundNotification object:nil];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnClick) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    //开启重力感应来判断目前屏幕方向
    [self startMotionManager];
    
    
    [JZSystemUtils videoAuthorizationStatusAuthorized:^{
        
        [JZSystemUtils soundAuthorizationStatusAuthorized:^{
            
        } restricted:^{
            _rotateBtn.userInteractionEnabled = NO;
            _completeBtn.userInteractionEnabled = NO;
            _repeatRecordBtn.userInteractionEnabled = NO;
            _flashLampBtn.userInteractionEnabled = NO;
        }];
    } restricted:^{
        _rotateBtn.userInteractionEnabled = NO;
        _completeBtn.userInteractionEnabled = NO;
        _repeatRecordBtn.userInteractionEnabled = NO;
        _flashLampBtn.userInteractionEnabled = NO;
    }];

}
- (void)startMotionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        [self setMotionManager:nil];
    }
}
- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
//    NSLog(@"x=====%f,y====%f",x,y);
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
//            NSLog(@"--------PortraitUpsideDown-------");
            _orientation = RecordDeviceOrientationPortraitUpsideDown;
        }
        else{
//            NSLog(@"--------Portrait-------");
            _orientation = RecordDeviceOrientationPortrait;
        }
    }
    else
    {
        if (x >= 0){
            _orientation = RecordDeviceOrientationLandscapeRight;
//            NSLog(@"--------LandscapeRight-------");
        }
        else{
            _orientation = RecordDeviceOrientationLandscapeLeft;
//            NSLog(@"--------LandscapeLeft-------");
        }
    }
    
    if (fabs(x) < 0.20 && fabs(y) < 0.20) {
        _orientation = RecordDeviceOrientationFaceUp;
    }
}

#pragma mark -- 初始化滤镜
- (void)creatFilter {
    // 创建滤镜：磨皮，美白，组合滤镜
    GPUImageFilterGroup *groupFilter = [[GPUImageFilterGroup alloc] init];
    
    // 磨皮滤镜
    GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    [groupFilter addTarget:bilateralFilter];
    [bilateralFilter setDistanceNormalizationFactor:10];
    
    
    // 美白滤镜
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [groupFilter addTarget:brightnessFilter];
    brightnessFilter.brightness = 0.05;
    
    // 设置滤镜组链
    [bilateralFilter addTarget:brightnessFilter];
    [groupFilter setInitialFilters:@[bilateralFilter]];
    groupFilter.terminalFilter = brightnessFilter;
    
    // 必须调用startCameraCapture，底层才会把采集到的视频源，渲染到GPUImageView中，就能显示了。
    // 开始采集视频
    [self.imageCamera startCameraCapture];
    
    
    self.filter = groupFilter;
    //// 切换美颜效果原理：移除之前所有处理链，重新设置处理链
    [self.imageCamera removeAllTargets];
    // 设置GPUImage处理链，从数据源 => 滤镜 => 最终界面效果
    [self.imageCamera addTarget:_filter];
    [_filter addTarget:_filterView];
    
}
#pragma mark -- 初始化子视图
- (void)creatBtnSubview {
    //闪光灯
    _flashLampBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashLampBtn.frame = CGRectMake(SCREEN_WIDTH-200, 20, 60, 60);
    [_flashLampBtn setImage:[UIImage imageNamed:@"ljm_video_flashLamp_off"] forState:UIControlStateNormal];
    [_flashLampBtn addTarget:self action:@selector(openLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashLampBtn];
    
    //旋转摄像头
    _rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rotateBtn.frame = CGRectMake(SCREEN_WIDTH-100, 20, 60, 60);
    [_rotateBtn setImage:[UIImage imageNamed:@"ljm_video_cam"] forState:UIControlStateNormal];
    [_rotateBtn addTarget:self action:@selector(cameraPosition:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rotateBtn];
    
    
    
    //返回按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setImage:[UIImage imageNamed:@"ljm_video_back"] forState:UIControlStateNormal];
    _backBtn.frame = CGRectMake(self.view.center.x-120, self.view.bounds.size.height-120, 60, 60);
    [self.view addSubview:_backBtn];
    
    
    //重新录制按钮
    _repeatRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _repeatRecordBtn.frame = CGRectZero;
    _repeatRecordBtn.layer.cornerRadius = 40;
    [_repeatRecordBtn setImage:[UIImage imageNamed:@"ljm_video_again"] forState:UIControlStateNormal];
    [_repeatRecordBtn addTarget:self action:@selector(repeatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //完成按钮
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeBtn.frame = CGRectZero;
    [_completeBtn setImage:[UIImage imageNamed:@"ljm_video_complete"] forState:UIControlStateNormal];
    _completeBtn.layer.cornerRadius = 40;
    [_completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //提示语label
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-170, SCREEN_WIDTH, 21)];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.font = [UIFont systemFontOfSize:15];
    if (_cameraType == CameraTypeRecored) {
        _promptLabel.text = @"长按摄像";
    } else {
        _promptLabel.text = @"轻触拍照";
    }
    _promptLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_promptLabel];
    
    //拍照图片
    _cameraPicture = [[UIImageView alloc] initWithFrame:self.view.frame];
    _cameraPicture.contentMode = UIViewContentModeScaleAspectFill;
    _cameraPicture.clipsToBounds = YES;
    
    
    //录制按钮
    _gestureView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, SCREEN_HEIGHT-130, 80, 80)];
    _gestureView.clipsToBounds = YES;
    _gestureView.layer.cornerRadius = 30;
    _gestureView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_gestureView];
    
    //背景layer
    _shapeLayer = [[CAShapeLayer alloc] init];
    _shapeLayer.lineWidth = 10;
    _shapeLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-90) radius:30 startAngle:0 endAngle:2*M_PI clockwise:true] CGPath];
    _shapeLayer.strokeColor = [UIColor colorWithRed:220/255.0 green:204/255.0 blue:198/255.0 alpha:1].CGColor;
    _shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:_shapeLayer];
    
    
    //外圆
    _shapeOutLayer = [[CAShapeLayer alloc] init];
    _shapeOutLayer.lineWidth = 10;
    _shapeOutLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-90) radius:60 startAngle:0 endAngle:2*M_PI clockwise:true] CGPath];
    _shapeOutLayer.strokeColor = [UIColor clearColor].CGColor;
    _shapeOutLayer.fillColor = [UIColor clearColor].CGColor;
    [_shapeLayer addSublayer:_shapeOutLayer];
    
    
    
    if (_cameraType == CameraTypeRecored) {//摄像
        //长按
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                          
                                                          initWithTarget:self action:@selector(handleLongPress:)];
        [_gestureView addGestureRecognizer:longPressGesture];
        
    } else {//拍照
        //单击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [_gestureView addGestureRecognizer:tap];
    }
    
}
- (void)onTimer {
    _count++;
    NSLog(@"--count---%ld",(long)_count);
    _timeLength = _count;
    if (_count >= VIDEO_RECORD_TIME) {
         [self stopRecord];
        [_gestureView resignFirstResponder];
        [self addRepeatAndCompleteBtn];
        _timeLength = VIDEO_RECORD_TIME;
        _count = 0;
    }
}
#pragma mark -- 返回按钮
- (void)backBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(recordVideoControllerDidCancel:completion:)]) {
        [self releasePlayObject];
        [self.delegate recordVideoControllerDidCancel:self completion:^{
            [self setPlayObjectNull];
        }];
    }else{
        UIViewController *controller = [JZContext shareInstance].currentViewController;
        if ([controller isKindOfClass:[JZRecordVideoViewController class]]) {
            [self releasePlayObject];
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"--------pop------------");
            [self setPlayObjectNull];
        }
    }

}

#pragma mark -- 单击手势 ----- 拍照
- (void) handleTapGesture: (UITapGestureRecognizer *)gestureRecognizer{
    
    //返回按钮隐藏
    _backBtn.hidden = YES;
    _promptLabel.hidden = YES;
    
    WEAKSELF
    [weakSelf.imageCamera capturePhotoAsImageProcessedUpToFilter:weakSelf.filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if(error){
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.cPicture = processedImage;
            [weakSelf addRepeatAndCompleteBtn];
        });
    }];
}

#pragma mark -- 长按手势
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
        
    {
        [JZSystemUtils videoAuthorizationStatusAuthorized:^{
            
            if ([[JZSystemUtils deviceString] isEqualToString:@"Simulator"]) {
                [JZAlertHUD showTipTitle:@"警告：该设备是模拟器，并没有摄像头！"];
                return ;
            }
            
            [JZSystemUtils soundAuthorizationStatusAuthorized:^{
            
                //返回按钮隐藏
                _backBtn.hidden = YES;
                _promptLabel.hidden = YES;
                
                [UIView animateWithDuration:0.5 animations:^{
                    
                    _gestureView.bounds = CGRectMake(0, 0, 100, 100);
                    _gestureView.layer.cornerRadius = 50;
                    _shapeLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-90) radius:40 startAngle:0 endAngle:2*M_PI clockwise:true] CGPath];
                    _shapeLayer.lineWidth = 45;
                } completion:^(BOOL finished) {
                    
                    
                    [self startrecord];
                    //外圆
                    _shapeOutLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-90) radius:60 startAngle:-(M_PI_2) endAngle:(3*M_PI_2) clockwise:true] CGPath];
                    _shapeOutLayer.lineWidth = 4;
                    _shapeOutLayer.strokeColor = [UIColor greenColor].CGColor;
                    CAKeyframeAnimation * strokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
                    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                    strokeEndAnimation.duration = VIDEO_RECORD_TIME;
                    strokeEndAnimation.values = @[@0.0, @1.0];
                    strokeEndAnimation.keyTimes = @[@0.0, @1.0];
                    strokeEndAnimation.repeatCount = 1;
                    [_shapeOutLayer addAnimation:strokeEndAnimation forKey:@"looping"];
                }];

            } restricted:^{
                _completeBtn.enabled = NO;
                [JZAlertHUD alertShowTitle:@"提示信息" message:@"提示信息" cancelButtonTitle:@"返回" otherButtonTitle:@"确定" continueBlock:^{
                    [self backBtnClick];
                } cancelBlock:^{
                    [self backBtnClick];
                }];
//                [JZAlertHUD alertShowTitle:@"提示信息" message:MSG_SOUND_NO_AUTH cancelButtonTitle:@"确定" otherButtonTitles:@"" continueBlock:^{
//                    [self backBtnClick];
//                } cancelBlock:^{
//                    [self backBtnClick];
//                }];
                
            }];
        } restricted:^{
            _completeBtn.enabled = NO;
            [JZAlertHUD alertShowTitle:@"提示信息" message:@"提示信息" cancelButtonTitle:@"返回" otherButtonTitle:@"确定" continueBlock:^{
                [self backBtnClick];
            } cancelBlock:^{
                [self backBtnClick];
            }];
//            [JZAlertHUD alertShowTitle:@"提示信息" message:MSG_VIDEO_NO_AUTH cancelButtonTitle:@"确定" otherButtonTitles:@"" continueBlock:^{
//                 [self backBtnClick];
//            } cancelBlock:^{
//                [self backBtnClick];
//            }];
        }];

    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
        
    {
        [JZSystemUtils videoAuthorizationStatusAuthorized:^{
            
            [JZSystemUtils soundAuthorizationStatusAuthorized:^{
                [self stopRecord];
                
                if (_count < 1) {
                    [JZAlertHUD showTipTitle:@"小视频录制时间太短"];
                    _count = 0;
                    //移除中心录像view和图层layer
                    [_gestureView removeFromSuperview];
                    [_shapeLayer removeFromSuperlayer];
                    [_shapeOutLayer removeFromSuperlayer];
                    [_backBtn removeFromSuperview];
                    [self repeatBtnClick];
                    return ;
                }
                
                [self addRepeatAndCompleteBtn];
                _timeLength = _count;
                _count = 0;
            } restricted:^{
                [JZAlertHUD alertShowTitle:@"提示信息" message:@"提示信息" cancelButtonTitle:@"返回" otherButtonTitle:@"确定" continueBlock:^{
                    [self backBtnClick];
                } cancelBlock:^{
                    [self backBtnClick];
                }];
//                [JZAlertHUD alertShowTitle:@"提示信息" message:MSG_SOUND_NO_AUTH cancelButtonTitle:@"确定" otherButtonTitles:@"" continueBlock:^{
//                    [self backBtnClick];
//                } cancelBlock:^{
//                    [self backBtnClick];
//                }];
            }];
        } restricted:^{
            _completeBtn.enabled = NO;
            [JZAlertHUD alertShowTitle:@"提示信息" message:@"提示信息" cancelButtonTitle:@"返回" otherButtonTitle:@"确定" continueBlock:^{
                [self backBtnClick];
            } cancelBlock:^{
                [self backBtnClick];
            }];
//            [JZAlertHUD alertShowTitle:@"提示信息" message:MSG_VIDEO_NO_AUTH cancelButtonTitle:@"确定" otherButtonTitles:@"" continueBlock:^{
//                [self backBtnClick];
//            } cancelBlock:^{
//                [self backBtnClick];
//            }];
        }];
    }
}
#pragma mark -- 开始录制
- (void)startrecord {
    
    //关闭重力感应
    [_motionManager stopDeviceMotionUpdates];
    //     self.imageCamera.outputImageOrientation=UIInterfaceOrientationPortrait;
    
    //释放对象,内存相关
    [self.imageCamera removeTarget:self.writer];
    [self.filter removeTarget:self.writer];
    self.writer = nil;
    self.imageCamera.audioEncodingTarget = nil;
    
//    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/recordVideo/",document,JZ_App.userId];
    NSString *directoryPath = [JZFilePath mainAudioCacheDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    _pathToMovie = [directoryPath stringByAppendingFormat:@"Movie%d.mp4",(int)[[NSDate date] timeIntervalSince1970]];
    
    NSURL *movieURL = [NSURL fileURLWithPath:_pathToMovie];
    self.writer = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(1280, 720)];
    self.writer.assetWriter.movieFragmentInterval = kCMTimeInvalid;
    
    [self.filter addTarget:self.writer];
    self.imageCamera.audioEncodingTarget = self.writer;
    
    
    if (_orientation == RecordDeviceOrientationLandscapeRight) {
        NSLog(@"---Right----");
        if (_rotateBtn.selected) {//前置镜头
//            [self.writer startRecordingInOrientation:CGAffineTransformIdentity];
            [self.writer startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI)];
        } else {   //后置镜头
            [self.writer startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI)];
        }
    } else if (_orientation == RecordDeviceOrientationLandscapeLeft) {
        NSLog(@"---Left----");
        if (_rotateBtn.selected) {//前置镜头
             [self.writer startRecordingInOrientation:CGAffineTransformIdentity];
//            [self.writer startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI)];
        } else {   //后置镜头
            [self.writer startRecordingInOrientation:CGAffineTransformIdentity];
        }
        
    } else if (_orientation == RecordDeviceOrientationPortraitUpsideDown) {
        NSLog(@"---UpsideDown----");
        if (_rotateBtn.selected) {//前置镜头
//            [self.writer startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI_2)];
             [self.writer startRecordingInOrientation:CGAffineTransformMakeRotation(3*M_PI_2)];
        } else {   //后置镜头
            [self.writer startRecordingInOrientation:CGAffineTransformMakeRotation(3*M_PI_2)];
        }
    }else {
        NSLog(@"---else----");
        if (_rotateBtn.selected) {//前置镜头
//            [self.writer startRecordingInOrientation:CGAffineTransformMakeRotation(3*M_PI_2)];
             [self.writer startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI_2)];
        } else {   //后置镜头
            [self.writer startRecordingInOrientation:CGAffineTransformMakeRotation(M_PI_2)];
        }
    }
    
    
    if (_rotateBtn.selected) {//前置镜头
        [self.writer setInputRotation:kGPUImageFlipVertical atIndex:0];
    } else {//后置镜头
        [self.writer setInputRotation:kGPUImageNoRotation atIndex:0];
    }
    
    
    //    [self.writer startRecording];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    _count = 0;
    
}
#pragma mark -- 停止录制
- (void)stopRecord {
    
    [self.writer finishRecording];
    [self.filter removeTarget:self.writer];
    self.imageCamera.audioEncodingTarget = nil;
    
    //移除动画
    [_shapeOutLayer removeAnimationForKey:@"looping"];
    [_shapeOutLayer removeAllAnimations];
    
    [_timer invalidate];
    _timer = nil;
    
    //返回按钮显示
    _backBtn.hidden = NO;
    _promptLabel.hidden = YES;
    
}
#pragma mark -- 旋转摄像头
- (void)cameraPosition:(UIButton *)btn {
    
    
    [self.imageCamera rotateCamera];
    _rotateBtn.selected = !_rotateBtn.selected;
    
    if (_rotateBtn.selected) {
        _flashLampBtn.selected = NO;
        [_flashLampBtn setImage:[UIImage imageNamed:@"ljm_video_flashLamp_off"] forState:UIControlStateNormal];
        
        [_filterView setInputRotation:kGPUImageRotateRightFlipVertical atIndex:0];
        self.imageCamera.outputImageOrientation=UIDeviceOrientationLandscapeRight;
    } else {
        [_filterView setInputRotation:kGPUImageRotateRight atIndex:0];
        self.imageCamera.outputImageOrientation=UIDeviceOrientationLandscapeLeft;
    }

}
#pragma mark -- 闪光灯
- (void)openLight:(UIButton *)btn {
    if (self.imageCamera.inputCamera.position == AVCaptureDevicePositionBack) {
        if (btn.selected) {
            [_flashLampBtn setImage:[UIImage imageNamed:@"ljm_video_flashLamp_off"] forState:UIControlStateNormal];
            [self.imageCamera.inputCamera lockForConfiguration:nil];
            [self.imageCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
            [self.imageCamera.inputCamera unlockForConfiguration];
        }else{
            [_flashLampBtn setImage:[UIImage imageNamed:@"ljm_video_flashLamp_on"] forState:UIControlStateNormal];
            [self.imageCamera.inputCamera lockForConfiguration:nil];
            [self.imageCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
            [self.imageCamera.inputCamera unlockForConfiguration];
        }
        btn.selected = !btn.selected;
    }else{
        NSLog(@"当前使用前置摄像头,未能开启闪光灯");
    }
}
#pragma mark -- 视频保存
-(void)saveToPhotosAlbum:(NSString *)path
{
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
        [JZAlertHUD showTipTitle:@"正在处理..." toView:self.view];
        WEAKSELF
        UISaveVideoAtPathToSavedPhotosAlbum(path, weakSelf, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        
    }
}
// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        if ([self.delegate respondsToSelector:@selector(recordVideoEnd)]) {
            [self.delegate recordVideoEnd];
        }
        [JZAlertHUD hideHUD:self.view];
        
        if (_orientation == RecordDeviceOrientationLandscapeRight) {
            _videoSize = CGSizeMake(SCREEN_HEIGHT, SCREEN_WIDTH);
        } else if (_orientation == RecordDeviceOrientationLandscapeLeft) {
            _videoSize = CGSizeMake(SCREEN_HEIGHT, SCREEN_WIDTH);
        } else if (_orientation == RecordDeviceOrientationPortraitUpsideDown) {
            _videoSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        }else {
            _videoSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        
        if ([self.delegate respondsToSelector:@selector(recordVideoControllerDidFinish:sendRecord:completion:)]) {
        
            [self releasePlayObject];
            JZRecordVideoModel * recordVideoModel = [[JZRecordVideoModel alloc] init];
            recordVideoModel.localStorePath = _pathToMovie;
            recordVideoModel.timeLength = _timeLength;
            recordVideoModel.videoSize = _videoSize;
//            [JZUtilsTools movieToImagePath:_pathToMovie handler:^(UIImage *movieImage) {
//                NSString *videoCacheDir =   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
//                NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/recordImage/",videoCacheDir,JZ_App.userId];
//                if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath])
//                {
//                    [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
//                }
//                NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
//                NSString *path = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%.f.png",interval]];
//                
//                NSData *imageData = UIImageJPEGRepresentation(movieImage, 1);
//                [imageData writeToFile:path atomically:YES];
//                recordVideoModel.localImagePath = path;
//                [self.delegate recordVideoControllerDidFinish:self sendRecord:recordVideoModel completion:^{
//                    [self setPlayObjectNull];
//                }];
//            }];
            [self.delegate recordVideoControllerDidFinish:self sendRecord:recordVideoModel completion:^{
                [self setPlayObjectNull];
            }];

        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:JZ_RECORD_VIDEO object:self userInfo:@{@"videoPath":_pathToMovie,@"timeLength":@(_timeLength),@"videoSize":NSStringFromCGSize(_videoSize)}];
            [self releasePlayObject];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [self setPlayObjectNull];
        }
    }
    
}

#pragma mark -- 停止录制时UI改变
- (void)addRepeatAndCompleteBtn {
    
    //移除中心录像view和图层layer
    [_gestureView removeFromSuperview];
    [_shapeLayer removeFromSuperlayer];
    [_shapeOutLayer removeFromSuperlayer];
    [_backBtn removeFromSuperview];
    
    
    //重新录制按钮
    _repeatRecordBtn.frame = CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT-130, 80, 80);
    //完成按钮
    _completeBtn.frame = CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT-130, 80, 80);
    [self.view addSubview:_repeatRecordBtn];
    [self.view addSubview:_completeBtn];
    _repeatRecordBtn.alpha = 0;
    _completeBtn.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _repeatRecordBtn.alpha = 1;
        _completeBtn.alpha = 1;
        //重新录制按钮
        _repeatRecordBtn.frame = CGRectMake(SCREEN_WIDTH/2-140, SCREEN_HEIGHT-130, 80, 80);
        //完成按钮
        _completeBtn.frame = CGRectMake(SCREEN_WIDTH/2+60, SCREEN_HEIGHT-130, 80, 80);
    } completion:^(BOOL finished) {
        
        if (_cameraType == CameraTypeRecored) {//摄像
            //视频回放开始
            [self startVideoPlayBack];
        } else {//拍照
            self.cameraPicture.image = _cPicture;
            
            [self.view addSubview:_cameraPicture];
            [self.view bringSubviewToFront:_repeatRecordBtn];
            [self.view bringSubviewToFront:_completeBtn];
            
            //关闭闪光灯
            [self closeFlashLamp];
        }
    }];
    
}
#pragma mark -- 重新录制按钮
- (void)repeatBtnClick {

    [self startMotionManager];
    
    if (_rotateBtn.selected) {//前置镜头
        [_filterView setInputRotation:kGPUImageRotateRightFlipVertical atIndex:0];
        self.imageCamera.outputImageOrientation=UIDeviceOrientationLandscapeRight;
    } else {//后置镜头
        [self.filterView setInputRotation:kGPUImageRotateRight atIndex:0];
        self.imageCamera.outputImageOrientation=UIDeviceOrientationLandscapeLeft;
    }

    
    _filterView.fillMode=kGPUImageFillModePreserveAspectRatio;//显示模式分为三种
    _filterView.hidden = NO;
    
    _completeBtn.enabled = YES;
    if (_cameraType == CameraTypeRecored) {//摄像
        //视频回放停止
        [self stopVideoPlayBack];
    } else {//拍照
        [_cameraPicture removeFromSuperview];
        _rotateBtn.userInteractionEnabled = YES;
        _flashLampBtn.userInteractionEnabled = YES;
        _rotateBtn.hidden = NO;
        _flashLampBtn.hidden = NO;
        _backBtn.hidden = NO;
        _promptLabel.hidden = NO;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _repeatRecordBtn.frame = CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT-130, 80,80);
        _completeBtn.frame = CGRectMake(SCREEN_WIDTH/2-40, SCREEN_HEIGHT-130, 80, 80);
        _repeatRecordBtn.alpha = 0;
        _completeBtn.alpha = 0;
    } completion:^(BOOL finished) {
        
        [_repeatRecordBtn removeFromSuperview];
        [_completeBtn removeFromSuperview];
        
        //提示语
        _promptLabel.hidden = NO;
        
        //还原
        _gestureView.bounds = CGRectMake(0, 0, 80, 80);
        _gestureView.layer.cornerRadius = 40;
        
        //背景layer
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.lineWidth = 10;
        _shapeLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-90) radius:30 startAngle:0 endAngle:2*M_PI clockwise:true] CGPath];
        _shapeLayer.strokeColor = [UIColor colorWithRed:220/255.0 green:204/255.0 blue:198/255.0 alpha:1].CGColor;
        _shapeLayer.fillColor = [UIColor whiteColor].CGColor;
        
        
        //外圆
        _shapeOutLayer = [[CAShapeLayer alloc] init];
        _shapeOutLayer.lineWidth = 10;
        _shapeOutLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-90) radius:60 startAngle:0 endAngle:2*M_PI clockwise:true] CGPath];
        _shapeOutLayer.strokeColor = [UIColor clearColor].CGColor;
        _shapeOutLayer.fillColor = [UIColor clearColor].CGColor;
        
        
        [self.view addSubview:_gestureView];
        [self.view.layer addSublayer:_shapeLayer];
        [_shapeLayer addSublayer:_shapeOutLayer];
        [self.view addSubview:_backBtn];
        
    }];

}
#pragma mark -- 完成按钮
- (void)completeBtnClick {
    if (_cameraType == CameraTypeRecored) {
        [self saveToPhotosAlbum:_pathToMovie];
    } else {
        //存入本地相册
        WEAKSELF
        
        UIImage *saveImage = [self scaleImage:weakSelf.cPicture toSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIImageWriteToSavedPhotosAlbum(saveImage, nil, nil, nil);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark -- 录制结束视频开始回放
- (void)startVideoPlayBack {
    
    
    //关闭闪光灯
    [self closeFlashLamp];
    
    NSURL *movieURL = [NSURL fileURLWithPath:_pathToMovie];
    _playerItem = [AVPlayerItem playerItemWithURL:movieURL];
    
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    
    CGFloat   videoPlayHeight = 0;
    if (SCREEN_WIDTH <375) {
        videoPlayHeight = 180;
    } else if (SCREEN_WIDTH <414) {
        videoPlayHeight = 215;
    } else {
        videoPlayHeight = 235;
    }

//    不能隐藏,隐藏那一瞬间会出现黑屏闪烁
//    _filterView.hidden = YES;
    
    
    if (_orientation == RecordDeviceOrientationLandscapeRight) {
        if (_rotateBtn.selected) {//前置镜头
            [_filterView setInputRotation:kGPUImageFlipHorizonal atIndex:0];
        } else {//kGPUImageFlipVertical
            [_filterView setInputRotation:kGPUImageRotate180 atIndex:0];
        }
        
        _playerLayer.frame = CGRectMake(0, (SCREEN_HEIGHT-videoPlayHeight)/2, SCREEN_WIDTH, videoPlayHeight);
        _cameraPicture.frame = CGRectMake(0, (SCREEN_HEIGHT-videoPlayHeight)/2, SCREEN_WIDTH, videoPlayHeight);
        
    } else if (_orientation == RecordDeviceOrientationLandscapeLeft) {
        
        if (_rotateBtn.selected) {//前置镜头
            
            [_filterView setInputRotation:kGPUImageFlipVertical atIndex:0];
        } else {//kGPUImageFlipHorizonal
            [_filterView setInputRotation:kGPUImageNoRotation atIndex:0];
        }
        
        _playerLayer.frame = CGRectMake(0, (SCREEN_HEIGHT-videoPlayHeight)/2, SCREEN_WIDTH, videoPlayHeight);
        _cameraPicture.frame = CGRectMake(0, (SCREEN_HEIGHT-videoPlayHeight)/2, SCREEN_WIDTH, videoPlayHeight);
        
    } else if (_orientation == RecordDeviceOrientationPortraitUpsideDown) {
        
        if (_rotateBtn.selected) {//前置镜头
//            [_filterView setInputRotation:kGPUImageRotateLeft atIndex:0];
        } else {
            [_filterView setInputRotation:kGPUImageRotateLeft atIndex:0];
        }
        _playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _cameraPicture.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else {
        if (_rotateBtn.selected) {//前置镜头
            [_filterView setInputRotation:kGPUImageRotateRightFlipVertical atIndex:0];
        } else {
            [_filterView setInputRotation:kGPUImageRotateRight atIndex:0];
        }
        _playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _cameraPicture.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }


    
    // 设置画面缩放模式
    _playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer insertSublayer:_playerLayer below:_shapeLayer];
    [self.view bringSubviewToFront:_repeatRecordBtn];
    [self.view bringSubviewToFront:_completeBtn];
    
    // 开始播放
    [_player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    
}
#pragma mark -- 关闭闪光灯
- (void)closeFlashLamp {
    if (self.imageCamera.inputCamera.torchMode == AVCaptureTorchModeOn) {
        [_flashLampBtn setImage:[UIImage imageNamed:@"ljm_video_flashLamp_off"] forState:UIControlStateNormal];
        [self.imageCamera.inputCamera lockForConfiguration:nil];
        [self.imageCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
        [self.imageCamera.inputCamera unlockForConfiguration];
    }
    _flashLampBtn.selected = NO;
    _rotateBtn.userInteractionEnabled = NO;
    _flashLampBtn.userInteractionEnabled = NO;
    _rotateBtn.hidden = YES;
    _flashLampBtn.hidden = YES;
}
#pragma mark -- 视频播放结束通知,开启循环播放
- (void)playerItemDidPlayToEnd:(NSNotification *)note {
    //循环播放
    WEAKSELF
    
    if (!weakSelf.isRecord) {
        weakSelf.filterView.hidden = YES;
        
        
        if (JZ_IOS8) {
            if (!weakSelf.player1) {//解决闪屏问题
                NSURL *movieURL = [NSURL fileURLWithPath:weakSelf.pathToMovie];
                weakSelf.playerItem1 = [AVPlayerItem playerItemWithURL:movieURL];
                
                weakSelf.player1 = [AVPlayer playerWithPlayerItem:weakSelf.playerItem1];
                weakSelf.playerLayer1 = [AVPlayerLayer playerLayerWithPlayer:weakSelf.player1];
                
                
                CGFloat   videoPlayHeight = 0;
                if (SCREEN_WIDTH <375) {
                    videoPlayHeight = 180;
                } else if (SCREEN_WIDTH <414) {
                    videoPlayHeight = 215;
                } else {
                    videoPlayHeight = 235;
                }
                
                if (weakSelf.orientation == RecordDeviceOrientationLandscapeRight) {
                    weakSelf.playerLayer1.frame = CGRectMake(0, (SCREEN_HEIGHT-videoPlayHeight)/2, SCREEN_WIDTH, videoPlayHeight);
                } else if (weakSelf.orientation == RecordDeviceOrientationLandscapeLeft) {
                    weakSelf.playerLayer1.frame = CGRectMake(0, (SCREEN_HEIGHT-videoPlayHeight)/2, SCREEN_WIDTH, videoPlayHeight);
                } else if (weakSelf.orientation == RecordDeviceOrientationPortraitUpsideDown) {
                    weakSelf.playerLayer1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }else {
                    weakSelf.playerLayer1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }
                
                
                // 设置画面缩放模式
                weakSelf.playerLayer1.videoGravity = AVLayerVideoGravityResize;
                [weakSelf.view.layer insertSublayer:weakSelf.playerLayer1 below:weakSelf.shapeLayer];
                [weakSelf.view bringSubviewToFront:weakSelf.repeatRecordBtn];
                [weakSelf.view bringSubviewToFront:weakSelf.completeBtn];
                
                [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:weakSelf.playerItem];
//                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:weakSelf.playerItem1];
                
                [weakSelf.player pause];
                [weakSelf.player1 play];
            } else {
                // 开始播放
                [weakSelf.player1 pause];
                [weakSelf.playerItem1 seekToTime:kCMTimeZero];
                [weakSelf.player1 play];
            }
        } else {
            [weakSelf.player pause];
            [weakSelf.playerItem seekToTime:kCMTimeZero];
            [weakSelf.player play];
        }
        
        weakSelf.promptLabel.hidden = YES;
    }
    
}
#pragma mark -- 视频停止回放
- (void)stopVideoPlayBack
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];  此处不能移除所有的监听
     [_player1 pause];
     [_player pause];
    
    [self setPlayObjectNull];
    
    _rotateBtn.userInteractionEnabled = YES;
    _flashLampBtn.userInteractionEnabled = YES;
    _rotateBtn.hidden = NO;
    _flashLampBtn.hidden = NO;
}
#pragma mark -- 缩放图片
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width < size.width) {
        return image;
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark -- 释放对象,停止播放
- (void)releasePlayObject {
    [_timer invalidate];
    _timer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_player1) {
        [_player1 pause];
    }
    if (_player) {
        [_player pause];
    }
    
    _isRecord = YES;
    //移除动画
    [_shapeOutLayer removeAnimationForKey:@"looping"];
    [_shapeOutLayer removeAllAnimations];
}
- (void)setPlayObjectNull {
    [_playerLayer removeFromSuperlayer];
    [_playerLayer1 removeFromSuperlayer];
    _player1 = nil;
    _player = nil;
    _playerItem = nil;
    _playerItem1 = nil;
    _playerLayer = nil;
    _playerLayer1 = nil;
}


@end
