//
//  UpdateDoorLockVC.h
//  FullLease
//
//  Created by wz on 2020/11/23.
//  Copyright © 2020 kad. All rights reserved.
//

#import "BaseViewController.h"
#import "DoorLockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpdateDoorLockVC : BaseViewController


@property (nonatomic,strong) NSMutableArray<DoorLockModel *> *models;

@property (nonatomic,assign) NSInteger curIndex;

@property (nonatomic,strong) NSMutableArray *titles;

@property (nonatomic,strong) NSString *contractId;

@end

NS_ASSUME_NONNULL_END
