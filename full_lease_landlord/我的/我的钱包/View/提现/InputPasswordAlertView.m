//
//  InputPasswordAlertView.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import "InputPasswordAlertView.h"
#import <JhtVerificationCodeView/JhtVerificationCodeView.h>

#define AniTime 0.1
#define BgColor HEXColor(@"#ffffff", 0.44);
typedef void(^Complete)(NSString *password);
@interface InputPasswordAlertView()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong)NSString *money;
@property (nonatomic, strong)JhtVerificationCodeView *codeView;
@property (nonatomic, copy)Complete complete;
@end

@implementation InputPasswordAlertView

- (instancetype)initWithMoney:(NSString *)money completion:(void (^)(NSString *password))completion cancel:(nullable void (^)(void))cancelBlock {
    self = [super init];
    if (self) {
        self.frame = SCREEN_BOUNDS;
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.money = money;
        //键盘将要显示
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        self.complete = completion;
    }
    return self;
}


- (void)show {
    CGFloat leftGap = 35;
    CGFloat width = SCREEN_WIDTH - leftGap * 2;
    CGFloat height = 220;
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(leftGap, 0, width, height)];
    _backView.center = self.center;
    _backView.backgroundColor = UIColor.whiteColor;
    _backView.layer.cornerRadius = 8.f;
    [self addSubview:self.backView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(removeViews) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"close_back"] forState:UIControlStateNormal];
    [_backView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(22);
        make.left.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"请输入支付密码";
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = HEXColor(@"#333333", 1);
    [_backView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(closeBtn);
        make.centerX.mas_equalTo(self.backView);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.text = @"提现";
    subTitle.font = [UIFont systemFontOfSize:14];
    subTitle.textColor = HEXColor(@"#333333", 1);
    [_backView addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titleLab);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(17);
    }];
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.text = [NSString stringWithFormat:@"¥ %@",self.money];
    moneyLab.font = [UIFont systemFontOfSize:23 weight:UIFontWeightMedium];
    moneyLab.textColor = HEXColor(@"#333333", 1);
    [_backView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(subTitle);
        make.height.mas_equalTo(32);
        make.top.mas_equalTo(subTitle.mas_bottom).offset(5);
    }];
    [moneyLab.superview layoutIfNeeded];
    
    CGFloat perWidth = (_backView.width - 16 * 2) / 6;
    _codeView = [[JhtVerificationCodeView alloc] initWithFrame:CGRectMake(16, moneyLab.bottom + 30, _backView.width - 16 * 2, perWidth)];
    _codeView.hasBoder = YES;
    _codeView.layer.cornerRadius = 4.f;
    _codeView.boderColor = HEXColor(@"#cccccc", 1);
    _codeView.codeViewType = VerificationCodeViewType_Secret;
    DDWeakSelf;
    _codeView.editBlcok = ^(NSString *text) {
        if (text.length == 6) {
            if (weakself.complete) {
                weakself.complete(text);
            }
        }
    };
    [_backView addSubview:_codeView];
    
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
    } completion:^(BOOL finished) {
        [self.codeView Jht_BecomeFirstResponder];
    }];
    
    [UIApplication.sharedApplication.windows[0] addSubview:self];
}

#pragma mark -键盘监听方法
- (void)keyBoardWillShow:(NSNotification *)notification
{
//    NSLog(@"--- %@",[notification userInfo]);
    //     获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    DDWeakSelf;
    [UIView animateWithDuration:animationTime animations:^{
        self.backView.top = SCREEN_HEIGHT - keyBoardHeight - weakself.backView.height - 100;
    }];
}

- (void)removeViews {
    [UIView animateWithDuration:AniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}
@end
