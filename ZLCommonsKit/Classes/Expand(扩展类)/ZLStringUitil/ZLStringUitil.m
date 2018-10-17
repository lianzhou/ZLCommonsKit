//
//  ZLStringUitil.m
//  ZLCommonsKit
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by zhoulian on 17/5/25.
//  Copyright © 2017年 zhoulian. All rights reserved.
//

#import "ZLStringUitil.h"
#import <CommonCrypto/CommonDigest.h>
#import "ZLStringMacrocDefine.h"
#import "AFURLResponseSerialization.h"
#import "NSString+Extension.h"

@implementation ZLStringUitil

+ (BOOL)isNullObject:(id)anObject
{
    if (!anObject || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)stringIsNull:(NSString *)string
{
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (!string || [string isKindOfClass:[NSNull class]] || string.length == 0 || [string isEqualToString:@""] || [string isEqualToString:@"<null>"]) {
        return YES;
    }else{
        return NO;
    }
}
+ (NSUInteger)utf8Length:(NSString*)string
{
    if (ZLStringIsNull(string)) {
        return 0;
    }
    size_t length = strlen([string UTF8String]);
    return length;
}

+ (BOOL)stringIsAllWhiteSpace:(NSString *)string
{
    if ([self stringIsNull:string]) {
        return YES;
    }else{
        
        NSString *trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (trimString.length > 0) {
            return NO;
        }else{
            return YES;
        }
    }
}

+ (BOOL)stringToBool:(NSString*)sourceString
{
    if ([self stringIsNull:sourceString]) {
        return NO;
    }else{
        return [sourceString boolValue];
    }
}

+ (NSInteger)stringToInt:(NSString*)sourceString
{
    if ([self stringIsNull:sourceString]) {
        return NSIntegerMax;
    }else{
        return [sourceString intValue];
    }
}

+ (CGFloat)stringToFloat:(NSString*)sourceString
{
    if ([self stringIsNull:sourceString]) {
        return CGFLOAT_MAX;
    }else{
        return [sourceString floatValue];
    }
}

+ (double)stringToDouble:(NSString*)sourceString
{
    if ([self stringIsNull:sourceString]) {
        return CGFLOAT_MAX;
    }else{
        return [sourceString doubleValue];
    }
}

+ (NSString *)boolToString:(BOOL)boolValue
{
    return [NSString stringWithFormat:@"%d",boolValue];
}

+ (NSString *)intToString:(NSInteger)intValue
{
    return [NSString stringWithFormat:@"%ld",(long)intValue];
}

+ (NSString *)floatToString:(CGFloat)floatValue
{
    return [NSString stringWithFormat:@"%f",floatValue];
}

+ (NSString *)doubleToString:(double)doubleValue
{
    return [NSString stringWithFormat:@"%lf",doubleValue];
}


+ (NSString*)stringFromFile:(NSString*)path
{
    if ([self stringIsNull:path]) {
        return nil;
    }
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+ (BOOL)sourceString:(NSString*)sourceString regexMatch:(NSString *)regexString
{
    if ([self stringIsNull:sourceString]|| [self stringIsNull:regexString] ) {
        return NO;
    }
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    return [emailTest evaluateWithObject:sourceString];
}

+ (BOOL)stringIsValidateEmailAddress:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [ZLStringUitil sourceString:string regexMatch:emailRegex];
}

+ (BOOL)stringISValidateMobilePhone:(NSString *)string
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //^1[3|4|5|6|7|8|9][0-9]\\d{8}$
//^134[0-8]\\d{7}$|^13[^4]\\d{8}$|^14[5-9]\\d{8}$|^15[^4]\\d{8}$|^16[6]\\d{8}$|^17[0-8]\\d{8}$|^18[\\d]{9}$|^19[8,9]\\d{8}$
    //^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$
    NSString *phoneRegex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    return [ZLStringUitil sourceString:string regexMatch:phoneRegex];
}

+ (BOOL)stringISValidateCarNumber:(NSString *)string
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    return [ZLStringUitil sourceString:string regexMatch:carRegex];
}

+ (BOOL)stringIsValidateUrl:(NSString *)string
{
    NSString *checkRegex = @"^(([hH][tT]{2}[pP][sS]?)|([fF][tT][pP]))\\:\\/\\/[wW]{3}\\.[\\w-]+\\.\\w{2,4}(\\/.*)?$";
    return [ZLStringUitil sourceString:string regexMatch:checkRegex];
}

+ (BOOL)stringIsAllChineseWord:(NSString *)string
{
    NSString *checkRegex = @"^[\u4e00-\u9fa5]+$";
    return [ZLStringUitil sourceString:string regexMatch:checkRegex];
}

+ (BOOL)stringISValidatePersonCardNumber:(NSString *)string
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [ZLStringUitil sourceString:string regexMatch:regex2];
}

+ (BOOL)stringIsValidatePhone:(NSString *)string
{
    NSString *phoneRegex = @"^(^0\\d{2}-?\\d{8}$)|(^400\\-[0-9]{0,7}\\-[0-9]{1,7}$)|(^0\\d{3}-?\\d{7}$)|(^\\(0\\d{2}\\)-?\\d{8}$)|(^\\(0\\d{3}\\)-?\\d{7}$)$";
    return [ZLStringUitil sourceString:string regexMatch:phoneRegex];
}

+ (BOOL)stringIsValidateMailCode:(NSString *)string
{
    NSString *mailCodeRegex = @"^\\d{6}$";
    return [ZLStringUitil sourceString:string regexMatch:mailCodeRegex];
}

+ (BOOL)stringJustHasNumberAndCharacter:(NSString *)string
{
    NSString *checkRegex = @"[a-zA-Z0-9]*";
    return [ZLStringUitil sourceString:string regexMatch:checkRegex];
}
+ (BOOL)stringHasDotNumberAndCharacter:(NSString *)string {
    NSString *checkRegex = @"[a-zA-Z0-9.@]*";
    return [ZLStringUitil sourceString:string regexMatch:checkRegex];
}
+ (BOOL)stringChineseNumberCharacterOnly:(NSString *)string
{
    NSString *checkRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    return [ZLStringUitil sourceString:string regexMatch:checkRegex];
}
+ (BOOL)stringChineseCharacterOnly:(NSString *)string
{
    NSString *checkRegex = @"^[a-zA-Z \u4e00-\u9fa5]+$";
    return [ZLStringUitil sourceString:string regexMatch:checkRegex];
}
+ (BOOL)stringJustHasNumber:(NSString *)string
{
    NSString *checkRegex = @"^[0-9]*$";
    return [ZLStringUitil sourceString:string regexMatch:checkRegex];
}

+ (NSString*)currentTimeStampString
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceReferenceDate];
    
    NSString *timeString = [NSString stringWithFormat:@"%lf",timeInterval];
    timeString = [timeString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    return timeString;
    
}

+ (NSString *)MD5:(NSString *)string
{
    const char* aString = [string UTF8String];
    unsigned char result[16];
    CC_MD5(aString, (unsigned int)strlen(aString), result);
    NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    
    return [hash lowercaseString];
}

+ (NSString *)stringByTrimingLeadingWhiteSpace:(NSString *)string
{
    NSRange range = [string rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
    return [string stringByReplacingCharactersInRange:range withString:@""];
}

+ (NSString *)stringByTrimingTailingWhiteSpace:(NSString *)string
{
    NSRange range = [string rangeOfString:@"\\s*$" options:NSRegularExpressionSearch];
    return [string stringByReplacingCharactersInRange:range withString:@""];
}

+ (NSString *)stringByTrimingWhiteSpace:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// 转化为UTF8编码
+ (NSString *)urlEncode:(id)object {
    
//    if (ZLCheckObjectNull(object)) {
//        return nil;
//    }
    
    NSString *string = (NSString*)object;
    CFStringRef str = CFURLCreateStringByAddingPercentEscapes(nil,
                                                              (CFStringRef)string,
                                                              nil,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8);
    NSString *encodedValue = (__bridge NSString*)str;
    
    //    CFRelease(str);
    
    return encodedValue;
}

+ (NSString *)encodeStringFromDict:(NSDictionary *)dict
{
//    if (ZLCheckObjectNull(dict)) {
//        return nil;
//    }
    
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in dict) {
        @autoreleasepool {
            id value = [dict objectForKey: key];
            NSString *part = [NSString stringWithFormat: @"%@=%@",[ZLStringUitil urlEncode:key],[ZLStringUitil urlEncode:value]];
            [parts addObject: part];
        }
    }
    return [parts componentsJoinedByString: @"&"];//拼装字符串
}

+ (NSRange)stringRange:(NSString *)string
{
    if ([self stringIsNull:string]) {
        return NSMakeRange(NSNotFound, 0);
    }
    return NSMakeRange(0, string.length);
}

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize )maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
//判断银行卡号是否正确
+ (BOOL)isBankCard:(NSString *)cardNumber{
    if(cardNumber.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++){
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--){
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;

}
+ (NSString *)ifSpacStringNull:(NSString *)string{
    
    return ZLStringIsNull(string)?@"   ":string;

}

+ (BOOL)isContainsEmoji:(NSString *)string;
{
    if (ZLStringIsNull(string)) {
        return NO;
    }
    
//    if ([string rangeOfString:@"☹️"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤑"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤓"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤓"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤔"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤗"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤐"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤐"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤖"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤒"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤕"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"✊🏽"].location !=NSNotFound || [string rangeOfString:@"✊🏻"].location !=NSNotFound ||[string rangeOfString:@"✊🏼"].location !=NSNotFound ||[string rangeOfString:@"✊🏾"].location !=NSNotFound ||[string rangeOfString:@"✊🏿"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"🦁"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🦄"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🦂"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🦀"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🦃"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🧀"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"✋🏿"].location !=NSNotFound || [string rangeOfString:@"✋🏻"].location !=NSNotFound ||[string rangeOfString:@"✋🏼"].location !=NSNotFound ||[string rangeOfString:@"✋🏽"].location !=NSNotFound ||[string rangeOfString:@"✋"].location !=NSNotFound ||[string rangeOfString:@"✋🏾"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"✍🏾"].location !=NSNotFound || [string rangeOfString:@"✍🏻"].location !=NSNotFound ||[string rangeOfString:@"✍🏼"].location !=NSNotFound ||[string rangeOfString:@"✍🏽"].location !=NSNotFound ||[string rangeOfString:@"✍🏿"].location !=NSNotFound ) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"✌️"].location !=NSNotFound || [string rangeOfString:@"✌🏽"].location !=NSNotFound || [string rangeOfString:@"✌🏼"].location !=NSNotFound || [string rangeOfString:@"✌🏾"].location !=NSNotFound || [string rangeOfString:@"✌🏿"].location !=NSNotFound || [string rangeOfString:@"✌🏻"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"☝🏽"].location !=NSNotFound || [string rangeOfString:@"☝🏻"].location !=NSNotFound || [string rangeOfString:@"☝🏼"].location !=NSNotFound|| [string rangeOfString:@"☝🏾"].location !=NSNotFound|| [string rangeOfString:@"☝🏿"].location !=NSNotFound|| [string rangeOfString:@"☝️"].location !=NSNotFound) {
//        return YES;
//    }
//    if ([string rangeOfString:@"🤘"].location !=NSNotFound || [string rangeOfString:@"🤘🏻"].location !=NSNotFound || [string rangeOfString:@"🤘🏼"].location !=NSNotFound|| [string rangeOfString:@"🤘🏽"].location !=NSNotFound|| [string rangeOfString:@"🤘🏾"].location !=NSNotFound|| [string rangeOfString:@"🤘🏿"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"⛹🏼"].location !=NSNotFound || [string rangeOfString:@"⛹🏾"].location !=NSNotFound ||[string rangeOfString:@"⛹🏻"].location !=NSNotFound|| [string rangeOfString:@"⛹🏽"].location !=NSNotFound||[string rangeOfString:@"⛹🏿"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"🤼‍♀️"].location !=NSNotFound || [string rangeOfString:@"🤺"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"🤣"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"☺️"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"⌚️"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"🤡"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"🤢"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"🤤"].location !=NSNotFound) {
//        return YES;
//    }
//    
//    if ([string rangeOfString:@"☠️"].location !=NSNotFound) {
//        return YES;
//    }
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff)
        {
            if (substring.length > 1)
            {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f9e0)
                {
                    returnValue = YES;
                }
            }
        }
        else if (substring.length > 1)
        {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3 ||
                ls == 0xfe0f ||
                ls == 0xd83c)
            {
                returnValue = YES;
            }
        }
        else
        {
            if (0x2100 <= hs && hs <= 0x27ff)
            {
                returnValue = YES;
            }
            else if (0x2B05 <= hs && hs <= 0x2b07)
            {
                returnValue = YES;
            }
            else if (0x2934 <= hs && hs <= 0x2935)
            {
                returnValue = YES;
            }
            else if (0x3297 <= hs && hs <= 0x3299)
            {
                returnValue = YES;
            }
            else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
            {
                returnValue = YES;
            }
        }
        
        *stop = returnValue;
    }];
    
    return returnValue;
}
//递归计算符合规定的文本长度
+ (NSString *)cutBeyondTextInLength:(NSInteger)maxLenth string:(NSString *)string
{
    size_t length = strlen([string UTF8String]);
    if (length > maxLenth)
    {
        NSString *text = [string substringToIndex:string.length - 1];
        return [self cutBeyondTextInLength:maxLenth string:text];
    }
    else
    {
        return string;
    }
}
//汉字的不同颜色和大小的混排
+ (NSMutableAttributedString *)createTextKitWithString:(NSString*)string attributes:(NSDictionary*)attributes withRange:(NSRange)range{
    //图文混排
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:string];
    [titleString addAttributes:attributes range:range];
    return  titleString;
}
//修改不同汉字的大小以及某个位置的汉字颜色
+ (NSMutableAttributedString *)changeTextWithString:(NSString *)textStr withFirstAttribues:(NSDictionary *)firstAttributeDic withFirstRange:(NSRange)firstRange withSecondAttributes:(NSDictionary *)secondAttributesDic withSecondRange:(NSRange)secondRange {
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:textStr];
    [titleString addAttributes:firstAttributeDic range:firstRange];
    [titleString addAttributes:secondAttributesDic range:secondRange];
    return  titleString;
}
//图文混排
+ (NSMutableAttributedString *)createTextKitWithString:(NSString*)string attributes:(NSDictionary*)attributes image:(NSString*)imageName  index:(NSInteger)index{
    //图文混排
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc]initWithString:string attributes:attributes];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *showImage = [UIImage imageNamed:imageName];
    textAttachment.image = showImage;
//    UIFont *font = [attributes objectForKey:NSFontAttributeName];
    CGFloat y = -1.25;
    textAttachment.bounds = CGRectMake(0, y, showImage.size.width, showImage.size.height);
    NSAttributedString *textAttschmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [titleString insertAttributedString:textAttschmentString atIndex:index];
    return  titleString;
}
+ (NSString *)ZLCusTomWithMessageError:(NSError *)error{
//    @try {
//        NSError * ZLError = (NSError *)error;
//        NSDictionary * userInfo = ZLError.userInfo;
//
//        id  response = userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
//        NSString * responseText = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
//        id  responseObject = [NSString jsonStringToNSDictionary:responseText];
//        id  errorDic =   [responseObject objectForKey:@"error"];
//        NSString * errorKey = [errorDic objectForKey:@"key"];
//        if (ZLStringIsNull(responseText)) {
//            NSDictionary * errorUserInfo = (NSDictionary *)error.userInfo;
//            errorDic =  [NSString stringWithFormat:@"%@",[errorUserInfo objectForKey:@"NSLocalizedDescription"]];
//            if (!ZLStringIsNull(errorKey)) {
//                NSLog(@"错误:---------\n%@\n-----",errorKey);
//                return errorKey;
//            }else{
//                NSLog(@"错误:---------\n%@\n-----",error);
//            }
//        }else{
//            NSLog(@"错误:---------\n%@\n-----",responseText);
//        }
//
//        if (!ZLStringIsNull(errorKey)) {
//            NSString * errorMessage = ZLRequestErrorMessage(errorKey);
//            if (!ZLStringIsNull(errorMessage)) {
//                return  errorMessage;
//            }else{
//                return @"";
//            }
//        }else{
//            return @"";
//        }
//
//    } @catch (NSException *exception) {
////        [ZLUtilsTools uploadLog:ZL_EXCEPTION(exception)];
//        return @"";
//    }
    
    return  [error localizedDescription];
}
//根据传入的时间（以秒为单位）的返回xxhxxmin的格式的
+ (NSMutableAttributedString *)returnContent:(NSString *)timeStr withStartAttributeDic:(NSDictionary *)startAttrDic withEndAttributeDic:(NSDictionary *)endAttriDic {
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] init];
    
    //秒数
    NSInteger second = 0;
    
    //分钟
    NSInteger minute = 0;
    
    //小时
    NSInteger hour = 0;
    
    //小时
    NSAttributedString *hourStr1 = nil;
    
    NSAttributedString *hourStr2 = nil;
    
    //分钟
    NSAttributedString *minuteStr1 = nil;
    
    NSAttributedString *minuteStr2 = nil;
    
    NSInteger count = [timeStr integerValue];
    
    if (count <= 60 && count > 0) {
        minute = 1;
    }else{
        
        minute = count / 60;
        
        second = count % 60;
        
        if (second > 0) {
            minute += 1;
        }
        if (minute >= 60) {
            hour = minute / 60;
            minute = minute % 60;
        }
    }
    if (hour > 0) {
        hourStr1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",hour] attributes:startAttrDic];
        hourStr2 = [[NSAttributedString alloc] initWithString:@"h" attributes:endAttriDic];
        [attributeStr appendAttributedString:hourStr1];
        [attributeStr appendAttributedString:hourStr2];
    }
    minuteStr1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",minute] attributes:startAttrDic];
    minuteStr2 = [[NSAttributedString alloc] initWithString:@"min" attributes:endAttriDic];
    [attributeStr appendAttributedString:minuteStr1];
    [attributeStr appendAttributedString:minuteStr2];
    
    return attributeStr;
}
/**
 *  @return 根据error的key 得到自定义的提示
 */
static inline NSString * ZLRequestErrorMessage(NSString * errorKey){
    return [ZLRequestErrorDic() objectForKey:errorKey];
}
static inline NSDictionary * ZLRequestErrorDic(){
    return @{@"apis.groups.groupsLimit":@"创建群数量已达上限",
             @"answer.error":@"该问题已经被别人回答",
             @"apis.user.authentication.failed":@"用户名或密码错误",
             @"api.account.paycode.nomatch":@"提现密码错误",
             @"api.product.noEnoughProduct":@"库存不足",
             @"api.peace.stu.par.or.cardId.have.bind":@"该卡已绑定",
             @"student.id.error":@"孩子已被删除",
             @"apis.user.userNameisillega":@"姓名中不能包含表情",
             @"password.error":@"支付密码错误",
             @"apis.user.phonenumexisted":@"该账号信息已在后台录入,请重新注册",
             @"api.account.disabled":@"您的e学云账户已被冻结,请联系客服进行解冻",
             @"apis.user.noguest":@"用户不存在",
             @"api.live.device.no.exists":@"当前设备不存在,支付失败",
             @"apis.user.oldpassword.incorrect":@"旧密码输入错误,密码修改失败",
             @"api.product.novalue":@"此商品已下线",
             @"apis.user.card.coupon.efficacy":@"该卡券已经失效",
             @"apis.user.card.coupon.no.exist":@"该卡券不存在",
             @"apis.user.card.coupon.has.used":@"该卡券已经被使用",
             @"apis.user.card.coupon.no.equals.userId":@"该卡券已经被领取",
             @"apis.user.card.coupon.no.equals.school":@"该卡券与所在的学校不匹配",
             @"apis.user.card.coupon.equals.userId":@"该卡券您已领取",
             @"apis.groups.groupsLimit":@"你创建的圈子数已达上限!",
             @"apis.groups.groupsAttentLimit":@"你关注的圈子数已达上限!",
             @"apis.groups.groupsAttentNumberLimit":@"此圈子人数已满!",
             @"apis.groups.hasAttent":@"您已经加入过这个圈子!",
             @"apis.user.noguest":@"用户不存在",
             @"api.peace.cardId.not.null":@"此孩子还没有绑定平安卡",
             @"api.peace.stu.par.have.bind":@"您的孩子已经绑定了平安卡，不能继续绑定",
             @"api.peace.cardId.have.not.belong.to.orange":@"非法卡号,无法绑定",
             @"apis.class.noprivelege":@"您不在该班级",
             };
}
@end
