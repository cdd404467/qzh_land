//
//  LandInfoModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LandInfoModel : NSObject
//信息id
@property (nonatomic, copy)NSString *k_id;
//业主名字
@property (nonatomic, copy)NSString *name;
//业主手机号
@property (nonatomic, copy)NSString *phone;
//0 身份证 1 护照 2台胞证 3港澳通行证 4 居住证 5 临时身份证 6 其他证件
@property (nonatomic, copy)NSString *documenttype;
//脱敏后证件号码
@property (nonatomic, copy)NSString *document;

//1 已经认证 2 未认证
@property (nonatomic, assign)NSInteger certification;
//脱敏后银行卡号
@property (nonatomic, copy)NSString *bankcarNo;
//银行名字
@property (nonatomic, copy)NSString *bank;
@end



@interface LeaseInfoModel : NSObject
//信息id
@property (nonatomic, copy)NSString *k_id;
//业主名字
@property (nonatomic, copy)NSString *name;
//业主手机号
@property (nonatomic, copy)NSString *phone;
//0 身份证 1 护照 2台胞证 3港澳通行证 4 居住证 5 临时身份证 6 其他证件
@property (nonatomic, copy)NSString *documenttype;
//脱敏后证件号码
@property (nonatomic, copy)NSString *document;
//1 已经认证 0 未认证
@property (nonatomic, assign)NSInteger issign;
@end
NS_ASSUME_NONNULL_END
