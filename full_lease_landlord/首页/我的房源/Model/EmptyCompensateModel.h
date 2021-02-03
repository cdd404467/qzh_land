//
//  EmptyCompensateModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/4.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmptyCompensateModel : NSObject
//说明
@property (nonatomic, copy)NSString *explain;
//空置天数
@property (nonatomic, copy)NSString *saleDay;
//状态名
@property (nonatomic, copy)NSString *statusStr;
//理赔金额
@property (nonatomic, copy)NSString *amount;
//状态编号 0：未支付 1：已支付
@property (nonatomic, assign)NSInteger status;
@end

NS_ASSUME_NONNULL_END
