//
//  BankCardListVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BankCardListVC.h"
#import "BankCardListCell.h"
#import "AddBankCardFooter.h"
#import "PayPasswordVC.h"
#import "SetPayPassWordVC.h"
#import "AlertInputPhoneVIew.h"
#import "CountDown.h"
#import "CheckPayPasswordVC.h"
#import "full_lease_landlord-Swift.h"

@interface BankCardListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)AddBankCardFooter *footerView;
@property (nonatomic, copy)NSArray<BankCardModel *> *dataSource;
@property (nonatomic, strong)AlertInputPhoneVIew *phoneView;
@end

@implementation BankCardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"收款账户";
    [self.view addSubview:self.tableView];
    [self requestList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestList) name:NotificationName_AddBankCardSuccess object:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(9, 0, 0, 0);
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        [footer addSubview:self.footerView];
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}

- (AddBankCardFooter *)footerView {
    if (!_footerView) {
        _footerView = [[AddBankCardFooter alloc] initWithFrame:CGRectMake(0, 22, SCREEN_WIDTH, 180)];
        DDWeakSelf;
        _footerView.tapClickBlock = ^(NSInteger tag) {
            if (tag == 0) {
                if (User_IsSetPW) {
                    PayPasswordVC *vc = [[PayPasswordVC alloc] init];
                    vc.type = 1;
                    [weakself.navigationController pushViewController:vc animated:YES];
                } else {
                    SetPayPassWordVC *vc = [[SetPayPassWordVC alloc] init];
                    vc.setType = 1;
                    [weakself.navigationController pushViewController:vc animated:YES];
                }
            } else if (tag == 1) {
                if (User_IsSetPW) {
                    CheckPayPasswordVC *vc = [[CheckPayPasswordVC alloc] init];
                    vc.checkRightBlock = ^{
                        AddAliPayVC *aVC = [[AddAliPayVC alloc] init];
                        [weakself.navigationController pushViewController:aVC animated:YES];
                    };
                    [weakself.navigationController pushViewController:vc animated:YES];
                } else {
                    SetPayPassWordVC *vc = [[SetPayPassWordVC alloc] init];
                    vc.setType = 1;
                    [weakself.navigationController pushViewController:vc animated:YES];
                }
            }
        };
    }
    return _footerView;
}

- (void)requestList {
    NSDictionary *dict = @{@"userid":User_Id};
    [NetTool postRequest:URLPost_MyBankCard_List Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            self.dataSource = [BankCardModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [self.tableView reloadData];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)unBindBankCard:(NSString *)bankCardID {
    _phoneView = [[AlertInputPhoneVIew alloc] init];
    _phoneView.phone = User_Phone;
    [_phoneView.sendCodeBtn addTarget:self action:@selector(getSMSCode) forControlEvents:UIControlEventTouchUpInside];
    DDWeakSelf;
    _phoneView.yesBlock = ^{
        [weakself.view endEditing:YES];
        [weakself checkSMSCode:bankCardID];
    };
    [_phoneView show];
}

//获取短信验证码
- (void)getSMSCode {
    NSDictionary *dict = @{@"userPhone":User_Phone,
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

- (void)checkSMSCode:(NSString *)bankCardID {
    if (_phoneView.codeTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入验证码" view:_phoneView];
        return;
    }
    NSDictionary *dict = @{@"userPhone":User_Phone,
                           @"status":@5,
                           @"SMSCode":_phoneView.codeTF.text,
                           @"type":@1,
                           @"bankCardId":bankCardID
    };
    [CddHud show:self.phoneView];
    [NetTool postRequest:URLPost_OtherSMS_Check Params:dict Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.phoneView];
        if (JsonCode == 200) {
            @try {
                if ([json[@"data"][@"result"] integerValue]) {
                    [self.phoneView remove];
                    [CddHud showTextOnly:@"解绑成功" view:self.view];
                    [self requestList];
                } else {
                    [CddHud showTextOnly:@"解绑失败" view:self.view];
                }
            } @catch (NSException *exception) {
                [CddHud showTextOnly:@"解绑失败" view:self.view];
            }
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
           weakself.phoneView.sendCodeBtn.enabled = YES;
           [weakself.phoneView.sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
       }else{
           weakself.phoneView.sendCodeBtn.enabled = NO;
           [weakself.phoneView.sendCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)second] forState:UIControlStateNormal];
       }
   }];
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCardListCell *cell = [BankCardListCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    DDWeakSelf;
    cell.unBindBlock = ^(NSString * _Nonnull bankcardID) {
        [weakself unBindBankCard:bankcardID];
    };
    return cell;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
