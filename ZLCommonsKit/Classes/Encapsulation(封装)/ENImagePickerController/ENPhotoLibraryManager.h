//
//  ENPhotoLibraryManager.h
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/2.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ENAlbumModel.h"

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@interface ENPhotoLibraryManager : NSObject

- (BOOL)authorizationStatusAuthorized:(void (^)(void))completion;

+ (instancetype)manager NS_SWIFT_NAME(default());

#pragma mark - 获取所有的相册 PHFetchResult 或 ALAssetsGroup 的集合

- (void)getAllAlbums:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<ENAlbumModel *> *))completion;

#pragma mark - 获取一个相册的所有图片的实体类 <PHAsset> 或 <ALAsset> 的集合

- (void)getAllAssetWithAlbums:(ENAlbumModel *)albumModel selectedModels:(NSMutableArray<ENAssetModel *> *)selectedModels allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<ENAssetModel *> *))completion;

#pragma mark - 从 <PHAsset> 或 <ALAsset> 获取(下载)图片 
- (int32_t)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

- (void)savePhotoWithImage:(UIImage *)image  completion:(void (^)(ENAssetModel * assetModel))completion failure:(void (^)(NSString *error))failure;

- (void)getVideoOutputPathWithAsset:(id)asset completion:(void (^)(NSString *outputPath))completion;

- (void)savePhotoWithImageData:(NSData *)data GIF:(BOOL)gif location:(CLLocation *)location completion:(void (^)(ENAssetModel * assetModel))completion failure:(void (^)(NSString *error))failure;

- (NSString *)getAssetIdentifier:(ENAssetModel *)assetModel;
@end

