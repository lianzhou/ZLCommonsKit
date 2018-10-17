//
//  ENImagePickerController.h
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/1.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENAssetViewCell.h"
#import "ENPhotoLibraryManager.h"
#import "ENCameraModel.h"

@class ENImagePickerController;
@protocol ENImagePickerControllerDelegate <NSObject>
@optional

- (void)imagePickerController:(ENImagePickerController *)picker didFinishPickingImageList:(NSMutableArray<UIImage *> *)imageList;

- (void)imagePickerController:(ENImagePickerController *)picker didFinishPickingImageList:(NSMutableArray<UIImage *> *)imageList infoArr:(NSArray *)infoArr;

- (void)imagePickerController:(ENImagePickerController *)picker didFinishPickingImageList:(NSMutableArray<UIImage *> *)imageList assetModelList:(NSMutableArray<ENAssetModel *> *)assetModelList infoArr:(NSArray *)infoArr;


- (void)imagePickerController:(ENImagePickerController *)picker didFinishVideoModel:(ENCameraModel *)videoModel;


- (void)imagePickerController:(ENImagePickerController *)picker failure:(NSString *)failure;

    
@end

@interface ENImagePickerController : UIViewController

/// 默认为YES，如果设置为NO,用户将不能选择发送图片
@property(nonatomic, assign) BOOL allowPickingImage;

/// 默认为YES，如果设置为NO,用户将不能选择视频
@property (nonatomic, assign) BOOL allowPickingVideo;

/// 默认为NO，如果设置为YES,可以裁剪
@property (nonatomic, assign) BOOL allowsEditing;


//一行多少个
@property (nonatomic, assign) NSInteger columnNumber;
// 最小照片必选张数,默认是0
@property (nonatomic, assign) NSInteger minImagesCount;
// 最小照片必选张数,默认是9
@property (nonatomic, assign) NSInteger maxImagesCount;
// 最小视频必选张数,默认是1
@property (nonatomic, assign) NSInteger maxVideosCount;
// 视频长度
@property (nonatomic, assign) CGFloat maxVideosTime;
// 用户选中过的图片数组
@property (nonatomic, strong) NSMutableArray<ENAssetModel *> *selectedModels;

@property (nonatomic, weak) id <ENImagePickerControllerDelegate> delegate;

@end
