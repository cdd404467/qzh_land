//
//  LeaseBillModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeaseBillModel : NSObject
//账单ID
@property (nonatomic, copy)NSString *billID;
//开始时间
@property (nonatomic, copy)NSString *begintime;
//结束时间
@property (nonatomic, copy)NSString *endtime;
//0-未支付1-已支付
@property (nonatomic, assign)NSInteger status;
//应收款时间
@property (nonatomic, copy)NSString *shoureceivetime;
//应收款时间描述状态 1 逾期XX天  2 今日支付  3 XX天后付款
@property (nonatomic, assign)NSInteger shoureceivetimeStatus;
//期
@property (nonatomic, copy)NSString *stage;
//应收款时间特殊情况描述
@property (nonatomic, copy)NSString *shoureceivetimeDesc;
//1 -租约 2 -记账 3-仪表 4-报修 5- 保洁
@property (nonatomic, copy)NSString *sourcetypestr;
//房源详细描述
@property (nonatomic, copy)NSString *adress;
//应缴金额
@property (nonatomic, copy)NSString *amountPayable;


/*详情*/
//总金额
@property (nonatomic, copy)NSString *amount;
//已支付金额
@property (nonatomic, copy)NSString *amountpaid;
//账单明细
@property (nonatomic, copy)NSArray *tbillLandlordDetailListDTOSList;
//账单标题
@property (nonatomic, copy)NSString *title;
@end


@interface tbillLandlordDetailListDTOSListModel : NSObject
//账单类别
@property (nonatomic, copy)NSString *billtype;
//账单类别金额
@property (nonatomic, copy)NSString *amountpaid;
@end
NS_ASSUME_NONNULL_END
