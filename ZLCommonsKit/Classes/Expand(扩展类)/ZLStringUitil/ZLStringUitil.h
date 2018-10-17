//
//  ZLStringUitil.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLStringUitil : NSObject

+ (NSUInteger)utf8Length:(NSString*)string;
+ (BOOL)isContainsEmoji:(NSString *)string;
+ (BOOL)isNullObject:(id)anObject;
+ (BOOL)stringIsNull:(NSString *)string;

+ (BOOL)stringIsAllWhiteSpace:(NSString *)string;

+ (BOOL)stringToBool:(NSString*)sourceString;

+ (NSInteger)stringToInt:(NSString*)sourceString;

+ (CGFloat)stringToFloat:(NSString*)sourceString;

+ (double)stringToDouble:(NSString*)sourceString;

+ (NSString *)boolToString:(BOOL)boolValue;

+ (NSString *)intToString:(NSInteger)intValue;

+ (NSString *)floatToString:(CGFloat)floatValue;

+ (NSString *)doubleToString:(double)doubleValue;

+ (BOOL)stringIsValidateEmailAddress:(NSString *)string;

+ (BOOL)stringISValidateMobilePhone:(NSString *)string;

+ (BOOL)stringIsValidatePhone:(NSString *)string;

+ (BOOL)stringIsValidateMailCode:(NSString *)string;

+ (BOOL)stringIsAllChineseWord:(NSString *)string;

+ (BOOL)stringISValidateCarNumber:(NSString *)string;

+ (BOOL)stringIsValidateUrl:(NSString *)string;

+ (BOOL)stringISValidatePersonCardNumber:(NSString *)string;

+ (BOOL)stringJustHasNumberAndCharacter:(NSString *)string;

+ (BOOL)stringJustHasNumber:(NSString *)string;

+ (BOOL)stringChineseNumberCharacterOnly:(NSString *)string;

+ (BOOL)stringChineseCharacterOnly:(NSString *)string;

+ (NSString*)stringFromFile:(NSString*)path;

+ (NSString*)currentTimeStampString;


+ (NSString *)MD5:(NSString *)string;

+ (NSString *)stringByTrimingLeadingWhiteSpace:(NSString *)string;

+ (NSString *)stringByTrimingTailingWhiteSpace:(NSString *)string;

+ (NSString *)stringByTrimingWhiteSpace:(NSString *)string;

+ (NSString *)urlEncode:(id)object;

+ (NSString *)encodeStringFromDict:(NSDictionary *)dict;

+ (NSRange)stringRange:(NSString *)string;

//文本长度或者宽度计算
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize )maxSize;
+ (NSString *)ifSpacStringNull:(NSString *)string;

//判断银行卡号是否正确
+ (BOOL)isBankCard:(NSString *)cardNumber;

//递归计算符合规定的文本长度
+ (NSString *)cutBeyondTextInLength:(NSInteger)maxLenth string:(NSString *)string;

/**
 汉字的不同颜色和大小的混排
 
 @param string 要进行混排的汉字
 @param attributes 要改变的字体大小和颜色等属性
 @param range 要改变的范围
 @return 返回目标数据
 */
+ (NSMutableAttributedString *)createTextKitWithString:(NSString*)string attributes:(NSDictionary*)attributes withRange:(NSRange)range;

/**
 修改不同汉字的大小以及某个位置的汉字颜色

 @param textStr 要进行混排的所有数据
 @param firstAttributeDic 要改变的字体大小和颜色等属性
 @param firstRange 要改变的范围
 @param secondAttributesDic 要改变的字体大小和颜色等属性
 @param secondRange 要改变的范围
 @return 返回目标数据
 */
+ (NSMutableAttributedString *)changeTextWithString:(NSString *)textStr withFirstAttribues:(NSDictionary *)firstAttributeDic withFirstRange:(NSRange)firstRange withSecondAttributes:(NSDictionary *)secondAttributesDic withSecondRange:(NSRange)secondRange;


/**
 图文混排

 @param string 要进行混排的所有数据
 @param attributes 要改变的字体大小和颜色等属性
 @param imageName 图片名称
 @param index 图片放置的位置
 @return 返回目标数据
 */
+ (NSMutableAttributedString *)createTextKitWithString:(NSString*)string attributes:(NSDictionary*)attributes image:(NSString*)imageName  index:(NSInteger)index;

//根据error 获取错误信息
+ (NSString *)ZLCusTomWithMessageError:(NSError *)error;

//判断只能输入数字字母.@符号
+ (BOOL)stringHasDotNumberAndCharacter:(NSString *)string;


/**
 根据秒返回xxhxxmin的格式

 @param timeStr timeStr
 @param startAttrDic startAttrDic
 @param endAttriDic endAttriDic
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)returnContent:(NSString *)timeStr withStartAttributeDic:(NSDictionary *)startAttrDic withEndAttributeDic:(NSDictionary *)endAttriDic;

@end
