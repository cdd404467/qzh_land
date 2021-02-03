//
//  DecorateContactOnlineVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/12/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import "DecorateContactOnlineVC.h"
#import "UITextField+Limit.h"
#import "CountDown.h"


@interface DecorateContactOnlineVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *nameTF;
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *codeTF;
@property (nonatomic, strong)UIButton *codeBtn;
@end

@implementation DecorateContactOnlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"在线联系";
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(_scrollView.width, _scrollView.height);
    }
    return _scrollView;
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    NSArray *titleArr = @[@"姓名",@"联系电话",@"验证码"];
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 35 + (38 + 20) * i, 100, 20)];
        txtLab.textColor = HEXColor(@"#333333", 1);
        txtLab.text = titleArr[i];
        txtLab.font = kFont(14);
        [self.scrollView addSubview:txtLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, txtLab.bottom + 19, SCREEN_WIDTH - 32, 0.5)];
        line.backgroundColor = HEXColor(@"#eeeeee", 1);
        [self.scrollView addSubview:line];
    }
    
    UITextField *nameTF = [[UITextField alloc] init];
    nameTF.font = kFont(14);
    nameTF.textAlignment = NSTextAlignmentRight;
    nameTF.placeholder = @"请输入您的姓名";
    [self.scrollView addSubview:nameTF];
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(130);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(35);
    }];
    _nameTF = nameTF;
    
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.font = kFont(14);
    phoneTF.textAlignment = NSTextAlignmentRight;
    phoneTF.placeholder = @"请输入您的联系电话";
    phoneTF.maxLength = 11;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(nameTF);
        make.top.mas_equalTo(nameTF.mas_bottom).offset(38);
    }];
    _phoneTF = phoneTF;
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.backgroundColor = MainColor;
    [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    codeBtn.layer.cornerRadius = 2.f;
    [codeBtn addTarget:self action:@selector(getSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(phoneTF);
        make.width.mas_equalTo(75);
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(34);
        make.height.mas_equalTo(28);
    }];
    _codeBtn = codeBtn;
    
    UITextField *codeTF = [[UITextField alloc] init];
    codeTF.font = kFont(14);
    codeTF.maxLength = 6;
    codeTF.textAlignment = NSTextAlignmentRight;
    codeTF.placeholder = @"请输入验证码";
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView addSubview:codeTF];
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneTF);
        make.right.mas_equalTo(codeBtn.mas_left).offset(-25);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(codeBtn);
    }];
    _codeTF = codeTF;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(checSMSkCodeAndSubmit) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = MainColor;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kFont(18);
    submitBtn.layer.cornerRadius = 4.f;
    [self.scrollView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KFit_H(106) - Bottom_Height_Dif);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(49);
    }];
}

//获取验证码
- (void)getSMSCode {
    [self.view endEditing:YES];
    if (_phoneTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入手机号" view:self.view];
        return;
    } else if (_phoneTF.text.length < 11) {
        [CddHud showTextOnly:@"请输入正确的手机号" view:self.view];
        return;
    }
    
    NSDictionary *dict = @{@"userPhone":_phoneTF.text,
                           @"status":@10,
                           @"userType":@1
    };
    [NetTool postRequest:URLPost_OtherSMS_Code Params:dict Success:^(id  _Nonnull json) {
        NSLog(@"--- %@",json);
        if (JsonCode == 200) {
            [self countDown];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

//校验验证码
- (void)checSMSkCodeAndSubmit {
    if (_nameTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入姓名" view:self.view];
        return;
    } else if (_phoneTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入手机号" view:self.view];
        return;
    } else if (_phoneTF.text.length < 11) {
        [CddHud showTextOnly:@"请输入正确的手机号" view:self.view];
        return;
    } else if (_codeTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入验证码" view:self.view];
        return;
    }
    
    NSDictionary *dict = @{@"userPhone":_phoneTF.text,
                           @"status":@10,
                           @"SMSCode":_codeTF.text,
                           @"name":_nameTF.text
    };
    DDWeakSelf;
    [NetTool postRequest:URLPost_OtherSMS_Check Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [CddHud showTextOnly:@"提交成功" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark 倒计时
-(void)countDown {
   DDWeakSelf;
   NSTimeInterval aMinutes = 60;
   NSDate *finishDate = [NSDate dateWithTimeIntervalSinceNow:aMinutes];
   CountDown *countDown = [[CountDown alloc] init];
   [countDown countDownWithStratDate:[NSDate date] finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
       if (second == 0) {
           weakself.codeBtn.enabled = YES;
           [weakself.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
       }else{
           weakself.codeBtn.enabled = NO;
           [weakself.codeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)second] forState:UIControlStateNormal];
       }
   }];
}
@end
