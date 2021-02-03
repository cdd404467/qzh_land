//
//  IncomeModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class orderMothTotalDtoModel;
@class sourcetypeEnumModel;
@class pgingDataModel;


NS_ASSUME_NONNULL_BEGIN

@interface IncomeModel : NSObject

@property (nonatomic, strong)orderMothTotalDtoModel *orderMothTotalDto;
//账单类型枚举
@property (nonatomic, copy)NSArray<sourcetypeEnumModel *> *sourcetypeEnum;
//分页数据
@property (nonatomic, strong)pgingDataModel *pgingData;

@end


@interface orderMothTotalDtoModel : NSObject
//总收入
@property (nonatomic, copy)NSString * incomeTotal;
//总支出
@property (nonatomic, copy)NSString * expenditureTotal;
@end


@interface sourcetypeEnumModel : NSObject
//账单类型id
@property (nonatomic, copy)NSString *groupid;
//账单类型
@property (nonatomic, copy)NSString *sourcetype;
@end


@interface pgingDataModel : NSObject
//列表数据
@property (nonatomic, copy)NSArray *data;
@end


@interface IncomeListModel : NSObject
//流水主表ID
@property (nonatomic, copy)NSString *k_id;
//0 收入 1 支出
@property (nonatomic, assign)NSInteger budgettype;
//流水明细标题
@property (nonatomic, copy)NSString *title;
//创建时间
@property (nonatomic, copy)NSString *createtime;
//1 租约 2 记账 3 仪表
@property (nonatomic, assign)NSInteger sourcetype;
//金额
@property (nonatomic, copy)NSString *amount;
//房源的地址
@property (nonatomic, copy)NSString *adress;
@end


@interface IncomeDetailModel : NSObject
//流水明细标题
@property (nonatomic, copy)NSString *title;
//房源的地址
@property (nonatomic, copy)NSString *adress;
//支付方式
@property (nonatomic, copy)NSString *paytype;
//交易时间
@property (nonatomic, copy)NSString *paytime;
//交易金额
@property (nonatomic, copy)NSString *orderAmount;
//列表
@property (nonatomic, copy)NSArray *orderDetailDTOList;
@end


@interface orderDetailDTOListModel : NSObject
//详细明细金额
@property (nonatomic, copy)NSString *financeAmount;
//费用名称
@property (nonatomic, copy)NSString *costname;

@end

NS_ASSUME_NONNULL_END
