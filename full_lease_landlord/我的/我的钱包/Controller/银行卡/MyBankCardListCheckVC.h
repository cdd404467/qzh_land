//
//  MyBankCardListCheckVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyBankCardListCheckVC : BaseViewController
@property (nonatomic, copy)NSString *idCardNum;
@property (nonatomic, copy)NSString *phoneNum;
@property (nonatomic, copy)NSArray *dataSource;
@end

NS_ASSUME_NONNULL_END
