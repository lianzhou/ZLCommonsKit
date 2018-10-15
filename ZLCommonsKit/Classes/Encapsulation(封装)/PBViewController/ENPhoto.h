//
//  ENPhoto.h
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/8.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ENAlbumModel.h"
#import "ENPhotoLibraryManager.h"
@interface ENPhoto : NSObject

@property (nonatomic, strong) UIImage *underlyingImage;

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic) BOOL isVideo;
@property (nonatomic, assign) BOOL isDownLoad;

@property (nonatomic, strong,readonly) ENAssetModel *assetModel;

+ (ENPhoto *)photoWithImage:(UIImage *)image;
+ (ENPhoto *)photoWithURL:(NSURL *)url;
+ (ENPhoto *)photoWithAsset:(ENAssetModel *)asset;
+ (ENPhoto *)videoWithURL:(NSURL *)url; // Initialise video with no poster image

- (id)init;
- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url;
- (id)initWithAsset:(ENAssetModel *)asset;
- (id)initWithVideoURL:(NSURL *)url;


- (void)loadUnderlyingImageAndNotify;
- (void)_performLoadUnderlyingImageAndNotifyWithOriginalWebURL:(NSURL *)url;
@end
