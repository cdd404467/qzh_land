//
//  PayManagerVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/10.
//  Copyright © 2020 apple. All rights reserved.
//

#import "PayManagerVC.h"
#import "PayManagerCell.h"
#import "PayPasswordVC.h"
#import "AlertSystem.h"
#import "SetPayPassWordVC.h"

@interface PayManagerVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation PayManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"支付管理";
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _tableView.separatorColor = HEXColor(@"#EEEEEE", 1);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!User_IsSetPW) {
        [AlertSystem alertTwo:@"您还没有设置支付密码,是否先去设置支付密码？" msg:nil cancelBtn:@"取消" okBtn:@"去设置"  OKCallBack:^{
            SetPayPassWordVC *vc = [[SetPayPassWordVC alloc] init];
            vc.setType = 1;
            [self.navigationController pushViewController:vc animated:YES];
        } cancelCallBack:nil];
        return;
    }
    if (indexPath.row == 0) {
        PayPasswordVC *vc = [[PayPasswordVC alloc] init];
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        SetPayPassWordVC *vc = [[SetPayPassWordVC alloc] init];
        vc.setType = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArr = @[@"修改支付密码",@"忘记支付密码"];
    PayManagerCell *cell = [PayManagerCell cellWithTableView:tableView];
    cell.titleLab.text = titleArr[indexPath.row];
    return cell;
}
@end
