//
//  MyBankCardListCheckVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MyBankCardListCheckVC.h"
#import "MyBankCardCheckCell.h"
#import "CheckBankCardNumVC.h"

@interface MyBankCardListCheckVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)NSInteger selectPayType;
@end

@implementation MyBankCardListCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"忘记支付密码";
    self.selectPayType = 0;
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = TableColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self addTableHeader];
        _tableView.tableFooterView = [self addTableFooter];
        //点击切换时默认选中第一个
        NSIndexPath *ip = [NSIndexPath indexPathForRow:self.selectPayType inSection:0];
        [_tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
         
    }
    return _tableView;
}

- (UIView *)addTableHeader {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 16, view.width - 30, 20)];
    tipLab.textColor = HEXColor(@"#999999", 1);
    tipLab.font = [UIFont systemFontOfSize:14];
    tipLab.text = @"选择任意银行卡进行验证";
    [view addSubview:tipLab];
    return view;
}

- (UIView *)addTableFooter {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.layer.cornerRadius = 4.f;
    [nextBtn setBtnWithTitle:@"下一步" titleColor:UIColor.whiteColor font:KFit_W(18)];
    nextBtn.backgroundColor = MainColor;
    [nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.height.mas_equalTo(49);
    }];
    return view;
}

- (void)nextStep {
    CheckBankCardNumVC *vc = [[CheckBankCardNumVC alloc] init];
    BankCardModel *model = self.dataSource[self.selectPayType];
    vc.lastFourNum = model.account;
    vc.bankCardID = model.bankCardID;
    vc.idCardNum = self.idCardNum;
    vc.phoneNum = self.phoneNum;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KFit_W(70);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectPayType = indexPath.row;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBankCardCheckCell *cell = [MyBankCardCheckCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
@end
