//
//  ENCameraViewController.m
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/10.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENCameraViewController.h"
#import <Masonry/Masonry.h>
#import "ENProgressView.h"
#import "UIImage+Picker.h"
#import "ZLAlertHUD.h"
#import "ENPhotoLibraryManager.h"
#import "ZLSystemUtils.h"
#import "ZLSystemMacrocDefine.h"
#import "ZLBaseNavigationController.h"
#import "ZLBaseTabBarController.h"
#import "UIImage+ZLTintColor.h"

@interface ENCameraViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong) ENProgressView * progressView;
@property(nonatomic,strong) UIButton *backButton;
@property(nonatomic,strong) UIButton *afreshButton;
@property(nonatomic,strong) UIButton *sureButton;
//@property(nonatomic,strong) UIButton *flashButton;
@property(nonatomic,strong) UIButton *frontButton;


@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
//是否是摄像 YES 代表是录制  NO 表示拍照
@property (assign, nonatomic) BOOL isVideo;
//视频拍摄是否结束
@property (assign, nonatomic) BOOL isVideoEnd;

//是否正在录制视频
@property (assign, nonatomic) BOOL isRecordVide;


@property (nonatomic,assign) CGFloat currentRecordTime;

@end

@implementation ENCameraViewController


- (void)dealloc{
    NSLog(@"ENCameraViewController");
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        _isVideo = NO;
        _isVideoEnd = NO;
        _isRecordVide = NO;
        _currentRecordTime = 0.0f;
        self.maxRecordTime = 15.0f;
        _allowShootVideo = YES;
        _allowShootImage = YES;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissViewControllerCompletion) name:@"ZLNotificationTypeWillLogInOut" object:nil];

//    [self.view addSubview:self.flashButton];
    [self.view addSubview:self.frontButton];

    [self.view addSubview:self.backButton];
    [self.view addSubview:self.afreshButton];
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.progressView];

    [self makeConstraints];
    
    if (_allowShootImage == YES) {
        [self.view addGestureRecognizer:self.singleTapGestureRecognizer];
    }
    if (_allowShootVideo == YES) {
        [self.view addGestureRecognizer:self.longPressGestureRecognizer];
        [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.longPressGestureRecognizer];
    }

}
- (void)dismissViewControllerCompletion{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)makeConstraints {
    
    
    [self.frontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ZL_IPHONE_X) make.bottom.mas_equalTo(self.view.mas_top).mas_offset([ZLSystemUtils obtainStatusHeight] + 60);
        else make.bottom.mas_equalTo(self.view.mas_top).mas_offset([ZLSystemUtils obtainStatusHeight] + 30);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
//    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.frontButton.mas_top);
//        make.right.mas_equalTo(self.frontButton.mas_left).mas_offset(-20);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
//    }];
//

    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (ZL_IPHONE_X) make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-120);
        else make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-50);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(([UIScreen mainScreen].bounds.size.width-107)/2/2-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.sureButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-[UIScreen mainScreen].bounds.size.width/2+20);
    }];
    [self.afreshButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.left.mas_equalTo(self.view.mas_left).mas_offset([UIScreen mainScreen].bounds.size.width/2-20);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.backButton);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
}

#pragma mark - Actions

- (void)frontButtonButtonClick:(UIButton *)sender {

    //切换前后置摄像头
    [self.imageVideoCamera rotateCamera];
}

- (void)backButtonButtonClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)afreshButtonButtonClick:(UIButton *)sender {
    self.isVideoEnd = NO;
    self.isVideo = NO;
    self.frontButton.hidden = NO;
    [self.progressView updateWidthConstraints:75 completion:^(BOOL finished) {
        [self resumeCameraCapture];
        [self showAnimateCameraButton:YES];
    }];
}
- (void)sureButtonButtonClick:(UIButton *)sender {
    //记录拍照瞬间的手机状态
   
    [self saveCameraDataWithImageCompletion:^{
        [self stopPreviewRecordVideo];
    } failure:^(NSString *error) {
        
    }];
    
}
- (void)saveCameraDataWithImageCompletion:(void (^)(void))completion failure:(void (^)(NSString *error))failure{
    if (self.isVideo) {
        [self saveVideoWithImageCompletion:completion failure:failure];
    }else{
        [self savePhotoWithImageCompletion:completion failure:failure];
    }
}
- (void)savePhotoWithImageCompletion:(void (^)(void))completion failure:(void (^)(NSString *error))failure{
    [ZLAlertHUD showHUDTitle:@"保存中..." toView:self.view];
    UIImage *image = [UIImage fixOrientation:self.cameraModel.cameraImage rotation:self.imageOrientation];
    [[ENPhotoLibraryManager manager] savePhotoWithImage:image completion:^(ENAssetModel *assetModel) {
        [ZLAlertHUD hideHUD:self.view];
        if (completion) {
            completion();
        }
        self.cameraModel.cameraImage = image;
        self.cameraModel.assetModel = assetModel;
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:cameraModel:isVideo:)]) {
            [self.delegate viewController:self cameraModel:self.cameraModel isVideo:self.isVideo];
        }
        
    } failure:^(NSString *error) {
        if (failure) {
            failure(error);
        }
        [ZLAlertHUD hideHUD:self.view];

    }];
}

- (void)saveVideoWithImageCompletion:(void (^)(void))completion failure:(void (^)(NSString *error))failure{

    if (completion) {
        completion();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewController:cameraModel:isVideo:)]) {
        [self.delegate viewController:self cameraModel:self.cameraModel isVideo:self.isVideo];
    }

}

- (void)handleSingleTapAction:(UITapGestureRecognizer *)sender {

//    [self useAccelerometerPull];
    //判断区域
    sender.enabled = NO;
    CGPoint point = [sender locationInView:self.view];
    if (!(CGRectContainsPoint(self.progressView.frame, point))) {
        sender.enabled = YES;
        return;
    }
    NSLog(@"---点击");
    if (self.frontButton.hidden == YES) {
        sender.enabled = YES;
        return;
    }
    self.frontButton.hidden = YES;

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.isVideoEnd = YES;

    }else if (sender.state == UIGestureRecognizerStateEnded) {
        self.isVideo = NO;
        [self capturePhotoInCameraCompletionHandler:^{
            sender.enabled = YES;

            [self showAnimateCameraButton:NO];
            return;
        } failure:^{
            sender.enabled = YES;
            self.isVideoEnd = NO;
        }];
        return;
    }
}

- (void)onStartCountdown {
    if (self.maxVideoTime && self.maxVideoTime > 0) {
        self.maxRecordTime = self.maxVideoTime;
    }
    self.currentRecordTime +=0.1;
    if (self.currentRecordTime >= self.maxRecordTime) {
        [self onStopCountdown];
    }
   
    if (!self.isVideoEnd) {
        [self performSelector:@selector(onStartCountdown) withObject:nil afterDelay:0.1];
    }
    self.progressView.progress = (self.currentRecordTime/self.maxRecordTime)*100;
    
}

//结束动画,结束录制
- (void)onStopCountdown{
    if (self.currentRecordTime <= 2.0f) {
        self.isVideoEnd = NO;
        self.currentRecordTime = 0.0f;
        self.progressView.progress = self.currentRecordTime;
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(onStartCountdown) object:nil];
        [ZLAlertHUD showTipTitle:@"录制时间过短"];
        return;
    }
    self.frontButton.hidden = YES;
    self.isVideoEnd = YES;
    self.currentRecordTime = 0.0f;
    self.progressView.progress = self.currentRecordTime;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(onStartCountdown) object:nil];
    [self finishRecordingWithCompletionHandler:^{
        [self showAnimateCameraButton:NO];
    }];
}
- (void)handleLongPressAction:(UILongPressGestureRecognizer *)sender {
    
    //判断区域
    CGPoint point = [sender locationInView:self.view];
    if (!(CGRectContainsPoint(self.progressView.frame, point))) {
        if (self.isRecordVide) {
            self.isRecordVide = NO;
            [self.progressView updateWidthConstraints:75 completion:^(BOOL finished) {
                [self onStopCountdown];
                return;
            }];
        }
        return;
    }
    
    if ((sender.state == UIGestureRecognizerStateBegan)) {
        
        self.cameraModel.isPortrait = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]);
        
        if (self.isVideoEnd) {
            return;
        }
        self.isRecordVide = YES;

        self.isVideo = YES;
        [self.progressView updateWidthConstraints:120 completion:^(BOOL finished) {
            [self startRecording];
            [self performSelector:@selector(onStartCountdown) withObject:nil];
        }];

    }else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.isVideoEnd) {
            return;
        }
        self.isRecordVide = NO;
        self.isVideoEnd = YES;
        [self.progressView updateWidthConstraints:75 completion:^(BOOL finished) {
            [self onStopCountdown];
            return;
        }];
        return;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.isVideoEnd) {
        return NO;
    }
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(self.progressView.frame, point)) {
        return YES;
    }
    return NO;
}
- (void)showAnimateCameraButton:(BOOL)show{
    [self updateShowButtonConstraints:show];
    [UIView animateWithDuration:0.25 animations:^{
        [self showCameraButton:show];
    }completion:^(BOOL finished) {
        
    }];
}
- (void)updateShowButtonConstraints:(BOOL)show {
    CGFloat afresh_offset = show?([UIScreen mainScreen].bounds.size.width/2.0f-20.0f):50.0f;
    [self.afreshButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(afresh_offset);
    }];
    
    CGFloat sure_offset = show?(-[UIScreen mainScreen].bounds.size.width/2.0f+20.0f):-50.0f;
    [self.sureButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(sure_offset);
    }];
}
- (void)showCameraButton:(BOOL)show{
    
    CGFloat hiddenAlpha = show?1.0:0.0;
    CGFloat showAlpha   = !show?1.0:0.0;
    
    self.afreshButton.hidden = show;
    self.sureButton.hidden = show;
    self.afreshButton.alpha = hiddenAlpha;
    self.sureButton.alpha = hiddenAlpha;
    
    self.backButton.hidden = !show;
    self.progressView.hidden = !show;
    self.afreshButton.alpha = showAlpha;
    self.sureButton.alpha = showAlpha;
    [self.view layoutIfNeeded];

}



#pragma mark - 懒加载

- (UITapGestureRecognizer *)singleTapGestureRecognizer {
    if (!_singleTapGestureRecognizer) {
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapAction:)];
        _singleTapGestureRecognizer.delegate = self;
    }
    return _singleTapGestureRecognizer;
}

- (UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (!_longPressGestureRecognizer) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAction:)];
//        _longPressGestureRecognizer.minimumPressDuration = 3.0f;
        _longPressGestureRecognizer.delegate = self;
    }
    return _longPressGestureRecognizer;
}

- (ENProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[ENProgressView alloc] init];
    }
    return _progressView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(backButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamedWithPickerName:@"lce_camera_video_back"] forState:UIControlStateNormal];
    }
    return _backButton;
}
- (UIButton *)afreshButton{
    if (!_afreshButton) {
        _afreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_afreshButton addTarget:self action:@selector(afreshButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_afreshButton setImage:[UIImage imageNamedWithPickerName:@"lce_camera_video_afresh"] forState:UIControlStateNormal];
        _afreshButton.hidden = YES;
        _afreshButton.alpha = 0.0f;
    }
    return _afreshButton;
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton addTarget:self action:@selector(sureButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setImage:[UIImage imageNamedWithPickerName:@"lce_camera_video_confirm"] forState:UIControlStateNormal];
        _sureButton.hidden = YES;
        _sureButton.alpha = 0.0f;
    }
    return _sureButton;
}
//- (UIButton *)flashButton{
//    if (!_flashButton) {
//        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_flashButton addTarget:self action:@selector(afreshButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_flashButton setImage:[UIImage imageNamedWithPickerName:@"lce_camera_video_afresh"] forState:UIControlStateNormal];
//    }
//    return _flashButton;
//}
- (UIButton *)frontButton{
    if (!_frontButton) {
        _frontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_frontButton addTarget:self action:@selector(frontButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_frontButton setImage:[UIImage imageNamedWithPickerName:@"lce_camera_video_fontCamera"] forState:UIControlStateNormal];
    }
    return _frontButton;
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
