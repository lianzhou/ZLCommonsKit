//
//  UIImageView+ZLSDWebImage.h
//  Pods
//
//  Created by wangjingfei on 2017/8/26.
//
//

#import <UIKit/UIKit.h>
#import <SDWebImageManager.h>

//类型较多,慢慢添加
typedef NS_ENUM(NSUInteger, ZLPlaceholderImageType) {
    ZLPlaceholderImageTypeNone,
    ZLPlaceholderImageTypeAvatar,//默认是45x45
    ZLPlaceholderImageTypeAvatar_50_50,
    ZLPlaceholderImageTypeAvatar_90_90,
    ZLPlaceholderImageTypeClassAvatar,
    ZLPlaceholderImageTypeChatClassAvatar,
    ZLPlaceholderImageTypeDefault_60_60,
    ZLPlaceholderImageTypeDefault_375_210,
};

/* 默认图 */
extern NSString * ZL_PlaceholderImages [];
@interface UIImageView (ZLSDWebImage)

- (UIImage *)bundlePlaceholderName:(NSString *)iconName;
- (void)zl_setImageWithStringNoPlaceholder:(NSString *)URLString;
- (void)zl_setImageWithString:(NSString *)URLString;
- (void)zl_setImageWithString:(NSString *)URLString placeholderImage:(UIImage *)placeholder;

- (void)zl_setImageWithURL:(NSURL *)url;
- (void)zl_setImageWithString:(NSString *)URLString placeholderType:(ZLPlaceholderImageType)placeholderType;
- (void)zl_setImageWithURL:(NSURL *)url placeholderType:(ZLPlaceholderImageType)placeholderType;
- (void)zl_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)zl_setImageWithURL:(NSURL *)url placeholderType:(ZLPlaceholderImageType)placeholderType completed:(SDWebImageCompletionBlock)completedBlock;
- (void)zl_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)zl_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock;
@end
@interface UIButton (ZLSDWebImage)

- (UIImage *)bundlePlaceholderName:(NSString *)iconName;

- (void)zl_setImageWithString:(NSString *)URLString;
- (void)zl_setImageWithURL:(NSURL *)url;
- (void)zl_setImageWithString:(NSString *)URLString placeholderImage:(UIImage *)placeholder;
- (void)zl_setImageWithString:(NSString *)URLString placeholderType:(ZLPlaceholderImageType)placeholderType;
- (void)zl_setImageWithURL:(NSURL *)url placeholderType:(ZLPlaceholderImageType)placeholderType;
- (void)zl_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)zl_setImageWithURL:(NSURL *)url placeholderType:(ZLPlaceholderImageType)placeholderType completed:(SDWebImageCompletionBlock)completedBlock;
- (void)zl_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)zl_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock;

- (void)zl_ImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock;

- (void)zl_setBackgroundImageWithURL:(NSString *)URLString placeholderImage:(ZLPlaceholderImageType)type;

- (void)zl_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)zl_BackgroundImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal completed:(SDWebImageCompletionBlock)completedBlock;

- (void)zl_BackgroundImageWithOringinalImageURL:(NSURL *)oringinalImageUrl  thumbnailImageURL:(NSURL *)thumbnailImageURL palceHolderImage:(UIImage *)placeholderImage isDownloadOringinal:(BOOL)isOringinal forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock;
@end

