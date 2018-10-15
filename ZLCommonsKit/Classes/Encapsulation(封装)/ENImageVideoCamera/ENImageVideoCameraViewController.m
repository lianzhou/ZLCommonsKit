//
//  ENImageVideoCameraViewController.m
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/10.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENImageVideoCameraViewController.h"
#import "ENAVPlayerView.h"
#import "JZFilePath.h"
#import "JZDataHandler.h"
#import "JZStringMacrocDefine.h"
#import <CoreMotion/CoreMotion.h>
#import "UIImage+JZTintColor.h"


@interface ENImageVideoCameraViewController ()

//@property(nonatomic,strong)GPUImageStillCamera * imageVideoCamera;
@property(nonatomic,strong)GPUImageView * targetImageView;
@property(nonatomic,strong)GPUImageMovieWriter *movieWriter;
@property(nonatomic,strong)GPUImageFilterGroup *groupFilter;
@property(nonatomic,strong)ENAVPlayerView * videoPlayer;

@property(nonatomic,strong,readwrite)ENCameraModel * cameraModel; 
@property (nonatomic,copy,readwrite) NSURL * moviePath;



@end

@implementation ENImageVideoCameraViewController

- (int)imageOrientation{
    if (!_imageOrientation) {
        _imageOrientation = 0;
    }
    return _imageOrientation;
}

-(void)dealloc{
    [self stopCameraCapture];
    NSLog(@"基类摄像头关闭");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    磨皮/Users/wangwangming/Desktop/Project/JZCommonsKit/JZCommonsKit/Classes/Encapsulation(封装)/JZAlertHUD
    GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    bilateralFilter.distanceNormalizationFactor = 10.0f;
//    美白
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    brightnessFilter.brightness = 0.05;
    [self addGPUImageFilter:bilateralFilter];
    [self addGPUImageFilter:brightnessFilter];
    
    [self.view addSubview:self.targetImageView];

    [self startCameraCapture];
}
//1,进入页面,开始打开摄像头,并加入滤镜
- (void)startCameraCapture {
    [self.imageVideoCamera startCameraCapture];
    if (self.videoPlayer) {
        self.videoPlayer.hidden = YES;
    }
    if (![self.imageVideoCamera.targets containsObject:self.groupFilter]) {
        [self.imageVideoCamera addTarget:self.groupFilter];
        if (![self.groupFilter.targets containsObject:self.targetImageView]) {
            [self.groupFilter addTarget:self.targetImageView];
        }
    }
}

#pragma mark - 公开函数
/**
 使用陀螺仪确定当前手机方向
 */
- (void)useAccelerometerPull{
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 加速计
    if (motionManager.accelerometerAvailable) {
        motionManager.accelerometerUpdateInterval = 2;
        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            [motionManager stopAccelerometerUpdates];
            if (error) {
                NSLog(@"error:获取手机状态失败");
            } else {
                NSLog(@"x 加速度--> %f\n y 加速度--> %f\n z 加速度--> %f\n", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
                CMAcceleration accelerate = accelerometerData.acceleration;
                if (fabs(accelerate.y) > fabs(accelerate.x)) {
                    if (accelerate.y < 0) {
                        self.imageOrientation = UIImageOrientationUp;
                    }else{
                        self.imageOrientation = UIImageOrientationDown;
                    }
                }else if (fabs(accelerate.y) < fabs(accelerate.x)){
                    if (accelerate.x < 0) {
                        self.imageOrientation = UIImageOrientationLeft;
                    }else{
                        self.imageOrientation = UIImageOrientationRight;
                    }
                }else{
                    self.imageOrientation = UIImageOrientationUp;
                }
            }
        }];
    } else {
        NSLog(@"This device has no accelerometer这个设备没有陀螺仪");
    }
    
}



//2,拍照完成,先取到图片,然后暂停使用摄像头
- (void)capturePhotoInCameraCompletionHandler:(void (^)(void))handler failure:(void (^)(void))failure {
    [self useAccelerometerPull];
    [self.imageVideoCamera capturePhotoAsImageProcessedUpToFilter:self.groupFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (error) {
            failure();
        }
        if (handler) {
            self.cameraModel.cameraImage = processedImage;
            [self pauseCameraCapture];
            handler();
        }
    }];
}

//2,开始录制视频
- (void)startRecording{
//    [AVAssetWriter startWriting] Cannot call method when status is 1
    
//    [self.movieWriter ] = self.cameraModel.isPortrait ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft;
//    CGAffineTransform transform = CGAffineTransformIdentity;
//     transform = CGAffineTransformRotate(transform, M_PI / 180.0 * 30);
//    [self.targetImageView setInputRotation:kGPUImageRotateLeft atIndex:0];
    
    [self stopRecordingWithCompletionHandler:^{
        //把给录制的视频,加上滤镜
        [self.groupFilter addTarget:self.movieWriter];
        
        //延迟0.5秒,避免第一帧黑屏
        double delayToStartRecording = 0.5;
        dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
        dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
            //给录制的视频加上音频
            self.imageVideoCamera.audioEncodingTarget = self.movieWriter;
            //确定写入方向
//            [self.movieWriter startRecordingInOrientation:CGAffineTransformMakeRotation(-90 / 180.0 * M_PI )];
            //开始录制
            [self.movieWriter startRecording];
        });
    }];
}

//3,完成录制视频
- (void)finishRecordingWithCompletionHandler:(void (^)(void))handler {
    [self stopRecordingWithCompletionHandler:^{ //.1结束录制视频
        [self pauseCameraCapture];      //.2暂停摄像头
        [self startPreviewRecordVideo]; //.3预览视频
        if (handler) {
            handler();
        }
    }];
}

//4,预览视频
- (void)startPreviewRecordVideo {
        if (!self.videoPlayer) {
            self.videoPlayer = [[ENAVPlayerView alloc] initWithFrame:self.targetImageView.bounds targetView:self.targetImageView movieURL:[self documentMovieURL:NO]];
            self.videoPlayer.hidden = NO;
        }else{
            self.videoPlayer.hidden = NO;
            self.videoPlayer.movieURL = [self documentMovieURL:NO];
        }
}

//5,结束视频预览
- (void)stopPreviewRecordVideo {
    [self.videoPlayer stopVideoPlayer];
    self.videoPlayer.hidden = YES;
}

//结束录制视频
- (void)stopRecordingWithCompletionHandler:(void (^)(void))handler {
    [self.movieWriter finishRecordingWithCompletionHandler:^{
        NSString * moviePath = [self.moviePath path];
        if (!JZStringIsNull(moviePath)) {
            self.cameraModel = nil;
            [self.movieWriter.assetWriter.inputs enumerateObjectsUsingBlock:^(AVAssetWriterInput * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.mediaType == AVMediaTypeVideo) {
                    self.cameraModel.outputSettings = obj.outputSettings;
                }
                
            }];
            self.cameraModel.cameraVodeoLength = [self movieWriterDuration];
            self.cameraModel.cameraVodeoLocal = moviePath;
            self.cameraModel.cameraImage = [self firstFrameWithVideoURL:[self documentMovieURL:NO]];
        }
        [self.groupFilter removeTarget:self.movieWriter];
        self.imageVideoCamera.audioEncodingTarget = nil;
        self.movieWriter = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler();
            }
        });
        
    }];
}

#pragma mark ---- 获取图片第一帧 
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url 
{  
    // 获取视频第一帧  
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];  
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];  
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];  
    generator.appliesPreferredTrackTransform = YES;  
    
    if (self.cameraModel.videoWidth) {
        generator.maximumSize = CGSizeMake(self.cameraModel.videoWidth, self.cameraModel.videoHeight);
    }else {
        generator.maximumSize = CGSizeMake(kScreenWidth, kScreenHeight);  
    }
    NSError *error = nil;  
    CGImageRef cgImage = [generator copyCGImageAtTime:CMTimeMake(0.0, 30) actualTime:NULL error:&error];  
    if (error) {
        NSLog(@"%@",error);
        return nil;  
    }
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    if (image) {
        return image;
    }
    return nil;  
}

//3,暂停使用摄像头,不移除滤镜
- (void)pauseCameraCapture {
    [self.imageVideoCamera pauseCameraCapture];
}

//4,重新使用摄像头
- (void)resumeCameraCapture {
    self.cameraModel = nil;
    [self.imageVideoCamera resumeCameraCapture];
    [self stopPreviewRecordVideo];
}

//5,彻底结束摄像头
- (void)stopCameraCapture {
    [self.imageVideoCamera stopCameraCapture];
    [self.groupFilter removeAllTargets];
    [self.imageVideoCamera removeAllTargets];
}

- (CGFloat)movieWriterDuration{

    NSLog(@"%lld",self.movieWriter.duration.value/self.movieWriter.duration.timescale);
    NSLog(@"%f",ceil(self.movieWriter.duration.value/self.movieWriter.duration.timescale));
    NSLog(@"%f",(CGFloat)(self.movieWriter.duration.value));
    NSLog(@"%f",(CGFloat)(self.movieWriter.duration.timescale));
    return  ceil((CGFloat)(self.movieWriter.duration.value)/(CGFloat)(self.movieWriter.duration.timescale));
}

- (void)addGPUImageFilter:(GPUImageOutput<GPUImageInput> *)filter {
    [self.groupFilter addFilter:filter];
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    NSInteger count = self.groupFilter.filterCount;
    
    if (count == 1) {
        self.groupFilter.initialFilters = @[newTerminalFilter];
        self.groupFilter.terminalFilter = newTerminalFilter;
    } else {
        GPUImageOutput<GPUImageInput> *terminalFilter    = self.groupFilter.terminalFilter;
        NSArray *initialFilters                          = self.groupFilter.initialFilters;
        [terminalFilter addTarget:newTerminalFilter];
        self.groupFilter.initialFilters = @[initialFilters[0]];
        self.groupFilter.terminalFilter = newTerminalFilter;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
            orient = UIInterfaceOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orient = UIInterfaceOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationPortrait:
            orient = UIInterfaceOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            orient = UIInterfaceOrientationPortraitUpsideDown;
            break;
            
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            orient = fromInterfaceOrientation;
            break;
    }
    self.imageVideoCamera.outputImageOrientation = orient;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; 
}

#pragma mark - 视频播放
- (NSURL *)documentMovieURL:(BOOL)isRemove{
    NSString * moviePath = [self.moviePath path];
    if (!JZStringIsNull(moviePath)) {
        if(isRemove){
            [JZFilePath removeDocumentDirectoryPath:moviePath];
//            NSError * err;
//            [[NSFileManager defaultManager] removeItemAtURL:self.moviePath error:&err];
//            if (err) {
//                NSLog(@"删除失败:%@",err);
//            }
        }
        return self.moviePath;
    }
    NSString *mainIMImageCacheDirectory = [JZFilePath mainIMImageCacheDirectory];
    
    [JZFilePath creatPathWithFilePath:mainIMImageCacheDirectory type:JZLocalFilePathTypeTemporary];

    NSString *pathMovie =[mainIMImageCacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[JZDataHandler currentTimeString]]];
    NSURL *movieURL = [NSURL fileURLWithPath:pathMovie];
    self.moviePath = movieURL;
    return movieURL;
}

- (GPUImageFilterGroup *)groupFilter{
    if (!_groupFilter) {
        _groupFilter = [[GPUImageFilterGroup alloc] init];
    }
    return _groupFilter;
}
- (GPUImageMovieWriter *)movieWriter{
    if (!_movieWriter) {
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self documentMovieURL:YES] size:CGSizeMake(1080.0, 1920.0) fileType:AVFileTypeMPEG4 outputSettings:nil];
        _movieWriter.assetWriter.movieFragmentInterval = kCMTimeInvalid;

    }
    return _movieWriter;
}

- (GPUImageView *)targetImageView{
    if (!_targetImageView) {
        _targetImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _targetImageView;
}
- (GPUImageStillCamera *)imageVideoCamera{
    if (!_imageVideoCamera) {
        _imageVideoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        _imageVideoCamera.outputImageOrientation = UIDeviceOrientationPortrait;
        _imageVideoCamera.horizontallyMirrorFrontFacingCamera = YES;
        _imageVideoCamera.horizontallyMirrorRearFacingCamera = NO;
        [_imageVideoCamera addAudioInputsAndOutputs];

    }
    return _imageVideoCamera;
}
- (ENCameraModel *)cameraModel {
    if (!_cameraModel) {
        _cameraModel = [[ENCameraModel alloc] init];
    }
    return _cameraModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
