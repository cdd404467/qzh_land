//
//  PayPasswordVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/10.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayPasswordVC : BaseViewController
/**
 1-添加银行卡输入密码
 2-修改支付密码验证原密码
 3-修改支付密码输入新密码
 4-修改支付密码再次确认新密码
 5-设置支付密码输入新密码
 6-设置支付密码再次确认新密码
 7-忘记密码输入新密码
 8-忘记密码再次确认新密码
 **/
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, copy)NSString *bankCardNum;
@property (nonatomic, copy)NSString *phoneNum;
@property (nonatomic, copy)NSString *idCardNum;
//设置新密码接收的参数
@property (nonatomic, copy)NSString *password_new;
@property (nonatomic, copy)NSString *password_old;
@end

NS_ASSUME_NONNULL_END
