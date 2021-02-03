//
//  QuickTool.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuickTool : NSObject
//判断是否是模拟器
+ (BOOL)is_SimuLator;
//判断是否是debug模式
+ (BOOL)is_Debug;
+ (BOOL)isRirhtData:(nullable id)object;
+ (NSString *)RightDataSafe:(nullable id)object;
+ (void)callPhone:(nullable NSString *)phone;
+ (BOOL)isSetPassword;
+ (NSInteger)checkPassWord:(NSString *)password;
+ (NSString *)getDoorToken;
@end

NS_ASSUME_NONNULL_END
