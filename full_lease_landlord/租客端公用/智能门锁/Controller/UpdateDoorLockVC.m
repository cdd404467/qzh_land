//
//  UpdateDoorLockVC.m
//  FullLease
//
//  Created by wz on 2020/11/23.
//  Copyright © 2020 kad. All rights reserved.
//

#import "UpdateDoorLockVC.h"
#import "TopNavTitleBar.h"

@interface UpdateDoorLockVC ()<TopNavTitleBarDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UITextField *textField2;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation UpdateDoorLockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitle = @"";
    
    [self createUI];
}

-(void)createUI{
    TopNavTitleBar *bar = [[TopNavTitleBar alloc] initWithTitles:self.titles titleColor:UIColorFromHex(0x333333) selectedColor:MainColor titleSize:17 selectIndex:self.curIndex lineH:2 frame:CGRectMake(0, JCNAVBar_H, JCWIDTH, JCWidth(42))];
    bar.delegate = self;
    [self.view addSubview:bar];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = UIColorFromHex(0xFAFAFA);
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(JCWidth(48));
        make.top.equalTo(bar.mas_bottom);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = self.models.firstObject.doorAddress;
    titleLab.textColor = UIColorFromHex(0x333333);
    titleLab.font = bkFont(14);
    [titleView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.centerY.mas_equalTo(titleView);
    }];
    self.titleLab = titleLab;
    
    DoorLockModel *model = self.models[_curIndex];
    UITextField *textField = [[UITextField alloc] init];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.font = kFont(14);
    textField.placeholder = [NSString stringWithFormat:@"请输入数字新密码（%ld位数字)",model.password.passWordLength];
    textField.secureTextEntry = YES;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.right.mas_equalTo(-JCWidth(16));
        make.top.mas_equalTo(titleView.mas_bottom);
        make.height.mas_equalTo(JCWidth(56));
    }];
    self.textField =textField;
    
    UIView *btLine = [[UIView alloc] init];
    btLine.backgroundColor  = UIColorFromHex(0xEEEEEE);
    [self.view addSubview:btLine];
    [btLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textField);
        make.left.right.equalTo(textField);
        make.height.mas_equalTo(0.5);
    }];

    UITextField *textField2 = [[UITextField alloc] init];
    textField2.keyboardType = UIKeyboardTypeNumberPad;
    textField2.font = kFont(14);
    textField2.placeholder = @"确认新密码";
    textField2.secureTextEntry = YES;
    [self.view addSubview:textField2];
    [textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.right.mas_equalTo(-JCWidth(16));
        make.top.mas_equalTo(btLine.mas_bottom);
        make.height.mas_equalTo(JCWidth(56));
    }];
    self.textField2 = textField2;
    
    UIView *btLine2 = [[UIView alloc] init];
    btLine2.backgroundColor  = UIColorFromHex(0xEEEEEE);
    [self.view addSubview:btLine2];
    [btLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textField2);
        make.left.right.equalTo(textField2);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 4;
    submitBtn.backgroundColor = MainColor;
    [submitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = kFont(18);
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.right.mas_equalTo(-JCWidth(16));
        make.height.mas_equalTo(JCWidth(50));
        make.bottom.mas_equalTo(-JCWidth(66));
    }];
}

-(void)selectTitle:(TopNavTitleBar *)topNavTitleBar index:(NSInteger)index{
    if (_curIndex ==index) {
        return;
    }
    _curIndex = index;
    self.textField.text = @"";
    self.textField2.text = @"";
}

-(void)submitClick{
    
    DoorLockModel *model = self.models[_curIndex];
    if (!isRightData(self.textField.text)) {
        [CddHud showTextOnly:@"请输入要修改的密码" view:self.view];
        return;
    }
    
    if (!isRightData(self.textField2.text)) {
        [CddHud showTextOnly:@"请输入确认密码" view:self.view];
        return;
    }
    
    if (![self.textField.text isEqualToString:self.textField2.text]) {
        [CddHud showTextOnly:@"两次密码不一致！请重新输入" view:self.view];
        return;
    }
    
    if (self.textField.text.length != model.password.passWordLength) {
        [CddHud showTextOnly:@"密码位数不正确" view:self.view];
        return;
    }
    
    NSString *password = [NSString stringWithString:self.textField2.text];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"contarctId"] = self.contractId;
    dic[@"lockId"] = model.lockId;
    dic[@"pwdId"] = model.password.pwdId;
    dic[@"password"] = password;
    
    DDWeakSelf;
    [CddHud show:self.view];
    [NetTool postRequest:@"member/smartDevices/setPassword" Params:dic Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [CddHud showTextOnly:@"设置成功" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
