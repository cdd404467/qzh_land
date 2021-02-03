//
//  MsgModel.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/1.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MsgModel.h"

@implementation MsgModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"s_id":@"id"
    };
}
@end
