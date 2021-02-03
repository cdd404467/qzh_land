//
//  TimeAbout.h
//  FullLease
//
//  Created by apple on 2020/8/10.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeAbout : NSObject
+ (NSString*)dateToString:(NSDate*)date;
+ (NSString*)dateToStringMonth:(NSDate*)date;
+ (NSDate *)stringToDate:(NSString *)string;
+ (NSDate *)stringToDateMonth:(NSString *)string;
+ (NSDate *)getNewDateSince:(NSDate *)date year:(NSInteger)year month:(NSInteger)month days:(NSInteger)days;
+ (NSString *)getNewDateForStringSince:(NSDate *)date year:(NSInteger)year month:(NSInteger)month days:(NSInteger)days;
@end

NS_ASSUME_NONNULL_END
