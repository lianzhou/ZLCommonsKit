//
//  NSString+Extension.m
//  Pods
//
//  Created by li_chang_en on 2017/9/7.
//
//

#import "NSString+Extension.h"
#import "ZLStringMacrocDefine.h"
#import "ZLSystemMacrocDefine.h"
#import "YYKit.h"
#import "DTCoreText.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

//这是公式转的图片
#define FormulaUrl  @"http://gs.xueleyun.com//cgi-bin/mathtex.cgi?"

@implementation NSString (Extension)
- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)font
{
    return [self textSizeIn:size font:font breakMode:NSLineBreakByWordWrapping];
}

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)breakMode
{
    return [self textSizeIn:size font:afont breakMode:breakMode align:NSTextAlignmentLeft];
}

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)abreakMode align:(NSTextAlignment)alignment
{
    return [self textSizeIn:size font:afont breakMode:abreakMode align:alignment numberOfLines:0];
}

- (CGSize)textSizeIn:(CGSize)size font:(UIFont *)afont breakMode:(NSLineBreakMode)abreakMode align:(NSTextAlignment)alignment numberOfLines:(NSInteger)numberOfLines {
    
    if (ZLStringIsNull(self)) {
        return CGSizeZero;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        _Pragma("clang diagnostic push")
        _Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")
        return [self sizeWithFont:afont constrainedToSize:size lineBreakMode:abreakMode];
        _Pragma("clang diagnostic pop")
    }else{
        NSLineBreakMode breakMode = abreakMode;
        UIFont *font = afont ? afont : [UIFont systemFontOfSize:14];
        
        CGSize contentSize = CGSizeZero;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = breakMode;
        paragraphStyle.alignment = alignment;
        
        
        if (numberOfLines != 0) {
            
            //设置段落行间距
            paragraphStyle.lineSpacing = 5.f;
            //获取一行的高度
            CGFloat oneHeight = [font lineHeight];
            
            CGSize maxSize = CGSizeMake(size.width, (oneHeight + paragraphStyle.lineSpacing) * numberOfLines);
            
            size = maxSize;
        }
        
        NSDictionary* attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        contentSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        contentSize = CGSizeMake((int)contentSize.width + 1, (int)contentSize.height + 1);
        
        return contentSize;
    }
}

- (NSAttributedString *)attributeStringFromHTMLWithFont:(UIFont *)font textColor:(UIColor *)textColor breakMode:(NSLineBreakMode)abreakMode {
    
    NSDictionary *options = @{
                              NSTextSizeMultiplierDocumentOption:@1.0f,
                              DTDefaultFontFamily:@"Helvetica",
                              DTDefaultTextColor:textColor,
                              DTDefaultLinkColor:textColor,
                              DTDefaultFontSize:[NSNumber numberWithFloat:font.pointSize],
                              DTDefaultStyleSheet:[[DTCSSStylesheet alloc] initWithStyleBlock:@"p,span,li, b { font-family: 'Helvetica Neue'; line-height: 18px; } b {} ul { padding-left: 14px; } em {font-style:'italic';}"]
                              };
    
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //    [paragraphStyle setLineSpacing:6.0];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithHTMLData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:textColor} range:NSMakeRange(0, attrStr.length)];
    [attrStr setAlignment:NSTextAlignmentLeft];
    [attrStr setLineBreakMode:abreakMode];
    return attrStr;
}

- (NSString *)htmlStringBoundingImgString {
    
    //判断是否含有公式
    NSString *newString = [self formulaPicUrlFromFormulaText:self];
    //定义img标签
    NSString *imgHtml = @"<img";
    if (![newString containsString:imgHtml]) {
        
        //如果不包含img标签直接return
        return newString;
    }
    
    NSString *text = nil;
    NSString *imgString = @"[图片]";
    
    //这是包含 imgHtml标签的
    NSScanner * scanner = [NSScanner scannerWithString:newString];
    
    while([scanner isAtEnd]==NO) {
        
        //找到标签的起始位置
        [scanner scanUpToString:imgHtml intoString:nil];
        
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        /***********************************找宽度***********************************/
        //替换字符
        NSString *tempHtml = [NSString stringWithFormat:@"%@>",text];
        
        NSLog(@"%@",tempHtml);
        /***********************************找宽度***********************************/
        newString = [newString stringByReplacingOccurrencesOfString:tempHtml withString:imgString];
        
    }
    return newString;
}

- (NSString *)replaceLineBreakString {
    
    NSString *replaceString = [self copy];
    NSScanner * scanner = [NSScanner scannerWithString:self];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<p>" intoString:nil];
        [scanner scanUpToString:@"</p>" intoString:&text];
        
        //替换字符
        NSString *html = [NSString stringWithFormat:@"%@</p>",text];
        
        //找到标签中级的内容
        NSString *contentString = [[text componentsSeparatedByString:@"<p>"] lastObject];
        
        if (!ZLStringIsNull(contentString)) {
            replaceString = [replaceString stringByReplacingOccurrencesOfString:html withString:contentString];
        }else {
            
            replaceString = [replaceString stringByReplacingOccurrencesOfString:html withString:@""];
        }
        
        NSLog(@"%@",replaceString);
        
    }
    
    return replaceString;
}


- (NSString *)adjustHtmlStringImageSizeWithMaxWidth:(CGFloat)maxWidth {
    
    //判断是否含有公式
    NSString *newString = [self formulaPicUrlFromFormulaText:self];
    //定义img标签
    NSString *imgHtml = @"<img";
    if (![newString containsString:imgHtml]) {
        
        //如果不包含img标签直接return
        return newString;
    }
    
    NSString *text = nil;    
    //这是包含 imgHtml标签的
    NSScanner * scanner = [NSScanner scannerWithString:newString];
    
    while([scanner isAtEnd]==NO) {
        
        //找到标签的起始位置
        [scanner scanUpToString:imgHtml intoString:nil];
        
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        
        //替换字符
        NSString *tempHtml = [NSString stringWithFormat:@"%@>",text];
        
        NSLog(@"%@",tempHtml);
        
        NSScanner *sizeScanner = [NSScanner scannerWithString:tempHtml];
        
        //宽度
        NSString *tempWidthHtml = nil;
        //高度
        NSString *tempHeightHtml = nil;
        
        if ([tempHtml containsString:@"width: 100%;"]) {
            tempHtml = [tempHtml stringByReplacingOccurrencesOfString:@"width: 100%;" withString:@""];
        }
        if ([tempHtml containsString:@"height: 100%;"]) {
            tempHtml = [tempHtml stringByReplacingOccurrencesOfString:@"height: 100%;" withString:@""];
        }
        
        if ([tempHtml containsString:@"style"]) {
            
            //这是含有style样式
            while([sizeScanner isAtEnd]==NO) {
                
                //找到标签的起始位置
                [sizeScanner scanUpToString:@"width: " intoString:nil];
                //找到标签的结束位置
                [sizeScanner scanUpToString:@"p" intoString:&tempWidthHtml];
                
                NSString *widthString = [NSString stringWithFormat:@"%@",tempWidthHtml];
                
                //已空格分割
                NSArray *widthArray = [widthString componentsSeparatedByString:@" "];
                
                //获取宽度
                CGFloat width = [[widthArray lastObject] floatValue];
                
                //如果宽度大于最大宽度 需要对连接中的图片进行处理
                if (width > maxWidth) {
                    
                    //找到高度标签的起始位置
                    [sizeScanner scanUpToString:@"height: " intoString:nil];
                    //找到高度标签的结束位置
                    [sizeScanner scanUpToString:@"p" intoString:&tempHeightHtml];
                    //                NSLog(@"%@",[NSString stringWithFormat:@"%@",tempHeightHtml]);
                    
                    NSString *heightString = [NSString stringWithFormat:@"%@",tempHeightHtml];
                    
                    //已空格分割
                    NSArray *heightArray = [heightString componentsSeparatedByString:@" "];
                    //获取宽度
                    CGFloat height = [[heightArray lastObject] floatValue];
                    
                    //更新宽度
                    NSString *newWidthString = [NSString stringWithFormat:@"%@ %.2lf",widthArray[0], maxWidth];
                    
                    //更新高度
                    NSString *newHeightString = [NSString stringWithFormat:@"%@ %.2lf",heightArray[0], maxWidth *height/width];
                    
                    tempHtml = [tempHtml stringByReplacingOccurrencesOfString:widthString withString:newWidthString];
                    tempHtml = [tempHtml stringByReplacingOccurrencesOfString:heightString withString:newHeightString];
                }
            }
        }else {
            
            //这是不含有style样式 需要自己处理
            //            NSArray *tempStringArray = [tempHtml componentsSeparatedByString:@">"];
            //            NSLog(@"%@",tempStringArray);
            //
            //            NSString *styleString = [NSString stringWithFormat:@" style=\"max-width: %.2lfpx;\">",maxWidth];
            //            tempHtml = [[tempStringArray componentsJoinedByString:@""] stringByAppendingString:styleString];
            //            NSLog(@"%@",tempHtml);
        }
        
        NSLog(@"%@",tempHtml);
        
        newString = [newString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:tempHtml];
        
    }
    return newString;
}

//将公式标签转成img标签
- (NSString *)formulaPicUrlFromFormulaText:(NSString *)formulaText {
    
    //新的string
    NSString *formulaNewString = [NSString stringWithString:formulaText];
    
    //定义[LaTeXI]标签
    NSString *latexiHtml = @"[LaTeXI]";
    NSString *latexiLastHtml = @"[/LaTeXI]";
    if (![formulaText containsString:latexiHtml]) {
        
        //如果不包含[LaTeXI]标签直接return
        return formulaText;
    }
    
    //这是含有[LaTeXI]标签的
    NSString *latexiText = nil;
    
    //这是包含 imgHtml标签的
    NSScanner * scanner = [NSScanner scannerWithString:formulaText];
    
    while([scanner isAtEnd]==NO) {
        
        //找到标签的起始位置
        [scanner scanUpToString:latexiHtml intoString:nil];
        
        //找到标签的结束位置
        [scanner scanUpToString:latexiLastHtml intoString:&latexiText];
        //替换字符
        NSString *html = [NSString stringWithFormat:@"%@[/LaTeXI]",latexiText];
        
        //找到标签中级的内容
        NSString *contentString = [[latexiText componentsSeparatedByString:latexiHtml] lastObject];
        
        
        NSString *contextUrl = [FormulaUrl stringByAppendingString:contentString];
        contextUrl = [contextUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        //拼接成图片标签的字符串
        NSString *imgString = [NSString stringWithFormat:@"<img src=\"%@\">",contextUrl];
        
        formulaNewString = [formulaNewString stringByReplacingOccurrencesOfString:html withString:imgString];
    }
    return formulaNewString;
}

+ (NSDictionary *)jsonStringToNSDictionary:(NSString *)jsonString
{
    if (ZLStringIsNull(jsonString)) {
        return @{};
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    if ([responseJsonDic isKindOfClass:[NSDictionary class]]) {
        return responseJsonDic;
    }
    return @{};
}
+ (NSString *)initWithJsonDictionary:(NSDictionary *)jsonDic
{
    if (ZLCheckObjectNull(jsonDic)) {
        return @"";
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:kNilOptions error:nil];
    NSString *responseJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (ZLStringIsNull(responseJson)) {
        return @"";
    }
    return responseJson;
}

+ (NSString *)obtainSixRandomNo{
    
    //    NSMutableArray <NSNumber *>* numberArray = [@[@0,@1,@2,@3,@4,@5,@6,@7,@8,@9] mutableCopy];
    //
    //    for (int i = 10; i > 1; i--) {
    //        int index = arc4random() % i;
    //        NSNumber * tmp = numberArray[index];
    //        numberArray[index] = numberArray[i - 1];
    //        numberArray[i - 1] = tmp;
    //    }
    
    //    NSMutableArray *numberArray = [NSMutableArray array];
    NSString *randStr = nil;
    for (int i = 0; i < 6; i++) {
        int result = arc4random_uniform(10);
        if (i == 0) {
            randStr = [NSString stringWithFormat:@"%d",result];
        }else{
            randStr = [NSString stringWithFormat:@"%@%d",randStr,result];
        }
        //        [numberArray addObject:[NSString stringWithFormat:@"%d",result]];
    }
    
    return randStr;
    //    long long result = arc4random();
    //    if (result >= 100000) {
    //        NSString *resultStr = [NSString stringWithFormat:@"%lld",result];
    //        resultStr = [resultStr substringWithRange:NSMakeRange(0, 6)];
    //        return resultStr;
    //    }else{
    //      return [NSString stringWithFormat:@"%06lld",result];
    //    }
    //    for(int i = 0; i < 6; i++){
    //        result = result * 10 + [[numberArray objectAtIndex:i] intValue];
    //    }
    
    
}
+(NSString*)obtainCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
    
}

- (NSString*)ZLAES_EncryptwithKey:(NSString *)key{
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:key];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return baseStr;
}

- (NSString*)ZLAES_DecryptWithkey:(NSString *)key{
    
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:key];
    
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    return decStr;
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *
 *  @return          返回加密后的字符串
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    if(cryptorStatus == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        NSLog(@"Error");
    }
    
    free(buffer);
    return nil;
}
/**
 *  去掉首尾空字符串
 */
- (NSString *)replaceSpaceOfHeadTail
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string setString:self];
    CFStringTrimWhitespace((CFMutableStringRef)string);
    return string;
}

- (NSString *)replaceUnicode
{
    NSStringEncoding strEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:strEncode];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}


#pragma mark  生成uuid
+ (NSString *)getUUIDString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    return uuidString;
}


/**
 替换掉字符串中的空格
 
 @param inputString <#inputString description#>
 
 @return <#return value description#>
 */
+(NSString*) stringReplacePlace:(NSString* )inputString
{
    inputString = [inputString stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    inputString=[inputString stringByReplacingOccurrencesOfString:@" " withString:@""];//两个中英文不同的空格
    inputString=[inputString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return inputString;
}

#pragma mark去除特殊字符
+(NSString*)RemoveSpecialCharacters:(NSString *)strString
{
    strString=[self stringReplacePlace:strString];
    strString=[strString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    strString=[strString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    strString=[strString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strString=[strString stringByReplacingOccurrencesOfString:@">" withString:@""];
    strString=[strString stringByReplacingOccurrencesOfString:@"&" withString:@""];
    strString=[strString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strString=[strString stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    strString = [strString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    strString = [strString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return strString;
}
@end
