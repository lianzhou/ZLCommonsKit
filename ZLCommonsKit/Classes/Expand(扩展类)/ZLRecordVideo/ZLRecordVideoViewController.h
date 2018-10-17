//
//  ZLRecordVideoViewController.h
//  
//
//  Created by zhoulian on 2017/4/3.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLRecordVideoModel.h"
#import "ZLBaseViewController.h"

@class ZLRecordVideoViewController;
@protocol ZLRecordVideoViewControllerDelegate <NSObject>

- (void)recordVideoEnd;


- (void)recordVideoControllerDidCancel:(ZLRecordVideoViewController *)viewController completion: (void (^)(void))completion;

- (void)recordVideoControllerDidFinish:(ZLRecordVideoViewController *)viewController sendRecord:(ZLRecordVideoModel *)videoModel completion: (void (^)(void))completion;


@end

@interface ZLRecordVideoViewController : ZLBaseViewController

typedef NS_ENUM(NSInteger,CameraType) {
    CameraTypePicture = 1,//拍照
    CameraTypeRecored = 2,//摄像
};

@property (nonatomic , assign)CameraType    cameraType;

@property (nonatomic, assign) id <ZLRecordVideoViewControllerDelegate> delegate;

@end
