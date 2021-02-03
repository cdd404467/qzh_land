//
//  LeaseContractVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LeaseContractVC.h"
#import "LeaseContractCell.h"
#import "ZukeConModel.h"
#import "LeaseContractDetailVC.h"

@interface LeaseContractVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<ZukeConModel *> *dataSource;
@end

@implementation LeaseContractVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"租客合同";
    [self.view addSubview:self.tableView];
    [self requestList];
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
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, TABBAR_HEIGHT + 30, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.pageNumber = 1;
            [self requestList];
        }];
        _tableView.mj_header.ignoredScrollViewContentInsetTop = 10;
        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakself.pageNumber++;
            [self requestList];
        }];
    }
    return _tableView;
}

- (NSMutableArray<ZukeConModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)requestList {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithObject:@(self.pageNumber) forKey:@"pageNumber"];
    //常规首页进入
    if (_type == 0) {
        [mDict setObject:User_Phone forKey:@"userPhone"];
    }
    //详情进入 - 在租租客
    else if (_type == 1) {
        [mDict setObject:_houseID forKey:@"houseid"];
        [mDict setObject:@"1,2,5" forKey:@"status"];
    }
    //详情进入 - 历史租客
    else if (_type == 2) {
        [mDict setObject:_houseID forKey:@"houseid"];
        [mDict setObject:@"2,4,6,7,10,11,12,13" forKey:@"status"];
    }
    
    [NetTool postRequest:URLPost_ZuKeCon_List Params:mDict Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            NSArray *tempArr = [ZukeConModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"dataList"]];
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
    return KFit_W(124);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaseContractDetailVC *vc = [[LeaseContractDetailVC alloc] init];
    vc.conID = self.dataSource[indexPath.row].contract.conID ;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaseContractCell *cell = [LeaseContractCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

@end
