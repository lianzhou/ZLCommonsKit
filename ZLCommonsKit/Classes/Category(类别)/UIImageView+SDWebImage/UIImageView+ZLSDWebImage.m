//
//  UIImageView+ZLSDWebImage.m
//  Pods
//
//  Created by wangjingfei on 2017/8/26.
//
//

#import "UIImageView+ZLSDWebImage.h"
#import "ZLStringMacrocDefine.h"
#import "ZLCollectionUtils.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

/* 默认图 */
NSString * ZL_PlaceholderImages[] ={
    [ZLPlaceholderImageTypeNone]            = @"lce_default_60_60",
    [ZLPlaceholderImageTypeAvatar]          = @"lce_noti_person",
    [ZLPlaceholderImageTypeAvatar_50_50]    = @"lce_noti_person_50_50",
    [ZLPlaceholderImageTypeAvatar_90_90]    = @"lce_noti_person_90_90",
    [ZLPlaceholderImageTypeClassAvatar]     = @"lce_noti_class",
    [ZLPlaceholderImageTypeChatClassAvatar] = @"lce_default_60_60",
    [ZLPlaceholderImageTypeDefault_60_60]   = @"lce_default_60_60",
    [ZLPlaceholderImageTypeDefault_375_210] = @"lce_banner_default_16_9",

};
@implementation UIImageView (ZLSDWebImage)


- (UIImage *)bundlePlaceholderName:(NSString *)iconName{
    NSString *imagePath = [@"ZLPlaceholderExp.bundle" stringByAppendingPathComponent:iconName];
    UIImage *placeholderImage = [UIImage imageNamed:imagePath];
    return placeholderImage;
}
- (void)zl_setImageWithStringNoPlaceholder:(NSString *)URLString{
    [self zl_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:nil completed:nil];
}
- (void)zl_setImageWithString:(NSString *)URLString{
    [self zl_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[ZLPlaceholderImageTypeNone]] completed:nil];
}
- (void)zl_setImageWithURL:(NSURL *)url{
    [self zl_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[ZLPlaceholderImageTypeNone]] completed:nil];
}
- (void)zl_setImageWithString:(NSString *)URLString placeholderImage:(UIImage *)placeholder{
    [self zl_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:placeholder completed:nil];
    
}
- (void)zl_setImageWithString:(NSString *)URLString placeholderType:(ZLPlaceholderImageType)placeholderType{
    
    [self zl_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[placeholderType]] completed:nil];
}
- (void)zl_setImageWithURL:(NSURL *)url placeholderType:(ZLPlaceholderImageType)placeholderType{
    [self zl_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[placeholderType]] completed:nil];
}

- (void)zl_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    [self zl_setImageWithURL:url placeholderImage:placeholder completed:nil];
}
- (void)zl_setImageWithURL:(NSURL *)url placeholderType:(ZLPlaceholderImageType)placeholderType completed:(SDWebImageCompletionBlock)completedBlock{
    [self zl_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[placeholderType]] completed:completedBlock];
}


- (void)zl_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock{
    [self sd_cancelCurrentImageLoad];

//    if (placeholder) {
//        dispatch_main_async_safe(^{
//            self.image =placeholder;
//        });
//    }
    
    NSString * downloadImageString = url.absoluteString;
    if (ZLStringIsNull(downloadImageString)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
        NSError * error = [NSError errorWithDomain:@"图片链接是nil" code:-1090 userInfo:nil];
        if (completedBlock) {
            completedBlock(placeholder,error,SDImageCacheTypeNone,url);
        }
        return;
    }
    downloadImageString = [self imageURLString:downloadImageString];
    
    if (ZLStringIsNull(downloadImageString)) {
        return;
    }
    NSString * oringinalImageString = downloadImageString;
    NSString * thumbnailImageString = downloadImageString;
    BOOL isOringinal = NO;

    [self zl_ImageWithOringinalImageURL:[NSURL URLWithString:oringinalImageString] thumbnailImageURL:[NSURL URLWithString:thumbnailImageString] palceHolderImage:placeholder isDownloadOringinal:isOringinal completed:completedBlock];
}
- (void)zl_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock{
    
//    //下载图片,如果缓存有大图,直接加载大图
//    if (oringinalImageUrl) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UIImage * diskOringinalCacheImage = [self determineWhetherThereIsACacheImages:oringinalImageUrl];
//
//            if (diskOringinalCacheImage) {
//                dispatch_main_async_safe(^{
//                    self.image = diskOringinalCacheImage;
//                    if (completedBlock) {
//                        completedBlock(diskOringinalCacheImage,nil,SDImageCacheTypeDisk,oringinalImageUrl);
//                    }
//                });
//            }else{
                [self sd_setImageWithURL:thumbnailImageURL placeholderImage:placeholderImage options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (completedBlock) {
                        completedBlock(image,error,cacheType,imageURL);
                    }
                }];
//            }
//
//        });
//    }
//
//    //如果没有大图,查看有没有小图缓存
//    UIImage * diskThumbnailCacheImage = nil;
//    if (thumbnailImageURL) {
//        diskThumbnailCacheImage = [self determineWhetherThereIsACacheImages:thumbnailImageURL];
//    }
//    if (isOringinal) {
//        //如果是下载大图,发现有小图的缓存,那么就先加载小图,然后下载大图
//        if (diskThumbnailCacheImage) {
//            [self sd_setImageWithURL:oringinalImageUrl placeholderImage:diskThumbnailCacheImage options:SDWebImageRetryFailed completed:completedBlock];
//
//            return;
//        }
//        //如果没有小图缓存,那么就先加载默认图,然后下载小图
//        [self sd_setImageWithURL:oringinalImageUrl placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:completedBlock];
//        return;
//    }
//    //如果是加载小图,查看有没有缓存,有的话直接加载
//    if (diskThumbnailCacheImage) {
//        self.image = diskThumbnailCacheImage;
//        if (completedBlock) {
//            completedBlock(diskThumbnailCacheImage,nil,SDImageCacheTypeDisk,thumbnailImageURL);
//            return;
//        }
//    }
//    //没有小图的缓存,先加载默认图,然后下载小图
//    [self sd_setImageWithURL:thumbnailImageURL placeholderImage:placeholderImage options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (completedBlock) {
//            completedBlock(image,error,cacheType,imageURL);
//        }
//    }];
}
///拼接图片
-(NSString *)imageURLString:(NSString *)urlStr
{
    if (ZLStringIsNull(urlStr)) {
        return nil;
    }
    NSArray *arr = [urlStr componentsSeparatedByString:@";"];
    NSString *imgStr = [arr objectAtIndex:0];
    
    if ([imgStr hasPrefix:@"http"]) {
        return imgStr;
    }else{
        NSString *urlPath = [NSString stringWithFormat:@"%@%@",ZL_API_IMG_IP,imgStr];
        return urlPath;
    }
}
//获取sd缓存中的图片
- (UIImage *)determineWhetherThereIsACacheImages:(NSURL *)url
{
    if (url) {
        //此方法会先从memory中取。
        NSString* key  = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        return image;
    }
    return nil;
}
@end


@implementation UIButton (ZLSDWebImage)
- (UIImage *)bundlePlaceholderName:(NSString *)iconName{
    NSString *imagePath = [@"ZLPlaceholderExp.bundle" stringByAppendingPathComponent:iconName];
    UIImage *placeholderImage = [UIImage imageNamed:imagePath];
    return placeholderImage;
}
- (void)zl_setImageWithString:(NSString *)URLString{
    [self zl_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[ZLPlaceholderImageTypeNone]] completed:nil];
}
- (void)zl_setImageWithURL:(NSURL *)url{
    [self zl_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[ZLPlaceholderImageTypeNone]] completed:nil];
}
- (void)zl_setImageWithString:(NSString *)URLString placeholderImage:(UIImage *)placeholder{
    [self zl_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:placeholder completed:nil];
    
}
- (void)zl_setImageWithString:(NSString *)URLString placeholderType:(ZLPlaceholderImageType)placeholderType{
    
    [self zl_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[placeholderType]] completed:nil];
}
- (void)zl_setImageWithURL:(NSURL *)url placeholderType:(ZLPlaceholderImageType)placeholderType{
    [self zl_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[placeholderType]] completed:nil];
}

- (void)zl_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    [self zl_setImageWithURL:url placeholderImage:placeholder completed:nil];
}
- (void)zl_setImageWithURL:(NSURL *)url placeholderType:(ZLPlaceholderImageType)placeholderType completed:(SDWebImageCompletionBlock)completedBlock{
    
    [self zl_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[placeholderType]] completed:completedBlock];
}
- (void)zl_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock{
    
    if (placeholder) {
        [self setImage:placeholder forState:UIControlStateNormal];
    }else{
        [self setImage:[self bundlePlaceholderName:ZL_PlaceholderImages[ZLPlaceholderImageTypeNone]] forState:UIControlStateNormal];
    }
    NSString * downloadImageString = url.absoluteString;
    if (ZLStringIsNull(downloadImageString)) {
        [self setImage:placeholder forState:UIControlStateNormal];
        NSError * error = [NSError errorWithDomain:@"图片链接是nil" code:-1090 userInfo:nil];
        if (completedBlock) {
            completedBlock(placeholder,error,SDImageCacheTypeNone,url);
        }
        return;
    }
    downloadImageString = [self imageURLString:downloadImageString];

    NSString * oringinalImageString = downloadImageString;
    NSString * thumbnailImageString = downloadImageString;
    BOOL isOringinal = NO;

    [self zl_ImageWithOringinalImageURL:[NSURL URLWithString:oringinalImageString] thumbnailImageURL:[NSURL URLWithString:thumbnailImageString] palceHolderImage:placeholder isDownloadOringinal:isOringinal completed:completedBlock];
}
- (void)zl_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock{
    [self zl_ImageWithOringinalImageURL:oringinalImageUrl thumbnailImageURL:thumbnailImageURL palceHolderImage:placeholderImage isDownloadOringinal:isOringinal forState:UIControlStateNormal completed:completedBlock];
}

- (void)zl_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock{

    UIImage * diskOringinalCacheImage = [self determineWhetherThereIsACacheImages:oringinalImageUrl];
    if (diskOringinalCacheImage) {
        [self setImage:diskOringinalCacheImage forState:UIControlStateNormal];
        if (completedBlock) {
            completedBlock(diskOringinalCacheImage,nil,SDImageCacheTypeDisk,oringinalImageUrl);
        }
        return;
    }
    //如果没有大图,查看有没有小图缓存
    UIImage * diskThumbnailCacheImage = [self determineWhetherThereIsACacheImages:thumbnailImageURL];
    if (isOringinal) {
        //如果是下载大图,发现有小图的缓存,那么就先加载小图,然后下载大图
        if (diskThumbnailCacheImage) {
            [self sd_setImageWithURL:oringinalImageUrl forState:state placeholderImage:diskThumbnailCacheImage options:SDWebImageRetryFailed completed:completedBlock];
            return;
        }
        //如果没有小图缓存,那么就先加载默认图,然后下载小图
        [self sd_setImageWithURL:oringinalImageUrl forState:state placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:completedBlock];
        return;
    }
    //如果是加载小图,查看有没有缓存,有的话直接加载
    if (diskThumbnailCacheImage) {
        [self setImage:diskThumbnailCacheImage forState:UIControlStateNormal];
        if (completedBlock) {
            completedBlock(diskThumbnailCacheImage,nil,SDImageCacheTypeDisk,thumbnailImageURL);
        }
        return;
    }
    //没有小图的缓存,先加载默认图,然后下载小图
    [self sd_setImageWithURL:thumbnailImageURL forState:state placeholderImage:placeholderImage options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self setImage:image forState:UIControlStateNormal];
        }
        if (completedBlock) {
            completedBlock(image,error,cacheType,imageURL);
        }
        
    }];
    
}

#pragma mark - 默认图

- (void)zl_setBackgroundImageWithURL:(NSString *)URLString placeholderImage:(ZLPlaceholderImageType)type
{
    NSURL *url =[NSURL URLWithString:[self imageURLString:URLString]];
    [self zl_setBackgroundImageWithURL:url placeholderImage:[self bundlePlaceholderName:ZL_PlaceholderImages[type]] completed:nil];
}

- (void)zl_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
    if (placeholder) {
        [self setImage:placeholder forState:UIControlStateNormal];
    }else{
        [self setImage:[self bundlePlaceholderName:ZL_PlaceholderImages[ZLPlaceholderImageTypeNone]] forState:UIControlStateNormal];
    }
    NSString * downloadImageString = url.absoluteString;
    if (ZLStringIsNull(downloadImageString)) {
        [self setImage:placeholder forState:UIControlStateNormal];
        NSError * error = [NSError errorWithDomain:@"图片链接是nil" code:-1090 userInfo:nil];
        completedBlock(placeholder,error,SDImageCacheTypeNone,url);
        return;
    }
    downloadImageString = [self imageURLString:downloadImageString];

    NSString * oringinalImageString = downloadImageString;
    NSString * thumbnailImageString = downloadImageString;
    BOOL isOringinal = NO;

    [self zl_BackgroundImageWithOringinalImageURL:[NSURL URLWithString: oringinalImageString] thumbnailImageURL:[NSURL URLWithString: thumbnailImageString] palceHolderImage:placeholder isDownloadOringinal:isOringinal forState:UIControlStateNormal completed:completedBlock];
}

- (void)zl_BackgroundImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock
{
    [self zl_BackgroundImageWithOringinalImageURL:oringinalImageUrl thumbnailImageURL:thumbnailImageURL palceHolderImage:placeholderImage isDownloadOringinal:isOringinal forState:UIControlStateNormal completed:completedBlock];
}

- (void)zl_BackgroundImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock
{
    //下载图片,如果缓存有大图,直接加载大图
    
    UIImage * diskOringinalCacheImage = [self determineWhetherThereIsACacheImages:oringinalImageUrl];
    if (diskOringinalCacheImage) {
        [self setBackgroundImage:diskOringinalCacheImage forState:UIControlStateNormal];
        if (completedBlock) {
            completedBlock(diskOringinalCacheImage,nil,SDImageCacheTypeDisk,oringinalImageUrl);
        }
        return;
    }
    //如果没有大图,查看有没有小图缓存
    UIImage * diskThumbnailCacheImage = [self determineWhetherThereIsACacheImages:thumbnailImageURL];
    if (isOringinal) {
        //如果是下载大图,发现有小图的缓存,那么就先加载小图,然后下载大图
        if (diskThumbnailCacheImage) {
            [self sd_setBackgroundImageWithURL:oringinalImageUrl forState:state placeholderImage:diskThumbnailCacheImage options:SDWebImageRetryFailed completed:completedBlock];
            return;
        }
        //如果没有小图缓存,那么就先加载默认图,然后下载小图
         [self sd_setBackgroundImageWithURL:oringinalImageUrl forState:state placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:completedBlock];
        return;
    }
    //如果是加载小图,查看有没有缓存,有的话直接加载
    if (diskThumbnailCacheImage) {
        [self setBackgroundImage:diskThumbnailCacheImage forState:UIControlStateNormal];
        if (completedBlock) {
            completedBlock(diskThumbnailCacheImage,nil,SDImageCacheTypeDisk,thumbnailImageURL);
        }
        return;
    }
    //没有小图的缓存,先加载默认图,然后下载小图
     [self sd_setBackgroundImageWithURL:thumbnailImageURL forState:state placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:completedBlock];
}
///拼接图片
-(NSString *)imageURLString:(NSString *)urlStr
{
    if (ZLStringIsNull(urlStr)) {
        return nil;
    }
    NSArray *arr = [urlStr componentsSeparatedByString:@";"];
    NSString *imgStr = [arr objectAtIndex:0];
    
    if ([imgStr hasPrefix:@"http"]) {
        return imgStr;
    }else{
        NSString *urlPath = [NSString stringWithFormat:@"%@%@",ZL_API_IMG_IP,imgStr];
        return urlPath;
    }
}
//获取sd缓存中的图片
- (UIImage *)determineWhetherThereIsACacheImages:(NSURL *)url
{
    if (url) {
        NSString* key  = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        return image;
    }
    return nil;
}
@end


