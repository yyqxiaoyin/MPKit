//
//  NSDate+YYQExtension.m
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//
//

#import "NSDate+YYQExtension.h"

@implementation NSDate (YYQExtension)

-(NSInteger)year{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

-(NSInteger)month{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

-(NSInteger)day{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

-(NSInteger)hour{

     return [[[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

-(NSInteger)minute{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self]minute];
}

-(NSInteger)second{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self]second];
}

-(NSInteger)nanosecond{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitNanosecond fromDate:self]nanosecond];
}

-(NSInteger)weekday{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSString *)dayFromWeekday {
    return [NSDate dayFromWeekday:self];
}

+ (NSString *)dayFromWeekday:(NSDate *)date {
    switch([date weekday]) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)standardDayFromWeekDay:(NSDate *)date {
    
    switch([date weekday]) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

-(BOOL)isToday{
    if (fabs(self.timeIntervalSinceNow)>= 60*60*24) return NO;
    return [NSDate date].day == self.day;
}

-(BOOL)isTomorrow{
    
    NSDate *date = [self dateByAddingDays:-1];
    
    return [date isToday];
}

-(BOOL)isAfterDay{

    NSDate *date = [self dateByAddingDays:-2];
    
    return [date isToday];
}

- (BOOL)isYesterday {
    NSDate *added = [self dateByAddingDays:1];
    return [added isToday];
}

-(NSDate *)dateByAddingYears:(NSInteger)years{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

-(NSDate *)dateByAddingMonths:(NSInteger)months{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

-(NSDate *)dateByAddingWeeks:(NSInteger)weeks{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

-(NSDate *)dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSince1970] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
    return newDate;
}

-(NSDate *)dateByAddingMinutes:(NSInteger)minutes{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

-(NSDate *)dateByAddingSeconds:(NSInteger)seconds{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

-(NSString *)stringWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

-(NSString *)timeAgo{
    return [NSDate timeAgo:self];
}

+(NSString *)timeAgo:(NSDate *)date{
    return [NSDate timeAgoWithDateString:[date stringWithFormat:[self ymdHmsFormat]]];
}

+(NSString *)timeAgoWithDateString:(NSString *)dateString{
    NSDate *date = [self dateWithString:dateString format:[self ymdHmsFormat]];
    NSDate *curDate = [[NSDate date] convertDateToLocalTime];
    NSTimeInterval timeInterval = -[date timeIntervalSinceDate:curDate];
    
    int temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    
    return  result;
}

-(NSDate *)convertDateToLocalTime{
    
    NSDate *date = [NSDate convertDateToLocalTime:self];
    
    return date;
}

- (NSUInteger)daysInYear {
    return [NSDate daysInYear:self];
}

+ (NSUInteger)daysInYear:(NSDate *)date {
    return [self isLeapYear:date] ? 366 : 365;
}

- (BOOL)isLeapYear {
    return [NSDate isLeapYear:self];
}

+ (BOOL)isLeapYear:(NSDate *)date {
    NSUInteger year = [date year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}

- (NSUInteger)daysInMonth:(NSUInteger)month {
    return [NSDate daysInMonth:self month:month];
}

+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [date isLeapYear] ? 29 : 28;
    }
    return 30;
}

- (NSUInteger)daysInMonth {
    return [NSDate daysInMonth:self];
}

+ (NSUInteger)daysInMonth:(NSDate *)date {
    return [self daysInMonth:date month:[date month]];
}

-(NSString *)ymdFormat{
    return [NSDate ymdFormat];
}

-(NSString *)hmsFormat{
    return [NSDate hmsFormat];
}

-(NSString *)ymdHmsFormat{
    return [NSDate ymdHmsFormat];
}

+(NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+(NSDate *)convertDateToLocalTime:(NSDate *)fromDate{
    
    NSTimeZone *zone = [NSCalendar currentCalendar].timeZone;
    NSInteger interval = [zone secondsFromGMTForDate: fromDate];
    NSDate *localeDate = [fromDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSString *)ymdFormat {
    return @"yyyy-MM-dd";
}

+ (NSString *)hmsFormat {
    return @"HH:mm:ss";
}

+ (NSString *)ymdHmsFormat {
    return [NSString stringWithFormat:@"%@ %@", [self ymdFormat], [self hmsFormat]];
}

@end
