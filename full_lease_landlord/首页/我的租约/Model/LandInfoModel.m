//
//  LandInfoModel.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LandInfoModel.h"

@implementation LandInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"k_id":@"id"
    };
}
@end


@implementation LeaseInfoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"k_id":@"id"
    };
}

@end
