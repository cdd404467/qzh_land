//
//  WithdrawalRecordVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/12/16.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WithdrawalRecordVC.h"
#import "WalletSpendCell.h"

@interface WithdrawalRecordVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation WithdrawalRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"提现记录";
    [self.view addSubview:self.tableView];
    [self requestList];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = TableColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        DDWeakSelf;
        _tableView.pageCount = 20;
        [_tableView addHeaderWithRefresh:^(NSInteger pageIndex) {
            weakself.pageNumber = pageIndex;
            [weakself requestList];
        }];
        [_tableView addFooterWithRefresh:^(NSInteger pageIndex) {
            weakself.pageNumber = pageIndex;
            [weakself requestList];
        }];
    }
    return _tableView;
}

- (void)requestList {
    NSDictionary *dict = @{@"PageIndex":@(self.pageNumber),
                           @"PageSize":@20
    };
    [NetTool postRequest:URLPost_Wallet_Spend Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            NSArray *tempArr = [WalletModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"responseResult"][@"numberData"]];
            if (self.pageNumber == 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:tempArr];
            [self.tableView endRefreshWithDataCount:tempArr.count];
            [self.tableView reloadData];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_data"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return KFit_W(-100);
}

// 如果不实现此方法的话,无数据时下拉刷新不可用
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KFit_W(77);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MyBillDetailVC *vc = [[MyBillDetailVC alloc] init];
//    vc.billID = self.dataSource[indexPath.row].billID;
//    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletSpendCell *cell = [WalletSpendCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

@end
