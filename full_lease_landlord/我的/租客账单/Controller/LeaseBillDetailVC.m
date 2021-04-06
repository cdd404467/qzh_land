//
//  LeaseBillDetailVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LeaseBillDetailVC.h"
#import "MyBillDetailCell.h"
#import "DictModel.h"
#import "LeaseBillModel.h"

@interface LeaseBillDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UILabel *txtLab;
@property (nonatomic, strong)UILabel *priceLab;
@property (nonatomic, strong)LeaseBillDetailHeader *tableHeader;
@end

@implementation LeaseBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"租客账单详情";
    self.navBar.backBtnTintColor = UIColor.whiteColor;
    self.navBar.titleColor = UIColor.whiteColor;
    self.navBar.backgroundColor = MainColor;
    self.view.backgroundColor = MainColor;
    [self.view addSubview:self.tableView];
    [self requestData];
}

- (NSMutableArray<DictModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (LeaseBillDetailHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[LeaseBillDetailHeader alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, KFit_W(250))];
        _tableHeader.isPay = NO;
    }
    return _tableHeader;
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_LeaseBill_Detail,_billID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            NSArray *keyArray = @[@"总金额",@"已支付",@"支付日",@"支付状态",@"地址",@"账单周期"];
            LeaseBillModel *data = [LeaseBillModel mj_objectWithKeyValues:json[@"data"]];
            data.tbillLandlordDetailListDTOSList = [tbillLandlordDetailListDTOSListModel mj_objectArrayWithKeyValuesArray:data.tbillLandlordDetailListDTOSList];
            NSArray *valueArray = @[data.amount,data.amountpaid,data.shoureceivetime,
                                    data.status == 0 ? @"未支付" : @"已支付",data.adress,
                                    [NSString stringWithFormat:@"%@至%@",data.begintime,data.endtime]
            ];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            for (NSInteger i = 0; i < keyArray.count; i++) {
                DictModel *model = [[DictModel alloc] init];
                model.key = keyArray[i];
                model.value = valueArray[i];
                [arr addObject:model];
            }
            NSMutableArray *arr_1 = [NSMutableArray arrayWithCapacity:0];
            for (tbillLandlordDetailListDTOSListModel *model in data.tbillLandlordDetailListDTOSList) {
                DictModel *d_model = [[DictModel alloc] init];
                d_model.key = model.billtype;
                d_model.value = model.amountpaid;
                [arr_1 addObject:d_model];
            }
            [self.dataSource addObject:arr];
            [self.dataSource addObject:arr_1];
            self.tableHeader.model = data;
            [self.tableView reloadData];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, NAV_HEIGHT, SCREEN_WIDTH - 30, SCREEN_HEIGHT - NAV_HEIGHT - Bottom_Height_Dif - 23) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MainColor;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif + 20, 0);
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 30)];
        [HelperTool drawRound:footer corner:UIRectCornerBottomLeft | UIRectCornerBottomRight radiu:5.f];
        footer.backgroundColor = UIColor.whiteColor;
        _tableView.tableHeaderView = self.tableHeader;
        _tableView.tableFooterView = footer;
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    return _tableView;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DictModel *model = self.dataSource[indexPath.section][indexPath.row];
    return ceil(model.height);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 60)];
        view.backgroundColor = UIColor.whiteColor;
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 40, 140, 20)];
        titleLab.text = @"账单明细";
        titleLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        titleLab.textColor = HEXColor(@"#333333", 1);
        [view addSubview:titleLab];
        return view;
    }
    return nil;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBillDetailCell *cell = [MyBillDetailCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end

@interface LeaseBillDetailHeader()
@property (nonatomic, strong)UILabel *txtLab;
@property (nonatomic, strong)UILabel *priceLab;
@property (nonatomic, strong)UILabel *desLab;
@property (nonatomic, strong)UIButton *payBtn;
@end

@implementation LeaseBillDetailHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [HelperTool drawRound:self corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:5.f];
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(10, KFit_W(38), self.width - 20, KFit_W(17))];
    txtLab.textAlignment = NSTextAlignmentCenter;
    txtLab.textColor = HEXColor(@"#999999", 1);
    txtLab.font = kFont(12);
    [self addSubview:txtLab];
    _txtLab = txtLab;
    
    UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(txtLab.left, txtLab.bottom + 6, txtLab.width, KFit_W(48))];
    priceLab.textColor = HEXColor(@"#333333", 1);
    priceLab.textAlignment = NSTextAlignmentCenter;
    priceLab.font = kFont(34);
    [self addSubview:priceLab];
    _priceLab = priceLab;
    
    UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(txtLab.left, priceLab.bottom + 3, txtLab.width, KFit_W(48))];
    desLab.textColor = HEXColor(@"#333333", 1);
    desLab.font = kFont(14);
    desLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:desLab];
    _desLab = desLab;
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(KFit_W(40), desLab.bottom + KFit_W(25), self.width - KFit_W(80), 44);
    payBtn.backgroundColor = MainColor;
    payBtn.layer.cornerRadius = 4.f;
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self addSubview:payBtn];
    _payBtn = payBtn;
}

- (void)setModel:(LeaseBillModel *)model {
    _model = model;
    if (model.status == 0) {
        _txtLab.text = @"待支付";
        _priceLab.text = model.amountPayable;
    } else {
        _txtLab.text = @"已支付";
        _priceLab.text = model.amountpaid;
        self.height = self.height - 60;
    }
    _desLab.text = model.title;
}

- (void)setIsPay:(BOOL)isPay {
    if (!isPay) {
        self.payBtn.hidden = YES;
        self.height = self.height - 44;
    }
}

@end
