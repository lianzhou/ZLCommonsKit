//
//  NSString+Extension.h
//  Pods
//
//  Created by li_chang_en on 2017/9/7.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)breakMode;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)abreakMode align:(NSTextAlignment)alignment;
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)abreakMode align:(NSTextAlignment)alignment numberOfLines:(NSInteger)numberOfLines;


/**
 html字符串转富文本

 @param font font
 @param textColor textColor
 @param abreakMode 换行模式
 @return 富文本
 */
- (NSAttributedString *)attributeStringFromHTMLWithFont:(UIFont *)font textColor:(UIColor *)textColor breakMode:(NSLineBreakMode)abreakMode;


/**
 html字符串将图片过滤成[图片]

 @return 过滤后的html字符串
 */
- (NSString *)htmlStringBoundingImgString;


/**
 html字符串图片适应

 @param maxWidth 图片最大宽度
 @return self
 */
- (NSString *)adjustHtmlStringImageSizeWithMaxWidth:(CGFloat)maxWidth;


- (NSString *)replaceLineBreakString;


/**
 将字符串转换为字典

 @param jsonString 字符串
 @return 字典
 */
+ (NSDictionary *)jsonStringToNSDictionary:(NSString *)jsonString;

/**
 将字典转换为字符串

 @param jsonDic 字典
 @return 字符串
 */
+ (NSString *)initWithJsonDictionary:(NSDictionary *)jsonDic;

/**
 6位随机码
 @return 字符串
 */
+ (NSString *)obtainSixRandomNo;

/**
 当前时间字符串 YYYY-MM-dd HH:mm:ss
 @return 字符串
 */
+(NSString*)obtainCurrentTime;

/**
 AES加密
 
 @param key key
 @return 加密后的字符串
 */
- (NSString *)JZAES_EncryptwithKey:(NSString *)key;

/**
 AES解密
 
 @param key key
 @return 解密后的字符串
 */
- (NSString *)JZAES_DecryptWithkey:(NSString *)key;

@end
