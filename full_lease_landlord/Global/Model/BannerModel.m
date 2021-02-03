//
//  BannerModel.m
//  FullLease
//
//  Created by wz on 2020/8/4.
//  Copyright © 2020 kad. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"bannerId":@"id"
    };
}

@end
