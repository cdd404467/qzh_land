//
//  TimeAbout.h
//  FullLease
//
//  Created by apple on 2020/8/10.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *TimeFormat NS_STRING_ENUM;
FOUNDATION_EXPORT TimeFormat const TimeFormatYear;
FOUNDATION_EXPORT TimeFormat const TimeFormatMonth;
FOUNDATION_EXPORT TimeFormat const TimeFormatDay;
FOUNDATION_EXPORT TimeFormat const TimeFormatHour;
FOUNDATION_EXPORT TimeFormat const TimeFormatMinute;
FOUNDATION_EXPORT TimeFormat const TimeFormatSecond;


@interface TimeAbout : NSObject
+ (NSString*)dateToString:(NSDate*)date;
+ (NSString*)dateToStringMonth:(NSDate*)date;
+ (NSDate *)stringToDate:(NSString *)string;
+ (NSDate *)stringToDateMonth:(NSString *)string;
+ (NSDate *)getNewDateSince:(NSDate *)date year:(NSInteger)year month:(NSInteger)month days:(NSInteger)days;
+ (NSString *)getNewDateForStringSince:(NSDate *)date year:(NSInteger)year month:(NSInteger)month days:(NSInteger)days;


+ (NSString*)dateToString:(NSDate*)date format:(TimeFormat)format;
+ (NSDate *)stringToDate:(NSString *)string format:(TimeFormat)format;
+ (NSString *)timeStampToString:(long)timeStamp format:(TimeFormat)format;
+ (long)stringToTimestamp:(NSString *)string format:(TimeFormat)format;
+ (NSDate *)timeStampToDate:(long)timeStamp;
+ (long)dateToTimeStamp:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
