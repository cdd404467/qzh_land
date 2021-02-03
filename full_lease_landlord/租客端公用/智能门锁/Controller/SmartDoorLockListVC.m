//
//  SmartDoorLockListVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/12/3.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SmartDoorLockListVC.h"
#import "DoorLockCell.h"
#import "GesturePasswordVC.h"
#import "DoorLockModel.h"
#import "SmartDoorLockVC.h"

@interface SmartDoorLockListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong)NSMutableArray <DoorLockModel *>*List;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation SmartDoorLockListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"智能门锁";
    [self.view addSubview:self.tableView];
    [self requestList];
}

-(NSMutableArray *)List
{
    if(!_List){
        _List=[[NSMutableArray alloc]init];
    }
    return _List;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[DoorLockCell class] forCellReuseIdentifier:@"DoorLockCell"];
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.pageNumber = 1;
            [self requestList];
        }];
//        _tableView.mj_header.ignoredScrollViewContentInsetTop = 10;
//        _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            weakself.pageNumber++;
//            [self requestList];
//        }];
    }
    return _tableView;
}

-(void)endMjRefreshing{
    if([self.tableView.mj_header isRefreshing]){
        [self.tableView.mj_header endRefreshing];
    }
    if([self.tableView.mj_footer isRefreshing]){
        [self.tableView.mj_footer endRefreshing];
    }
}

-(void)requestList{
    NSString *toke = DoorToken;
    if (toke.length < 2) {
        return;
    }
    NSDictionary *headerDict = @{@"Authorization":toke};
    [CddHud show:self.view];
    [NetTool getRequestWithHeader:headerDict requestUrl:@"member/smartDevices/getNamekeyList" Params:nil Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
        if (JsonCode == 200) {
            self.List = [DoorLockModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"numberData"]];
        } 
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } Failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_lock"];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return KFit_W(-100);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DoorLockCell *cell=[tableView dequeueReusableCellWithIdentifier:@"DoorLockCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.List[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KFit_W(84);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GesturePasswordVC *vc = [[GesturePasswordVC alloc] init];
//    vc.doorLockModel = self.List[indexPath.row];
//    if (isSetGesturePW) {
//        vc.type = 2;
//    } else {@property (nonatomic, strong)DoorLockModel *doorLockModel;
//        vc.type = 1;
//    }
//    [self.navigationController pushViewController:vc animated:YES];
    
    SmartDoorLockVC *vc = [[SmartDoorLockVC alloc] init];
    vc.doorLockModel = self.List[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
