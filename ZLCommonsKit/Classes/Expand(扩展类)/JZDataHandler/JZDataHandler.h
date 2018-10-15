//
//  JZDataHandler.h
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/7/5.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//

//日期类型
typedef NS_ENUM(NSInteger,JZDateFormatType) {
    JZDateFormatTypeYYYY_MM_DD = 0,//年-月-日
    JZDateFormatTypeYYYY_MM_DD_HH_MM,//年-月-日 时:分
    JZDateFormatTypeYYYY_MM_DD_HH_MM_SS,//年-月-日 时:分:秒
    JZDateFormatTypeYYYY_MM_DD_HH_MM_SS_SSS,//年-月-日 时:分:秒.毫秒
};


#import <Foundation/Foundation.h>
#import "JZCollectionUtils.h"

#define YYYYMMddHHmmss @"yyyy-MM-dd HH:mm:ss"//2015-07-21 13:27:30
#define YYYYMMddHHmm @"yyyy-MM-dd HH:mm"
#define YYYYMMdd @"yyyy-MM-dd"
#define YYYYMM @"yyyy-MM"

#define YYYYMMddHHmmssCN @"yyyy年MM月dd日 HH:mm:ss"
#define YYYYMMddHHmmCN @"yyyy年MM月dd日 HH:mm"
#define YYYYMMddCN @"yyyy年MM月dd日"
#define HHmm @"HH:mm"
#define HHmmss @"HH:mm:ss"

typedef void(^TimeResultBlock)(NSInteger missDay,NSInteger missHour,NSInteger missMinu,NSInteger missSeconds);

@interface JZDataHandler : NSObject

+ (NSCalendar *)sharedCalendar;


//日期转换字符串:yyyy-MM-dd HH:mm:ss
+(NSString*)toYYYYMMddHHmmss:(NSDate*)date;

//日期转字符串:yyyy-MM-dd HH:mm
+(NSString*)toYYYYMMddHHmm:(NSDate*)date;

//日期转字符串:yyyy-MM-dd
+(NSString*)toYYYYMMdd:(NSDate*)date;

+(NSString*)toYYYYMM:(NSDate*)date;

//日期转字符串HH:mm
+(NSString*)toHHmm:(NSDate*)date;

//日期转字符串HH:mm:ss
+(NSString*)toHHmmss:(NSDate*)date;



//日期转字符串yyyy年MM月dd日 HH:mm:ss
+(NSString*)toYYYYMMddHHmmssCN:(NSDate*)date;

//日期转字符串yyyy年MM月dd日 HH:mm
+(NSString*)toYYYYMMddHHmmCN:(NSDate*)date;

//日期转字符串yyyy年MM月dd日
+(NSString*)toYYYYMMddCN:(NSDate*)date;



//字符串转日期:yyyy-MM-dd HH:mm:ss
+(NSDate *)formYYYYMMddHHmmss:(NSString *)timeStr;

//字符串转日期:yyyy-MM-dd HH:mm
+(NSDate *)formYYYYMMddHHmm:(NSString *)timeStr;

//字符串转日期:yyyy-MM-dd
+(NSDate *)formYYYYMMdd:(NSString *)timeStr;

//字符串转日期:HH:mm
+(NSDate *)formHHmm:(NSString *)timeStr;

+(NSDate *)formYYYYMM:(NSString *)timeStr;

+ (NSString *)currentTimeString;
//date转时间戳
+ (long long)intervaleFormDate:(NSDate *)date;

//时间戳转date
+ (NSDate *)dateFromTimeInterval:(long long)timeImterval;

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;

//获取两个时间的时间差
+(void)missTimeResultToStartTime:(NSString *)startTime formEndTime:(NSString *)endTime withResultBlock:(TimeResultBlock)timeBlock;


//显示自定义的时间
/*
 发布时间距当前时间
 10分钟之内，显示：刚刚
 1小时之内，以分钟为最小单位，显示：XX分钟前
 1天之内（当天），以小时为最小单位，显示：xx小时前
 昨天的显示：昨天 HH：MM
 两天以上，显示：xx月xx日 HH：MM
 1年以上，显示xxxx年xx月xx日
 */
+ (NSString *)showSpecailTimeWithTimeString:(NSString *)lastTime;
/**
 时间显示:月/日  eg:09/25
 
 @param timeStr 时间字符串
 @return 月/日
 */
+ (NSString *)showOnlyMonthAndDay:(NSString *)timeStr;
//年月日--马金丽
+ (NSString *)showYYMMDDStr:(NSString *)timeStr;
//年月日--马金丽
+ (NSString *)showYYMMDDTimeDate:(NSDate *)timeDate;
//年月--马金丽
+ (NSString *)showYYMMTimeDate:(NSDate *)timeDate;
//月日--马金丽 eg:09月25日
+ (NSString *)showMMDDWithDataStr:(NSString *)timeStr;
//分:秒--马金丽 eg:10:30
+ (NSString *)showHHddWithDateStr:(NSString *)timeStr;
//月/日--马金丽 eg:10/30
+ (NSString *)showMMDDWithDateStr:(NSString *)timeStr;
//月/日/分/秒 --马金丽 eg:10月20日 10:25
+ (NSString *)showMMDDHHmmWithDateStr:(NSString *)timeStr;
/**
 获取n个月之后的日期  n为正时则为n个月后的日期  n为负则为n个月之前的日期
 
 @param starDateStr 当前指定的日期
 @param month n
 @return 返回目标日期
 */
+ (NSString *)obtainPriousorLaterDateFromDate:(NSString *)starDateStr withMonth:(NSInteger)month withDateFormatType:(JZDateFormatType)dateFormatType;

/**
 根据日期获取计算星期
 
 @param dateStr 当前指定日期
 @return 返回日期的星期几
 */
+ (NSString *)weekDayStringFromDate:(NSString *)dateStr;

/**
 比较两个日期的大小
 
 @param currenDateStr 指定日期 date1
 @param newDateStr 新日期  date2
 @return YES：date1 >= date2  NO date1 < date2
 */
+ (BOOL)compareDate:(NSString *)currenDateStr withDate:(NSString *)newDateStr withDateFormatType:(JZDateFormatType)dateFormatType;

/**
 比较两个日期是否相同 精确到分钟
 
 @param currenDateStr 指定日期 date1
 @param newDateStr 新日期  date2
 @return YES：相同  NO 不同
 */
+ (BOOL)isSameTime:(NSDate *)currenDateStr withDate:(NSDate *)newDateStr;

/**
 获取指定时间的前几天或者后几天的时间字符串
 
 @param currentTime 当前指定的日期
 @param dayCount n天  （n > 0 为当前日期的后几天 n < 0 为当前日期的前几天 ）
 @return 返回目标日期
 */
+ (NSString *)obtainTheTimeStringOfTheDayBeforeOrAfterTheSpecifiedTime:(NSString *)currentTime withTheDay:(NSInteger)dayCount withDateFormatType:(JZDateFormatType)dateFormatType;

/**
 获取当前日期所在的周的开始日期或者结束日期
 
 @param currentDateStr 当前指定日期
 @param isEnd YES 指定日期所在的周的结束日期  NO指定日期所在的周的开始日期
 @param dateFormatType 日期类型
 @return 返回目标日期
 */
+ (NSString *)obtainTheBenginOrEndDateOfTheCurrentWeek:(NSString *)currentDateStr withIsEnd:(BOOL)isEnd withDateFormatType:(JZDateFormatType)dateFormatType;

/**
 根据日期类型的枚举获取日期类型
 
 @param dateFormatType 日期类型
 @return 返回日期格式
 */
+ (NSString *)obtainTheDateTypeBasedOnTheDateTypeEnumeration:(JZDateFormatType)dateFormatType;

/**将时间戳修改为小时分钟秒*/
+ (NSString *)timeStampChangeHHMMSS:(long long )timeStamp;

/**将时间戳修改为分钟秒*/
+ (NSString *)timeStampChangeMMSS:(long long )timeStamp;

/**根据时间小时分钟秒返回小时分钟*/
+ (NSString *)obtainTimeHHMMSS:(NSString *)timeStr;

/**根据时间戳转换为年月日*/
+ (NSString *)timeStampChangeYYYYMMMHHMMSS:(long long)timeStamp;

//将年月日时分秒改成年月日
//+ (NSString *)changeYYYYMMDDHHMMSSToYYYYMMDD:(NSString *)currentTimeStr;

/**将年月日时分秒 改为月日十分*/
+ (NSString *)changeYYYYMMDDHHMMSSTOMMDDHHMM:(NSString *)timeStr;

/**将秒数转化成小时分钟*/
+ (NSString *)hourMinuteTimeFromSecond:(NSString *)secondStr;




//判断是不是同年同月
+ (BOOL)isSameMonth:(NSDate *)date1 date2:(NSDate *)date2;
+ (BOOL)isSameMonthString:(NSString *)dateString1 dateString2:(NSString *)dateString2;

//判断是否在同一周
+ (BOOL)isSameWeekWithDate:(NSDate *)date fromDate:(NSDate *)fromDate;

/**
 时间显示:年-月  eg:2017-06  本月显示"本月"(当前本地时间)
 
 @param timeString 时间字符串 2017-06-28 09:00:00
 @return 2017-06
 */
+ (NSString *)showYearAndMonth:(NSString *)timeString;

+ (NSString *)timeString:(NSString *)timeStr;

/**
 将年月日时分秒转化为年月日

 @param currentTimeStr 指定的时间
 @return 返回目标数据
 */
+ (NSString *)changeYYYYMMDDHHMMSSToYYYYMMDD:(NSString *)currentTimeStr;

/**
 根据指定日期的获取指定月份的天数

 @param timeStr 指定日期
 @return 返回目标数据
 */
+ (NSInteger)obtainNumberOfDaysInMonth:(NSString *)timeStr;


/**
 当前日期时间
 
 @param format 时间格式
 
 */
+ (NSString *) getDateTimeNow:(NSString*)format;


@end
