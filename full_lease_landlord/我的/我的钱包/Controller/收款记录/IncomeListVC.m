//
//  IncomeListVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "IncomeListVC.h"
#import "IncomeListCell.h"
#import "IncomeDetailVC.h"
#import "IncomeHeaderView.h"
#import "DateSelectVC.h"
#import <BRPickerView.h>
#import "TimeAbout.h"


@interface IncomeListVC ()<UITableViewDelegate, UITableViewDataSource,DateSelectDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)IncomeModel *model;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)IncomeHeaderView *secHeader;
@property (nonatomic, copy)NSString *selectMonth;
@property (nonatomic, copy)NSString *selectBeginDay;
@property (nonatomic, copy)NSString *selectEndDay;
@property (nonatomic, copy)NSString *incomeType;
@property (nonatomic, copy)NSString *orderType;
@property (nonatomic, strong)UIButton *paySelBtn;
@property (nonatomic, strong)UIButton *orderTypeBtn;
@property (nonatomic, assign) BOOL isDaySelect;
@end

@implementation IncomeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"收入明细";
    _selectMonth = [TimeAbout dateToStringMonth:[NSDate date]];
    _incomeType = @"";
    _orderType = @"";
    [self requestList];
    [self setupUI];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT + 42, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 42) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = TableColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, KFit_W(15), 0, KFit_W(15));
        _tableView.separatorColor = HEXColor(@"#dddddd", 1);
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        DDWeakSelf;
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

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
    UIView *topBg = [[UIView alloc] init];
    topBg.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 42);
    topBg.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:topBg];
    
    UIButton *paySelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [paySelBtn setTitleColor:HEXColor(@"333333", 1) forState:UIControlStateNormal];
    paySelBtn.frame = CGRectMake(30, 0, 50, topBg.height);
    paySelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [paySelBtn setImage:[UIImage imageNamed:@"sel_arrow_down"] forState:UIControlStateNormal];
    [paySelBtn setTitle:@"全部" forState:UIControlStateNormal];
    [paySelBtn addTarget:self action:@selector(selectIncomeType) forControlEvents:UIControlEventTouchUpInside];
    [paySelBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [topBg addSubview:paySelBtn];
    _paySelBtn = paySelBtn;
    
    
    UIButton *orderTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderTypeBtn setTitleColor:HEXColor(@"333333", 1) forState:UIControlStateNormal];
    orderTypeBtn.frame = CGRectMake(paySelBtn.right + 40, 0, 50, topBg.height);
    orderTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [orderTypeBtn setImage:[UIImage imageNamed:@"sel_arrow_down"] forState:UIControlStateNormal];
    [orderTypeBtn setTitle:@"全部" forState:UIControlStateNormal];
    [orderTypeBtn addTarget:self action:@selector(selectOrderType) forControlEvents:UIControlEventTouchUpInside];
    [orderTypeBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:4];
    [topBg addSubview:orderTypeBtn];
    _orderTypeBtn = orderTypeBtn;
}


- (void)requestList {
    NSDictionary *dict = @{@"phone":User_Phone,
                           @"tsource":@2,
                           @"queryMothTime":_isDaySelect ? @"" : _selectMonth,
                           @"queryDayBeginTime":_isDaySelect ? _selectBeginDay : @"",
                           @"queryDayEndTime":_isDaySelect ? _selectEndDay : @"",
                           @"sourcetypeStr":_orderType,
                           @"budgettypeStr":_incomeType,
                           @"pageNumber":@(self.pageNumber)
    };
    
    [NetTool postRequest:URLPost_Income_List Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            self.model = [IncomeModel mj_objectWithKeyValues:json[@"data"]];
            self.model.sourcetypeEnum = [sourcetypeEnumModel mj_objectArrayWithKeyValuesArray:self.model.sourcetypeEnum];
            self.model.orderMothTotalDto = [orderMothTotalDtoModel mj_objectWithKeyValues:self.model.orderMothTotalDto];
            self.model.pgingData.data = [IncomeListModel mj_objectArrayWithKeyValuesArray:self.model.pgingData.data];
            if (self.pageNumber == 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:self.model.pgingData.data];
            [self.tableView endRefreshWithDataCount:self.model.pgingData.data.count];
            [self.tableView reloadData];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)selectTimeComplete:(NSString *)startTime endTime:(NSString *)endTime monthTime:(NSString *)monthTime isDaySelect:(BOOL)isDaySelect {
    
    if (startTime.length == 0 && endTime.length == 0 && monthTime.length == 0) {
        return;
    }
    
    self.isDaySelect = isDaySelect;
    self.selectMonth = monthTime;
    self.selectBeginDay = startTime;
    self.selectEndDay = endTime;
    self.secHeader.timeStr = _isDaySelect ? [NSString stringWithFormat:@"%@至%@",_selectBeginDay,_selectEndDay] : _selectMonth;
    [self requestList];
}


- (void)selectIncomeType {
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
    stringPickerView.title = @"选择收支类型";
    NSArray *arr = @[@"全部",@"收入",@"支出"];
    NSMutableArray *modelArr = [[NSMutableArray alloc]init];
    for (NSInteger i =0; i < arr.count; i++) {
        BRResultModel *brModel = [[BRResultModel alloc]init];
        brModel.key= @(i - 1).stringValue;
        if (i == 0) {
            brModel.key = @"";
        }
        brModel.value = arr[i];
        [modelArr addObject:brModel];
    }
    stringPickerView.dataSourceArr = [modelArr copy];
    DDWeakSelf;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        weakself.incomeType = resultModel.key;
        [weakself.paySelBtn setTitle:resultModel.value forState:UIControlStateNormal];
        [weakself requestList];
    };
    stringPickerView.pickerStyle = BR_Appearance;
    [stringPickerView show];
}

- (void)selectOrderType {
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]initWithPickerMode:BRStringPickerComponentSingle];
        stringPickerView.title = @"选择账单类型";
    NSArray *arr = @[@"全部",@"租约",@"记账",@"仪表"];
        NSMutableArray *modelArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < arr.count; i++) {
        BRResultModel *brModel = [[BRResultModel alloc]init];
        brModel.key= @(i).stringValue;
        if (i == 0) {
            brModel.key = @"";
        }
        brModel.value = arr[i];
        [modelArr addObject:brModel];
    }
    stringPickerView.dataSourceArr = [modelArr copy];
    DDWeakSelf;
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        weakself.orderType = resultModel.key;
        [weakself.orderTypeBtn setTitle:resultModel.value forState:UIControlStateNormal];
        [weakself requestList];
    };
    stringPickerView.pickerStyle = BR_Appearance;
    [stringPickerView show];
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
    return KFit_W(114);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.secHeader = [IncomeHeaderView headerWithTableView:tableView];
    self.secHeader.timeStr = _isDaySelect ? [NSString stringWithFormat:@"%@至%@",_selectBeginDay,_selectEndDay] : _selectMonth;
    self.secHeader.spendLab.text = [NSString stringWithFormat:@"支出 ¥%@",RightDataSafe(self.model.orderMothTotalDto.expenditureTotal)];
    self.secHeader.incomeLab.text = [NSString stringWithFormat:@"收入 ¥%@",RightDataSafe(self.model.orderMothTotalDto.incomeTotal)];
    DDWeakSelf;
    self.secHeader.selectBlock = ^{
        DateSelectVC *vc = [[DateSelectVC alloc] init];
        vc.isDaySelect = weakself.isDaySelect;
        vc.delegate = weakself;
        vc.daySelectDate = [TimeAbout stringToDateMonth:weakself.selectMonth];
        vc.beginSelectDate = [TimeAbout stringToDate:weakself.selectBeginDay];
        vc.endSelectDate = [TimeAbout stringToDate:weakself.selectEndDay];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return self.secHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IncomeDetailVC *vc = [[IncomeDetailVC alloc] init];
    vc.incomeID = [self.dataSource[indexPath.row] k_id];
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IncomeListCell *cell = [IncomeListCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end
