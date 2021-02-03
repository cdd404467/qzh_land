//
//  MessageListVC.m
//  FullLease
//
//  Created by apple on 2020/8/17.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MessageListVC.h"
#import "MessageListCell.h"
#import "MsgModel.h"
#import "VCJump.h"

@interface MessageListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation MessageListVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"消息通知";
    [self.view addSubview:self.tableView];
    [self requestData];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)requestData {
    NSDictionary *dict = @{@"type":@(_type),
                           @"userId":User_Id
    };
    
    [NetTool postRequest:URLPost_Message_List Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            NSArray *tempArr = [MsgModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"data"]];
            [self.dataSource addObjectsFromArray:tempArr];
            [self.tableView reloadData];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = TableColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
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
    MsgModel *model = self.dataSource[indexPath.row];
    [VCJump jumpPageWithType:model.type];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListCell *cell = [MessageListCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}



@end
