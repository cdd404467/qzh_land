//
//  AddBankCardVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/9.
//  Copyright © 2020 apple. All rights reserved.
//

#import "AddBankCardVC.h"
#import "MutableCell.h"
#import "UITextField+Limit.h"
#import "BankSelectVC.h"
#import "CountDown.h"

@interface AddBankCardVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UIButton *submitBtn;
@end

@implementation AddBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"添加银行卡";
    [self.view addSubview:self.tableView];
    [self getBankName];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
        NSArray *tempArr = @[@[@"银行卡号",@"开户银行",@"开户支行"],@[@"持卡人姓名",@"持卡人证件号",@"预留手机号",@"验证码"]];
        for (NSInteger i = 0; i < tempArr.count; i ++) {
            [_dataSource addObject:[NSMutableArray arrayWithCapacity:0]];
            for (NSInteger j = 0; j < [tempArr[i] count];j++) {
                MutableCellModel *model = [[MutableCellModel alloc] init];
                model.title = tempArr[i][j];
                if (i == 0 && j == 0) {
                    model.subTitle = _bankCardNum;
                }
                [_dataSource[i] addObject:model];
            }
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
        _tableView.tableFooterView = [self addtableFooter];
//        _tableView.contentInset = UIEdgeInsetsMake(9, 0, 0, 0);
    }
    return _tableView;
}

- (UIView *)addtableFooter {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 7 * 57 - 8)];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.layer.cornerRadius = 4.f;
    [submitBtn setBtnWithTitle:@"提交" titleColor:UIColor.whiteColor font:KFit_W(18)];
    submitBtn.backgroundColor = MainColor;
    [submitBtn addTarget:self action:@selector(checkSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-TABBAR_HEIGHT);
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.height.mas_equalTo(49);
    }];
    _submitBtn = submitBtn;
    return view;
}

//获取开户银行名字
- (void)getBankName {
    NSDictionary *dict = @{@"account":_bankCardNum};
    [NetTool postRequest:URLPost_GetBankName Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            MutableCellModel *model = self.dataSource[0][1];
            model.subTitle = RightDataSafe(json[@"data"][@"banName"]);
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)submit {
    MutableCellModel *model_1 = self.dataSource[0][1];
    MutableCellModel *model_2 = self.dataSource[0][2];
    MutableCellModel *model_3 = self.dataSource[1][0];
    MutableCellModel *model_4 = self.dataSource[1][1];
    MutableCellModel *model_5 = self.dataSource[1][2];
    MutableCellModel *model_6 = self.dataSource[1][3];
    
    if (model_1.subTitle.length == 0) {
        [CddHud showTextOnly:@"请选择开户银行" view:self.view];
        return;
    } else if (model_2.subTitle.length == 0) {
        [CddHud showTextOnly:@"请填写开户支行" view:self.view];
        return;
    } else if (model_3.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入持卡人姓名" view:self.view];
        return;
    } else if (model_4.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入持卡人证件号" view:self.view];
        return;
    } else if (model_5.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入预留手机号码" view:self.view];
        return;
    } else if (model_5.subTitle.length != 11) {
        [CddHud showTextOnly:@"请输入正确的手机号码" view:self.view];
        return;
    } else if (model_6.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入手机验证码" view:self.view];
        return;
    }
    NSDictionary *dict = @{@"userid":User_Id,
                           @"account":_bankCardNum,
                           @"bankname":model_1.subTitle,
                           @"bankbranch":model_2.subTitle,
                           @"createperson":model_3.subTitle,
                           @"document":model_4.subTitle,
                           @"phone":model_5.subTitle
    };
    self.submitBtn.enabled = NO;
    [NetTool postRequest:URLPost_Add_BankCard Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [CddHud showTextOnly:@"添加成功" view:self.view];
            NSMutableArray *vcArr = [self.navigationController.viewControllers mutableCopy];
            [vcArr removeObjectAtIndex:vcArr.count - 2];
            self.navigationController.viewControllers = vcArr;
            [[NSNotificationCenter defaultCenter]postNotificationName:NotificationName_AddBankCardSuccess object:nil userInfo:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        self.submitBtn.enabled = YES;
    } Failure:^(NSError * _Nonnull error) {
        self.submitBtn.enabled = YES;
    }];
    
}

//获取短信验证码
- (void)getSMSCode {
    MutableCellModel *model = self.dataSource[1][2];
    if (model.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入预留手机号码" view:self.view];
        return;
    } else if (model.subTitle.length != 11) {
        [CddHud showTextOnly:@"请输入正确的手机号码" view:self.view];
        return;
    }
    
    NSDictionary *dict = @{@"userPhone":model.subTitle,
                           @"status":@5,
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
    MutableCellModel *model_1 = self.dataSource[1][2];
    MutableCellModel *model_2 = self.dataSource[1][3];
    if (model_1.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入预留手机号码" view:self.view];
        return;
    } else if (model_1.subTitle.length != 11) {
        [CddHud showTextOnly:@"请输入正确的手机号码" view:self.view];
        return;
    } else if (model_2.subTitle.length == 0) {
        [CddHud showTextOnly:@"请输入验证码" view:self.view];
        return;
    }
    
    NSDictionary *dict = @{@"userPhone":model_1.subTitle,
                           @"status":@5,
                           @"SMSCode":model_2.subTitle,
                           @"type":@0
    };
    [NetTool postRequest:URLPost_OtherSMS_Check Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [self submit];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}



#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 4;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        view.backgroundColor = HEXColor(@"#F5F5F5", 1);
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            BankSelectVC *vc = [[BankSelectVC alloc] init];
            vc.selectBlock = ^(NSString * _Nonnull bankName) {
                MutableCellModel *model = self.dataSource[0][1];
                model.subTitle = bankName;
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MutableCellModel *model = self.dataSource[indexPath.section][indexPath.row];
    MutableCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [MutableCell cellWithTableView:tableView type:0];
            cell.rightLab.textAlignment = NSTextAlignmentRight;
        } else if (indexPath.row == 1){
            cell = [MutableCell cellWithTableView:tableView type:1];
            cell.placeHolder = @"请选择";
        } else {
            cell = [MutableCell cellWithTableView:tableView type:2];
            cell.tf.placeholder = @"请输入开户支行";
            cell.tf.textAlignment = NSTextAlignmentRight;
        }
    } else {
        NSArray *placeHolderArr = @[@"请输入持卡人姓名",@"请输入证件号",@"请输入手机号码",@"请输入验证码"];
        if (indexPath.row == 3) {
            cell = [MutableCell cellWithTableView:tableView type:3];
            cell.tf.placeholder = placeHolderArr[indexPath.row];
            cell.tf.keyboardType = UIKeyboardTypeNumberPad;
            cell.tf.maxLength = 6;
            self.codeBtn = cell.sendCodeBtn;
            DDWeakSelf;
            cell.btnClickBlock = ^{
                [weakself getSMSCode];
            };
        } else {
            cell = [MutableCell cellWithTableView:tableView type:2];
            cell.tf.placeholder = placeHolderArr[indexPath.row];
            if (indexPath.row == 2) {
                cell.tf.maxLength = 11;
                cell.tf.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
    }
    cell.model = model;
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
