//
//  DevelopTool.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import "DevelopTool.h"



//#define _TEST_API
#define _PRODUCT_API

#ifdef _TEST_API
//会员系统
#define Member @"https://member.girders.cn/"
//房源系统
#define Room @"https://room.girders.cn/"
//工单系统
#define Order @"https://order.girders.cn/"
//合同系统
#define Contract @"https://contract.girders.cn/"
//房东系统
#define Landlord @"https://landlord.girders.cn/"
#else
//会员系统
#define Member @"https://yzhjava.yizuhui.vip/member/"
//房源系统
#define Room @"https://yzhjava.yizuhui.vip/house/"
//工单系统
#define Order @"https://yzhjava.yizuhui.vip/order/"
//合同系统
#define Contract @"https://yzhjava.yizuhui.vip/contract/"
//房东系统
#define Landlord @"https://yzhjava.yizuhui.vip/landlord/"

#endif

@implementation DevelopTool
//生产环境
+ (NSString *)selectProductServerApi:(NSString *)urlStr {
    NSArray  *array = [urlStr componentsSeparatedByString:@"/"];
    if (array.count > 0) {
        NSString *str = array[0];
        if ([str isEqualToString:@"member"]) {
            return Member;
        }
        else if ([str isEqualToString:@"house"]) {
            return Room;
        }
        else if ([str isEqualToString:@"order"]) {
            return Order;
        }
        else if ([str isEqualToString:@"contract"]) {
            return Contract;
        }
        else if ([str isEqualToString:@"landlord"]) {
            return Landlord;
        }
        return @"";
    }
    return @"";
}

@end
