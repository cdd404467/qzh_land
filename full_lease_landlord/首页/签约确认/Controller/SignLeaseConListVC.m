//
//  SignLeaseConListVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SignLeaseConListVC.h"
#import "SignLeaseConCell.h"
#import "SignConfirmVC.h"



@interface SignLeaseConListVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UILabel *headerLab;
@property (nonatomic, strong)NSMutableArray<ZukeConModel *> *dataSource;

@end

@implementation SignLeaseConListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"选择合同";
    [self.view addSubview:self.tableView];
    [self requestList];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)requestList {
    NSDictionary *dict = @{@"userPhone":User_Phone,
                           @"status":@"11",
                           @"pageNumber":@(self.pageNumber)
    };
    [NetTool postRequest:URLPost_ZuKeCon_List Params:dict Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            NSArray *tempArr = [ZukeConModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"dataList"]];
            if (self.pageNumber == 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:tempArr];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            if (self.dataSource.count > 0) {
                self.headerLab.text = [NSString stringWithFormat:@"您有%lu份租客合同待签约确定，快去签约吧!",(unsigned long)self.dataSource.count];
            } else {
                self.headerLab.text = @"暂无待签合同";
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
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
        _tableView.tableHeaderView = [self headerView];
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

- (UIView *)headerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(100))];
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 4.f;
    bgView.backgroundColor = MainColor;
    [view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.height.mas_equalTo(KFit_W(55));
        make.centerY.mas_equalTo(view);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_leaselist_image"]];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.width.mas_equalTo(KFit_W(46));
        make.height.mas_equalTo(KFit_W(40));
        make.centerY.mas_equalTo(bgView);
    }];
    
    UILabel *headerLab = [[UILabel alloc] init];
    headerLab.textColor = UIColor.whiteColor;
    headerLab.numberOfLines = 2;
    headerLab.font = kFont(13);
    [view addSubview:headerLab];
    [headerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(2);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(bgView);
    }];
    _headerLab = headerLab;
    
    return view;
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
    SignConfirmVC *vc = [[SignConfirmVC alloc] init];
    vc.model = self.dataSource[indexPath.row];
    DDWeakSelf;
    vc.refuseSuccess = ^{
        weakself.pageNumber = 1;
        [weakself requestList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignLeaseConCell *cell = [tableView cddDequeueReusableCell:SignLeaseConCell.class];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end
