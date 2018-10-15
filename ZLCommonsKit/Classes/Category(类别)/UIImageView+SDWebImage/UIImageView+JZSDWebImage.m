//
//  UIImageView+JZSDWebImage.m
//  Pods
//
//  Created by wangjingfei on 2017/8/26.
//
//

#import "UIImageView+JZSDWebImage.h"
#import "JZStringMacrocDefine.h"
#import "JZCollectionUtils.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

/* 默认图 */
NSString * JZ_PlaceholderImages[] =
{
    [JZPlaceholderImageTypeNone]            = @"lce_default_60_60",
    [JZPlaceholderImageTypeAvatar]          = @"lce_noti_person",
    [JZPlaceholderImageTypeAvatar_50_50]    = @"lce_noti_person_50_50",
    [JZPlaceholderImageTypeAvatar_90_90]    = @"lce_noti_person_90_90",
    [JZPlaceholderImageTypeClassAvatar]     = @"lce_noti_class",
    [JZPlaceholderImageTypeChatClassAvatar] = @"lce_default_60_60",
    [JZPlaceholderImageTypeDefault_60_60]   = @"lce_default_60_60",
    [JZPlaceholderImageTypeDefault_375_210] = @"lce_banner_default_16_9",

};
@implementation UIImageView (JZSDWebImage)


- (UIImage *)bundlePlaceholderName:(NSString *)iconName{
    NSString *imagePath = [@"JZPlaceholderExp.bundle" stringByAppendingPathComponent:iconName];
    UIImage *placeholderImage = [UIImage imageNamed:imagePath];
    return placeholderImage;
}
- (void)jz_setImageWithStringNoPlaceholder:(NSString *)URLString{
    [self jz_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:nil completed:nil];
}
- (void)jz_setImageWithString:(NSString *)URLString{
    [self jz_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[JZPlaceholderImageTypeNone]] completed:nil];
}
- (void)jz_setImageWithURL:(NSURL *)url{
    [self jz_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[JZPlaceholderImageTypeNone]] completed:nil];
}
- (void)jz_setImageWithString:(NSString *)URLString placeholderImage:(UIImage *)placeholder{
    [self jz_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:placeholder completed:nil];
    
}
- (void)jz_setImageWithString:(NSString *)URLString placeholderType:(JZPlaceholderImageType)placeholderType{
    
    [self jz_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[placeholderType]] completed:nil];
}
- (void)jz_setImageWithURL:(NSURL *)url placeholderType:(JZPlaceholderImageType)placeholderType{
    [self jz_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[placeholderType]] completed:nil];
}

- (void)jz_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    [self jz_setImageWithURL:url placeholderImage:placeholder completed:nil];
}
- (void)jz_setImageWithURL:(NSURL *)url placeholderType:(JZPlaceholderImageType)placeholderType completed:(SDWebImageCompletionBlock)completedBlock{
    [self jz_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[placeholderType]] completed:completedBlock];
}


- (void)jz_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock{
    [self sd_cancelCurrentImageLoad];

//    if (placeholder) {
//        dispatch_main_async_safe(^{
//            self.image =placeholder;
//        });
//    }
    
    NSString * downloadImageString = url.absoluteString;
    if (JZStringIsNull(downloadImageString)) {
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
    
    if (JZStringIsNull(downloadImageString)) {
        return;
    }
    NSString * oringinalImageString = downloadImageString;
    NSString * thumbnailImageString = downloadImageString;
    BOOL isOringinal = NO;

    [self jz_ImageWithOringinalImageURL:[NSURL URLWithString:oringinalImageString] thumbnailImageURL:[NSURL URLWithString:thumbnailImageString] palceHolderImage:placeholder isDownloadOringinal:isOringinal completed:completedBlock];
}
- (void)jz_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock{
    
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
    if (JZStringIsNull(urlStr)) {
        return nil;
    }
    NSArray *arr = [urlStr componentsSeparatedByString:@";"];
    NSString *imgStr = [arr objectAtIndex:0];
    
    if ([imgStr hasPrefix:@"http"]) {
        return imgStr;
    }else{
        NSString *urlPath = [NSString stringWithFormat:@"%@%@",JZ_API_IMG_IP,imgStr];
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


@implementation UIButton (JZSDWebImage)
- (UIImage *)bundlePlaceholderName:(NSString *)iconName{
    NSString *imagePath = [@"JZPlaceholderExp.bundle" stringByAppendingPathComponent:iconName];
    UIImage *placeholderImage = [UIImage imageNamed:imagePath];
    return placeholderImage;
}
- (void)jz_setImageWithString:(NSString *)URLString{
    [self jz_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[JZPlaceholderImageTypeNone]] completed:nil];
}
- (void)jz_setImageWithURL:(NSURL *)url{
    [self jz_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[JZPlaceholderImageTypeNone]] completed:nil];
}
- (void)jz_setImageWithString:(NSString *)URLString placeholderImage:(UIImage *)placeholder{
    [self jz_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:placeholder completed:nil];
    
}
- (void)jz_setImageWithString:(NSString *)URLString placeholderType:(JZPlaceholderImageType)placeholderType{
    
    [self jz_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[placeholderType]] completed:nil];
}
- (void)jz_setImageWithURL:(NSURL *)url placeholderType:(JZPlaceholderImageType)placeholderType{
    [self jz_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[placeholderType]] completed:nil];
}

- (void)jz_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    [self jz_setImageWithURL:url placeholderImage:placeholder completed:nil];
}
- (void)jz_setImageWithURL:(NSURL *)url placeholderType:(JZPlaceholderImageType)placeholderType completed:(SDWebImageCompletionBlock)completedBlock{
    
    [self jz_setImageWithURL:url placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[placeholderType]] completed:completedBlock];
}
- (void)jz_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock{
    
    if (placeholder) {
        [self setImage:placeholder forState:UIControlStateNormal];
    }else{
        [self setImage:[self bundlePlaceholderName:JZ_PlaceholderImages[JZPlaceholderImageTypeNone]] forState:UIControlStateNormal];
    }
    NSString * downloadImageString = url.absoluteString;
    if (JZStringIsNull(downloadImageString)) {
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

    [self jz_ImageWithOringinalImageURL:[NSURL URLWithString:oringinalImageString] thumbnailImageURL:[NSURL URLWithString:thumbnailImageString] palceHolderImage:placeholder isDownloadOringinal:isOringinal completed:completedBlock];
}
- (void)jz_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock{
    [self jz_ImageWithOringinalImageURL:oringinalImageUrl thumbnailImageURL:thumbnailImageURL palceHolderImage:placeholderImage isDownloadOringinal:isOringinal forState:UIControlStateNormal completed:completedBlock];
}

- (void)jz_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock{

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

- (void)jz_setBackgroundImageWithURL:(NSString *)URLString placeholderImage:(JZPlaceholderImageType)type
{
    NSURL *url =[NSURL URLWithString:[self imageURLString:URLString]];
    [self jz_setBackgroundImageWithURL:url placeholderImage:[self bundlePlaceholderName:JZ_PlaceholderImages[type]] completed:nil];
}

- (void)jz_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
    if (placeholder) {
        [self setImage:placeholder forState:UIControlStateNormal];
    }else{
        [self setImage:[self bundlePlaceholderName:JZ_PlaceholderImages[JZPlaceholderImageTypeNone]] forState:UIControlStateNormal];
    }
    NSString * downloadImageString = url.absoluteString;
    if (JZStringIsNull(downloadImageString)) {
        [self setImage:placeholder forState:UIControlStateNormal];
        NSError * error = [NSError errorWithDomain:@"图片链接是nil" code:-1090 userInfo:nil];
        completedBlock(placeholder,error,SDImageCacheTypeNone,url);
        return;
    }
    downloadImageString = [self imageURLString:downloadImageString];

    NSString * oringinalImageString = downloadImageString;
    NSString * thumbnailImageString = downloadImageString;
    BOOL isOringinal = NO;

    [self jz_BackgroundImageWithOringinalImageURL:[NSURL URLWithString: oringinalImageString] thumbnailImageURL:[NSURL URLWithString: thumbnailImageString] palceHolderImage:placeholder isDownloadOringinal:isOringinal forState:UIControlStateNormal completed:completedBlock];
}

- (void)jz_BackgroundImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock
{
    [self jz_BackgroundImageWithOringinalImageURL:oringinalImageUrl thumbnailImageURL:thumbnailImageURL palceHolderImage:placeholderImage isDownloadOringinal:isOringinal forState:UIControlStateNormal completed:completedBlock];
}

- (void)jz_BackgroundImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock
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
    if (JZStringIsNull(urlStr)) {
        return nil;
    }
    NSArray *arr = [urlStr componentsSeparatedByString:@";"];
    NSString *imgStr = [arr objectAtIndex:0];
    
    if ([imgStr hasPrefix:@"http"]) {
        return imgStr;
    }else{
        NSString *urlPath = [NSString stringWithFormat:@"%@%@",JZ_API_IMG_IP,imgStr];
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


