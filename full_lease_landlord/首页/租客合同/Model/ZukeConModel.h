//
//  ZukeConModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContractModel.h"
#import "ZukeModel.h"


@class ZukeConHouseinfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface ZukeConModel : NSObject
//合同model
@property (nonatomic, strong)ContractModel *contract;
//租客信息
@property (nonatomic, strong)ZukeModel *tenant;
//房源id
@property (nonatomic, copy)NSString *houseid;
//房源信息
@property (nonatomic, strong)ZukeConHouseinfoModel *houseinfo;

@end

@interface ZukeConHouseinfoModel : NSObject
//房源详细描述
@property (nonatomic, copy)NSString *accurate;
//小区名字
@property (nonatomic, copy)NSString *estateName;
//几居室
@property (nonatomic, copy)NSString *houseType;
@end


NS_ASSUME_NONNULL_END
