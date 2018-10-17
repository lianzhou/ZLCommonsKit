//
//  ZLEmojiHelper.h
//  ZLChatToolBarView
//
//  Created by 马金丽 on 17/6/23.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZLEmojiInfo;

@interface ZLEmojiHelper : NSObject
@property(nonatomic,strong)NSMutableArray *emojList;

+ (ZLEmojiHelper *)shareInstance;

+ (BOOL)isEmojStr:(NSString *)emojStr;


/**
 所有表情

 @return 返回所有表情数组
 */
+ (NSArray *)emojisArray;


/**
 表情转字符串字典

 @return 字符串字典
 */
+ (NSDictionary *)emojiTextDict;


/**
 表情总页码

 @return 页码
 */
+ (NSInteger)emojiAllPage;


/**
 返回当前页的表情数组

 @param page 当前页
 @return 数组
 */
+ (NSArray *)emojisCurrentPage:(NSInteger)page;

+ (NSString *)emojiIconName:(NSString *)iconName;

//一页多少个表情
+ (NSInteger)emojiCountCurrentPage;
//一页多少列
+ (NSInteger)colsOfCurrentPage;
//一页多少行
+ (NSInteger)lineOfCurrentPage;

//每个表情的尺寸
+ (CGFloat)emojiSize;

@end
