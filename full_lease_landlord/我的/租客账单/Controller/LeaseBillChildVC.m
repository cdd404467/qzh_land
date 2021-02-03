//
//  LeaseBillChildVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LeaseBillChildVC.h"
#import "LeaseBillListCell.h"
#import "LeaseBillDetailVC.h"

@interface LeaseBillChildVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<LeaseBillModel *> *dataSource;

@end

@implementation LeaseBillChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    [self.view addSubview:self.tableView];
    [self requestList];
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
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, TABBAR_HEIGHT + 30, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.pageNumber = 1;
            [self requestList];
        }];
        _tableView.mj_header.ignoredScrollViewContentInsetTop = 20;
        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakself.pageNumber++;
            [self requestList];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)requestList {
    NSDictionary *dict = @{@"status":@(_type),
                           @"phone":User_Phone,
                           @"pageNumber":@(self.pageNumber),
                           @"pageSize":@20
    };
    
    NSMutableDictionary *mDict = [dict mutableCopy];
    if (_conID) {
        [mDict setObject:_conID forKey:@"contractid"];
    }
    
    [NetTool postRequest:URLPost_Lease_Bill Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            NSArray *tempArr = [LeaseBillModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"data"]];
            if (self.pageNumber == 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:tempArr];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
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
    return KFit_W(160);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaseBillDetailVC *vc = [[LeaseBillDetailVC alloc] init];
    vc.billID = self.dataSource[indexPath.row].billID;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaseBillListCell *cell = [tableView cddDequeueReusableCell:LeaseBillListCell.class];
    cell.type = _type;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

@end
