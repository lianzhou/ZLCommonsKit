//
//  ENPhotoLibraryManager.m
//  JZImagePickerController
//
//  Created by li_chang_en on 2017/11/2.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENPhotoLibraryManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "JZSystemMacrocDefine.h"
#import "JZStringMacrocDefine.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "JZDataHandler.h"

@interface ENPhotoLibraryManager ()

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;

@end
@implementation ENPhotoLibraryManager


+ (instancetype)manager {
    static ENPhotoLibraryManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
#pragma mark - 获取所有的相册 PHFetchResult 或 ALAssetsGroup 的集合
- (void)getAllAlbums:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<ENAlbumModel *> *))completion{
    NSMutableArray *albumArr = [NSMutableArray array];
    if (iOS8Later) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        if (!allowPickingVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        if (!allowPickingImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                                                    PHAssetMediaTypeVideo];
 
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

        // 我的照片流 1.6.10重新加入..
        PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
        NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
        for (PHFetchResult *fetchResult in allAlbums) {
            for (PHAssetCollection *collection in fetchResult) {
                // 有可能是PHCollectionList类的的对象，过滤掉
                if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                if (fetchResult.count < 1) continue;
                
                if ([collection.localizedTitle containsString:@"Hidden"] || [collection.localizedTitle isEqualToString:@"已隐藏"]) continue;
                if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]) continue;
                if ([self isCameraRollAlbum:collection]) {
                    [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:YES] atIndex:0];
                } else {
                    [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:NO]];
                }
            }
        }
        if (completion && albumArr.count > 0) completion(albumArr);
    } else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil) {
                if (completion && albumArr.count > 0) completion(albumArr);
            }
            if ([group numberOfAssets] < 1) return;
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            
            if ([self isCameraRollAlbum:group]) {
                [albumArr insertObject:[self modelWithResult:group name:name isCameraRoll:YES] atIndex:0];
            } else if ([name isEqualToString:@"My Photo Stream"] || [name isEqualToString:@"我的照片流"]) {
                if (albumArr.count) {
                    [albumArr insertObject:[self modelWithResult:group name:name isCameraRoll:NO] atIndex:1];
                } else {
                    [albumArr addObject:[self modelWithResult:group name:name isCameraRoll:NO]];
                }
            } else {
                [albumArr addObject:[self modelWithResult:group name:name isCameraRoll:NO]];
            }
        } failureBlock:nil];
    }
}
- (ENAlbumModel *)modelWithResult:(id)result name:(NSString *)name isCameraRoll:(BOOL)isCameraRoll {
    ENAlbumModel *model = [[ENAlbumModel alloc] init];
    model.result = result;
    model.name = name;
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *group = (ALAssetsGroup *)result;
        model.count = [group numberOfAssets];
    }
    return model;
}
- (BOOL)isCameraRollAlbum:(id)metadata {
    if ([metadata isKindOfClass:[PHAssetCollection class]]) {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
    if ([metadata isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *group = metadata;
        return ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos);
    }
    
    return NO;
}
#pragma mark - 获取一个相册的所有图片的实体类 <PHAsset> 或 <ALAsset> 的集合

- (void)getAllAssetWithAlbums:(ENAlbumModel *)albumModel selectedModels:(NSMutableArray<ENAssetModel *> *)selectedModels allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<ENAssetModel *> *))completion {
   
    NSMutableArray <ENAssetModel *>*photoList = [@[] mutableCopy];
    if ([albumModel.result isKindOfClass:[PHFetchResult class]]) {
        
        NSMutableArray <PHAsset *>*selectedAssets = [@[] mutableCopy];
        for (ENAssetModel *assetModel in selectedModels) {
            [selectedAssets addObject:assetModel.asset];
        }
        PHFetchResult *fetchResult = (PHFetchResult *)albumModel.result;
        [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset* asset, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([selectedAssets containsObject:asset]) {
                NSInteger index = [selectedAssets indexOfObject:asset];
                ENAssetModel *assetModel  = [selectedModels objectAtIndex:index];
                if (assetModel) {
                    [photoList addObject:assetModel];
                }
            }else{
                ENAssetModel * assetModel = [self assetModelWithAsset:asset allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage];
                if (assetModel) {
                    [photoList addObject:assetModel];
                }
            }
        }];
    }else if ([albumModel.result isKindOfClass:[ALAssetsGroup class]]) {
        
        NSMutableArray *selectedAssetUrls = [@[] mutableCopy];
        for (ENAssetModel *assetModel in selectedModels) {
            ALAsset *asset_item = (ALAsset *)assetModel.asset;
            [selectedAssetUrls addObject:[asset_item valueForProperty:ALAssetPropertyURLs]];
        }
        ALAssetsGroup *group = (ALAssetsGroup *)albumModel.result;
        if (allowPickingImage && allowPickingVideo) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
        } else if (allowPickingVideo) {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
        } else if (allowPickingImage) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        }
        ALAssetsGroupEnumerationResultsBlock resultBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop)  {
            if (result == nil) {
                if (completion) completion(photoList);
            }
            if ([selectedAssetUrls containsObject:[result valueForProperty:ALAssetPropertyURLs]]) {
                NSInteger index = [selectedAssetUrls indexOfObject:[result valueForProperty:ALAssetPropertyURLs]];
                ENAssetModel *assetModel  = [selectedModels objectAtIndex:index];
                if (assetModel) {
                    [photoList addObject:assetModel];
                }
                
            }else{
                ENAssetModel *assetModel = [self assetModelWithAsset:result allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage];
                if (assetModel) {
                    [photoList addObject:assetModel];
                }  
            }
            
        };
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (resultBlock) { resultBlock(result,index,stop); }
        }];
    }
    if (completion) completion(photoList);

}
- (ENAssetModel *)assetModelWithAsset:(id)asset allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage {
    BOOL canSelect = YES;
    if (!canSelect) return nil;
    
    ENAssetModelMediaType type = [self getAssetType:asset];
    if ([asset isKindOfClass:[PHAsset class]]) {
        if (!allowPickingVideo && type == ENAssetModelMediaTypeVideo) return nil;
        if (!allowPickingImage && type == ENAssetModelMediaTypePhoto) return nil;
        if (!allowPickingImage && type == ENAssetModelMediaTypePhotoGif) return nil;
        
        PHAsset *phAsset = (PHAsset *)asset;
        ENAssetModel * assetModel = [[ENAssetModel alloc]init];
        assetModel.asset = phAsset;
        assetModel.type = type;
        assetModel.duration = type == ENAssetModelMediaTypeVideo ? [[NSNumber numberWithDouble:phAsset.duration] intValue] : 0;
        assetModel.pixelWidth = phAsset.pixelWidth;
        assetModel.pixelHeight = phAsset.pixelHeight;
        
        return assetModel;
    } else if([asset isKindOfClass:[ALAsset class]]){
        
        ALAssetRepresentation *representation = [(ALAsset *)asset defaultRepresentation];
        CGSize dimension = [representation dimensions];
        if (!allowPickingVideo){
            
            ENAssetModel * assetModel = [[ENAssetModel alloc]init];
            assetModel.asset = asset;
            assetModel.type = type;
            assetModel.duration = -1;
            assetModel.pixelWidth = dimension.width;
            assetModel.pixelHeight = dimension.height;

            return assetModel;
        }
        if (type == ENAssetModelMediaTypeVideo) {
            NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
            
            ENAssetModel * assetModel = [[ENAssetModel alloc]init];
            assetModel.asset = asset;
            assetModel.type = type;
            assetModel.duration = [[NSString stringWithFormat:@"%.0f",duration] intValue];
            assetModel.pixelWidth = dimension.width;
            assetModel.pixelHeight = dimension.height;
            return assetModel;
        }else {
            
            ENAssetModel * assetModel = [[ENAssetModel alloc]init];
            assetModel.asset = asset;
            assetModel.type = type;
            assetModel.duration = 0;
            assetModel.pixelWidth = dimension.width;
            assetModel.pixelHeight = dimension.height;
            return assetModel; 
        }
    }
    return nil;
}
#pragma mark - 获取图片类型 
- (ENAssetModelMediaType)getAssetType:(id)asset {
    ENAssetModelMediaType type = ENAssetModelMediaTypePhoto;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        if (phAsset.mediaType == PHAssetMediaTypeVideo)      type = ENAssetModelMediaTypeVideo;
        else if (phAsset.mediaType == PHAssetMediaTypeAudio) type = ENAssetModelMediaTypeAudio;
        else if (phAsset.mediaType == PHAssetMediaTypeImage) {
            if (iOS9_1Later) {
                if (phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                    type = ENAssetModelMediaTypeLivePhoto;
                }
            }
            if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                type = ENAssetModelMediaTypePhotoGif;
            }
        }
    } else {
        if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
            type = ENAssetModelMediaTypeVideo;
        }
    }
    return type;
}

#pragma mark - 从 <PHAsset> 或 <ALAsset> 获取(下载)图片 
- (int32_t)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    
//    CGFloat  scale =  [UIScreen mainScreen].scale;
//    CGFloat maxPhotoWidth = [UIScreen mainScreen].bounds.size.width*(scale>2?2:scale);
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;

        CGSize imageSize;
  
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        if (JZ_IPHONE_X) {
            imageSize = CGSizeMake(photoWidth / 1.5, photoWidth / 1.5 * aspectRatio);
        }else{
            imageSize = CGSizeMake(photoWidth, photoWidth * aspectRatio);
        }

//        if (photoWidth < maxPhotoWidth) {
//            imageSize = CGSizeMake(photoWidth, photoWidth * aspectRatio);
//        } else {
//            CGFloat pixelWidth = maxPhotoWidth;
//            // 超宽图片
//            if (aspectRatio > 1.8) {
//                pixelWidth = pixelWidth * aspectRatio;
//            }
//            // 超高图片
//            if (aspectRatio < 0.2) {
//                pixelWidth = pixelWidth * 0.5;
//            }
//            CGFloat pixelHeight = pixelWidth / aspectRatio;
//            imageSize = CGSizeMake(pixelWidth, pixelHeight);
//        }
        
        __block UIImage *image;
        // 修复获取图片时出现的瞬间内存过高问题
        // 下面两行代码，来自hsjcom，他的github是：https://github.com/hsjcom 表示感谢
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                image = result;
            }
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                result = [self fixOrientation:result];
                if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
            // Download image from iCloud / 从iCloud下载图片
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result && networkAccessAllowed) {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress, error, stop, info);
                        }
                    });
                };
                options.networkAccessAllowed = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                    resultImage = [self scaleImage:resultImage toSize:imageSize];
                    if (!resultImage) {
                        resultImage = image;
                    }
                    resultImage = [self fixOrientation:resultImage];
                    if (completion) completion(resultImage,info,NO);
                }];
            }
        }];
        return imageRequestID;
    } else if ([asset isKindOfClass:[ALAsset class]]) {

        ALAsset *alAsset = (ALAsset *)asset;
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            CGImageRef thumbnailImageRef = alAsset.thumbnail;
            UIImage *thumbnailImage = [UIImage imageWithCGImage:thumbnailImageRef scale:2.0 orientation:UIImageOrientationUp];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(photoWidth < thumbnailImage.size.width){
                    if (completion) completion(thumbnailImage,nil,YES);
                }else{
                    dispatch_async(dispatch_get_global_queue(0,0), ^{
                        ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
                        CGImageRef fullScrennImageRef = [assetRep fullScreenImage];
                        UIImage *fullScrennImage = [UIImage imageWithCGImage:fullScrennImageRef scale:2.0 orientation:UIImageOrientationUp];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) completion(fullScrennImage,nil,NO);
                        });
                    });
                }
            });
        });
    }
    return 0;
}
- (NSString *)getAssetIdentifier:(ENAssetModel *)assetModel {
    if (iOS8Later) {
        PHAsset *phAsset = (PHAsset *)assetModel.asset;
        return phAsset.localIdentifier;
    } else {
        ALAsset *alAsset = (ALAsset *)assetModel.asset;
        NSURL *assetUrl = [alAsset valueForProperty:ALAssetPropertyAssetURL];
        return assetUrl.absoluteString;
    }
}
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}
/// 修正图片转向
- (UIImage *)fixOrientation:(UIImage *)aImage {    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 授权
/// 如果得到了授权返回YES
- (BOOL)authorizationStatusAuthorized:(void (^)(void))completion {
    NSInteger status = [self.class authorizationStatus];
    if (status == 0) {
        /**
         * 当某些情况下AuthorizationStatus == AuthorizationStatusNotDetermined时，无法弹出系统首次使用的授权alertView，系统应用设置里亦没有相册的设置，此时将无法使用，故作以下操作，弹出系统首次使用的授权alertView
         */
        [self requestAuthorizationWithCompletion:^{
            
        }];
    }
    
    return status == 3;
}
+ (NSInteger)authorizationStatus {
    if (iOS8Later) {
        return [PHPhotoLibrary authorizationStatus];
    } else {
        return [ALAssetsLibrary authorizationStatus];
    }
    return NO;
}
- (void)requestAuthorizationWithCompletion:(void (^)(void))completion {
    void (^callCompletionBlock)(void) = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    };
    
    if (iOS8Later) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                callCompletionBlock();
            }];
        });
    } else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            callCompletionBlock();
        } failureBlock:^(NSError *error) {
            callCompletionBlock();
        }];
    }
}
#pragma mark - 保存Gif
- (void)savePhotoWithImage:(UIImage *)image  completion:(void (^)(ENAssetModel * assetModel))completion failure:(void (^)(NSString *error))failure{
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    [self savePhotoWithImageData:data completion:completion failure:failure];
}
- (void)savePhotoWithImageData:(NSData *)data  completion:(void (^)(ENAssetModel * assetModel))completion failure:(void (^)(NSString *error))failure{
    [self savePhotoWithImageData:data GIF:NO location:nil completion:completion failure:failure];
}
- (void)savePhotoWithImageData:(NSData *)data location:(CLLocation *)location completion:(void (^)(ENAssetModel * assetModel))completion failure:(void (^)(NSString *error))failure{
    [self savePhotoWithImageData:data GIF:NO location:location completion:completion failure:failure];
}
- (void)savePhotoWithImageData:(NSData *)data GIF:(BOOL)gif completion:(void (^)(ENAssetModel * assetModel))completion failure:(void (^)(NSString *error))failure{
    [self savePhotoWithImageData:data GIF:gif location:nil completion:completion failure:failure];
}
- (void)savePhotoWithImageData:(NSData *)data GIF:(BOOL)gif location:(CLLocation *)location completion:(void (^)(ENAssetModel * assetModel))completion failure:(void (^)(NSString *error))failure {
    
    [JZSystemUtils assetsAuthorizationStatusAuthorized:^{
        
        if (iOS9Later) {
            __block NSString *localIdentifier;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
                
                PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                options.shouldMoveFile = YES;
                PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
                [request addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
                if (location) {
                    request.location = location;
                }
                request.creationDate = [NSDate date];
                
//                PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
//                options.shouldMoveFile = YES;
//                PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
//                [request addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
//                if (location) {
//                    request.location = location;
//                }
//                request.creationDate = [NSDate date];
                localIdentifier = request.placeholderForCreatedAsset.localIdentifier;

            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil].firstObject;
                    ENAssetModel * assetModel = [[ENAssetModel alloc]init];
                    assetModel.asset = asset;
                    assetModel.type = [self getAssetType:asset];
                    assetModel.duration = -1;
                    assetModel.pixelWidth = asset.pixelWidth;
                    assetModel.pixelHeight = asset.pixelHeight;
                    assetModel.isSelected = YES;
                    if (completion) {
                        dispatch_async_on_main_queue(^{
                            completion(assetModel);
                        });
                    }
                }else {
                    if (JZStringIsNull(error.localizedDescription)) {
                        if (failure) {
                            dispatch_async_on_main_queue(^{
                                failure(@"未知原因,保存失败");
                            });

                        }
                    }else{
                        if (failure) {
                            dispatch_async_on_main_queue(^{
                                failure(error.localizedDescription);
                            });

                        }
                    }
                }
            
            }];
        }else {
            NSDictionary *metadata = @{@"UTI":(__bridge NSString *)kUTTypePNG} ;
            if (gif) {
                metadata = @{@"UTI":(__bridge NSString *)kUTTypeGIF};
            }
            // 开始写数据   
            [self.assetLibrary writeImageDataToSavedPhotosAlbum:data metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
                
                if (error) {
                    if (failure) {
                        dispatch_async_on_main_queue(^{

                            failure(error.localizedDescription);
                        });
                    }
                }else{
                    
                    [self.assetLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        ALAssetRepresentation *representation = [(ALAsset *)asset defaultRepresentation];
                        CGSize dimension = [representation dimensions];
                        ENAssetModel * assetModel = [[ENAssetModel alloc]init];
                        assetModel.asset = asset;
                        assetModel.type = [self getAssetType:asset];
                        assetModel.duration = -1;
                        assetModel.pixelWidth = dimension.width;
                        assetModel.pixelHeight = dimension.height;
                        assetModel.isSelected = YES;

                        if (completion) {
                            dispatch_async_on_main_queue(^{                           
                                completion(assetModel);
                            });

                        }
                        NSLog(@"成功保存到相册");

                    } failureBlock:^(NSError *error) {
                        if (failure) {
                            dispatch_async_on_main_queue(^{                                                     
                                failure(error.localizedDescription);
                            });
                        }
                    }];
                }
            }];
        }

    } restricted:^{
        if (failure) {
            failure(@"没有保存权限,请前往设置");
        }
    }];

    
    
}

#pragma mark - 获取视频去播放

- (void)getVideoWithAsset:(id)asset completion:(void (^)(AVPlayerItem *, NSDictionary *))completion {
    [self getVideoWithAsset:asset progressHandler:nil completion:completion];
}

- (void)getVideoWithAsset:(id)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(AVPlayerItem *, NSDictionary *))completion {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
        option.networkAccessAllowed = YES;
        option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressHandler) {
                    progressHandler(progress, error, stop, info);
                }
            });
        };
        [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:option resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
            if (completion) completion(playerItem,info);
        }];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = (ALAsset *)asset;
        ALAssetRepresentation *defaultRepresentation = [alAsset defaultRepresentation];
        NSString *uti = [defaultRepresentation UTI];
        NSURL *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:videoURL];
        if (completion && playerItem) completion(playerItem,nil);
    }
}

#pragma mark - Export video

/// Export Video / 导出视频
- (void)getVideoOutputPathWithAsset:(id)asset completion:(void (^)(NSString *outputPath))completion {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
            // NSLog(@"Info:\n%@",info);
            AVURLAsset *videoAsset = (AVURLAsset*)avasset;
            // NSLog(@"AVAsset URL: %@",myAsset.URL);
            [self startExportVideoWithVideoAsset:videoAsset completion:completion];
        }];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        NSURL *videoURL =[asset valueForProperty:ALAssetPropertyAssetURL]; // ALAssetPropertyURLs
        AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        [self startExportVideoWithVideoAsset:videoAsset completion:completion];
    }
}

- (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset completion:(void (^)(NSString *outputPath))completion {
    // Find compatible presets by video asset.
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    

    if ([presets containsObject:AVAssetExportPreset640x480]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:videoAsset presetName:AVAssetExportPreset640x480];
        
        NSString *outputPath = [[self documentMovieURL] path];
        session.outputURL = [NSURL fileURLWithPath:outputPath];
        
        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        AVMutableVideoComposition *videoComposition = [self fixedCompositionWithAsset:videoAsset];
        if (videoComposition.renderSize.width) {
            // 修正视频转向
            session.videoComposition = videoComposition;
        }
        
        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (session.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"AVAssetExportSessionStatusUnknown"); break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"AVAssetExportSessionStatusWaiting"); break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting"); break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) {
                            completion(outputPath);
                        }
                    });
                }  break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed"); break;
                default: break;
            }
        }];
    }
}
- (NSURL *)documentMovieURL{
    NSString *mainIMImageCacheDirectory = [JZFilePath mainIMImageCacheDirectory];
    [JZFilePath creatPathWithFilePath:mainIMImageCacheDirectory type:JZLocalFilePathTypeTemporary];
    NSString *pathMovie =[mainIMImageCacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[JZDataHandler currentTimeString]]];
    NSURL *movieURL = [NSURL fileURLWithPath:pathMovie];
    return movieURL;
}

- (ALAssetOrientation)orientationFromImage:(UIImage *)image {
    NSInteger orientation = image.imageOrientation;
    return orientation;
}

// 获取优化后的视频转向信息
- (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self degressFromVideoFileWithAsset:videoAsset];
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        videoComposition.frameDuration = CMTimeMake(1, 30);
        
        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // 加入视频方向信息
        videoComposition.instructions = @[roateInstruction];
    }
    return videoComposition;
}

/// 获取视频角度
- (int)degressFromVideoFileWithAsset:(AVAsset *)asset {
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

#pragma mark - 懒加载
- (ALAssetsLibrary *)assetLibrary {
    if (!_assetLibrary){
         _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetLibrary;
}

#pragma clang diagnostic pop

@end

