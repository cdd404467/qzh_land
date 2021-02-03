//
//  MsgTypeListVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/1.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MsgTypeListVC.h"
#import "MsgTypeListCell.h"
#import "MessageListVC.h"

@interface MsgTypeListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *msgCountArray;
@property (nonatomic, strong)NSMutableArray *timeArray;

@end

@implementation MsgTypeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"消息通知";
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self requestData];
}

- (NSMutableArray *)msgCountArray {
    if (!_msgCountArray) {
        _msgCountArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _msgCountArray;
}

- (NSMutableArray *)timeArray {
    if (!_timeArray) {
        _timeArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _timeArray;
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_UnRead_Message,User_Id];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [self.msgCountArray removeAllObjects];
            [self.timeArray removeAllObjects];
            [self.msgCountArray addObject:[json[@"data"][@"billTotalMsgNums"] stringValue]];
            [self.msgCountArray addObject:[json[@"data"][@"noticeTotalNums"] stringValue]];
            [self.msgCountArray addObject:[json[@"data"][@"systemTotalNums"] stringValue]];
            [self.timeArray addObject:json[@"data"][@"billLatestUnReadTime"]];
            [self.timeArray addObject:json[@"data"][@"noticeLatestUnReadTime"]];
            [self.timeArray addObject:json[@"data"][@"systemLatestUnReadTime"]];
            [self.tableView reloadData];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
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
    return self.msgCountArray.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KFit_W(72);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListVC *vc = [[MessageListVC alloc] init];
    vc.type = indexPath.row + 1;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *iconArr = @[@"msg_order",@"msh_notify",@"msg_system"];
    NSArray *titleArr = @[@"账单提醒",@"通知提醒",@"系统提醒"];
    MsgTypeListCell *cell = [MsgTypeListCell cellWithTableView:tableView];
    cell.iconName = iconArr[indexPath.row];
    cell.time = self.timeArray[indexPath.row];
    cell.title = titleArr[indexPath.row];
    cell.msgCount = self.msgCountArray[indexPath.row];
    return cell;
}


@end
