//
//  MyWalletVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MyWalletVC.h"
#import "MyWalletCell.h"
#import "MyWalletTBHeader.h"
#import "BankCardListVC.h"
#import "PayManagerVC.h"
#import "IncomeListVC.h"
#import "WalletRecordVC.h"
#import "WithdrawalVC.h"
#import "AlertSystem.h"
#import "SetPayPassWordVC.h"
#import "NSString+Extension.h"
#import "PayPasswordVC.h"
#import "QuickTool.h"

@interface MyWalletVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)MyWalletTBHeader *headerView;
@property (nonatomic, assign)BOOL isHasBankCard;
@end

@implementation MyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的钱包";
    self.navBar.rightBtn.hidden = NO;
    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"more_select"] forState:UIControlStateNormal];
    [self.navBar.rightBtn addTarget:self action:@selector(payManager) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState) name:NotificationName_AddBankCardSuccess object:nil];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = TableColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself requestData];
        }];
    }
    return _tableView;
}


- (MyWalletTBHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MyWalletTBHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(160) + 20)];
        DDWeakSelf;
        _headerView.tixianBlock = ^{
            [weakself jumpToWithdrawal];
        };
    }
    return _headerView;
}

- (void)changeState {
    self.isHasBankCard = YES;
}

- (void)requestData {
    [NetTool getRequest:URLGet_MinePage_Info Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            NSString *remainMoney = [json[@"data"][@"wallet"][@"walletAmount"] stringValue];
            NSString *addupMoney = [json[@"data"][@"wallet"][@"totalRevenue"] stringValue];
            self.headerView.remainMoney = [remainMoney correctPrecision];
            self.headerView.addupMoney = [addupMoney correctPrecision];
            self.isHasBankCard = [json[@"data"][@"haveBankCard"] boolValue];
            [self.tableView.mj_header endRefreshing];
        }
    } Failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)jumpToWithdrawal {
    //未设置密码
    if (!User_IsSetPW) {
        [AlertSystem alertTwo:@"您还没有设置支付密码,是否先去设置支付密码？" msg:nil cancelBtn:@"取消" okBtn:@"去设置" OKCallBack:^{
            SetPayPassWordVC *vc = [[SetPayPassWordVC alloc] init];
            vc.setType = 1;
            [self.navigationController pushViewController:vc animated:YES];
        } cancelCallBack:nil];
        return;
    }
    //未添加银行卡
    if (!_isHasBankCard) {
        [AlertSystem alertTwo:@"银行卡未添加,请先添加银行卡" msg:nil cancelBtn:@"取消" okBtn:@"去添加银行卡"  OKCallBack:^{
            PayPasswordVC *vc = [[PayPasswordVC alloc] init];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        } cancelCallBack:nil];
        return;
    }
    
    WithdrawalVC *vc = [[WithdrawalVC alloc] init];
    vc.maxMoney = self.headerView.remainMoney;
    DDWeakSelf;
    vc.successBlock = ^{
        [weakself requestData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WalletRecordVC *vc = [[WalletRecordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        IncomeListVC *vc = [[IncomeListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        BankCardListVC *vc = [[BankCardListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *imageArr = @[@"wallet_details_icon",@"collection_record_icon",@"bankcard_icon"];
    NSArray *titleArr = @[@"钱包明细",@"收款记录",@"银行卡"];
    NSArray *subTitleArr = @[@"钱包收支明细",@"打款到银行卡的记录",@"绑定银行卡操作"];
    MyWalletCell *cell = [MyWalletCell cellWithTableView:tableView];
    cell.headerImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.titleLab.text = titleArr[indexPath.row];
    cell.subTitleLab.text = subTitleArr[indexPath.row];
    return cell;
}

- (void)payManager {
    PayManagerVC *vc = [[PayManagerVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
