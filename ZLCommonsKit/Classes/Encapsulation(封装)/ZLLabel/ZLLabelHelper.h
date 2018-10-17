//
//  ZLLabelHelper.h
//  YYKit简单封装
//
//  Created by 马金丽 on 17/6/16.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLLabelHelper : NSObject
+ (NSRegularExpression *)phoneNumerRegularExpression;
+ (NSRegularExpression *)regexAt;
+ (NSRegularExpression *)emojiRegexEmoticon;
+ (NSRegularExpression *)URLRegularExpression;


+ (NSDictionary *)emojiDictionary ;
@end
