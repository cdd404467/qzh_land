//
//  CheckPayPasswordVC.m
//  full_lease_landlord
//
//  Created by apple on 2021/2/1.
//  Copyright © 2021 apple. All rights reserved.
//

#import "CheckPayPasswordVC.h"
#import <JhtVerificationCodeView/JhtVerificationCodeView.h>

@interface CheckPayPasswordVC ()
@property (nonatomic, strong)JhtVerificationCodeView *codeView;
@property (nonatomic, strong)UILabel *tipLab;
@property (nonatomic, copy)NSString *password;
@end

@implementation CheckPayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"验证密码";
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [_codeView Jht_BecomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [_codeView Jht_ResignFirstResponder];
}


- (void)setupUI {
    _tipLab = [[UILabel alloc] init];
    _tipLab.text = @"请输入支付密码，以验证身份";
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
}

- (void)inputPassWord {
    if (Check_PayPW(self.password)) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.checkRightBlock) {
            self.checkRightBlock();
        }
    }
}
@end
