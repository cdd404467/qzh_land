//
//  HouseResourceVC.m
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "HouseResourceVC.h"
#import "HouseResourceListCell.h"
#import "HouseResourceDetailVC.h"
#import "HouseInfoModel.h"

@interface HouseResourceVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<HouseInfoModel *> *dataSource;
@end

@implementation HouseResourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"房源";
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
        _tableView.contentInset = UIEdgeInsetsMake(KFit_W(15), 0, TABBAR_HEIGHT, 0);
        
        DDWeakSelf;
//        [_tableView addHeaderWithRefresh:^(NSInteger pageIndex) {
//            weakself.pageNumber = pageIndex;
//            [weakself requestList];
//        }];
//        
//        [_tableView addFooterWithRefresh:^(NSInteger pageIndex) {
//            weakself.pageNumber = pageIndex;
//            [weakself requestList];
//        }];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.pageNumber = 1;
            [self requestList];
        }];
        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakself.pageNumber++;
            [self requestList];
        }];
//        [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        _tableView.mj_header.ignoredScrollViewContentInsetTop = KFit_W(15);
    }
    return _tableView;
}

- (NSMutableArray<HouseInfoModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)requestList {
    NSDictionary *dict = @{@"phone":User_Phone,
                           @"pageNumber":@(self.pageNumber),
                           @"pageSize":@20
    };
    [NetTool postRequest:URLPost_HouseResource_List Params:dict Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue]) {
            NSArray *tempArr = [HouseInfoModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            for (HouseInfoModel *model in tempArr) {
                model.contractBillStatusDesc = [TagsViewModel mj_objectArrayWithKeyValuesArray:model.contractBillStatusDesc];
            }
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

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KFit_W(120);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HouseResourceDetailVC *vc = [[HouseResourceDetailVC alloc] init];
    vc.houseID = self.dataSource[indexPath.row].houseId;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HouseResourceListCell *cell = [HouseResourceListCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end
