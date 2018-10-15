//
//  JZEmojiHelper.m
//  JZChatToolBarView
//
//  Created by 马金丽 on 17/6/23.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "JZEmojiHelper.h"
#import "JZEmojiInfo.h"
#import "JZSystemMacrocDefine.h"


@interface JZEmojiHelper()



@end


@implementation JZEmojiHelper

+(JZEmojiHelper *)shareInstance
{
    static JZEmojiHelper *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[JZEmojiHelper alloc]init];
        [share createEmojiList];
    });
    return share;
}



//判断用户是否输入了表情
+ (BOOL)isEmojStr:(NSString *)emojStr
{

    const unichar hs = [emojStr characterAtIndex:0];
    // surrogate pair
    BOOL returnValue = NO;
    if (0xd800 <= hs && hs <= 0xdbff)
    {
        if (emojStr.length > 1)
        {
            const unichar ls = [emojStr characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f)
            {
                returnValue = YES;
            }
        }
    }
    else if (emojStr.length > 1)
    {
        const unichar ls = [emojStr characterAtIndex:1];
        if (ls == 0x20e3)
        {
            returnValue = YES;
        }
        
    }
    else
    {
        // non surrogate
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
    return returnValue;
}

//获取到表情数据
- (void)createEmojiList

{
//    NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/emoji.plist"];
    NSBundle *mainBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JZEmojiExpression" ofType:@"bundle"]];
    
    NSArray *emojiArray = [NSArray arrayWithContentsOfFile:[mainBundle pathForResource:@"emoji" ofType:@"plist"]];
    for (int i = 0; i < emojiArray.count; i++) {
        NSDictionary  *emojiDictionary = [emojiArray objectAtIndex:i];
        JZEmojiInfo *emojInfo = [[JZEmojiInfo alloc]init];
        emojInfo.emjStr = [emojiDictionary.allKeys firstObject];
        emojInfo.imageName = [emojiDictionary objectForKey:emojInfo.emjStr];
        emojInfo.emojiIndex = i;
        [self.emojList addObject:emojInfo];
    }
}

- (NSMutableArray *)emojList {
    if (!_emojList) {
        _emojList = [[NSMutableArray alloc] init];
    }
    return _emojList;
}


#pragma mark - 所有表情
+ (NSArray *)emojisArray {
    
    NSBundle *mainBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JZEmojiExpression" ofType:@"bundle"]];
    return [NSArray arrayWithContentsOfFile:[mainBundle pathForResource:@"emoji" ofType:@"plist"]];
}

#pragma mark - 表情转字符串字典
+ (NSDictionary *)emojiTextDict {
    
    NSBundle *mainBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"JZEmojiExpression" ofType:@"bundle"]];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[mainBundle pathForResource:@"emojiName" ofType:@"plist"]];
    
    return dict;
}

#pragma mark - 获取表情图片路径
+ (NSString *)emojiIconName:(NSString *)iconName {
    
    NSString *imagePath = [@"JZEmojiExpression.bundle" stringByAppendingPathComponent:iconName];
    return imagePath;
}

#pragma mark - 总页数

+ (NSInteger)emojiAllPage {
    
    NSInteger emojiCount = [self emojisArray].count;
    
    return (emojiCount - 1) / [self emojiCountCurrentPage] + 1;
}

#pragma mark - 一页显示多少个表情
+ (NSInteger)emojiCountCurrentPage {
    
    static NSInteger emojiCountOfPage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (([JZSystemUtils deviceScreenSize].width>=414)) {
            emojiCountOfPage = 23;
        }else{
            emojiCountOfPage = 20;
        }
    });
    return emojiCountOfPage;
}

#pragma mark - 一页多少列

+ (NSInteger)colsOfCurrentPage {
    
    static NSInteger colsOfPage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([JZSystemUtils deviceScreenSize].width>=414) {
            colsOfPage = 8;
        }else{
            colsOfPage = 7;
        }
    });
    return colsOfPage;
    
}

#pragma mark - 一页多少行
+ (NSInteger)lineOfCurrentPage {
    
    static NSInteger lineOfPage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lineOfPage = 3;
    });
    return lineOfPage;
}

#pragma mark - 每个表情的size

+ (CGFloat)emojiSize {
    static CGFloat emotionWH;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emotionWH = 33.0f;
    });
    return emotionWH;
}

#pragma mark - 当前页的表情数组
+ (NSArray *)emojisCurrentPage:(NSInteger)page {
    //获取所有表情
    NSArray *allCount = [self emojisArray];
    
    //角标
    NSInteger locIndex = page * [self emojiCountCurrentPage];
    
    //长度(当前页的表情数)
    NSInteger lengthCount = [self emojiCountCurrentPage];
    
    //总页数
    NSInteger allPage = [self emojiAllPage];
    
    if (page < 0 || page == allPage) {
        NSLog(@"超出页码或者页码不对");
        return nil;
    }
    
    if (page == allPage - 1) {  //最后一页(显示剩余表情)
        lengthCount = allCount.count % [self emojiCountCurrentPage];
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(locIndex, lengthCount)];
    NSArray *emojis = [allCount objectsAtIndexes:indexSet];
    return emojis;
}



@end
