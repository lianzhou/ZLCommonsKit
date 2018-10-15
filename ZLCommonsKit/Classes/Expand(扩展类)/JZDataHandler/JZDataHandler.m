//
//  JZDataHandler.m
//  eStudy
//
//         我有一壶酒,足以慰风尘
//         倾倒江海里,共饮天下人
//
//  Created by 马金丽 on 17/7/5.
//  Copyright © 2017年 苏州橘子网络科技股份有限公司. All rights reserved.
//


#import "JZDataHandler.h"
#import "JZSystemMacrocDefine.h"
#import "JZStringMacrocDefine.h"


@interface JZDataHandler ()

@end

@implementation JZDataHandler



/**
 日期转字符串

 @param date 日期
 @param formatterString 时间格式
 @return 日期字符串
 */
+ (NSString *)transformToString:(NSDate *)date formatterString:(NSString*)formatterString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatterString];
    NSTimeZone *GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    [dateFormatter setTimeZone:GTMzone];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}


+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)formatstring
{
    if (JZCheckKeyValueHasNull(date, formatstring)) {
        return nil;
    }
    [[self sharedDateFormatter] setDateFormat:formatstring];
    NSString *timestamp_str = [[self sharedDateFormatter] stringFromDate:date];
    return timestamp_str;
}


/**
 字符串转日期

 @param strDate 日期字符串
 @param formatterString 时间格式
 @return 日期
 */
+ (NSDate *)transformToDate:(NSString *)strDate formatterString:(NSString*)formatterString {
    
    NSString * timeString = [self timeString:strDate];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatterString];
    NSDate *date = [dateFormatter dateFromString:timeString];
    NSInteger intervalDate = [zone secondsFromGMTForDate:date];
    date = [date dateByAddingTimeInterval:intervalDate];
    return date;
}

//时间戳转日期
+ (NSDate *)dateFromTimeInterval:(long long)timeImterval
{
    return [NSDate dateWithTimeIntervalSince1970:timeImterval];
}



#pragma mark -日期转字符串
//日期转字符串:yyyy-MM-dd HH:mm:ss
+(NSString *)toYYYYMMddHHmmss:(NSDate *)date
{
    return [self transformToString:date formatterString:YYYYMMddHHmmss];
}
//日期转字符串:yyyy-MM-dd
+(NSString *)toYYYYMMdd:(NSDate *)date
{
    return [self transformToString:date formatterString:YYYYMMdd];
}
//日期转字符串:yyyy-MM-dd HH:mm
+ (NSString *)toYYYYMMddHHmm:(NSDate *)date
{
    return [self transformToString:date formatterString:YYYYMMddHHmm];
}
+(NSString*)toYYYYMM:(NSDate*)date {
    return [self transformToString:date formatterString:YYYYMM];
}
//日期转字符串HH:mm
+(NSString*)toHHmm:(NSDate*)date
{
    return [self transformToString:date formatterString:HHmm];
}
//日期转字符串HH:mm:ss
+ (NSString*)toHHmmss:(NSDate*)date {
   return [self transformToString:date formatterString:HHmmss];
}
//日期转字符串yyyy年MM月dd日 HH:mm:ss
+ (NSString *)toYYYYMMddHHmmssCN:(NSDate *)date
{
    return [self transformToString:date formatterString:YYYYMMddHHmmssCN];
}
//日期转字符串yyyy年MM月dd日 HH:mm
+ (NSString *)toYYYYMMddHHmmCN:(NSDate *)date
{
    return [self transformToString:date formatterString:YYYYMMddHHmmCN];
}
//日期转字符串yyyy年MM月dd日
+(NSString*)toYYYYMMddCN:(NSDate*)date
{
    return [self transformToString:date formatterString:YYYYMMddCN];
}


#pragma mark -字符串转日期
//字符串转日期
+(NSDate *)formYYYYMMddHHmmss:(NSString *)timeStr
{

    return [self transformToDate:timeStr formatterString:YYYYMMddHHmmss];
}

//字符串转日期:yyyy-MM-dd HH:mm
+(NSDate *)formYYYYMMddHHmm:(NSString *)timeStr
{
    return [self transformToDate:timeStr formatterString:YYYYMMddHHmm];
}

//字符串转日期:yyyy-MM-dd
+(NSDate *)formYYYYMMdd:(NSString *)timeStr
{
    return [self transformToDate:timeStr formatterString:YYYYMMdd];
}

//字符串转日期:HH:mm
+(NSDate *)formHHmm:(NSString *)timeStr
{
    return [self transformToDate:timeStr formatterString:HHmm];
}
+(NSDate *)formYYYYMM:(NSString *)timeStr {
    return [self transformToDate:timeStr formatterString:YYYYMM];
}
#pragma mark -获取时间戳

+ (NSString *)currentTimeString{
    NSTimeInterval timeInterval=[[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeInterval];
    return timeString;
}


//获取时间戳
+ (long long)intervalFormNewTime:(NSString *)timeStr
{
    NSDate *newDate = [self formYYYYMMddHHmmss:[self timeString:timeStr]];
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    long long newInterval = interval - 28800;//时差8小时
    return newInterval;
}

+ (long long)intervaleFormDate:(NSDate *)date
{
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    return interval;
}

//截取字符串.0
+ (NSString *)timeString:(NSString *)timeStr
{
    if (!JZStringIsNull(timeStr)) {
        if (timeStr.length > 19) {
            return [timeStr substringToIndex:19];
        }if ([timeStr rangeOfString:@".0"].location != NSNotFound) {
            return [timeStr substringToIndex:timeStr.length - 2];
        }
        return timeStr;
    }else{
        return @"";
    }
}


#pragma mark -自定义显示日期
+ (NSString *)showSpecailTimeWithTimeString:(NSString *)lastTime
{
    if (JZStringIsNull(lastTime)) {
        return @"";
    }
    NSString * timeString = [self timeString:lastTime];
    if (timeString.length<19) {
        return timeString;
    }
    
    long long lastInterval = [self intervalFormNewTime:lastTime];
    NSDate *lastDate = [self dateFromTimeInterval:lastInterval];
    if (JZCheckObjectNull(lastDate)) {
        return nil;
    }                                                
    NSCalendar *calendar = [self sharedCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:lastDate];
    NSInteger year = [component year];
    NSInteger month = [component month];
    NSInteger day = [component day];
    //当前时间
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    NSInteger t_year = [component year];
    NSInteger t_month   = [component month];
    NSInteger t_day     = [component day];
    
    long long now = [today timeIntervalSince1970];
    //时间差
    long long  distance= now - lastInterval;

    NSString *monthString;
    NSString *dayString;
    if (month<10) {
        monthString = [NSString stringWithFormat:@"0%ld",(long)month];
    }else{
        monthString = [NSString stringWithFormat:@"%ld",(long)month];
    }
    if (day<10) {
        dayString = [NSString stringWithFormat:@"0%ld",(long)day];
    }else{
        dayString = [NSString stringWithFormat:@"%ld",(long)day];
    }
    NSString *resultString = nil;
  
    if (year == t_year) {//当年
        NSString *detailTime = [self stringFromDate:lastDate withFormat:@"HH:mm"]; //时:分
        if (t_day-day >= 2 && month == t_month) {//前天
            resultString = [NSString stringWithFormat:@"%ld月%ld日 %@",month,day,detailTime];
        }else if (t_day - day == 1 && month == t_month){//昨日
            
            resultString = [NSString stringWithFormat:@"昨天 %@",detailTime];
        }else if (t_day - day == 0 && month == t_month){//今日
            if (distance < 60 * 60 && distance >= 60 * 10) {//XX分钟前
    
                resultString = [NSString stringWithFormat:@"%lld分钟前",distance/60];
            }else if (distance <= 60 * 10){//刚刚
                resultString = @"刚刚";
            }else{
                NSInteger hour = distance/(60*60);
                resultString = [NSString stringWithFormat:@"%ld小时前",hour];
            }
        }else{
            resultString = [NSString stringWithFormat:@"%@月%@日 %@",monthString,dayString,detailTime];
        }
  
    }else{//跨年
//        NSString *detailTime = [self stringFromDate:lastDate withFormat:@"HH:mm:ss"]; //时:分:秒
        resultString = [NSString stringWithFormat:@"%ld年%@月%@日",(long)year,monthString,dayString];
    }
    
    return resultString;
}

#pragma mark -获取两个时间的时间差
+(void)missTimeResultToStartTime:(NSString *)startTime formEndTime:(NSString *)endTime withResultBlock:(TimeResultBlock)timeBlock
{
    NSDate *startDate = [self formYYYYMMddHHmmss:startTime];
    NSDate *endDate = [self formYYYYMMddHHmmss:endTime];
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    if (interval >= 1) {
        NSInteger missDay = interval / (3600*24);
        NSInteger missHour = (interval - missDay *(3600*24))/3600;
        NSInteger missMinute = (interval - missDay*(3600*24)-missHour*3600)/60;
        NSInteger missSecond = (interval - missDay*(3600*24)-missHour*3600-missHour*60);
        if (timeBlock) {
            timeBlock(missDay,missHour,missMinute,missSecond);
        }
    } 
    
}

//日历
+ (NSCalendar *)sharedCalendar
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    [currentCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    [currentCalendar setFirstWeekday:2];
    return currentCalendar;
}

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_dateFormatter) {
            _dateFormatter = [[NSDateFormatter alloc]init];
        }
    });
    return _dateFormatter;
}
//获取n个月之后 或 n月之前的日期
+ (NSString *)obtainPriousorLaterDateFromDate:(NSString *)starDateStr withMonth:(NSInteger)month withDateFormatType:(JZDateFormatType)dateFormatType {
    
    if(JZStringIsNull(starDateStr)){
        return nil;
    }
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:month];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:[self obtainTheDateTypeBasedOnTheDateTypeEnumeration:dateFormatType]];
    
    NSDate *date = [dateFormatter dateFromString:[self changeYYYYMMDDHHMMSSToYYYYMMDD:starDateStr]];
    
    NSDate *newDate = [calendar dateByAddingComponents:components toDate:date options:0];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:newDate];
    
    NSString *finalDateStr = [self obtainTheTimeStringOfTheDayBeforeOrAfterTheSpecifiedTime:currentDateStr withTheDay:month > 0 ? (-1) : 1 withDateFormatType:dateFormatType];
    
    return finalDateStr;
}
//将时间的格式的年月日时分秒修改为年月日
+ (NSString *)changeYYYYMMDDHHMMSSToYYYYMMDD:(NSString *)currentTimeStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *currentDate = [formatter dateFromString:currentTimeStr];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *timeStr = [dateFormatter stringFromDate:currentDate];
    
    return timeStr;
}
//根据日期获取计算星期
+ (NSString *)weekDayStringFromDate:(NSString *)dateStr {
    NSArray *timeStrArr = [[NSArray alloc]init];
    if ([dateStr containsString:@"."]) {
        timeStrArr = [dateStr componentsSeparatedByString:@"."];
    }
    
    NSString *timeStr = @"";
    if (!JZCheckArrayNull(timeStrArr)) {
        timeStr = [timeStrArr firstObject];
    }else{
        timeStr = dateStr;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Beijing"];
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *componts = [calendar components:calendarUnit fromDate:date];
    NSString *weekStr = [weekdays objectAtIndex:componts.weekday];
    return weekStr;
}
//比较两个日期的大小
+ (BOOL)compareDate:(NSString *)currenDateStr withDate:(NSString *)newDateStr withDateFormatType:(JZDateFormatType)dateFormatType
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self obtainTheDateTypeBasedOnTheDateTypeEnumeration:dateFormatType]];
    NSDate *currentDate = [formatter dateFromString:currenDateStr];
    
    NSDate *newDate = [formatter dateFromString:newDateStr];
    
    if ([currentDate compare:newDate] != NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
}

//比较两个日期是否相同 精确到分钟
+ (BOOL)isSameTime:(NSDate *)currenDateStr withDate:(NSDate *)newDateStr {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit  | NSHourCalendarUnit |  NSMinuteCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:currenDateStr];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:newDateStr];
    
    return [comp1 day] == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year] &&
    [comp1 hour]  == [comp2 hour] &&
    [comp1 minute]  == [comp2 minute];
}

// 获取指定时间的前几天或者后几天的时间字符串 当前时间的前几天还是后几天（dayCount > 0 为后几天 dayCount < 0 为前几天 ）
+ (NSString *)obtainTheTimeStringOfTheDayBeforeOrAfterTheSpecifiedTime:(NSString *)currentTime withTheDay:(NSInteger)dayCount withDateFormatType:(JZDateFormatType)dateFormatType {
    
    if (JZStringIsNull(currentTime)) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self obtainTheDateTypeBasedOnTheDateTypeEnumeration:dateFormatType]];
    NSDate *currentDate = [formatter dateFromString:currentTime];
    
    NSDate *finalDate = [NSDate dateWithTimeInterval:24 * 60 * 60 * dayCount sinceDate:currentDate];
    
    NSString *finalStr = [formatter stringFromDate:finalDate];
    return finalStr;
}
//获取当前日期所在的周的开始日期或者结束日期
+ (NSString *)obtainTheBenginOrEndDateOfTheCurrentWeek:(NSString *)currentDateStr withIsEnd:(BOOL)isEnd withDateFormatType:(JZDateFormatType)dateFormatType {
    
    if (JZStringIsNull(currentDateStr)) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[self obtainTheDateTypeBasedOnTheDateTypeEnumeration:dateFormatType]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [formatter dateFromString:currentDateStr];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:date];
    
    //获取当前日期在本周内的第几天
    NSInteger dayofWeek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];
    if (isEnd) {
        //结束日期
        [components setDay:([components day] + (7 - (dayofWeek - 1)))];
    }else{
        //开始日期
        [components setDay:([components day] - (dayofWeek - 2))];
    }
    NSDate *endDate = [calendar dateFromComponents:components];
    NSString *dateStr = [formatter stringFromDate:endDate];
    return dateStr;
}
//根据日期类型的枚举获取日期类型
+ (NSString *)obtainTheDateTypeBasedOnTheDateTypeEnumeration:(JZDateFormatType)dateFormatType {
    
    switch (dateFormatType) {
        case JZDateFormatTypeYYYY_MM_DD:
            return @"yyyy-MM-dd";
            break;
        case JZDateFormatTypeYYYY_MM_DD_HH_MM:
            return @"yyyy-MM-dd HH:mm";
            break;
        case JZDateFormatTypeYYYY_MM_DD_HH_MM_SS:
            return @"yyyy-MM-dd HH:mm:ss";
            break;
        case JZDateFormatTypeYYYY_MM_DD_HH_MM_SS_SSS:
            return @"yyyy-MM-dd HH:mm:ss.SSS";
            break;
        default:
            break;
    }
}
//将时间戳修改为小时分钟秒
+ (NSString *)timeStampChangeHHMMSS:(long long )timeStamp {
    
    if (timeStamp <= 0) {
        return nil;
    }
    
    NSTimeInterval interval    = timeStamp  / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}

//将时间戳修改为分钟秒
+ (NSString *)timeStampChangeMMSS:(long long )timeStamp {
    
    if (timeStamp <= 0) {
        return nil;
    }
    
    NSTimeInterval interval    = timeStamp  / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}


//根据时间小时分钟秒返回小时分钟
+ (NSString *)obtainTimeHHMMSS:(NSString *)timeStr {
    
    if (JZStringIsNull(timeStr)) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeStr];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *currentTimeStr = [dateFormatter stringFromDate:date];
    return currentTimeStr;
}
//根据时间戳返回年月日
+ (NSString *)timeStampChangeYYYYMMMHHMMSS:(long long)timeStamp {
    
    if (timeStamp < 0) {
        return nil;
    }
    NSTimeInterval interval    = timeStamp / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}
//将年月日时分秒 改为月日十分
+ (NSString *)changeYYYYMMDDHHMMSSTOMMDDHHMM:(NSString *)timeStr {
    
    if (JZStringIsNull(timeStr)) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:JZIFISNULL(timeStr)];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *currentTimeStr = [formatter stringFromDate:date];
    
    return currentTimeStr;
}
// 根据指定日期获取指定日期中的月份的天数
+ (NSInteger)obtainNumberOfDaysInMonth:(NSString *)timeStr {
    
    if (JZStringIsNull(timeStr)) {
        return 0;
    }
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * currentDate = [formatter dateFromString:JZIFISNULL(timeStr)];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:currentDate];
    return range.length;
}

+ (NSString *)showYYMMDDStr:(NSString *)timeStr {
    if (JZStringIsNull(timeStr)) {
        return nil;
    }
    NSDate *newDate = [self formYYYYMMddHHmmss:timeStr];
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    long long newInterval = interval - 28800;//时差8小时
    NSDate *currentDate = [self dateFromTimeInterval:newInterval];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear = [[formatter stringFromDate:currentDate] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth = [[formatter stringFromDate:currentDate] integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay = [[formatter stringFromDate:currentDate] integerValue];
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",currentYear,currentMonth,currentDay];

}


+ (NSString *)showYYMMDDTimeDate:(NSDate *)timeDate {
    NSTimeInterval interval = [timeDate timeIntervalSince1970];
    long long newInterval = interval - 28800;//时差8小时
    NSDate *currentDate = [self dateFromTimeInterval:newInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear = [[formatter stringFromDate:currentDate] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth = [[formatter stringFromDate:currentDate] integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay = [[formatter stringFromDate:currentDate] integerValue];
    return [NSString stringWithFormat:@"%ld年%ld月%ld日",currentYear,currentMonth,currentDay];
}

+ (NSString *)showYYMMTimeDate:(NSDate *)timeDate {
    NSTimeInterval interval = [timeDate timeIntervalSince1970];
    long long newInterval = interval - 28800;//时差8小时
    NSDate *currentDate = [self dateFromTimeInterval:newInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear = [[formatter stringFromDate:currentDate] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth = [[formatter stringFromDate:currentDate] integerValue];
    return [NSString stringWithFormat:@"%ld年%ld月",currentYear,currentMonth];
}

//eg:09月25日
+ (NSString *)showMMDDWithDataStr:(NSString *)timeStr {
    if (JZStringIsNull(timeStr)) {
        return nil;
    }
    NSDate *newDate = [self formYYYYMMddHHmmss:timeStr];
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    long long newInterval = interval - 28800;//时差8小时
    NSDate *currentDate = [self dateFromTimeInterval:newInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth = [[formatter stringFromDate:currentDate] integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay = [[formatter stringFromDate:currentDate] integerValue];
    return [NSString stringWithFormat:@"%ld月%ld日",currentMonth,currentDay];
    
}

//eg:10月27日 10:27
+ (NSString *)showMMDDHHmmWithDateStr:(NSString *)timeStr {
    if (JZStringIsNull(timeStr)) {
        return nil;
    }
    NSDate *newDate = [self formYYYYMMddHHmmss:timeStr];
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    long long newInterval = interval - 28800;//时差8小时
    NSDate *currentDate = [self dateFromTimeInterval:newInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    
    NSString *resultStr = [formatter stringFromDate:currentDate];
    return resultStr;
}

// eg:10:30
+ (NSString *)showHHddWithDateStr:(NSString *)timeStr {
    if (JZStringIsNull(timeStr)) {
        return nil;
    }
    NSDate *newDate = [self formYYYYMMddHHmmss:timeStr];
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    long long newInterval = interval - 28800;//时差8小时
    NSDate *currentDate = [self dateFromTimeInterval:newInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];

    NSString *resultStr = [formatter stringFromDate:currentDate];
    return resultStr;
}
//eg:10/20
+ (NSString *)showMMDDWithDateStr:(NSString *)timeStr {
    if (JZStringIsNull(timeStr)) {
        return nil;
    }
    NSDate *newDate = [self formYYYYMMddHHmmss:timeStr];
    NSTimeInterval interval = [newDate timeIntervalSince1970];
    long long newInterval = interval - 28800;//时差8小时
    NSDate *currentDate = [self dateFromTimeInterval:newInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    
    NSString *resultStr = [formatter stringFromDate:currentDate];
    return resultStr;
}

//月-日 eg: 10-20
+ (NSString *)showOnlyMonthAndDay:(NSString *)timeStr {
    
    if (JZStringIsNull(timeStr)) {
        return nil;
    }
    NSDate *currentDate;
    NSArray *timeArray = [timeStr componentsSeparatedByString:@" "];
    if (timeArray.count == 1) {
        NSDate *newDate = [self formYYYYMMdd:[self timeString:timeStr]];
        NSTimeInterval interval = [newDate timeIntervalSince1970];
        long long newInterval = interval - 28800;//时差8小时
        currentDate = [self dateFromTimeInterval:newInterval];
    }else{
        long long lastInterval = [self intervalFormNewTime:timeStr];
        currentDate = [self dateFromTimeInterval:lastInterval];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth = [[formatter stringFromDate:currentDate] integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay = [[formatter stringFromDate:currentDate] integerValue];
    
    return [NSString stringWithFormat:@"%ld-%ld",currentMonth,currentDay];
    
}

//判断是不是同年同月
+ (BOOL)isSameMonth:(NSDate *)date1 date2:(NSDate *)date2
{
    if (!date1 || !date2) {
        return NO;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

//判断是否在本周
+ (BOOL)isSameWeekWithDate:(NSDate *)date fromDate:(NSDate *)fromDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:NSCalendarUnitWeekday fromDate:fromDate];
    NSDateComponents *components2 = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    //获取周几
    NSUInteger week1 = [JZDataHandler currentWeekdayFromSystem:components1.weekday];
    NSUInteger week2 = [JZDataHandler currentWeekdayFromSystem:components2.weekday];
    NSLog(@"===今天周%ld,目标周%ld",week1,week2);
    
    //相差的秒数
    NSTimeInterval differ = date.timeIntervalSince1970 - fromDate.timeIntervalSince1970;
    int secondsOfOneWeek = 86400; //一天所走的秒数
    if (differ == 0) {
        
        return YES;
    }else if (differ > 0) {
        
        return differ < secondsOfOneWeek * week2? YES:NO;
    }else {
        
        return -differ < secondsOfOneWeek * week1? YES : NO;
    }
}

//系统的是周日=1,周一=2...周六=7,需要做一次转换
+ (NSInteger)currentWeekdayFromSystem:(NSUInteger)weekday {
    switch (weekday) {
        case 1:
            return 7;
        case 2:
            return 1;
        case 3:
            return 2;
        case 4:
            return 3;
        case 5:
            return 4;
        case 6:
            return 5;
        case 7:
            return 6;
        default:
            return 0;
    }
}

+ (BOOL)isSameMonthString:(NSString *)dateString1 dateString2:(NSString *)dateString2 {
    if (JZStringIsNull(dateString1) || JZStringIsNull(dateString2)) {
        return NO;
    }
    NSDate *date1 = [self formYYYYMMddHHmmss:dateString1];
    NSDate *date2 = [self formYYYYMMddHHmmss:dateString2];
    return [self isSameMonth:date1 date2:date2];
}

+ (NSString *)showYearAndMonth:(NSString *)timeString {
    if (JZStringIsNull(timeString)) {
        return @"未知";
    }
    NSDate *date1 = [self formYYYYMMddHHmmss:timeString];
    NSDate *date2 = [NSDate date];
    if ([self isSameMonth:date1 date2:date2]) {
        return @"本月";
    }
    
    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"dd"];
//    NSDate *date = [dateFormatter dateFromString:timeString];
//    NSInteger intervalDate = [zone secondsFromGMTForDate:date];
//    date = [date dateByAddingTimeInterval:intervalDate];
    
//    NSDate * date = [self formYYYYMM:timeString];
    NSString * dateString = [self toYYYYMM:date1];
    
    if (JZStringIsNull(dateString)) {
        return @"未知";
    }
    return dateString;

}

//将秒数转化成分钟秒数
+ (NSString *)hourMinuteTimeFromSecond:(NSString *)secondStr {
    
    if (JZStringIsNull(secondStr)) {
        
        NSLog(@"秒数不存在!!!");
        return @"";
    }
    NSInteger seconds = [secondStr integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    
    if ([str_minute integerValue] < 10) {
        
        str_minute = [NSString stringWithFormat:@"0%@",str_minute];
    }
    
    if ([str_second integerValue] < 10) {
        
        str_second = [NSString stringWithFormat:@"0%@",str_second];;
    }
    
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
}


#pragma mark  当前日期时间
+(NSString *) getDateTimeNow:(NSString*)format{
    
    //获取当前时间日期
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:format];
 
    return  [format1 stringFromDate:date];
}

@end


