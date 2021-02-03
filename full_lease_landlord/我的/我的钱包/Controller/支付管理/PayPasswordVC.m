//
//  PayPasswordVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/10.
//  Copyright © 2020 apple. All rights reserved.
//

#import "PayPasswordVC.h"
#import <JhtVerificationCodeView/JhtVerificationCodeView.h>
#import "AddBankCardNumberVC.h"
#import "AlertSystem.h"
#import "MutableCellModel.h"

@interface PayPasswordVC ()
@property (nonatomic, strong)JhtVerificationCodeView *codeView;
@property (nonatomic, strong)UILabel *tipLab;
@property (nonatomic, copy)NSString *password;
@end

@implementation PayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = [self getTitle];
    self.view.backgroundColor = HEXColor(@"#FAFAFA", 1);
    [self setupUI];
    
    if (_type == 2) {
        [self.navBar.leftBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.navBar.leftBtn addTarget:self action:@selector(alertAsk) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_type == 2) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    [_codeView Jht_BecomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
//    [_codeView Jht_BecomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_type == 2) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    [_codeView Jht_ResignFirstResponder];
}

- (void)setupUI {
    _tipLab = [[UILabel alloc] init];
    _tipLab.text = [self getTips];
    _tipLab.textColor = HEXColor(@"#333333", 1);
    _tipLab.font = kFont(15);
    [self.view addSubview:_tipLab];
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(NAV_HEIGHT + KFit_H(40));
        make.height.mas_equalTo(21);
    }];
    
    _codeView = [[JhtVerificationCodeView alloc] initWithFrame:CGRectMake(KFit_W(47), NAV_HEIGHT + KFit_H(106), SCREEN_WIDTH - KFit_W(47) * 2, KFit_W(47))];
    _codeView.hasBoder = YES;
//    _codeView.isClearWhenInputFull = YES;
    _codeView.layer.cornerRadius = 4.f;
    _codeView.boderColor = HEXColor(@"#cccccc", 1);
    _codeView.codeViewType = VerificationCodeViewType_Secret;
    DDWeakSelf;
    _codeView.editBlcok = ^(NSString *text) {
        weakself.password = text;
        if (text.length == 6) {
            [weakself inputPassWord];
        }
    };
    [self.view addSubview:_codeView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.layer.cornerRadius = 4.f;
    submitBtn.hidden = YES;
    [submitBtn setBtnWithTitle:@"完成" titleColor:UIColor.whiteColor font:KFit_W(18)];
    submitBtn.backgroundColor = MainColor;
    [submitBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeView.mas_bottom).offset(KFit_H(45));
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.height.mas_equalTo(49);
    }];
    if (_type == 4 || _type == 6 || _type == 8) {
        submitBtn.hidden = NO;
    }
}

- (void)complete {
    [self.view endEditing:YES];
    if (_type == 4) {
        if ([_password isEqualToString:_password_new]) {
            [self changePassWord];
        } else {
            [AlertSystem alertOne:@"两次密码输入不一样" msg:nil okBtn:@"确定" OKCallBack:nil];
        }
    } else if (_type == 6 || _type == 8) {
        if ([_password isEqualToString:_password_new]) {
            [self setupPassWord];
        } else {
            [AlertSystem alertOne:@"两次密码输入不一样" msg:nil okBtn:@"确定" OKCallBack:nil];
        }
    }
}

//设置密码后提交
- (void)setupPassWord {
    [CddHud show:self.view];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mDict setValue:self.phoneNum forKey:@"userPhone"];
    [mDict setValue:self.idCardNum forKey:@"document"];
    [mDict setValue:self.password forKey:@"paymentCode"];
    if (_bankCardNum) {
        [mDict setValue:self.bankCardNum forKey:@"account"];
    }
    DDWeakSelf;
    [NetTool postRequest:URLPost_Set_Password Params:mDict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            NSMutableDictionary *mdict = [User_Info mutableCopy];
            [mdict setValue:@"1" forKey:@"isSetPW"];
            [UserDefault setObject:[mdict copy] forKey:@"userInfo"];
            [CddHud showTextOnly:@"密码设置成功" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *vcArr = weakself.navigationController.viewControllers;
                if (weakself.type == 6) {
                    [weakself.navigationController popToViewController:vcArr[1] animated:YES];
                } else if (weakself.type == 8) {
                    [weakself.navigationController popToViewController:vcArr[2] animated:YES];
                }
            });
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}


- (void)changePassWord {
    NSDictionary *dict = @{@"leftPaymentCode":self.password_old,
                           @"rightPaymentCode":self.password_new
    };
    DDWeakSelf;
    [NetTool postRequest:URLPost_Change_Password Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [CddHud showTextOnly:@"密码修改成功" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakself.type == 4) {
                    NSArray *vcArr = weakself.navigationController.viewControllers;
                    [weakself.navigationController popToViewController:vcArr[vcArr.count - 4] animated:YES];
                }
            });
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)alertAsk {
    [AlertSystem alertTwo:@"是否放弃修改支付密码？" msg:nil cancelBtn:@"否" okBtn:@"是"  OKCallBack:^{
        [self.navigationController popViewControllerAnimated:YES];
    } cancelCallBack:nil];
}

- (NSString *)getTitle {
    NSString *title = [NSString string];
    if (_type == 0) {
        title = @"无效页面";
    } else if (_type == 1) {
        title = @"添加银行卡";
    } else if (_type == 2 || _type == 3 || _type == 4) {
        title = @"修改支付密码";
    } else if (_type == 5 || _type == 6) {
        title = @"设置支付密码";
    } else if (_type == 7 || _type == 8) {
        title = @"重置支付密码";
    }
    return title;
}

- (NSString *)getTips {
    NSString *tips = [NSString string];
    if (_type == 1 || _type == 2) {
        tips = @"请输入支付密码，以验证身份";
    } else if (_type == 3 || _type == 5 || _type == 7) {
        tips = @"请设置支付密码，用于支付验证";
    } else if (_type == 4 || _type == 6 || _type == 8) {
        tips = @"请再次输入密码以确认";
    }
    
    return tips;
}
//[self.codeView changeAllAlreadyInputTextColor:UIColor.orangeColor hasShakeAndClear:NO];
//[CddHud showTextOnly:@"密码输入错误" view:self.view];
- (void)inputPassWord {
    if (_type == 1) {
        if (Check_PayPW(self.password)) {
            AddBankCardNumberVC *vc = [[AddBankCardNumberVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            NSMutableArray *vcArr = [self.navigationController.viewControllers mutableCopy];
            [vcArr removeObject:self];
            self.navigationController.viewControllers = [vcArr copy];
        }
    } else if (_type == 2) {
        if (Check_PayPW(self.password)) {
            PayPasswordVC *vc = [[PayPasswordVC alloc] init];
            vc.type = 3;
            vc.password_old = self.password;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (_type == 3) {
        PayPasswordVC *vc = [[PayPasswordVC alloc] init];
        vc.type = 4;
        vc.password_new = self.password;
        vc.password_old = self.password_old;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_type == 5) {
        PayPasswordVC *vc = [[PayPasswordVC alloc] init];
        vc.type = 6;
        vc.password_new = self.password;
        vc.idCardNum = self.idCardNum;
        vc.phoneNum = self.phoneNum;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (_type == 7) {
        PayPasswordVC *vc = [[PayPasswordVC alloc] init];
        vc.type = 8;
        vc.password_new = self.password;
        vc.idCardNum = self.idCardNum;
        vc.phoneNum = self.phoneNum;
        vc.bankCardNum = self.bankCardNum;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
