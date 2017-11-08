//
//  NSDate+YYQExtension.h
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YYQExtension)

@property (nonatomic ,readonly)NSInteger year;//当前日期时间的年份
@property (nonatomic ,readonly)NSInteger month;//当前日期时间的月份
@property (nonatomic ,readonly)NSInteger day;//当前日期时间号
@property (nonatomic ,readonly)NSInteger hour;//当前日期时间的小时
@property (nonatomic ,readonly)NSInteger minute;//当前日期时间的分钟
@property (nonatomic ,readonly)NSInteger second;//当前日期时间的秒钟
@property (nonatomic ,readonly)NSInteger nanosecond;//当前日期时间的毫秒
@property (nonatomic ,readonly)NSInteger weekday;//当前日期时间是星期几


@property (nonatomic ,readonly)BOOL isToday;//当前时间是否为今天
@property (nonatomic, readonly)BOOL isYesterday;//当前时间是否为昨天
@property (nonatomic, readonly)BOOL isTomorrow;//当前时间是否为明天
@property (nonatomic, readonly)BOOL isAfterDay;//当前时间是否为后天

//返回当前日期为星期几（星期几）;
- (NSString *)dayFromWeekday;
+ (NSString *)dayFromWeekday:(NSDate *)date;

/**
 返回当前是星期x

 @param date 日期

 @return 星期x
 */
+ (NSString *)standardDayFromWeekDay:(NSDate *)date;
/**
 *  返回一个多少年后的NSDate
 *
 *  @param years 多少年后
 */
- (NSDate *)dateByAddingYears:(NSInteger)years;

/**
 *  返回一个多少月后的NSDate
 *
 *  @param months 多少月后
 */
- (NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 *  返回一个多少星期后的NSDate
 *
 *  @param weeks 多少星期后
 */
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;

/**
 *  返回一个多少天后的NSDate
 *
 *  @param days 多少天后
 */
- (NSDate *)dateByAddingDays:(NSInteger)days;

/**
 *  返回一个多少小时后的NSDate
 *
 *  @param hours 多少小时
 */
- (NSDate *)dateByAddingHours:(NSInteger)hours;

/**
 *  返回一个多少分钟后的NSDate
 *
 *  @param minutes 多少分钟后
 */
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;

/**
 *  返回一个多少秒后的NSDate
 *
 *  @param seconds 多少秒之后
 */
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;

/**
 *  根据NSDate返回一个所需要转化的格式的字符串
 *
 *  @param format 需要转换的格式 如：yyyy-MM-dd HH:mm:ss
 *
 *  @return 返回格式化后的字符串
 */
- (NSString *)stringWithFormat:(NSString *)format;

/**
 *  转化为当地日期(处理8小时时间差)
 */
- (NSDate *)convertDateToLocalTime;

/**
 * 获取一年中的总天数
 */
- (NSUInteger)daysInYear;
+ (NSUInteger)daysInYear:(NSDate *)date;

/**
 * 判断是否是润年
 * @return YES表示润年，NO表示平年
 */
- (BOOL)isLeapYear;
+ (BOOL)isLeapYear:(NSDate *)date;

/**
 * 获取指定月份的天数
 */
- (NSUInteger)daysInMonth:(NSUInteger)month;
+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month;

/**
 * 获取当前月份的天数
 */
- (NSUInteger)daysInMonth;
+ (NSUInteger)daysInMonth:(NSDate *)date;

/**
 *  返回多久前（几分钟前 几小时前等 timeAgoWithDateString需要对应的格式为yyyy-MM-dd HH:mm:ss
 */
- (NSString *)timeAgo;
+ (NSString *)timeAgo:(NSDate *)date;
+ (NSString *)timeAgoWithDateString:(NSString *)dateString;


/**
 *  返回yyyy-MM-dd格式的字符串
 */
- (NSString *)ymdFormat;
+ (NSString *)ymdFormat;

/**
 *  返回HH:mm:ss格式的字符串
 */
- (NSString *)hmsFormat;
+ (NSString *)hmsFormat;

/**
 *  返回yyyy-MM-dd HH:mm:ss格式的字符串
 */
- (NSString *)ymdHmsFormat;
+ (NSString *)ymdHmsFormat;

/**
 *  将日期转化为当地日期(处理8小时时间差)
 *
 *  @param fromDate 需要转换的日期
 */
+ (NSDate *)convertDateToLocalTime:(NSDate *)fromDate;

/**
 *  根据时间字符串以及格式返回一个NSDate
 *
 *  @param dateString 时间字符串
 *  @param format     传进来的时间字符串对应的时间格式
 *
 *  @return 返回所需格式的NSDate
 */
+(NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

@end
