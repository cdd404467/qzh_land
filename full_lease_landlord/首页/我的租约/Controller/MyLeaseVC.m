//
//  MyLeaseVC.m
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MyLeaseVC.h"
#import "MyLeaseListCell.h"
#import "MyLeaseDetailVC.h"
#import "MyLeaseDetail2VC.h"
#import "ContractModel.h"
#import "ContactManagerVC.h"
#import <AFNetworking.h>
#import "UITableView+Extension.h"

@interface MyLeaseVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation MyLeaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的租约";
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
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        DDWeakSelf;
        [_tableView addHeaderWithRefresh:^(NSInteger pageIndex) {
            weakself.pageNumber = pageIndex;
            [weakself requestList];
        }];

        [_tableView addFooterWithRefresh:^(NSInteger pageIndex) {
            weakself.pageNumber = pageIndex;
            [weakself requestList];
        }];

        _tableView.mj_header.ignoredScrollViewContentInsetTop = 10;
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
    NSDictionary *dict = @{@"userPhone":User_Phone,
                           @"pageNumber":@(self.pageNumber)
    };
    [NetTool postRequest:URLPost_Con_List Params:dict Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            NSArray *tempArr = [ContractModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"dataList"]];
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
    return KFit_W(124);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0) {
        ContractModel *model = self.dataSource[indexPath.row];
        if (model.type == 1) {
            MyLeaseDetailVC *vc = [[MyLeaseDetailVC alloc] init];
            vc.conID = [self.dataSource[indexPath.row] conID];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (model.type == 2){
            MyLeaseDetail2VC *vc = [[MyLeaseDetail2VC alloc] init];
            vc.conID = [self.dataSource[indexPath.row] conID];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (_type == 1) {
        ContactManagerVC *vc = [[ContactManagerVC alloc] init];
        vc.conID = [self.dataSource[indexPath.row] conID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyLeaseListCell *cell = [tableView cddDequeueReusableCell:MyLeaseListCell.class];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

@end
