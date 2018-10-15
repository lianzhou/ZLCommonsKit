//
//  JZUtilsTools.m
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/8/28.
//
//


#import "JZUtilsTools.h"
#import "MJRefresh.h"
#import "JZStringMacrocDefine.h"
#import "JZSystemMacrocDefine.h"
#import "SDWebImageManager.h"
#import "MJExtension.h"

@interface JZUtilsTools ()

@end

@implementation JZUtilsTools

+ (JZUtilsTools *) sharedInstance{
    static JZUtilsTools *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JZUtilsTools alloc] init];
    });
    return instance;
}
// 更改上拉加载
+ (void)changeMJrefreshFooterImageWith:(UIScrollView *)tableView completed:(void (^)())completed {
    
    NSMutableArray *downImages = [NSMutableArray array];
    for (int i = 1; i <= 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"wjf_sx%d.png", i]];
        [downImages addObject:image];
    }
    // 上拉加载  自定义
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        completed();
    }];
    [footer setTitle:@"没有更多了哦 =_=‖ " forState:MJRefreshStateNoMoreData];
    tableView.mj_footer = footer;
}

#pragma mark -获取图片上数组
+ (NSMutableArray *)imagesArrFromPicStr:(NSString *)picStr
{
    if (JZStringIsNull(picStr)) {
        return nil;
    }
    NSMutableArray *urlArray=[@[] mutableCopy];
    NSArray *arr = [picStr componentsSeparatedByString:@";"];
    
    [arr  enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        
        if (!JZStringIsNull(obj)) {
         
            [urlArray addObject:obj];
        }
        
    }];
    return urlArray;
    
    
}

#pragma mark - 通知
+ (void)postNoti:(NSString *)notiName
{
    [JZUtilsTools postNoti:notiName withObject:nil];
}

+ (void)postNoti:(NSString *)notiName withObject:(id)obj
{
    [JZUtilsTools postNoti:notiName withObject:obj withUserInfo:nil];
}

+ (void)postNoti:(NSString *)notiName withObject:(id)obj withUserInfo:(NSDictionary *)infoDict
{
    if (JZStringIsNull(notiName)) {
        return;
    }
    [[JZUtilsTools defaultCenter] postNotificationName:notiName object:obj userInfo:infoDict];
}
+ (NSNotificationCenter *)defaultCenter
{
    return [NSNotificationCenter defaultCenter];
}

#pragma mark -  画线
/*!
 @brief 画水平细线
 @param lineColor 细线颜色 nil:默认0xcccccc
 @param lineWidth 细线宽度lineWidth
 */
+(UIImage*)drawHerLine:(UIColor*)lineColor lineWidth:(NSInteger)lineWidth
{
    lineColor=lineColor==nil?[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]:lineColor;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(lineWidth, 0.5), NO, 0);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(gc, 0.5);
    [lineColor setStroke];
    CGContextMoveToPoint(gc,0,0);
    CGContextAddLineToPoint(gc, lineWidth, 0);
    CGContextClosePath(gc);
    CGContextStrokePath(gc);
    UIImage *lineImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return lineImg;
}

//计算文件大小
+ (NSString *)calculSize:(NSInteger)size
{
    int loopCount = 1;
    int mod=0;
    while (size >=1024)
    {
        mod = size%1024;
        size /= 1024;
        loopCount++;
        if (loopCount > 4)
        {
            break;
        }
    }
    
    CGFloat rate=1;
    int loop = loopCount;
    while (loop--)
    {
        rate *= 1000.0;
    }
    CGFloat fSize = size + (CGFloat)mod/rate;
    NSString *sizeUnit;
    switch (loopCount)
    {
        case 0:
            sizeUnit = [[NSString alloc] initWithFormat:@"%.0fB",fSize];
            break;
        case 1:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.1fKB",fSize];
            break;
        case 2:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.2fMB",fSize];
            break;
        case 3:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.3fGB",fSize];
            break;
        case 4:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.4fTB",fSize];
            break;
        default:
            break;
    }
    return sizeUnit;
}

#pragma mark -判断文件的类型是word  || excel || ppt  || txt
//根据下载链接返回文件的类型
+ (NSString *)returnsTheTypeOfFileAccordingToTheDownloadLink:(NSString *)downLoadUrl {
    
    NSString *fileType = nil;
    if (!JZStringIsNull(downLoadUrl)) {
        NSArray *array = [[downLoadUrl lastPathComponent] componentsSeparatedByString:@"."];
        
        if ([[array lastObject] isEqualToString:@"ppt"] || [[array lastObject] isEqualToString:@"pptx"]) {
            //PPT
            fileType = @"ppt";
            
        }else if ([[array lastObject] isEqualToString:@"doc"] || [[array lastObject] isEqualToString:@"docx"]){
            //word
            fileType = @"word";
            
        }else{
           fileType = @"other";
        }
    }else{
       fileType = @"other";
    }
    
    return fileType;
}
+ (UIImage *)fileImg:(NSString *)titleHtml
{
    UIImage *img = nil;
    if (!JZCheckObjectNull(titleHtml)) {
        NSArray *array = [[titleHtml lastPathComponent] componentsSeparatedByString:@"."];
        
        if ([[array lastObject] isEqualToString:@"ppt"] || [[array lastObject] isEqualToString:@"pptx"]) {
            //PPT
            img = [UIImage imageNamed:@"PPT"];
            
        }else if ([[array lastObject] isEqualToString:@"doc"] || [[array lastObject] isEqualToString:@"docx"]){
            //word
            img = [UIImage imageNamed:@"word"];
            
        }else if ([[array lastObject] isEqualToString:@"xlsx"] || [[array lastObject] isEqualToString:@"xls"]){
            //excel
            img = [UIImage imageNamed:@"excel"];
            
        }else if ([[array lastObject] isEqualToString:@"pdf"]){
            //pdf
            img = [UIImage imageNamed:@"pdf"];
            
        }else if ([[array lastObject] isEqualToString:@"txt"]){
            //txt
            img = [UIImage imageNamed:@"txt"];
            
        }else{
            img = [UIImage imageNamed:@"txt"];
        }
    }
    return img;
}

#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString
{
    if (JZStringIsNull(aString)) {
        return @"#";
    }
    /**
     * **************************************** START ***************************************
     */
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    /**
     *  *************************************** END ******************************************
     */
    
    // 将拼音首字母装换成大写
    NSString *strPinYin = [pinyinString capitalizedString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
    
}

#pragma mark -TableViewCell分割线靠最左
/**
 *  TableViewCell分割线靠最左
 *
 *  @param tableViewCell <#tableViewCell description#>
 */
+ (void)separatorInsetZero:(UITableViewCell*)tableViewCell
{
    if ([tableViewCell respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableViewCell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableViewCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableViewCell setLayoutMargins:UIEdgeInsetsZero];
    }
}

+ (CGSize)imageSizeIMOriginalSize:(CGSize)originalSize{
    return [self imageSizeWithMaxSize:CGSizeMake(120, 120) minSize:CGSizeMake(40, 40) originalSize:originalSize];
}
+ (CGSize)imageSizeOriginalSize:(CGSize)originalSize{
    if (originalSize.width == 0 && originalSize.height == 0) {
        return CGSizeMake(180, 180);
    }
    return [self imageSizeWithMaxSize:CGSizeMake(180, 180) minSize:CGSizeMake(60, 60) originalSize:originalSize];
}
+ (CGSize)imageSizeWithMaxSize:(CGSize)maxSize minSize:(CGSize)minSize originalSize:(CGSize)originalSize{
    
    if (originalSize.width < originalSize.height && originalSize.height/originalSize.width >=3.0) {
        return CGSizeMake(minSize.width, maxSize.height);
    }else if (originalSize.height < originalSize.width && originalSize.width/originalSize.height >=3.0) {
        
        return CGSizeMake(maxSize.height, minSize.width);
    }else{
        
        CGFloat zoomWidth = originalSize.width/(maxSize.width*100);
        CGFloat zoomHeight = originalSize.height/(maxSize.height*100);
        
//        CGFloat changeWidth = originalSize.width;
//        CGFloat changeHeight = originalSize.height;
        
        CGFloat changeWidth = 0;
        CGFloat changeHeight = 0;

        //如果heigh能先达到最大值,那么height就是最大值,width就是等比的width
        if (zoomWidth < zoomHeight) {
            changeHeight = maxSize.height;
            changeWidth = maxSize.height*originalSize.width/originalSize.height;
            return CGSizeMake(changeWidth, changeHeight);
        }else if (zoomWidth > zoomHeight){
            changeWidth = maxSize.width;
            changeHeight = maxSize.width*originalSize.height/originalSize.width;
            return CGSizeMake(changeWidth, changeHeight);
        }else{
            return maxSize;
        }
    }
    return maxSize;

}


#pragma mark -等比缩放
+ (CGSize)imageSizeWithMAXSize:(CGSize)MAXSize originalSize:(CGSize)originalSize{
    
    if (originalSize.width<100&&originalSize.height<100) {
        
        if (originalSize.height<40) {
            return CGSizeMake(40*originalSize.width/originalSize.height, 40);
        }
        return originalSize;
    }
    
    CGSize newSize = CGSizeZero;
    
    if (MAXSize.width/MAXSize.height > originalSize.width/originalSize.height){
        newSize.width = MAXSize.height*originalSize.width/originalSize.height;
        newSize.height = MAXSize.height;
    }else {
        newSize.width = MAXSize.width;
        newSize.height = MAXSize.width*originalSize.height/originalSize.width;
    }
    
    if (newSize.width/newSize.height<0.2) {
        newSize.height = 150;
        newSize.width = 100/2;
    }
    if (newSize.height/newSize.width<0.2) {
        newSize.width = 200;
        newSize.height = 100/2;
    }
    return newSize;
}

#pragma mark -当前时间戳
+ (NSString *)theCurrentTimeStampString
{
    NSString *timeString = [NSString stringWithFormat:@"%lld",[self theCurrentTimeInterval]];
    timeString = [timeString stringByReplacingOccurrencesOfString:@"." withString:@""];
    return timeString;
}
+ (long long)theCurrentTimeInterval
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSince1970];
    return timeInterval;
    
}


//获取sd缓存中的图片
+ (UIImage *)determineWhetherThereIsACacheImages:(NSURL *)url
{
    if (url) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        SDImageCache* cache = [SDImageCache sharedImageCache];
        //此方法会先从memory中取。
        NSString* key  = [manager cacheKeyForURL:url];
        UIImage *image = [cache imageFromDiskCacheForKey:key];
        return image;
    }
    return nil;
}

#pragma mark -返回文件类型
+ (NSString *)fileType:(NSString *)filetype
{
    NSString *fileType = nil;
    if (!JZCheckObjectNull(filetype)) {
        NSArray *array = [[filetype lastPathComponent] componentsSeparatedByString:@"."];
        
        if ([[array lastObject] isEqualToString:@"ppt"] || [[array lastObject] isEqualToString:@"pptx"]) {
            //PPT
            fileType = @"ppt";
            
        }else if ([[array lastObject] isEqualToString:@"doc"] || [[array lastObject] isEqualToString:@"docx"]){
            //word
            fileType = @"word";
            
        }else if ([[array lastObject] isEqualToString:@"xlsx"] || [[array lastObject] isEqualToString:@"xls"]){
            //excel
            fileType = @"excel";
        }else if ([[array lastObject] isEqualToString:@"pdf"]){
            //pdf
            fileType = @"pdf";
            
        }else if ([[array lastObject] isEqualToString:@"txt"]){
            //txt
            fileType = @"txt";
        }else{
            return filetype;
        }
    }
    return fileType;
    
}
#pragma mark - 判断数组是否为空
+ (BOOL)arrayIsNull:(NSArray *)array
{
    
    if (![array isKindOfClass:[NSArray class]]) {
        return YES;
    }
    
    if (array == nil && [array isKindOfClass:[NSNull class]] && array.count == 0){
        return YES;
    }else{
        return NO;
    }
    
}

#pragma mark -跳转
- (void)jumpApp:(NSString *)urlStr
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

#pragma mark -去掉多余的分割线
+ (void)hidenExtraCellLine:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark -TableView分割线靠最左
+ (void)tableviewSeparatorInsetZero:(UITableView*)tableView
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

#pragma mark -计算文本高度
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize )maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

#pragma mark - 页面停留时间 折算为秒
+ (NSString *)viewSeconds:(NSDate *)date {
    
    @try{
        
        NSString * seconds;
        
        NSDate * now = [NSDate date];
        NSCalendar * calendar = [NSCalendar currentCalendar];
        NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        
        //利用日历对象比较两个时间的差值
        NSDateComponents *cmps = [calendar components:type fromDate:now toDate:date options:0];
        //输出结果
        NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
        
        long totalSeconds = labs(cmps.hour) * 60 * 60 + labs(cmps.minute) * 60 + labs(cmps.second);
        seconds = [NSString stringWithFormat:@"%ld",totalSeconds];
        
        return seconds;
        
    }@catch(NSException * exception){
        
        
    }
}


@end
