//
//  LoginVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LoginCompleteBlock)(void);
@interface LoginVC : BaseViewController
//登陆成功后的回调
@property (nonatomic, copy , nullable) LoginCompleteBlock loginCompleteBlock;
@end

NS_ASSUME_NONNULL_END
