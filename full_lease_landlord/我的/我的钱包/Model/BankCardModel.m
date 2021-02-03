//
//  BankCardModel.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/11.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BankCardModel.h"

@implementation BankCardModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"bankCardID":@"id"
    };
}
@end
