//
//  ZLStringMacrocDefine.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#ifndef ZLStringMacrocDefine_h
#define ZLStringMacrocDefine_h

#import "ZLStringUitil.h"

//解决block内的循环引用
//weak
#define ZLWeakObj(anObject)  __weak typeof(anObject)   weak##anObject = anObject;
//strong
#define ZLStrongObj(anObject)  __strong typeof(anObject) strong##anObject = anObject;
/*! @brief *
 *  字符串是否为空
 */
#define ZLStringIsNull(string) [ZLStringUitil stringIsNull:string]

/*! @brief *
 *  字符串是否全为空格
 */
#define ZLStringIsAllWhiteSpace(string) [ZLStringUitil stringIsAllWhiteSpace:string]

/*! @brief *
 *  字符串转NSInteger
 */
#define ZLStringToInt(string) [ZLStringUitil stringToInt:string]

/*! @brief *
 *  字符串转CGFloat
 */
#define ZLStringToFloat(string) [ZLStringUitil stringToFloat:string]

/*! @brief *
 *  字符串转double
 */
#define ZLStringToDouble(string) [ZLStringUitil stringToDouble:string]

/*! @brief *
 *  字符串转Bool
 */
#define ZLStringToBool(string) [ZLStringUitil stringToBool:string]

/*! @brief *
 *  int转字符串
 */
#define ZLStringFromInt(int) [ZLStringUitil intToString:int]

/*! @brief *
 *  float转字符串
 */
#define ZLStringFromFloat(float) [ZLStringUitil floatToString:float]

/*! @brief *
 *  double转字符串
 */
#define ZLStringFromDouble(double) [ZLStringUitil doubleToString:double]

/*! @brief *
 *  bool转字符串
 */
#define ZLStringFromBool(bool) [ZLStringUitil boolToString:bool]

/*! @brief *
 *  字符串是否合法邮箱
 */
#define ZLStringIsEmail(string) [ZLStringUitil stringIsValidateEmailAddress:string]

/*! @brief *
 *  字符串是否合法手机号码
 */
#define ZLStringIsMobilePhone(string) [ZLStringUitil stringISValidateMobilePhone:string]

/*! @brief *
 *  字符串是否合法url
 */
#define ZLStringIsUrl(string) [ZLStringUitil stringIsValidateUrl:string]

/*! @brief *
 *  字符串是否合法座机
 */
#define ZLStringIsPhone(string) [ZLStringUitil stringIsValidatePhone:string]

/*! @brief *
 *  字符串是否合法邮政编码
 */
#define ZLStringIsMailCode(string) [ZLStringUitil stringIsValidateMailCode:string]

/*! @brief *
 *  字符串是否合法身份证号
 */
#define ZLStringIsPersonCardNumber(string) [ZLStringUitil stringISValidatePersonCardNumber:string]

/*! @brief *
 *  字符串是否合法车牌号
 */
#define ZLStringIsCarNumber(string) [ZLStringUitil stringISValidateCarNumber:string]

/*! @brief *
 *  字符串是否只有中文字符
 */
#define ZLStringChineseOnly(string) [ZLStringUitil stringIsAllChineseWord:string]

/*! @brief *
 *  字符串是否只有英文字符和数字
 */
#define ZLStringCharNumOnly(string) [ZLStringUitil stringJustHasNumberAndCharacter:string]

/*! @brief *
 *  字符串是否只包含字符，中文，数字
 */
#define ZLStringCharNumChineseOnly(string) [ZLStringUitil stringChineseNumberCharacterOnly:string]

/*! @brief *
 *  字符串是否只包含字母，中文
 */
#define ZLStringCharChineseOnly(string) [ZLStringUitil stringChineseCharacterOnly:string]

/*! @brief *
 *  字符串是否纯数字
 */
#define ZLStringNumOnly(string) [ZLStringUitil stringJustHasNumber:string]

/*! @brief *
 *  从文件中读取出字符串
 */
#define ZLStringFromFile(path) [ZLStringUitil stringFromFile:path]

/*! @brief *
 *  从归档路径读取出字符串
 */
#define ZLStringUnArchieve(path) [ZLStringUitil unarchieveFromPath:path]

/*! @brief *
 *  获取一个当前时间戳字符串
 */
#define ZLStringCurrentTimeStamp [ZLStringUitil currentTimeStampString]

/*! @brief *
 *  将字符串转为MD5字符串
 */
#define ZLStringToMD5(string) [ZLStringUitil MD5:string]

/*! @brief *
 *  返回去除字符串首的空格的字符串
 */
#define ZLStringClearLeadingWhiteSpace(string) [ZLStringUitil stringByTrimingLeadingWhiteSpace:string]

/*! @brief *
 *  返回去除字符串结尾的空格的字符串
 */
#define ZLStringClearTailingWhiteSpace(string) [ZLStringUitil stringByTrimingTailingWhiteSpace:string]

/*! @brief *
 *  返回去除字符串中所有的空格的字符串
 */
#define ZLStringClearAllWhiteSpace(string) [ZLStringUitil stringByTrimingWhiteSpace:string]

/*! @brief *
 *  Url编码对象,通常是字符串,返回编码后的字符串
 */
#define ZLStringEncodeString(string) [ZLStringUitil urlEncode:string]

/*! @brief *
 *  Url编码一个字典,键值对用@链接,返回编码后的字符串
 */
#define ZLStringEncodeDict(aDict) [ZLStringUitil encodeStringFromDict:aDict]

/*! @brief *
 *  返回字符串范围
 */
#define ZLStringRange(string) [ZLStringUitil stringRange:string]

/*! @brief *
 *  返回字符串范围
 */
#define ZLStringUUID [ZLStringUitil stringWithUUID]
/*! @brief *
 *  字符串为空时返回@""
 */
#define ZLIFISNULL(string)  ZLStringIsNull(string)?@"":string

#define ZLUTF8Length(string) [ZLStringUitil utf8Length:string]
/*! @brief *
 *  判断银行卡号的合法性
 */
#define ZLStringIsBankCard(string)  [ZLStringUitil isBankCard:string]

/**
 *  字符串为空时给一个@"   "有空格
 */
#define ZLIFSPACISNULL(object) [ZLStringUitil ifSpacStringNull:object]

/**
 *  字符串为是否包含表情
 */
#define ZLStringIsContainsEmoji(object) [ZLStringUitil isContainsEmoji:object]
//递归计算符合规定的文本长度
#define ZLStringCutBeyondTextInLength(object,string1) [ZLStringUitil cutBeyondTextInLength:object string:string1]

/**
 *  拼接字符串
 */
#define ZLStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
#endif /* ZLStringMacrocDefine_h */
