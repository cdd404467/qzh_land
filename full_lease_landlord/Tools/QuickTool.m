//
//  QuickTool.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import "QuickTool.h"
#import <UIKit/UIKit.h>

@implementation QuickTool
+ (BOOL)is_SimuLator {
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        //模拟器
        return YES;
    } else {
        //真机
        return NO;
    }
}

+ (BOOL)is_Debug {
#ifdef DEBUG
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)isRirhtData:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        if (object && ![object isEqualToString:@"null"] && ![object isEqualToString:@""] && ![object isEqualToString:@"<null>"]) {
            return YES;
        }
        return NO;
    } else {
        if (object && object != NULL && ![object isKindOfClass:[NSNull class]]) {
            return YES;
        }
        return NO;
    }
}

+ (NSString *)RightDataSafe:(id)object {
    if([self isRirhtData:object]) {
        return object;
    }
    return @"";
}

+ (void)callPhone:(nullable NSString *)phone {
    if (!isRightData(phone))
        return;
    NSString *tel = [NSString stringWithFormat:@"telprompt://%@",phone];
    NSURL *phoneURL = [NSURL URLWithString:tel];
    //开线程，解决ios10调用慢的问题
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication openURL:phoneURL options:@{} completionHandler:nil];
        });
    });
}

+ (BOOL)isSetPassword {
    //创建信号
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSInteger isSetPW;
    [NetTool getRequestAsync:URLGet_IsSet_Password Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            if ([json[@"data"][@"result"] integerValue] == 1) {
                isSetPW = 1;
            } else {
                isSetPW = 0;
            }
        } else {
            isSetPW = -1;
        }
        dispatch_semaphore_signal(semaphore);   //发送信号
    } Failure:^(NSError * _Nonnull error) {
        isSetPW = -2;
        dispatch_semaphore_signal(semaphore);
    }];
    //没收到信号之前一直会卡在这里
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isSetPW;
}

//验证密码
+ (NSInteger)checkPassWord:(NSString *)password {
    NSDictionary *dict = @{@"paymentCode":password};
    __block NSInteger isCorrect;
//    [CddHud showWithText:@"正在验证支付密码" view:[HelperTool getCurrentVC].view];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [NetTool postRequestAsync:URLPost_Chect_Password Params:dict Success:^(id  _Nonnull json) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [CddHud hideHUD:[HelperTool getCurrentVC].view];
        });
        if (JsonCode == 200) {
            if ([json[@"data"][@"result"] integerValue] == 1) {
                isCorrect = 1;
            } else {
                isCorrect = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CddHud showTextOnly:@"密码错误" view:[HelperTool getCurrentVC].view];
                });
            }
        } else {
            isCorrect = -1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [CddHud showTextOnly:json[@"message"] view:[HelperTool getCurrentVC].view];
            });
        }
        dispatch_semaphore_signal(semaphore);
        } Failure:^(NSError * _Nonnull error) {
            isCorrect = -2;
            dispatch_semaphore_signal(semaphore);
        }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return isCorrect;
}

//获取智能门锁的token
+ (NSString *)getDoorToken {
    __block NSString *doorToken = [NSString string];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    if ([User_Info objectForKey:@"dootToken"] || isRightData([User_Info objectForKey:@"dootToken"])) {
//        doorToken = [User_Info objectForKey:@"dootToken"];
//        dispatch_semaphore_signal(semaphore);
//    } else {
        [NetTool getRequestAsync:URLGet_landlady_Login Params:nil Success:^(id  _Nonnull json) {
            if (JsonCode == 200) {
                doorToken = json[@"data"][@"Authorization"];
                NSMutableDictionary *mDict = [User_Info mutableCopy];
                [mDict setValue:doorToken forKey:@"dootToken"];
                [UserDefault setObject:[mDict copy] forKey:@"userInfo"];
            } else {
                doorToken = @"";
            }
            dispatch_semaphore_signal(semaphore);   //发送信号
        } Failure:^(NSError * _Nonnull error) {
            doorToken = @"";
            dispatch_semaphore_signal(semaphore);
        }];
//    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return doorToken;
}


@end
