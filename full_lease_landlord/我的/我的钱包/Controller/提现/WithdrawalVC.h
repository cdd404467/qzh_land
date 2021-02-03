//
//  WithdrawalVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessBlock)(void);
@interface WithdrawalVC : BaseViewController
@property (nonatomic, copy)NSString *maxMoney;
@property (nonatomic, copy)SuccessBlock successBlock;
@end

NS_ASSUME_NONNULL_END
