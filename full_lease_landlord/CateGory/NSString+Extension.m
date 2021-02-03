//
//  NSString+Extension.m
//  full_lease_landlord
//
//  Created by apple on 2020/12/15.
//  Copyright © 2020 apple. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)correctPrecision {
//    NSDecimalNumber * number = [NSDecimalNumber decimalNumberWithString:originMoney];
//    NSDecimal resultStruct;
//    NSDecimal str = number.decimalValue;
//    NSDecimalRound(&resultStruct, &str, 2, NSRoundPlain); // 四舍五入保留3为小数，末尾没有0
//    NSDecimalNumber * resultNumber = [NSDecimalNumber decimalNumberWithDecimal:resultStruct];
//    return [resultNumber stringValue];
    double conversionValue = [self doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
