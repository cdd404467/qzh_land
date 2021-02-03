//
//  BillModel.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BillModel.h"

@implementation BillModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"billID":@"id"
    };
}
@end
