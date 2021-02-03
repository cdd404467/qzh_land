//
//  SetPayPassWordVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/12.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SetPayPassWordVC.h"
#import "MutableCell.h"
#import "UITextField+Limit.h"
#import "CountDown.h"
#import "PayPasswordVC.h"
#import "MyBankCardListCheckVC.h"
#import "BankCardModel.h"

@interface SetPayPassWordVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, strong)NSMutableArray<MutableCellModel *> *dataSource;
@property (nonatomic, copy)NSArray *bankCardArray;
@end

@implementation SetPayPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = self.setType == 1 ? @"设置支付密码" : @"忘记支付密码";
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSArray *titleArr = @[@"证件号",@"证件类型",@"手机号",@"验证码"];
        _dataSource = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0;i < titleArr.count; i++) {
            MutableCellModel *model = [[MutableCellModel alloc] init];
            model.title = titleArr[i];
            if (i == 1) {
                model.subTitle = @"身份证";
            }
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [self addTableFooter];
    }
    return _tableView;
}

- (UIView *)addTableFooter {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_H(210))];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.layer.cornerRadius = 4.f;
    [submitBtn setBtnWithTitle:@"确认" titleColor:UIColor.whiteColor font:KFit_W(18)];
    submitBtn.backgroundColor = MainColor;
    [submitBtn addTarget:self action:@selector(checkSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KFit_H(160));
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.height.mas_equalTo(49);
    }];
    
    return view;
}

//获取短信验证码
- (void)getSMSCode {
    MutableCellModel *model = self.dataSource[2];
    if (model.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入预留手机号码" view:self.view];
        return;
    } else if (model.subTitle.length != 11) {
        [CddHud showTextOnly:@"请输入正确的手机号码" view:self.view];
        return;
    }
    
    NSDictionary *dict = @{@"userPhone":model.subTitle,
                           @"status":@8,
                           @"userType":@1
    };
    [NetTool postRequest:URLPost_OtherSMS_Code Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [self countDown];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)checkSMSCode {
    [self.view endEditing:YES];
    [CddHud show:self.view];
    __block MutableCellModel *model_0 = self.dataSource[0];
    __block MutableCellModel *model_2 = self.dataSource[2];
    MutableCellModel *model_3 = self.dataSource[3];
    if (model_0.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入证件号" view:self.view];
        return;
    } else if (model_2.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入预留手机号码" view:self.view];
        return;
    } else if (model_2.subTitle.length != 11) {
        [CddHud showTextOnly:@"请输入正确的手机号码" view:self.view];
        return;
    } else if (model_3.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入验证码" view:self.view];
        return;
    }
    
    NSDictionary *dict = @{@"userPhone":model_2.subTitle,
                           @"status":@8,
                           @"SMSCode":model_3.subTitle,
                           @"document":model_0.subTitle
    };
    [NetTool postRequest:URLPost_OtherSMS_Check Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            if (self.setType == 1) {
                PayPasswordVC *vc = [[PayPasswordVC alloc] init];
                vc.type = 5;
                vc.idCardNum = model_0.subTitle;
                vc.phoneNum = model_2.subTitle;
                [self.navigationController pushViewController:vc animated:YES];
            }
            //如果有银行卡,去验证银行卡
            else if (self.setType == 2) {
                [self requestBankList];
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        [CddHud hideHUD:self.view];
    }];
}

//获取我有没有银行卡
- (void)requestBankList {
    MutableCellModel *model_0 = self.dataSource[0];
    MutableCellModel *model_2 = self.dataSource[2];
    NSDictionary *dict = @{@"userid":User_Id};
    [CddHud show:self.view];
    [NetTool postRequest:URLPost_MyBankCard_List Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            self.bankCardArray = [BankCardModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (self.bankCardArray.count > 0) {
                MyBankCardListCheckVC *vc = [[MyBankCardListCheckVC alloc] init];
                vc.idCardNum = model_0.subTitle;
                vc.phoneNum = model_2.subTitle;
                vc.dataSource = self.bankCardArray;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                PayPasswordVC *vc = [[PayPasswordVC alloc] init];
                vc.type = 7;
                vc.idCardNum = model_0.subTitle;
                vc.phoneNum = model_2.subTitle;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MutableCell *cell;
    NSArray *placeHolderArr = @[@"请输入已认证身份证号",@"",@"请输入手机号码",@"请输入验证码"];
    if (indexPath.row == 3) {
        cell = [MutableCell cellWithTableView:tableView type:3];
        cell.tf.keyboardType = UIKeyboardTypeNumberPad;
        cell.tf.maxLength = 6;
        self.codeBtn = cell.sendCodeBtn;
        DDWeakSelf;
        cell.btnClickBlock = ^{
            [weakself getSMSCode];
        };
    } else {
        cell = [MutableCell cellWithTableView:tableView type:2];
        if (indexPath.row == 1) {
            cell.tf.userInteractionEnabled = NO;
        } else if (indexPath.row == 2) {
            cell.tf.maxLength = 11;
            cell.tf.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    cell.tf.placeholder = placeHolderArr[indexPath.row];
    cell.model = self.dataSource[indexPath.row];
    return cell;
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
