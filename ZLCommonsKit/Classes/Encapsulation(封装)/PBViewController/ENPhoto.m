//
//  ENPhoto.m
//  ZLImagePickerController
//
//  Created by li_chang_en on 2017/11/8.
//  Copyright © 2017年 李长恩. All rights reserved.
//

#import "ENPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <SDWebImage/SDWebImageManager.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface ENPhoto () {
    PHImageRequestID _assetRequestID;
    PHImageRequestID _assetVideoRequestID;
    BOOL _loadingInProgress;
    
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong,readwrite) ENAssetModel *assetModel;
@property (nonatomic) CGSize assetTargetSize;

@end

@implementation ENPhoto
+ (ENPhoto *)photoWithImage:(UIImage *)image {
    return [[ENPhoto alloc] initWithImage:image];
}
+ (ENPhoto *)photoWithURL:(NSURL *)url {
    return [[ENPhoto alloc] initWithURL:url];
    
}
+ (ENPhoto *)photoWithAsset:(ENAssetModel *)asset{
    return [[ENPhoto alloc] initWithAsset:asset];
    
}
+ (ENPhoto *)videoWithURL:(NSURL *)url {
    return [[ENPhoto alloc] initWithVideoURL:url];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.image = image;
        [self setup];
    }
    return self;
};
- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.photoURL = url;
        [self setup];
    }
    return self;
}
- (id)initWithAsset:(ENAssetModel *)asset{
    self = [super init];
    if (self) {
        self.assetModel = asset;
        self.isVideo = asset.type == ENAssetModelMediaTypeVideo;
        [self setup];
    }
    return self;
}
- (id)initWithVideoURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.videoURL = url;
        self.isVideo = YES;
        [self setup];
    }
    return self;
}
- (void)setup {
    _loadingInProgress = NO;
    _assetRequestID = PHInvalidImageRequestID;
    _assetVideoRequestID = PHInvalidImageRequestID;
}
- (UIImage *)underlyingImage {
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify{
    if (_loadingInProgress) {
        return;
    }
    _loadingInProgress = YES;
    @try {
        if (self.underlyingImage) {
            [self imageLoadingComplete];
        } else {
            [self performLoadUnderlyingImageAndNotify];
        }
    }
    @catch (NSException *exception) {
        self.underlyingImage = nil;
        _loadingInProgress = NO;
        [self imageLoadingComplete];
    }
}
//下载图片
- (void)performLoadUnderlyingImageAndNotify {
    if (self.image) {
        self.underlyingImage = self.image;
        [self imageLoadingComplete];
    } else if (self.photoURL){
        //周连添加判断本地图片还是网络图片
        //NSLog(@"ENPhoto Scheme: %@", [self.photoURL scheme]);
        if([[self.photoURL scheme] isEqualToString:@"http"] || [[self.photoURL scheme] isEqualToString:@"https"]){
            [self _performLoadUnderlyingImageAndNotifyWithWebURL: _photoURL];
        }
        else{
            [self _performLoadUnderlyingImageAndNotifyWithLocalFileURL:_photoURL];
        }
        //        if ([_photoURL isFileReferenceURL]) {
        //            [self _performLoadUnderlyingImageAndNotifyWithLocalFileURL: _photoURL];
        //        } else {
        //            [self _performLoadUnderlyingImageAndNotifyWithWebURL: _photoURL];
        //        }
        
    }else if (self.assetModel){
        if ([self.assetModel.asset isKindOfClass:[PHAsset class]]){
            [self _performLoadUnderlyingImageAndNotifyWithAsset:(PHAsset *)self.assetModel.asset];
        }else if ([self.assetModel.asset isKindOfClass:[ALAsset class]]){
            [self _performLoadUnderlyingImageAndNotifyWithAssetsLibrary];
        }
    }else{
        
    }
}
// iOS 7.0从相册下载图片
- (void)_performLoadUnderlyingImageAndNotifyWithAssetsLibrary {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            @try {
                ALAsset *alAsset = (ALAsset *)self.assetModel.asset;
                ALAssetRepresentation *rep = [alAsset defaultRepresentation];
                CGImageRef iref = [rep fullScreenImage];
                if (iref) {
                    self.underlyingImage = [UIImage imageWithCGImage:iref];
                }
                [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
            }@catch (NSException *e) {
                [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
            }
        }
    });
}
// iOS 8.0及以上从相册下载图片
- (void)_performLoadUnderlyingImageAndNotifyWithAsset:(PHAsset *)asset{
    
    _assetRequestID = [[ENPhotoLibraryManager manager] getPhotoWithAsset:asset photoWidth:asset.pixelWidth completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.underlyingImage = photo;
            [self imageLoadingComplete];
        });
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        
    } networkAccessAllowed:YES];
    
}

//加载本地图片
- (void)_performLoadUnderlyingImageAndNotifyWithLocalFileURL:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            @try {
                self.underlyingImage = [UIImage imageWithContentsOfFile:url.path];
                if (!self->_underlyingImage) {
                    NSLog(@"Error loading photo from path: %@", url.path);
                }
            } @finally {
                [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
            }
        }
    });
}
//网络图片
- (void)_performLoadUnderlyingImageAndNotifyWithWebURL:(NSURL *)url {
    
    NSString *imageUrl = url.absoluteString;
    if ([imageUrl hasPrefix:@"http://dfs.img.ZLexueyun.com/"]) {
        imageUrl = [NSString stringWithFormat:@"%@%@",imageUrl,@"?imageView2/2/w/1080/h/1920"];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"dfs.img.ZLexueyun.com/" withString:@"dfs.view-img.ZLexueyun.com/"];
    }else if ([imageUrl hasPrefix:@"http://test.img.juziwl.cn/"]){
        imageUrl = [NSString stringWithFormat:@"%@%@",imageUrl,@"?imageView2/2/w/1080/h/1920"];
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"test.img.juziwl.cn/" withString:@"test.view-img.juziwl.cn/"];
    }
    [self _performLoadUnderlyingImageAndNotifyWithOriginalWebURL: [NSURL URLWithString:imageUrl]];
}

//网络图片
- (void)_performLoadUnderlyingImageAndNotifyWithOriginalWebURL:(NSURL *)url
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __weak typeof(self) weak_self = self;
    
    [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        weak_self.underlyingImage = image;
        [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
    }];;
    
}
- (void)imageLoadingComplete {
    _loadingInProgress = NO;
    [self performSelector:@selector(postCompleteNotification) withObject:nil afterDelay:0];
}
- (void)postCompleteNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ENPHOTO_LOADING_DID_END_NOTIFICATION"
                                                        object:self];
}
@end

#pragma clang diagnostic pop

