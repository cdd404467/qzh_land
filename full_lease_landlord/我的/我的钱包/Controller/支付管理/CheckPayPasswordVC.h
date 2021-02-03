//
//  CheckPayPasswordVC.h
//  full_lease_landlord
//
//  Created by apple on 2021/2/1.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CheckRightBlock)(void);
@interface CheckPayPasswordVC : BaseViewController
@property (nonatomic, copy)CheckRightBlock checkRightBlock;
@end

NS_ASSUME_NONNULL_END
