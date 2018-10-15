//
//  UIImageView+JZSDWebImage.h
//  Pods
//
//  Created by wangjingfei on 2017/8/26.
//
//

#import <UIKit/UIKit.h>
#import <SDWebImageManager.h>

//类型较多,慢慢添加
typedef NS_ENUM(NSUInteger, JZPlaceholderImageType) {
    JZPlaceholderImageTypeNone,
    JZPlaceholderImageTypeAvatar,//默认是45x45
    JZPlaceholderImageTypeAvatar_50_50,
    JZPlaceholderImageTypeAvatar_90_90,
    JZPlaceholderImageTypeClassAvatar,
    JZPlaceholderImageTypeChatClassAvatar,
    JZPlaceholderImageTypeDefault_60_60,
    JZPlaceholderImageTypeDefault_375_210,
};

/* 默认图 */
extern NSString * JZ_PlaceholderImages [];
@interface UIImageView (JZSDWebImage)

- (UIImage *)bundlePlaceholderName:(NSString *)iconName;
- (void)jz_setImageWithStringNoPlaceholder:(NSString *)URLString;
- (void)jz_setImageWithString:(NSString *)URLString;
- (void)jz_setImageWithString:(NSString *)URLString placeholderImage:(UIImage *)placeholder;

- (void)jz_setImageWithURL:(NSURL *)url;
- (void)jz_setImageWithString:(NSString *)URLString placeholderType:(JZPlaceholderImageType)placeholderType;
- (void)jz_setImageWithURL:(NSURL *)url placeholderType:(JZPlaceholderImageType)placeholderType;
- (void)jz_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)jz_setImageWithURL:(NSURL *)url placeholderType:(JZPlaceholderImageType)placeholderType completed:(SDWebImageCompletionBlock)completedBlock;
- (void)jz_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)jz_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock;
@end
@interface UIButton (JZSDWebImage)

- (UIImage *)bundlePlaceholderName:(NSString *)iconName;

- (void)jz_setImageWithString:(NSString *)URLString;
- (void)jz_setImageWithURL:(NSURL *)url;
- (void)jz_setImageWithString:(NSString *)URLString placeholderImage:(UIImage *)placeholder;
- (void)jz_setImageWithString:(NSString *)URLString placeholderType:(JZPlaceholderImageType)placeholderType;
- (void)jz_setImageWithURL:(NSURL *)url placeholderType:(JZPlaceholderImageType)placeholderType;
- (void)jz_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)jz_setImageWithURL:(NSURL *)url placeholderType:(JZPlaceholderImageType)placeholderType completed:(SDWebImageCompletionBlock)completedBlock;
- (void)jz_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)jz_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock;

- (void)jz_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock;

- (void)jz_setBackgroundImageWithURL:(NSString *)URLString placeholderImage:(JZPlaceholderImageType)type;

- (void)jz_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)jz_BackgroundImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock;

- (void)jz_BackgroundImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock;
@end

