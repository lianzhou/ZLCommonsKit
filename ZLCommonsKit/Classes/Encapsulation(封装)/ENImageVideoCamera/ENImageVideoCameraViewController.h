//
//  ENImageVideoCameraViewController.h
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/10.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <GPUImage/GPUImage.h>
#import <GPUImage/GPUImage.h>
#import "ENCameraModel.h"

@interface ENImageVideoCameraViewController : UIViewController


@property (nonatomic,copy,readonly) NSURL * moviePath;


@property (nonatomic,assign) CGFloat maxRecordTime;

@property(nonatomic,strong,readonly)ENCameraModel * cameraModel;

@property(nonatomic,strong)GPUImageStillCamera * imageVideoCamera;

@property (nonatomic, assign) int imageOrientation;

//重新使用摄像头
- (void)resumeCameraCapture;

//开始录制视频
- (void)startRecording;

//完成录制视频
- (void)finishRecordingWithCompletionHandler:(void (^)(void))handler;

//结束视频预览
- (void)stopPreviewRecordVideo;

- (void)capturePhotoInCameraCompletionHandler:(void (^)(void))handler failure:(void (^)(void))failure;
@end
