//
//  SystemTool.m
//  full_lease_landlord
//
//  Created by apple on 2020/12/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SystemTool.h"

@implementation SystemTool

+ (void)requestSystemSetting {
    [NetTool postRequest:URLPost_System_Setting Params:nil Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            [kUserDefaults setObject:RightDataSafe(json[@"data"][@"lockAppLink"]) forKey:KlockAppLink];
            [kUserDefaults setObject:RightDataSafe(json[@"data"][@"contactPhone"]) forKey:@"contactPhone"];
            [kUserDefaults setObject:RightDataSafe(json[@"data"][@"wxQrCode"]) forKey:@"wxQrCode"];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
