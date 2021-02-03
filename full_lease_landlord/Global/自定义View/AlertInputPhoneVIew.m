//
//  AlertInputPhoneVIew.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import "AlertInputPhoneVIew.h"
#import "UITextField+Limit.h"

static CGFloat aniTime = 0.4f;

@interface AlertInputPhoneVIew()
@property (nonatomic, strong)UILabel *phoneLab;
@end

@implementation AlertInputPhoneVIew
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.frame = SCREEN_BOUNDS;
    CGFloat width = SCREEN_WIDTH - 35 * 2;
    CGFloat height = 250.f;
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(35, 0, width, height)];
    alertView.layer.cornerRadius = 5.f;
    alertView.clipsToBounds = YES;
    alertView.backgroundColor = UIColor.whiteColor;
    [self addSubview:alertView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"验证手机号";
    titleLab.textColor = HEXColor(@"#333333", 1);
    titleLab.font = [UIFont systemFontOfSize:18];
    [alertView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-40);
    }];

    UILabel *subTitleLab = [[UILabel alloc] init];
    subTitleLab.text = @"已发送短信验证码到手机";
    subTitleLab.textColor = HEXColor(@"#565656", 1);
    subTitleLab.font = [UIFont systemFontOfSize:12];
    [alertView addSubview:subTitleLab];
    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(13);
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(titleLab);
        make.right.mas_equalTo(titleLab);
    }];

    UILabel *phoneLab = [[UILabel alloc] init];
    phoneLab.textColor = HEXColor(@"#333333", 1);
    phoneLab.font = [UIFont systemFontOfSize:18];
    [alertView addSubview:phoneLab];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subTitleLab.mas_bottom).offset(4);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(titleLab);
        make.right.mas_equalTo(titleLab);
    }];
    _phoneLab = phoneLab;

    UITextField *codeTF = [[UITextField alloc] init];
    codeTF.maxLength = 6;
    codeTF.placeholder = @"请输入验证码";
    codeTF.tintColor = MainColor;
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    codeTF.font = [UIFont systemFontOfSize:14];
    [alertView addSubview:codeTF];
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneLab);
        make.right.mas_equalTo(-90);
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(phoneLab.mas_bottom).offset(20);
    }];
    _codeTF = codeTF;

    UIButton *sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendCodeBtn setBtnWithTitle:@"发送验证码" titleColor:MainColor font:13];
    [alertView addSubview:sendCodeBtn];
    [sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(26);
        make.centerY.mas_equalTo(codeTF);
    }];
    _sendCodeBtn = sendCodeBtn;

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"#ECECEC", 1);
    [alertView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(codeTF);
        make.right.mas_equalTo(sendCodeBtn);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(sendCodeBtn.mas_bottom).offset(4);
    }];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBtnWithTitle:@"取消" titleColor:HEXColor(@"#999999", 1) font:17];
    [cancelBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = RGBA(0, 0, 0, 0.04);
    [alertView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(alertView.width / 2);
    }];

    UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [yesBtn setBtnWithTitle:@"确定" titleColor:UIColor.whiteColor font:17];
    yesBtn.backgroundColor = MainColor;
    [alertView addSubview:yesBtn];
    [yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.width.mas_equalTo(cancelBtn);
    }];
    
    alertView.center = self.center;
    alertView.centerY = self.centerY - 60;
    alertView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:aniTime delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

- (void)setPhone:(NSString *)phone {
    _phoneLab.text = phone;
}

- (void)btnClick {
    if (self.yesBlock) {
        self.yesBlock();
    }
}

- (void)show {
    [UIApplication.sharedApplication.keyWindow addSubview:self];
}

- (void)remove {
    [UIView animateWithDuration:aniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
