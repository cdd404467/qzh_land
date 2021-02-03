//
//  AddBankCardNumberVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/9.
//  Copyright © 2020 apple. All rights reserved.
//

#import "AddBankCardNumberVC.h"
#import "AddBankCardVC.h"
#if !TARGET_IPHONE_SIMULATOR
#import <AipOcrSdk/AipOcrSdk.h>
#endif

typedef void(^SuccessHandler)(id);
typedef void(^FailHandler)(NSError *);
@interface AddBankCardNumberVC ()
@property (nonatomic, strong)UITextField *bankNumTF;
@end

@implementation AddBankCardNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"绑定银行卡";
    self.view.backgroundColor = HEXColor(@"#FAFAFA", 1);
    [self setupUI];
}

- (void)setupUI {
    UILabel *bankNumTxt = [[UILabel alloc] init];
    bankNumTxt.text = @"银行卡号";
    bankNumTxt.font = [UIFont systemFontOfSize:14];
    bankNumTxt.textColor = HEXColor(@"#333333", 1);
    [bankNumTxt setContentHuggingPriority:UILayoutPriorityRequired
                                    forAxis:UILayoutConstraintAxisHorizontal];
    [self.view addSubview:bankNumTxt];
    [bankNumTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(NAV_HEIGHT + 30);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoBtn setBtnWithTitle:@"拍照取卡" titleColor:HEXColor(@"#333333", 1) font:10];
    [photoBtn setImage:[UIImage imageNamed:@"take_photo_icon"] forState:UIControlStateNormal];
    [photoBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:3];
    [photoBtn addTarget:self action:@selector(getBankCardNumWithCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(bankNumTxt);
    }];
    
    UITextField *bankNumTF = [[UITextField alloc] init];
    bankNumTF.placeholder = @"请输入银行卡号";
    bankNumTF.font = [UIFont systemFontOfSize:14];
    bankNumTF.textColor = HEXColor(@"#333333", 1);
    bankNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:bankNumTF];
    [bankNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankNumTxt.mas_right).offset(40);
        make.centerY.mas_equalTo(bankNumTxt);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(photoBtn.mas_left).offset(-5);
    }];
    _bankNumTF = bankNumTF;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = Cell_Line_Color;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(bankNumTxt.mas_bottom).offset(14);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *expLab = [[UILabel alloc] init];
    expLab.text = @"为了您的账户安全，请添加本人银行储蓄卡。";
    expLab.font = [UIFont systemFontOfSize:11];
    expLab.textColor = HEXColor(@"#999999", 1);
    [self.view addSubview:expLab];
    [expLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(line);
        make.top.mas_equalTo(line.mas_bottom).offset(17);
        make.height.mas_equalTo(15);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.layer.cornerRadius = 4.f;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = kFont(18);
    [nextBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    nextBtn.backgroundColor = MainColor;
    [nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(expLab.mas_bottom).offset(80);
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.height.mas_equalTo(49);
    }];
}

- (void)getBankCardNumWithCamera {
#if !TARGET_IPHONE_SIMULATOR
    DDWeakSelf;
    UIViewController *vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard andImageHandler:^(UIImage *image) {
        [[AipOcrService shardService] detectBankCardFromImage:image successHandler:^(id result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.bankNumTF.text = result[@"result"][@"bank_card_number"];
                [weakself dismissViewControllerAnimated:YES completion:nil];
            });
        } failHandler:^(NSError *err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [weakself dismissViewControllerAnimated:YES completion:nil];
                [CddHud showTextOnly:@"识别失败，请重试！" view:weakself.view];
                return;
            });
        }];
    }];
    
    vc.modalPresentationStyle =  UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
#endif
}

- (void)nextStep {
    if (_bankNumTF.text.length < 4) {
        [CddHud showTextOnly:@"请输入正确的银行卡号" view:self.view];
        return;
    }
    AddBankCardVC *vc = [[AddBankCardVC alloc] init];
    vc.bankCardNum = _bankNumTF.text;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
