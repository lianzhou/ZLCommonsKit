//
//  JZLabel.h
//  YYKit简单封装
//
//  Created by 马金丽 on 17/6/15.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import <YYKit/YYKit.h>

@class JZLabel;

typedef enum : NSUInteger {
    JZLabelLongPressUrl,
    JZLabelLongPressAt,
    JZLabelLongPressPhone,
} JZLabelHeightLongPressType;

@protocol JZLabelDelegate <NSObject>

@optional

//文本轻点
- (void)jzLabel:(JZLabel *)jzLabel didtapSelectStr:(NSString *)selectStr;
//文本长按
- (void)jzLabel:(JZLabel *)jzLabel didLongPressSelectStr:(NSString *)selectStr;
//高亮轻点
- (void)jzLabel:(JZLabel *)jzLabel didHeightTextTapSelectStr:(NSString *)selectStr withTapType:(JZLabelHeightLongPressType)hieghtType;
//高亮长按
- (void)jzLabel:(JZLabel *)jzLabel didHeightTextLongPressSelectStr:(NSString *)selectStr withLongPressType:(JZLabelHeightLongPressType)hieghtType;

//特殊字符高亮点击
- (void)jzLabel:(JZLabel *)jzLabel didSpecialTextHeightTapSelectStr:(NSString *)selectStr;


- (void)jzLabel:(JZLabel *)jzLabel didSelectStrIndex:(NSInteger)selectIndex;
@end
@interface JZLabel : YYLabel



#pragma mark -计算文本高度
/**
 计算文本高度

 @param maxLayoutWidth 文本宽度
 @param font 文本字体大小
 @param emojiText 内容
 @param edgeInsets 内间距
 @param maximumNumberOfRows 最多显示几行
 @return CGSize
 */
+ (CGSize)preferredSizeWith_MaxWidth:(CGFloat)maxLayoutWidth
                           with_font:(UIFont *)font
                      with_emojiText:(NSString *)emojiText
                     with_edgeInsets:(UIEdgeInsets)edgeInsets
            with_maximumNumberOfRows:(NSUInteger)maximumNumberOfRows;


#pragma mark - 某段文字显示不同颜色
-(void)setColor:(UIColor *)color with_Alltext:(NSString *)text with_Substr:(NSString *)Substr;
#pragma mark - 匹配@
- (void)matchAt_withAtStr:(NSString *)atStr with_color:(UIColor *)atColor;
#pragma mark - 超出指定行数加...XXX
- (void)addMoreStr:(NSString *)moreStr with_maxNumberOfRows:(NSUInteger)maxNumberOfRows;
#pragma mark - 超出指定行数加...图片
- (void)addEndImageStr:(NSString *)imageStr with_maxNumberOfRows:(NSUInteger)maxNumberOfRows;
#pragma mark- 匹配字体
-(void)setAttributeDic:(NSDictionary *)attributeDic with_Alltext:(NSString *)text with_Substr:(NSString *)Substr;
#pragma mark 文字后面加图片
-(void)stringWithUIImage:(NSString *) contentStr imageStr:(NSString *) imageStr imageSize:(CGSize)imageSize;

@property(nonatomic,assign)id<JZLabelDelegate>delegate;

/**
内容---写在最后,在所有属性都配置完成之后
 */
@property(nonatomic,copy)NSString *textString;

/**
 匹配URL
 */
@property(nonatomic,assign)BOOL matchURL;

/**
 匹配Phone
 */
@property(nonatomic,assign)BOOL matchPhone;

/**
 匹配表情
 */
@property(nonatomic,assign)BOOL matchEmoj;

/**
 匹配@
 */
@property(nonatomic,assign)BOOL matchAt;

@property(nonatomic,assign)BOOL isParagraph;


@property(nonatomic,assign)YYTextTruncationType textTruncationType;

/**
 匹配全局字符+颜色,空间动态使用
 */
@property(nonatomic, strong) NSDictionary *matchOverallDic;

@end
