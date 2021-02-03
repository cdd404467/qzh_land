//
//  WithdrawalVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WithdrawalVC.h"
#import "UITextField+Limit.h"
#import "BankCardModel.h"
#import "SelectBankCardView.h"
#import "InputPasswordAlertView.h"
#import "WithdrawalRecordVC.h"
#import "PayPasswordVC.h"

@interface WithdrawalVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UILabel *bankCardLab;
@property (nonatomic, strong)UITextField *moneyTF;
@property (nonatomic, strong)UILabel *tipLab;
@property (nonatomic, copy)NSString *minMoney;
@property (nonatomic, copy)NSString *timeToAccount;
@property (nonatomic, copy)NSArray<BankCardModel *> *dataSource;
@property (nonatomic, copy)NSString *errorStr;
@property (nonatomic, assign)NSInteger selectBankIndex;
@property (nonatomic, strong)InputPasswordAlertView *passView;
@end

@implementation WithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"提现";
    [self setupUI];
    [self setupNav];
    [self requestTixianSet];
}

- (void)setupNav {
    self.navBar.rightBtn.hidden = NO;
    [self.navBar.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.centerY.mas_equalTo(self.navBar.leftBtn);
    }];
    [self.navBar.rightBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [self.navBar.rightBtn addTarget:self action:@selector(jumoToRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.rightBtn.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_moneyTF becomeFirstResponder];
}

- (void)jumoToRecord {
    WithdrawalRecordVC *vc = [[WithdrawalRecordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    scrollView.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [self.view addSubview:scrollView];
 
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 350)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.shadowColor = RGBA(0, 0, 0, 0.08).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.layer.shadowOpacity = 1.0f;
    bgView.layer.cornerRadius = 4;
    [scrollView addSubview:bgView];
    
    UIView *bankCardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.width, 65)];
    [HelperTool addTapGesture:bankCardView withTarget:self andSEL:@selector(requestList)];
    [bgView addSubview:bankCardView];
    
    UILabel *cardTxtLab = [[UILabel alloc] init];
    cardTxtLab.text = @"到账银行卡";
    cardTxtLab.textColor = HEXColor(@"#333333", 1);
    cardTxtLab.font = [UIFont systemFontOfSize:14];
    [cardTxtLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [bankCardView addSubview:cardTxtLab];
    [cardTxtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        make.centerY.mas_equalTo(bankCardView);
    }];
    
    UIImageView *rightArrow = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"arrow_right"];
    rightArrow.image = [image imageWithChangeTintColor:HEXColor(@"#333333", 1)];
    [bankCardView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-21);
        make.width.mas_equalTo(9);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(bankCardView);
    }];
    
    UILabel *bankCardLab = [[UILabel alloc] init];
    bankCardLab.textColor = HEXColor(@"#333333", 1);
    bankCardLab.font = [UIFont systemFontOfSize:14];
    [bankCardView addSubview:bankCardLab];
    [bankCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cardTxtLab.mas_right).offset(25);
        make.right.mas_equalTo(rightArrow.mas_left).offset(-3);
        make.centerY.mas_equalTo(bankCardView);
    }];
    _bankCardLab = bankCardLab;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bankCardView.height - 0.5, bankCardView.width, 0.5)];
    line.backgroundColor = HEXColor(@"#EEEEEE", 1);
    [bankCardView addSubview:line];
    
    UILabel *tixianLab = [[UILabel alloc] init];
    tixianLab.text = @"提现金额";
    tixianLab.textColor = HEXColor(@"#333333", 1);
    tixianLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:tixianLab];
    [tixianLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(21);
        make.top.mas_equalTo(bankCardView.mas_bottom).offset(28);
    }];
    
    UILabel *iconMoney = [[UILabel alloc] init];
    iconMoney.text = @"¥";
    iconMoney.font = [UIFont boldSystemFontOfSize:30];
    [iconMoney setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [bgView addSubview:iconMoney];
    [iconMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tixianLab);
        make.height.mas_equalTo(32);
        make.top.mas_equalTo(tixianLab.mas_bottom).offset(10);
    }];
    
    UITextField *moneyTF = [[UITextField alloc] init];
    moneyTF.delegate = self;
    moneyTF.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
    NSString *holderText = @"请输入提现金额";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, holderText.length)];
    moneyTF.attributedPlaceholder = placeholder;
    moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTF.tintColor = MainColor;
    [bgView addSubview:moneyTF];
    [moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconMoney.mas_right).offset(12);
        make.height.mas_equalTo(32);
        make.right.mas_equalTo(KFit_W(-90));
        make.centerY.mas_equalTo(iconMoney);
    }];
    _moneyTF = moneyTF;
    
    UIButton *allMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allMoneyBtn setBtnWithTitle:@"全部提现" titleColor:MainColor font:13];
    [allMoneyBtn addTarget:self action:@selector(withdrawalAllMoney) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:allMoneyBtn];
    [allMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-21);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(KFit_W(60));
        make.centerY.mas_equalTo(iconMoney);
    }];
    
    UIView *line_bot = [[UIView alloc] init];
    line_bot.backgroundColor = HEXColor(@"#BBBABB", 1);
    [bgView addSubview:line_bot];
    [line_bot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tixianLab);
        make.right.mas_equalTo(-21);
        make.top.mas_equalTo(iconMoney.mas_bottom).offset(13);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.numberOfLines = 3;
    tipLab.text = [NSString stringWithFormat:@"当前余额%@元",self.maxMoney];
    tipLab.textColor = HEXColor(@"#999999", 1);
    tipLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(line_bot);
        make.top.mas_equalTo(line_bot.mas_bottom).offset(12);
    }];
    _tipLab = tipLab;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.layer.cornerRadius = 4.f;
    [submitBtn setBtnWithTitle:@"提现" titleColor:UIColor.whiteColor font:KFit_W(18)];
    submitBtn.backgroundColor = MainColor;
    [submitBtn addTarget:self action:@selector(checkPassword) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_bot.mas_bottom).offset(80);
        make.left.mas_equalTo(line_bot);
        make.right.mas_equalTo(line_bot);
        make.height.mas_equalTo(49);
    }];
}

- (void)selectBankCard {
    DDWeakSelf;
    SelectBankCardView *view = [[SelectBankCardView alloc] initWithDataSource:self.dataSource completion:^(NSInteger index) {
        if (index >= 0) {
            weakself.selectBankIndex = index;
            BankCardModel *model = weakself.dataSource[index];
            weakself.bankCardLab.text = [NSString stringWithFormat:@"%@ (%@)",model.bankname,model.account];
        } else {
            PayPasswordVC *vc = [[PayPasswordVC alloc] init];
            vc.type = 1;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    } cancel:nil];
    [view show];
}

- (void)withdrawalAllMoney {
    self.moneyTF.text = self.maxMoney;
}

- (void)inputPassword {
    DDWeakSelf;
    
    self.passView = [[InputPasswordAlertView alloc] initWithMoney:self.moneyTF.text completion:^(NSString * _Nonnull password) {
        [weakself submitWithPassword:password];
    } cancel:nil];
    
    [self.passView show];
}

- (void)requestList {
    [self.view endEditing:YES];
    NSDictionary *dict = @{@"userid":User_Id};
    [CddHud show:self.view];
    [NetTool postRequest:URLPost_MyBankCard_List Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            self.dataSource = [BankCardModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (self.dataSource.count == 0) {
                [CddHud showTextOnly:@"你还没有添加银行卡" view:self.view];
                return;
            }
            for (BankCardModel *model in self.dataSource) {
                model.timeToAccount = self.timeToAccount;
            }
            [self selectBankCard];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)checkPassword {
    [self.view endEditing:YES];
    if (self.bankCardLab.text == 0) {
        [CddHud showTextOnly:@"请选择到账银行卡" view:self.view];
        return;
    } else if (self.moneyTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入提现金额" view:self.view];
        return;
    } else if ([self.moneyTF.text isEqualToString:@"0"] || [self.moneyTF.text isEqualToString:@"0."]) {
        [CddHud showTextOnly:@"提现金额不能为0" view:self.view];
        return;
    } else if (_errorStr || _errorStr.length > 0) {
        [CddHud showTextOnly:_errorStr view:self.view];
        return;
    }
    
    [self inputPassword];
}

- (void)submitWithPassword:(NSString *)password {
    [self.passView endEditing:YES];
    [CddHud show:self.passView];
    NSDictionary *dict = @{@"bankid":[self.dataSource[_selectBankIndex] bankCardID],
                           @"userid":User_Id,
                           @"amount":self.moneyTF.text,
                           @"PayMentPassword":password
    };
    DDWeakSelf;
    [NetTool postRequest:URLPost_withdraw Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.passView];
        [self.passView removeViews];
        if (JsonCode == 200) {
            if ([json[@"data"][@"responseCode"] integerValue] == 1001) {
                [CddHud showTextOnly:@"提现成功" view:self.view];
                if (self.successBlock) {
                    self.successBlock();
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [CddHud showTextOnly:json[@"data"][@"responseMsg"] view:self.view];
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestTixianSet {
    [NetTool postRequest:URLPost_Tixian_SystemSet Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            @try {
                self.timeToAccount = json[@"data"][@"paymentdatestr"];
                self.minMoney = json[@"data"][@"minwithdrawalamount"];
                self.tipLab.text = [NSString stringWithFormat:@"当前余额%@元(最低提现金额%@元)",self.maxMoney,self.minMoney];
            } @catch (NSException *exception) {

            }
        }
    
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL isHaveDian;
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    } else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.')) {
            return NO;
        }
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
            //            [MBProgressHUD bwm_showTitle:@"最多只能输入一个小数点" toView:self hideAfter:1.0];
            return NO;
        }
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            } else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length >= 2) {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    self.errorStr = nil;
    if (textField.text.length > 0) {
        self.tipLab.text = [NSString stringWithFormat:@"当前余额%@元(最低提现金额%@元)\n%@",self.maxMoney,self.minMoney,self.timeToAccount];
        self.tipLab.textColor = HEXColor(@"#999999", 1);
        if (textField.text.doubleValue > self.maxMoney.doubleValue) {
            self.tipLab.textColor = HEXColor(@"#FA6565", 1);
            self.tipLab.text = @"输入金额超过余额";
            self.errorStr = @"输入金额超过余额";
        }
        else if (textField.text.doubleValue < self.minMoney.doubleValue) {
            self.tipLab.textColor = HEXColor(@"#FA6565", 1);
            self.tipLab.text = @"输入金额小于最小提现金额";
            self.errorStr = @"输入金额小于最小提现金额";
        }
    }
    else {
        self.tipLab.text = [NSString stringWithFormat:@"当前余额%@元(最低提现金额%@元)",self.maxMoney,self.minMoney];
        self.tipLab.textColor = HEXColor(@"#999999", 1);
    }
}

@end
