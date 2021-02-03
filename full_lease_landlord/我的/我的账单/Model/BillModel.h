//
//  BillModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BillModel : NSObject
//账单ID
@property (nonatomic, copy)NSString *billID;
//开始时间
@property (nonatomic, copy)NSString *begintime;
//结束时间
@property (nonatomic, copy)NSString *endtime;
//status
@property (nonatomic, assign)NSInteger status;
//支付日
@property (nonatomic, copy)NSString *shoureceivetime;
//账单类型 1 -租约 2 -记账 3-仪表 4-报修 5- 保洁
@property (nonatomic, copy)NSString *sourcetypestr;
//待支付金额
@property (nonatomic, copy)NSString *amountPayable;


/*详情*/
//总金额
@property (nonatomic, copy)NSString *amount;
//已支付金额
@property (nonatomic, copy)NSString *amountpaid;
//地址
@property (nonatomic, copy)NSString *adress;
//账单说明
@property (nonatomic, copy)NSString *explain;
//账单标题
@property (nonatomic, copy)NSString *title;
@end

NS_ASSUME_NONNULL_END
