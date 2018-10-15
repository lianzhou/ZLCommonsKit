//
//  JZUtilsTools.h
//  Pods
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/8/28.
//
//

#import <Foundation/Foundation.h>
#import "JZBaseViewController.h"
@interface JZUtilsTools : NSObject

@property (nonatomic, weak) JZBaseViewController *currentViewController;


+ (JZUtilsTools *) sharedInstance;

#pragma mark -上拉加载
+ (void)changeMJrefreshFooterImageWith:(UIScrollView *)tableView completed:(void (^)())completed;
#pragma mark -获取图片上数组
+ (NSMutableArray *)imagesArrFromPicStr:(NSString *)picStr;

#pragma mark - 通知
+ (void)postNoti:(NSString *)notiName;
+ (void)postNoti:(NSString *)notiName withObject:(id)obj;
+ (void)postNoti:(NSString *)notiName withObject:(id)obj withUserInfo:(NSDictionary *)infoDict;
+ (NSNotificationCenter *)defaultCenter;
#pragma mark -  画线
+(UIImage*)drawHerLine:(UIColor*)lineColor lineWidth:(NSInteger)lineWidth;
//计算文件大小
+ (NSString *)calculSize:(NSInteger)size;
#pragma mark -判断文件的类型是word  || excel || ppt  || txt
+ (UIImage *)fileImg:(NSString *)titleHtml;
#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString;

#pragma mark -TableViewCell分割线靠最左
+ (void)separatorInsetZero:(UITableViewCell*)tableViewCell;
#pragma mark -等比缩放
+ (CGSize)imageSizeIMOriginalSize:(CGSize)originalSize;
+ (CGSize)imageSizeOriginalSize:(CGSize)originalSize;
+ (CGSize)imageSizeWithMaxSize:(CGSize)maxSize minSize:(CGSize)minSize originalSize:(CGSize)originalSize;
+ (CGSize)imageSizeWithMAXSize:(CGSize)MAXSize originalSize:(CGSize)originalSize;
#pragma mark -当前时间戳
+ (NSString *)theCurrentTimeStampString;
#pragma mark -获取sd缓存中的图片
+ (UIImage *)determineWhetherThereIsACacheImages:(NSURL *)url;
#pragma mark -返回文件类型
+ (NSString *)fileType:(NSString *)filetype;
#pragma mark - 判断数组是否为空
+ (BOOL)arrayIsNull:(NSArray *)array;
#pragma mark -跳转
- (void)jumpApp:(NSString *)urlStr;
#pragma mark -去掉多余的分割线
+ (void)hidenExtraCellLine:(UITableView *)tableView;
#pragma mark -TableView分割线靠最左
+ (void)tableviewSeparatorInsetZero:(UITableView*)tableView;
#pragma mark -计算文本高度
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize )maxSize;
#pragma mark - 页面停留时间 折算为秒
+ (NSString *)viewSeconds:(NSDate *)date;
//根据下载链接返回文件的类型
+ (NSString *)returnsTheTypeOfFileAccordingToTheDownloadLink:(NSString *)downLoadUrl;



@end
