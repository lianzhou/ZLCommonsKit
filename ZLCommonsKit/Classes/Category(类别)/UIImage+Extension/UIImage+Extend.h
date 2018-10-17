//
//  UIImage+Extend.h
//  CDHN
//
//  Created by muxi on 14-10-14.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)
/**
 UIImage to base64
 
 @param image UIImage
 @return base64String
 */
+(NSString *)imagebase64String:(UIImage*)image;
 
/**
 图片自适应UIImageView 
 @param image <#image description#>
 @param newSize <#newSize description#>
 @return <#return value description#>
 */
+ (UIImage*)scaleImageSimple:(UIImage*)image
                    scaledToSize:(CGSize)newSize;


/**
 按比例缩放,size 是你要把图显示到 多大区域

 @param sourceImage <#sourceImage description#>
 @param size CGSizeMake(200, 140)
 @return <#return value description#>
 */
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size;


/**
 指定宽度按比例缩放

 @param sourceImage <#sourceImage description#>
 @param defineWidth <#defineWidth description#>
 @return <#return value description#>
 */
+(UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/**
 压图片比例
 
 @param image <#image description#>
 @param scaleSize <#scaleSize description#>
 
 */
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

/**
  判断照片大小再压缩
 
 @param image <#image description#>
 @return <#return value description#>
 */
+(UIImage *)scaleImage :(UIImage *)image;


/**
 *  截取当前View作为一张背景图返回, capture:捕获,刻画
 */
+ (UIImage *)imageWithCaptureView:(UIView *)view;

/**
 *  拉伸图片:自定义比例
 */
+(UIImage *)resizeWithImageName:(NSString *)name leftCap:(CGFloat)leftCap topCap:(CGFloat)topCap;


/**
 *  拉伸图片
 */
+(UIImage *)resizeWithImageName:(NSString *)name;


/**
 *  获取启动图片
 */
+(UIImage *)launchImage;

/**
 获取AppIcon
 
 @return <#return value description#>
 */
+(UIImage *)iconImage;

 


@end
