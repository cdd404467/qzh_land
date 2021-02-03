//
//  LockOnlyOnePasswordViewController.h
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "BaseViewController.h"

#import "DoorLockNumberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LockOnlyOnePasswordViewController : BaseViewController

@property (nonatomic, strong) DoorLockNumberModel *oneTimeModel;

@end

NS_ASSUME_NONNULL_END
