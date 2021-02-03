//
//  CheckBankCardNumVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import "CheckBankCardNumVC.h"
#import "PayPasswordVC.h"

@interface CheckBankCardNumVC ()
@property (nonatomic, strong)UITextField *cardTF;
@end

@implementation CheckBankCardNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"填写银行卡信息";
    self.view.backgroundColor = HEXColor(@"#FAFAFA", 1);
    [self setupUI];
}

- (void)setupUI {
    UILabel *txtLab = [[UILabel alloc] init];
    txtLab.text = @"请补充完整卡号进行验证";
    txtLab.font = kFont(14);
    txtLab.textColor = HEXColor(@"#999999", 1);
    [self.view addSubview:txtLab];
    [txtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(NAV_HEIGHT + KFit_H(20));
        make.right.mas_equalTo(-15);
    }];
    
    UIView *line_top = [[UIView alloc] init];
    line_top.backgroundColor = HEXColor(@"#EEEEEE", 1);
    [self.view addSubview:line_top];
    [line_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(txtLab);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(txtLab.mas_bottom).offset(KFit_H(20));
    }];
    
    UILabel *cardLab = [[UILabel alloc] init];
    cardLab.text = @"卡号";
    cardLab.font = kFont(14);
    [cardLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    cardLab.textColor = HEXColor(@"#333333", 1);
    [self.view addSubview:cardLab];
    [cardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(txtLab);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(line_top.mas_bottom).offset(20);
    }];
    
    _cardTF = [[UITextField alloc] init];
    _cardTF.font = [UIFont systemFontOfSize:14];
    _cardTF.keyboardType = UIKeyboardTypeNumberPad;
    _cardTF.placeholder = [NSString stringWithFormat:@"******%@(请输入完整卡号)",_lastFourNum];
    [self.view addSubview:_cardTF];
    [_cardTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cardLab.mas_right).offset(30);
        make.right.mas_equalTo(line_top);
        make.height.mas_equalTo(22);
        make.centerY.mas_equalTo(cardLab);
    }];
    
    UIView *line_bot = [[UIView alloc] init];
    line_bot.backgroundColor = HEXColor(@"#EEEEEE", 1);
    [self.view addSubview:line_bot];
    [line_bot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(txtLab);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(cardLab.mas_bottom).offset(20);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.layer.cornerRadius = 4.f;
    [nextBtn setBtnWithTitle:@"下一步" titleColor:UIColor.whiteColor font:KFit_W(18)];
    nextBtn.backgroundColor = MainColor;
    [nextBtn addTarget:self action:@selector(checkBankCard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line_bot.mas_bottom).offset(240);
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.height.mas_equalTo(49);
    }];
}

- (void)checkBankCard {
    [self.view endEditing:YES];
    if (self.cardTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入银行卡号" view:self.view];
        return;
    }
    [CddHud show:self.view];
    NSDictionary *dict = @{@"account":self.cardTF.text,
                           @"id":self.bankCardID
    };
    [NetTool postRequest:URLPost_Check_Bankcard Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            if ([json[@"data"][@"result"] integerValue]) {
                PayPasswordVC *vc = [[PayPasswordVC alloc] init];
                vc.type = 7;
                vc.bankCardNum = self.cardTF.text;
                vc.idCardNum = self.idCardNum;
                vc.phoneNum = self.phoneNum;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [CddHud showTextOnly:@"银行卡验证错误" view:self.view];
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}



@end
