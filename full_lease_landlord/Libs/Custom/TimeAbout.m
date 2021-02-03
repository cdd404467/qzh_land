//
//  TimeAbout.m
//  FullLease
//
//  Created by apple on 2020/8/10.
//  Copyright © 2020 kad. All rights reserved.
//

#import "TimeAbout.h"

@implementation TimeAbout
//nsdate转string
+ (NSString*)dateToString:(NSDate*)date {
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}

+ (NSString*)dateToStringMonth:(NSDate*)date {
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}

//string转nsdata
+ (NSDate *)stringToDate:(NSString *)string {
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd";
    // NSString * -> NSDate *
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [format dateFromString:string];
    
    return date;
}

+ (NSDate *)stringToDateMonth:(NSString *)string {
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM";
    // NSString * -> NSDate *
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [format dateFromString:string];
    
    return date;
}

+(NSDate *)getNewDateSince:(NSDate *)date year:(NSInteger)year month:(NSInteger)month days:(NSInteger)days {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDateComponents *adcomps = [[NSDateComponents alloc]init];
    [adcomps setYear:year];//year=1表示1年后的时间 year=-1为1年前的日期
    [adcomps setMonth:month];
    [adcomps setDay:days];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}


+ (NSString *)getNewDateForStringSince:(NSDate *)date year:(NSInteger)year month:(NSInteger)month days:(NSInteger)days {
    NSDate *targetDate = [self getNewDateSince:date year:year month:month days:days];
    return [self dateToString:targetDate];
}

/*
//nsdate转string
+ (NSString*)dateToString:(NSDate*)date format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}

//string转nsdata
+ (NSDate *)stringToDate:(NSString *)string format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}

//时间戳转string
+ (NSString *)timeStampToString:(long)timeStamp format:(NSString *)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return [self dateToString:date format:format];
}

//string转时间戳
+ (long)stringToTimestamp:(NSString *)string format:(NSString *)format {
    NSDate *date = [self stringToDate:string format:format];
    return [self dateToTimeStamp:date];
}

//时间戳转NSDate
+ (NSDate *)timeStampToDate:(long)timeStamp {
    long long value = 0;
    if (@(timeStamp).stringValue.length != 10 || @(timeStamp).stringValue.length != 13) {
        return nil;
    }
    if (@(timeStamp).stringValue.length > 10) {
        value = timeStamp / 1000;
    }
    NSNumber *time = [NSNumber numberWithLongLong:value];
    //转换成NSTimeInterval,用longLongValue，防止溢出
    NSTimeInterval nsTimeInterval = [time longLongValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}

//NSDate转时间戳
+ (long)dateToTimeStamp:(NSDate *)date {
   return [date timeIntervalSince1970];
}
 
//比较两个时间戳之间的时间差
+ (NSDateComponents *)timeDiffWithStartTime:(NSString *)starTime finishTime:(NSString *)finishTime format:(NSString *)format {
 NSDate *startDate  = [self stringToDate:starTime format:format];
 NSDate *finishDate = [self stringToDate:finishTime format:format];
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
 NSCalendar *calendar = [NSCalendar currentCalendar];
 NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
 NSDateComponents *cmps = [calendar components:type fromDate:startDate toDate:finishDate options:0];
 return cmps;
}

//从一个时间往后推
+(NSDate *)getNewDateSince:(NSDate *)date year:(NSInteger)year month:(NSInteger)month days:(NSInteger)days {
 NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
 NSDateComponents *comps = nil;
 comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
 NSDateComponents *adcomps = [[NSDateComponents alloc]init];
 [adcomps setYear:year];//year=1表示1年后的时间 year=-1为1年前的日期
 [adcomps setMonth:month];
 [adcomps setDay:days];
 NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
 return newdate;
}
 
 */
@end
