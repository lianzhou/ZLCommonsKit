//
//  JZStringMacrocDefine.h
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 18/7/10.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#ifndef JZStringMacrocDefine_h
#define JZStringMacrocDefine_h

#import "JZStringUitil.h"

//解决block内的循环引用
//weak
#define JZWeakObj(anObject)  __weak typeof(anObject)   weak##anObject = anObject;
//strong
#define JZStrongObj(anObject)  __strong typeof(anObject) strong##anObject = anObject;
/*! @brief *
 *  字符串是否为空
 */
#define JZStringIsNull(string) [JZStringUitil stringIsNull:string]

/*! @brief *
 *  字符串是否全为空格
 */
#define JZStringIsAllWhiteSpace(string) [JZStringUitil stringIsAllWhiteSpace:string]

/*! @brief *
 *  字符串转NSInteger
 */
#define JZStringToInt(string) [JZStringUitil stringToInt:string]

/*! @brief *
 *  字符串转CGFloat
 */
#define JZStringToFloat(string) [JZStringUitil stringToFloat:string]

/*! @brief *
 *  字符串转double
 */
#define JZStringToDouble(string) [JZStringUitil stringToDouble:string]

/*! @brief *
 *  字符串转Bool
 */
#define JZStringToBool(string) [JZStringUitil stringToBool:string]

/*! @brief *
 *  int转字符串
 */
#define JZStringFromInt(int) [JZStringUitil intToString:int]

/*! @brief *
 *  float转字符串
 */
#define JZStringFromFloat(float) [JZStringUitil floatToString:float]

/*! @brief *
 *  double转字符串
 */
#define JZStringFromDouble(double) [JZStringUitil doubleToString:double]

/*! @brief *
 *  bool转字符串
 */
#define JZStringFromBool(bool) [JZStringUitil boolToString:bool]

/*! @brief *
 *  字符串是否合法邮箱
 */
#define JZStringIsEmail(string) [JZStringUitil stringIsValidateEmailAddress:string]

/*! @brief *
 *  字符串是否合法手机号码
 */
#define JZStringIsMobilePhone(string) [JZStringUitil stringISValidateMobilePhone:string]

/*! @brief *
 *  字符串是否合法url
 */
#define JZStringIsUrl(string) [JZStringUitil stringIsValidateUrl:string]

/*! @brief *
 *  字符串是否合法座机
 */
#define JZStringIsPhone(string) [JZStringUitil stringIsValidatePhone:string]

/*! @brief *
 *  字符串是否合法邮政编码
 */
#define JZStringIsMailCode(string) [JZStringUitil stringIsValidateMailCode:string]

/*! @brief *
 *  字符串是否合法身份证号
 */
#define JZStringIsPersonCardNumber(string) [JZStringUitil stringISValidatePersonCardNumber:string]

/*! @brief *
 *  字符串是否合法车牌号
 */
#define JZStringIsCarNumber(string) [JZStringUitil stringISValidateCarNumber:string]

/*! @brief *
 *  字符串是否只有中文字符
 */
#define JZStringChineseOnly(string) [JZStringUitil stringIsAllChineseWord:string]

/*! @brief *
 *  字符串是否只有英文字符和数字
 */
#define JZStringCharNumOnly(string) [JZStringUitil stringJustHasNumberAndCharacter:string]

/*! @brief *
 *  字符串是否只包含字符，中文，数字
 */
#define JZStringCharNumChineseOnly(string) [JZStringUitil stringChineseNumberCharacterOnly:string]

/*! @brief *
 *  字符串是否只包含字母，中文
 */
#define JZStringCharChineseOnly(string) [JZStringUitil stringChineseCharacterOnly:string]

/*! @brief *
 *  字符串是否纯数字
 */
#define JZStringNumOnly(string) [JZStringUitil stringJustHasNumber:string]

/*! @brief *
 *  从文件中读取出字符串
 */
#define JZStringFromFile(path) [JZStringUitil stringFromFile:path]

/*! @brief *
 *  从归档路径读取出字符串
 */
#define JZStringUnArchieve(path) [JZStringUitil unarchieveFromPath:path]

/*! @brief *
 *  获取一个当前时间戳字符串
 */
#define JZStringCurrentTimeStamp [JZStringUitil currentTimeStampString]

/*! @brief *
 *  将字符串转为MD5字符串
 */
#define JZStringToMD5(string) [JZStringUitil MD5:string]

/*! @brief *
 *  返回去除字符串首的空格的字符串
 */
#define JZStringClearLeadingWhiteSpace(string) [JZStringUitil stringByTrimingLeadingWhiteSpace:string]

/*! @brief *
 *  返回去除字符串结尾的空格的字符串
 */
#define JZStringClearTailingWhiteSpace(string) [JZStringUitil stringByTrimingTailingWhiteSpace:string]

/*! @brief *
 *  返回去除字符串中所有的空格的字符串
 */
#define JZStringClearAllWhiteSpace(string) [JZStringUitil stringByTrimingWhiteSpace:string]

/*! @brief *
 *  Url编码对象,通常是字符串,返回编码后的字符串
 */
#define JZStringEncodeString(string) [JZStringUitil urlEncode:string]

/*! @brief *
 *  Url编码一个字典,键值对用@链接,返回编码后的字符串
 */
#define JZStringEncodeDict(aDict) [JZStringUitil encodeStringFromDict:aDict]

/*! @brief *
 *  返回字符串范围
 */
#define JZStringRange(string) [JZStringUitil stringRange:string]

/*! @brief *
 *  返回字符串范围
 */
#define JZStringUUID [JZStringUitil stringWithUUID]
/*! @brief *
 *  字符串为空时返回@""
 */
#define JZIFISNULL(string)  JZStringIsNull(string)?@"":string

#define JZUTF8Length(string) [JZStringUitil utf8Length:string]
/*! @brief *
 *  判断银行卡号的合法性
 */
#define JZStringIsBankCard(string)  [JZStringUitil isBankCard:string]

/**
 *  字符串为空时给一个@"   "有空格
 */
#define JZIFSPACISNULL(object) [JZStringUitil ifSpacStringNull:object]

/**
 *  字符串为是否包含表情
 */
#define JZStringIsContainsEmoji(object) [JZStringUitil isContainsEmoji:object]
//递归计算符合规定的文本长度
#define JZStringCutBeyondTextInLength(object,string1) [JZStringUitil cutBeyondTextInLength:object string:string1]



#endif /* JZStringMacrocDefine_h */
