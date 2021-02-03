//
//  UserInfoModel.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"userid":@"id"
    };
}

-(NSString *)userid{
    if(_userid == nil) {
        return @"";
    }
    return _userid;
}

- (NSString *)userPhone {
    if (!_userPhone) {
        return @"";
    }
    return _userPhone;
}

- (NSString *)userMoney {
    if (!_userMoney) {
        return @"0";
    }
    return _userMoney;
}

@end
