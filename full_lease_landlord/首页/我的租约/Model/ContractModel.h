//
//  ContractModel.h
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContractModel : NSObject
//合同id
@property (nonatomic, copy)NSString *conID;
//地址
@property (nonatomic, copy)NSString *adress;
//开始时间
@property (nonatomic, copy)NSString *begintime;
//结束时间
@property (nonatomic, copy)NSString *endtime;
//月租金
@property (nonatomic, copy)NSString *recent;
//状态  1-待签约 4-待搬入5在租 6逾期 7已退租8 作废 9 退租审批中 10 退租未结账 2-续租在租
//1-待签约 4-待搬入5在租 6逾期 7已退租8 作废 10 退租未结账 2-续租在租 11-待房东确认 12-房东拒绝 13退租审核中
@property (nonatomic, assign)NSInteger status;
//付款频率
@property (nonatomic, assign)NSInteger pinlv;
@property (nonatomic, copy)NSString *pinlvStr;
//押几
@property (nonatomic, copy)NSString *deposittype;
@property (nonatomic, copy)NSString *deposittypeStr;
//付几
@property (nonatomic, copy)NSString *firstpay;
//押金
@property (nonatomic, copy)NSString *deposit;

/* 详情 */
//租金分阶
@property (nonatomic, copy)NSArray *grading;
//银行卡号
@property (nonatomic, copy)NSString *account;
//银行名字
@property (nonatomic, copy)NSString *bank;
//最高涨幅
@property (nonatomic, copy)NSString *highestincrease;
//租金分阶每年的金额
@property (nonatomic, copy)NSString *gradingvalue;
//分阶类型 1-按比例逐年新增 2-按金额逐年新增 3-按年自定义
@property (nonatomic, assign)NSInteger gradingtype;


//押金数组
@property (nonatomic, copy)NSArray *totherfeeDTOSOneList;
//加收费用
@property (nonatomic, copy)NSArray *totherfeeDTOSTwoList;
@end


@interface GradingModel : NSObject
//租金
@property (nonatomic, copy)NSString *amount;
//year
@property (nonatomic, copy)NSString *year;
//中国化nsstr
@property (nonatomic, copy)NSString *chinaAnnual;
@end

@interface OtherChargeModel : NSObject
//押金名字
@property (nonatomic, copy)NSString *name;
//押金费用
@property (nonatomic, copy)NSString *amount;
//结算方式 1-固定费用结算2-预充值3-抄表结算4-不收取电费
@property (nonatomic, assign)NSInteger type;
//结算描述
@property (nonatomic, copy)NSString *pinlvStr;
@end

NS_ASSUME_NONNULL_END
