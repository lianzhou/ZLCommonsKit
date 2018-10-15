//
//  ENAlbumModel.h
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/3.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ENAssetModelMediaTypePhoto = 0,
    ENAssetModelMediaTypeLivePhoto,
    ENAssetModelMediaTypePhotoGif,
    ENAssetModelMediaTypeVideo,
    ENAssetModelMediaTypeAudio
} ENAssetModelMediaType;

@interface ENAlbumModel : NSObject
// 相册名字
@property (nonatomic, strong) NSString *name;   
// 照片个数
@property (nonatomic, assign) NSInteger count;       
// PHFetchResult 或 ALAssetsGroup
@property (nonatomic, strong) id result;         

// <PHAsset> 或 <ALAsset>的集合
@property (nonatomic, strong) NSArray *models;
//当前相册所选<PHAsset> 或 <ALAsset> 个数
@property (nonatomic, assign) NSUInteger selectedCount;

@end

@interface ENAssetModel : NSObject

// <PHAsset> 或 <ALAsset> 
@property (nonatomic, strong) id asset;
// 默认是NO
@property (nonatomic, assign) BOOL isSelected; 
@property (nonatomic, assign) ENAssetModelMediaType type;
@property (nonatomic, assign) int duration;
@property (nonatomic, assign) NSInteger  count;

@property (nonatomic, assign) NSUInteger pixelWidth;
@property (nonatomic, assign) NSUInteger pixelHeight;

@property (nonatomic,copy)dispatch_block_t changeSelectImageCount;

- (void)changeSelectImageCount:(NSInteger)count;

@end
