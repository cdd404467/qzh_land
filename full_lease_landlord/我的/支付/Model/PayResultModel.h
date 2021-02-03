//
//  PayResultModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/25.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayResultModel : NSObject
//支付的url
@property (nonatomic, copy)NSString *pay_info;
//订单编号
@property (nonatomic, copy)NSString *orderid;

@end


@interface PayCheckModel : NSObject
//WaitPay-待支付，Success-支付成功，Canceled-已取消，Failed-支付失败，Other-其他，Checking-审批中(线下支付存在)，Refused-审批拒绝(线下支付存在)
@property (nonatomic, copy)NSString *status;
//总金额
@property (nonatomic, copy)NSString *Amount;
//未支付金额
@property (nonatomic, assign)double UnpaidAmount;
//已支付金额
@property (nonatomic, assign)double AmountPaid;
//账单编号数组
@property (nonatomic, copy)NSArray *BillIds;
@end


NS_ASSUME_NONNULL_END
