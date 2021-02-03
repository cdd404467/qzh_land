//
//  SignConfirmVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "ZukeConModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RefuseSuccess)(void);
@interface SignConfirmVC : BaseViewController
@property (nonatomic, strong)ZukeConModel *model;
@property (nonatomic, copy)RefuseSuccess refuseSuccess;
@end

NS_ASSUME_NONNULL_END
