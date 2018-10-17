//
//  ENCameraViewController.h
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/10.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENImageVideoCameraViewController.h"

@class ENCameraViewController;
@protocol ENCameraViewControllerDelegate <NSObject>

@optional
- (void)viewController:(ENCameraViewController *)viewController cameraModel:(ENCameraModel *)cameraModel isVideo:(BOOL)isVideo;


//- (void)viewController:(ENCameraViewController *)viewController 
@end



@interface ENCameraViewController : ENImageVideoCameraViewController

/// 默认为YES，如果设置为NO,用户将不能选择发送图片
@property(nonatomic, assign) BOOL allowShootImage;
/// 默认为YES，如果设置为NO,用户将不能选择视频
@property (nonatomic, assign) BOOL allowShootVideo;
// 视频最大时长
@property (nonatomic, assign) CGFloat maxVideoTime;

@property (nonatomic, weak) id<ENCameraViewControllerDelegate> delegate;

@end
