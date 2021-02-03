//
//  BankSelectVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/11.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectBlock)(NSString *bankName);

@interface BankSelectVC : BaseViewController
@property (nonatomic, copy)SelectBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
