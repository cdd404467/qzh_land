//
//  HouseInfoModel.h
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseInfoModel : NSObject

//房源ID
@property (nonatomic, copy)NSString *houseId;
//房源状态 空置中，已出租，维修中，锁定中
@property (nonatomic, copy)NSString *statusStr;
//地址
@property (nonatomic, copy)NSString *specificAddress;
//状态
@property (nonatomic, assign)int status;
//展示价格
@property (nonatomic, copy)NSString *finalAmount;
@property (nonatomic, copy)NSString *price;
//空置天数
@property (nonatomic, copy)NSString *vacantDays;
//租客姓名
@property (nonatomic, copy)NSString *tenantName;
//租客电话
@property (nonatomic, copy)NSString *tenantPhone;


//业务状态 有欠款，待收款，逾期未退房
@property (nonatomic, copy)NSArray *contractBillStatusDesc;
//月租金最高涨幅描述 固定金额就是固定金额，是按照比例就是 XX%
@property (nonatomic, copy)NSString *higHestincreaseStr;

/* 详情里面的字段 */
//地址
@property (nonatomic, copy)NSString *adress;
//图片数组
@property (nonatomic, copy)NSArray *publicimgList;
//户型
@property (nonatomic, copy)NSString *hallDesc;
//面积
@property (nonatomic, copy)NSString *measure;
//朝向
@property (nonatomic, copy)NSString *orientation;
//楼层
@property (nonatomic, copy)NSString *floorDesc;
//公共区域设备
@property (nonatomic, copy)NSString *publicpeibei;
//房屋特色
@property (nonatomic, copy)NSString *publicteshe;
//房屋描述
@property (nonatomic, copy)NSString *houseDesc;
//管家头像
@property (nonatomic, copy)NSString *keeperAvatar;
//管家手机号
@property (nonatomic, copy)NSString *keeperMobile;
//管家真实姓名
@property (nonatomic, copy)NSString *keeperRealName;
//合同id
@property (nonatomic, copy)NSString *townContractId;
//1是托管，2是包租
@property (nonatomic, assign)NSInteger type;
@end


@interface TagsViewModel : NSObject
//字体颜色
@property (nonatomic, copy)NSString *typeface;
//背景颜色
@property (nonatomic, copy)NSString *background;
//内容
@property (nonatomic, copy)NSString *content;
@end

NS_ASSUME_NONNULL_END
