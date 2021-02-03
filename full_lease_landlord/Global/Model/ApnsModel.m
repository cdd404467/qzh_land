//
//  ApnsModel.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/16.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ApnsModel.h"

@implementation ApnsModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"apnsID":@"id"
    };
}
@end
