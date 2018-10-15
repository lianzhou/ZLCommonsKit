//
//  JZRecordVideoViewController.h
//  e学云
//
//  Created by Mac mini on 2017/4/3.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZRecordVideoModel.h"
#import "JZBaseViewController.h"

@class JZRecordVideoViewController;
@protocol JZRecordVideoViewControllerDelegate <NSObject>

- (void)recordVideoEnd;


- (void)recordVideoControllerDidCancel:(JZRecordVideoViewController *)viewController completion: (void (^)(void))completion;

- (void)recordVideoControllerDidFinish:(JZRecordVideoViewController *)viewController sendRecord:(JZRecordVideoModel *)videoModel completion: (void (^)(void))completion;


@end

@interface JZRecordVideoViewController : JZBaseViewController

typedef NS_ENUM(NSInteger,CameraType) {
    CameraTypePicture = 1,//拍照
    CameraTypeRecored = 2,//摄像
};

@property (nonatomic , assign)CameraType    cameraType;

@property (nonatomic, assign) id <JZRecordVideoViewControllerDelegate> delegate;

@end
