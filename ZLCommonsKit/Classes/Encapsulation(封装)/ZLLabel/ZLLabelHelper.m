//
//  ZLLabelHelper.m
//  YYKit简单封装
//
//  Created by 马金丽 on 17/6/16.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "ZLLabelHelper.h"

@implementation ZLLabelHelper
//URL的正则表达式
+ (NSRegularExpression *)URLRegularExpression {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:kNilOptions error:NULL];
    });
    return regex;
}
//电话的正则表达式
+ (NSRegularExpression *)phoneNumerRegularExpression {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$" options:kNilOptions error:NULL];
    });
    
    return regex;
}
//@用户名的正则表达式
+ (NSRegularExpression *)regexAt {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:kNilOptions error:NULL];
    });
    return regex;
}
//表情的正则表达式
+ (NSRegularExpression *)emojiRegexEmoticon {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

+ (NSDictionary *)emojiDictionary {
    static NSDictionary *emojiDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *mainBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ZLEmojiExpression" ofType:@"bundle"]];
        emojiDictionary = [NSDictionary dictionaryWithContentsOfFile:[mainBundle pathForResource:@"emojiName" ofType:@"plist"]];
    });
    return emojiDictionary;
}

@end
