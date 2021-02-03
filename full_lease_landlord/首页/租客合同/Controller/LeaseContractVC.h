//
//  LeaseContractVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeaseContractVC : BaseViewController
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, copy)NSString *houseID;
@end

NS_ASSUME_NONNULL_END
