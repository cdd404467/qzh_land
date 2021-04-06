//
//  WalletChildIncomeVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/12.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WalletChildIncomeVC.h"
#import "WalletIncomeCell.h"

@interface WalletChildIncomeVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation WalletChildIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 42) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = TableColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    [NetTool postRequest:URLPost_Wallet_Income Params:dict Success:^(id  _Nonnull json) {
        
        if (JsonCode == 200) {
            NSArray *tempArr = [WalletModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"responseResult"]];
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
    return KFit_W(107);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MyBillDetailVC *vc = [[MyBillDetailVC alloc] init];
//    vc.billID = self.dataSource[indexPath.row].billID;
//    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletIncomeCell *cell = [WalletIncomeCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end
