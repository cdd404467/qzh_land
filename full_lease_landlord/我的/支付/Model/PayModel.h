//
//  PayModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/24.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayModel : NSObject
//支付名称
@property (nonatomic, copy)NSString *value;
//支付图标
@property (nonatomic, copy)NSString *iconClass;
//支付编码
@property (nonatomic, copy)NSString *payFrom;
//手续费
@property (nonatomic, copy)NSString *feeAmount;
//总金额
@property (nonatomic, copy)NSString *amount;
//选中
@property (nonatomic, assign)BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
