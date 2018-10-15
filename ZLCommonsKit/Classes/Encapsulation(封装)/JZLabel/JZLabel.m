//
//  JZLabel.m
//  YYKit简单封装
//
//  Created by 马金丽 on 17/6/15.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "JZLabel.h"
#import "JZLabelHelper.h"
#import "JZStringMacrocDefine.h"
#import "JZSystemMacrocDefine.h"

@interface JZLabel()

@property(nonatomic,strong)NSMutableAttributedString *resultText;
@end

@implementation JZLabel



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initializer];
}

+ (instancetype)sharenInstance
{
    static JZLabel *label = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [[JZLabel alloc]init];
    });
    return label;
}



//初始化
- (void)initializer
{
    self.displaysAsynchronously = YES;
    self.ignoreCommonProperties = YES;//通过textLayout实现label的内容显示,设置为YES,性能更高
    //    self.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    //文本轻点
    self.textTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        NSString *resultStr = [text string];
        if (range.location >= text.length) return;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(jzLabel:didtapSelectStr:)]) {
            [weakSelf.delegate jzLabel:weakSelf didtapSelectStr:resultStr];
        }
    };
    //文本长按
    self.textLongPressAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        NSString *resultStr = [text string];
        if (range.location >= text.length) return;
        if (self.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didLongPressSelectStr:)]) {
            [weakSelf.delegate jzLabel:weakSelf didLongPressSelectStr:resultStr];
        }
    };
    
    //高亮轻点(电话,@,链接)
    self.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        if (range.location >= text.length) return;
        YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:range.location];
        NSDictionary *info = highlight.userInfo;
        if (info.count == 0) {
            return;
        }
        if ([info objectForKey:@"at"]) {
            NSString *url = info[@"at"];
            
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didHeightTextTapSelectStr:withTapType:)]) {
                [weakSelf.delegate jzLabel:weakSelf didHeightTextTapSelectStr:url withTapType:JZLabelLongPressAt];
            }
        }
        if ([info objectForKey:@"url"]) {
            NSString *url = info[@"url"];
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didHeightTextTapSelectStr:withTapType:)]) {
                [weakSelf.delegate jzLabel:weakSelf didHeightTextTapSelectStr:url withTapType:JZLabelLongPressUrl];
            }
        }
        if ([info objectForKey:@"phone"]) {
            NSString *url = info[@"phone"];
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didHeightTextTapSelectStr:withTapType:)]) {
                [weakSelf.delegate jzLabel:weakSelf didHeightTextTapSelectStr:url withTapType:JZLabelLongPressPhone];
            }
            
        }
        
    };
    
    self.highlightLongPressAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        if (range.location >= text.length) return;
        YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:range.location];
        NSDictionary *info = highlight.userInfo;
        if (info.count == 0) {
            return;
        }
        if ([info objectForKey:@"at"]) {
            NSString *url = info[@"at"];
            
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didHeightTextLongPressSelectStr:withLongPressType:)]) {
                [weakSelf.delegate jzLabel:weakSelf didHeightTextLongPressSelectStr:url withLongPressType:JZLabelLongPressAt];
            }
        }
        if ([info objectForKey:@"url"]) {
            NSString *url = info[@"url"];
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didHeightTextLongPressSelectStr:withLongPressType:)]) {
                [weakSelf.delegate jzLabel:weakSelf didHeightTextLongPressSelectStr:url withLongPressType:JZLabelLongPressUrl];
            }
        }
        if ([info objectForKey:@"phone"]) {
            NSString *url = info[@"phone"];
            if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didHeightTextLongPressSelectStr:withLongPressType:)]) {
                [weakSelf.delegate jzLabel:weakSelf didHeightTextLongPressSelectStr:url withLongPressType:JZLabelLongPressPhone];
            }
            
        }
    };
    
}
//计算文本高度
+ (CGSize)preferredSizeWith_MaxWidth:(CGFloat)maxLayoutWidth
                           with_font:(UIFont *)font
                      with_emojiText:(NSString *)emojiText
                     with_edgeInsets:(UIEdgeInsets)edgeInsets
            with_maximumNumberOfRows:(NSUInteger)maximumNumberOfRows
{
    if (JZStringIsNull(emojiText)) {
        return CGSizeZero;
    }
    
    
    NSMutableAttributedString *resultText = [[NSMutableAttributedString alloc]initWithString:emojiText];
    [JZLabel sharenInstance].font = font;
    resultText.font = font;
    //匹配表情
    resultText = [[JZLabel sharenInstance] matchEmjo_withOldString:resultText];
    if ([JZLabel sharenInstance].matchURL) {
        //匹配URL
        resultText = [[JZLabel sharenInstance] matchURL_withOldString:resultText];
    }
    if ([JZLabel sharenInstance].matchPhone) {
        resultText = [[JZLabel sharenInstance] matchPhone_withOldString:resultText];
    }
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(maxLayoutWidth, CGFLOAT_MAX) insets:edgeInsets];
    if (!maximumNumberOfRows) {
        maximumNumberOfRows = 0;
    }
    container.maximumNumberOfRows = maximumNumberOfRows;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:resultText];
    return layout.textBoundingSize;
}

//显示不同颜色
-(void)setColor:(UIColor *)color with_Alltext:(NSString *)text with_Substr:(NSString *)Substr
{
    _resultText.font = self.font;
    if (JZStringIsNull(Substr)) {
        return;
    }
    NSRange range = [text rangeOfString:Substr];
    if (range.length != 0) {
        [_resultText setColor:color range:[text rangeOfString:Substr]];
    }
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX)];
    container.truncationType = YYTextTruncationTypeEnd;
    container.maximumNumberOfRows = self.numberOfLines;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:_resultText];
    self.textLayout = layout;
    
}

-(void)setAttributeDic:(NSDictionary *)attributeDic with_Alltext:(NSString *)text with_Substr:(NSString *)Substr
{
    //    _resultText.font = self.font;
    if (JZStringIsNull(Substr)) {
        return;
    }
    NSRange range = [text rangeOfString:Substr];
    if (range.length != 0) {
        [_resultText setAttributes:attributeDic range:[text rangeOfString:Substr]];
    }
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX)];
    container.truncationType = YYTextTruncationTypeEnd;
    container.maximumNumberOfRows = self.numberOfLines;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:_resultText];
    self.textLayout = layout;
    
}


- (void)addEndImageStr:(NSString *)imageStr with_maxNumberOfRows:(NSUInteger)maxNumberOfRows {
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX) insets:self.textContainerInset];
    //默认添加...
    NSMutableAttributedString *moreText = [[NSMutableAttributedString alloc] initWithString:@"..."];
    //添加图片
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:[UIImage imageNamed:imageStr] contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(20, 20) alignToFont:self.font alignment:YYTextVerticalAlignmentCenter];
    [moreText appendAttributedString:attachText];
    
    [moreText setTextHighlightRange:NSMakeRange(0, moreText.length) color:[UIColor blueColor] backgroundColor:[UIColor redColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didSpecialTextHeightTapSelectStr:)]) {
            [self.delegate jzLabel:self didSpecialTextHeightTapSelectStr:[text string]];
        }
    }];
    
    YYLabel *moreLabel = [[YYLabel alloc] init];
    moreLabel.attributedText = moreText;
    [moreLabel sizeToFit];
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:moreLabel contentMode:UIViewContentModeCenter attachmentSize:moreLabel.frame.size alignToFont:self.font alignment:YYTextVerticalAlignmentCenter];
    container.truncationToken = truncationToken;
    
    moreText.font =self.font;
    container.truncationType = YYTextTruncationTypeEnd;
    container.maximumNumberOfRows = maxNumberOfRows;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:_resultText];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textLayout = layout;
    });
    
}

- (void)addMoreStr:(NSString *)moreStr with_maxNumberOfRows:(NSUInteger)maxNumberOfRows
{
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX) insets:self.textContainerInset];
    if (moreStr.length != 0) {
        moreStr = [NSString stringWithFormat:@"%@",moreStr];
        NSMutableAttributedString *moreText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"...%@",moreStr]];
        YYTextHighlight *hi = [YYTextHighlight new];
        [hi setColor:[UIColor blueColor]];
        
        hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didSpecialTextHeightTapSelectStr:)]) {
                [self.delegate jzLabel:self didSpecialTextHeightTapSelectStr:[text string]];
            }
        };
        
        [moreText setColor:[UIColor blueColor] range:[moreText.string rangeOfString:moreStr]];
        [moreText setTextHighlight:hi range:[moreText.string rangeOfString:moreStr]];
        moreText.font =self.font;
        
        YYLabel *seeMore = [[YYLabel alloc] init];
        seeMore.attributedText = moreText;
        [seeMore sizeToFit];
        
        NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:self.font alignment:YYTextVerticalAlignmentCenter];
        
        container.truncationToken = truncationToken;
    }
    container.truncationType = YYTextTruncationTypeEnd;
    container.maximumNumberOfRows = maxNumberOfRows;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:_resultText];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textLayout = layout;
    });
    
    
}


//setter
- (void)setTextString:(NSString *)textString{
    if (textString == nil) {
        return;
    }
    _textString = textString;
    NSMutableAttributedString *attribuText = [[NSMutableAttributedString alloc]initWithString:textString];
    attribuText.color = self.textColor;
    
    if (self.isParagraph) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.firstLineHeadIndent = 5;
        paragraphStyle.headIndent = 5;
        paragraphStyle.lineSpacing = 3;
        [attribuText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attribuText.length)];
    }
    
    //匹配表情
    attribuText = [self matchEmjo_withOldString:attribuText];
    
    if (self.matchURL) {
        //匹配URL
        attribuText = [self matchURL_withOldString:attribuText];
    }
    if (self.matchPhone) {
        attribuText = [self matchPhone_withOldString:attribuText];
    }
    //    if (self.matchAt) {
    //        attribuText = [self matchAt_withOldString:attribuText];
    //    }
    if (self.matchOverallDic) {
        attribuText = [self matchOverallDic:self.matchOverallDic attributeString:attribuText labelString:textString];
    }
    _resultText = attribuText;
    _resultText.font = self.font;
    //_resultText.color = self.textColor;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX)];
    if (self.textTruncationType != YYTextTruncationTypeEnd) {
        container.truncationType = self.textTruncationType;
    } else {
        container.truncationType = YYTextTruncationTypeEnd;
    }
    container.maximumNumberOfRows = self.numberOfLines;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attribuText];
    self.textLayout = layout;
}

//匹配表情
- (NSMutableAttributedString *)matchEmjo_withOldString:(NSMutableAttributedString *)oldText{
    oldText.lineSpacing = 3.0;
    oldText.font = self.font;
    //获取到包含表情的数组
    NSArray *emjoRequest = [[JZLabelHelper emojiRegexEmoticon] matchesInString:oldText.string options:kNilOptions range:oldText.rangeOfAll];
    NSUInteger emjoIndex = 0;
    for (NSTextCheckingResult *result in emjoRequest) {
        if (result.range.location == NSNotFound && result.range.length <=1) {
            continue;
        }else{
            NSRange range = result.range;
            range.location -=emjoIndex;
            if ([oldText attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
            if ([oldText attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
            NSString *emoString = [oldText.string substringWithRange:range];
            NSString *imagePathName = [JZLabelHelper emojiDictionary][emoString];
            NSString *imagePath = [@"JZEmojiExpression.bundle" stringByAppendingPathComponent:imagePathName];
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) continue;
            NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:self.font.pointSize];
            [oldText replaceCharactersInRange:range withAttributedString:emoText];
            emjoIndex += range.length - 1;
        }
    }
    NSMutableAttributedString *attribuText = [oldText mutableCopy];
    
    return attribuText;
    
}

//匹配URL
- (NSMutableAttributedString *)matchURL_withOldString:(NSMutableAttributedString *)oldText{
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = UIColorRGBA(230, 230, 230, 0.5);
    NSArray *urlResults = [[JZLabelHelper URLRegularExpression] matchesInString:oldText.string options:kNilOptions range:oldText.rangeOfAll];
    for (NSTextCheckingResult *phoneResult in urlResults) {
        if (phoneResult.range.location == NSNotFound && phoneResult.range.length <= 1) continue;
        if ([oldText attribute:YYTextHighlightAttributeName atIndex:phoneResult.range.location] == nil) {
            [oldText setColor:[UIColor blueColor] range:phoneResult.range];
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{@"url" : [oldText.string substringWithRange:NSMakeRange(phoneResult.range.location, phoneResult.range.length)]};
            [oldText setTextHighlight:highlight range:phoneResult.range];
        }
    }
    NSMutableAttributedString *attribuText = [oldText mutableCopy];
    return attribuText;
}

//匹配Phone
- (NSMutableAttributedString *)matchPhone_withOldString:(NSMutableAttributedString *)oldText{
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = UIColorRGBA(230, 230, 230, 0.5);
    // 匹配 手机号
    NSArray *phoneResults = [[JZLabelHelper phoneNumerRegularExpression] matchesInString:oldText.string options:kNilOptions range:oldText.rangeOfAll];
    for (NSTextCheckingResult *phoneResult in phoneResults) {
        if (phoneResult.range.location == NSNotFound && phoneResult.range.length <= 1){
            continue;
        }
        if (phoneResult.range.length>11) {
            continue;
        }
        if ([oldText attribute:YYTextHighlightAttributeName atIndex:phoneResult.range.location] == nil) {
            [oldText setColor:[UIColor blueColor] range:phoneResult.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            
            highlight.userInfo = @{@"phone" : [oldText.string substringWithRange:NSMakeRange(phoneResult.range.location, phoneResult.range.length )]};
            [oldText setTextHighlight:highlight range:phoneResult.range];
        }
    }
    NSMutableAttributedString *attribuText = [oldText mutableCopy];
    return attribuText;
}

//匹配@---暂时不用
- (NSMutableAttributedString *)matchAt_withOldString:(NSMutableAttributedString *)oldText{
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor yellowColor];
    NSArray *atResults = [[JZLabelHelper regexAt] matchesInString:oldText.string options:kNilOptions range:oldText.rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([oldText attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [oldText setColor:[UIColor blueColor] range:at.range];
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{@"at" : [oldText.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [oldText setTextHighlight:highlight range:at.range];
            
        }
        
    }
    
    NSMutableAttributedString *attribuText = [oldText mutableCopy];
    return attribuText;
}

- (NSMutableAttributedString *)matchOverallDic:(NSDictionary *)matchDic attributeString:(NSMutableAttributedString *)attreibuteString labelString:(NSString *)labelString {
    UIColor *matchColor = (UIColor *)[matchDic objectForKey:@"matchColor"];
    NSDictionary *matchContentDic = (NSDictionary *)[matchDic valueForKey:@"matchContentDic"];
    NSArray *nameArray = (NSArray *)[matchContentDic valueForKey:@"nameArray"];
    NSMutableAttributedString *matchAttribute = [[NSMutableAttributedString alloc] initWithAttributedString:attreibuteString];
    NSUInteger currentLocation = 0;
    NSUInteger currentLength = 0;
    for (int i = 0 ; i < nameArray.count; i++) {
        @weakify(self);
        NSString *nameString = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:i]];
        if (i == nameArray.count - 1) {
            currentLength = nameString.length;
        } else {
            currentLength = nameString.length + 1;
            
        }
        [matchAttribute setTextHighlightRange:NSMakeRange(currentLocation, currentLength)
                                        color:nil
                              backgroundColor:nil
                                    tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                                        @strongify(self);
                                        if (self.delegate && [self.delegate respondsToSelector:@selector(jzLabel:didSelectStrIndex:)]) {
                                            [self.delegate jzLabel:self didSelectStrIndex:i];
                                        }
                                    }];
        if (i != nameArray.count - 1) {
            currentLocation = currentLocation + currentLength;
            [matchAttribute setColor:matchColor range:NSMakeRange(currentLocation - 1, 1)];
        }
    }
    return matchAttribute;
}

//匹配@
- (void)matchAt_withAtStr:(NSString *)atStr with_color:(UIColor *)atColor{
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = [UIColor clearColor];
    if (atStr.length != 0) {
        YYTextHighlight *hi = [[YYTextHighlight alloc]init];
        [hi setBackgroundBorder:highlightBorder];
        hi.userInfo = @{@"at" : atStr};
        
        [_resultText setColor:atColor range:[_resultText.string rangeOfString:atStr]];
        [_resultText setTextHighlight:hi range:[_resultText.string rangeOfString:atStr]];
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX)];
        container.truncationType = YYTextTruncationTypeEnd;
        container.maximumNumberOfRows = self.numberOfLines;
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:_resultText];
        self.textLayout = layout;
    }
}


- (void)stringWithUIImage:(NSString *) contentStr imageStr:(NSString *) imageStr imageSize:(CGSize)imageSize{
    if (contentStr == nil) {
        return;
    }
    _textString = [NSString stringWithFormat:@"%@  ",contentStr];
    
    NSMutableAttributedString *attribuText = [[NSMutableAttributedString alloc]initWithString:_textString];
    attribuText.color = self.textColor;
    
    YYAnimatedImageView *imageView= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    imageView.frame =  CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    NSMutableAttributedString *attachText= [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.frame.size alignToFont:self.font alignment:YYTextVerticalAlignmentCenter];
    
    [attribuText appendAttributedString:attachText];
    
    //属性来使用富文本
    _resultText = attribuText;
    _resultText.font = self.font;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.preferredMaxLayoutWidth, CGFLOAT_MAX) insets:self.textContainerInset];
    
    container.truncationType = YYTextTruncationTypeNone;
    container.maximumNumberOfRows =  self.numberOfLines;
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:_resultText];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textLayout = layout;
    });
}

@end
