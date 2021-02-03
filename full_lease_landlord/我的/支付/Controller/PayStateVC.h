//
//  PayStateVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/25.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayStateVC : BaseViewController
//账单编号
@property (nonatomic, copy)NSString *orderID;
//账单id
@property (nonatomic, copy)NSString *billID;
@end

NS_ASSUME_NONNULL_END
