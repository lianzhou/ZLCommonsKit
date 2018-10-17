//
//  UIImage+Tint.h
//  ImageColorDemo
//
//  Created by zhangjiang on 2017/6/2.
//  Copyright © 2017年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 颜色生成图片
 */
@interface UIImage (ZLTintColor)

- (UIImage *)imageWithTintColor:(UIColor *)color;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor  imageSize:(CGSize)imageSize;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor  imageSize:(CGSize)imageSize;

- (UIImage *)imageWithWidth:(int)width hight:(int)hight;
+ (UIImage*)imageBy:(UIImage*)image withWidth:(int)width withHight:(int)hight;
+ (UIImage *)scaleToSize:(UIImage *)image :(CGSize)newsize;
// 旋转图片
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;


@end


/**
 * 透明度
 */
@interface UIImage (Alpha)

- (BOOL)hasAlpha;

- (UIImage *)imageWithAlpha;

- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;

@end

@interface UIImage (Common)

- (UIImage *)fixOrientation;
- (UIImage *)fixOrientationWithScale:(CGFloat)scale;

- (UIImage *)thumbnailWithSize:(CGSize)asize;

- (UIImage *)rescaleImageToSize:(CGSize)size;

- (UIImage *)cropImageToRect:(CGRect)cropRect;

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;

- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;

- (UIImage *)cropToSquareImage;

// path为图片的键值
- (void)saveToCacheWithKey:(NSString *)key;

+ (UIImage *)loadFromCacheWithKey:(NSString *)key;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)randomColorImageWith:(CGSize)size;

- (UIImage *)croppedImage:(CGRect)bounds;



@end




//========================================

@interface UIImage (Cut)

- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize;
- (UIImage *)clipImageWithScaleWithsize:(CGSize)asize roundedCornerImage:(NSInteger)roundedCornerImage borderSize:(NSInteger)borderSize;
@end

//========================================

@interface UIImage (Resize)



- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize transparentBorder:(NSUInteger)borderSize cornerRadius:(NSUInteger)cornerRadius interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageInRect:(CGRect)rect transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

@end

//========================================

@interface UIImage (RoundedCorner)

- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;

@end

//========================================
@interface UIImage (SplitImageIntoTwoParts)
+ (NSArray*)splitImageIntoTwoParts:(UIImage*)image;
@end

@interface UIImage (ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
@interface UIImage (QRCode)

+ (UIImage *)qrImageByContent:(NSString *)content;

//pre
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size;
/**
 *   色值 0~255
 *
 */
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;



+ (UIImage *)qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;


@end

@interface UIImage (Direction)

+ (UIImage *)fixOrientation:(UIImage *)image rotation:(UIImageOrientation)orientation;

@end

