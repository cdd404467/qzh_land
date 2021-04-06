//
//  MyBillDetailVC.m
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MyBillDetailVC.h"
#import "MyBillDetailCell.h"
#import "DictModel.h"
#import "BillModel.h"
#import "PayVC.h"


@interface MyBillDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<DictModel *> *dataSource;
@property (nonatomic, strong)MyBillDetailHeader *tableHeader;
@property (nonatomic, strong)BillModel *data;
@end

@implementation MyBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"账单详情";
    self.navBar.backBtnTintColor = UIColor.whiteColor;
    self.navBar.titleColor = UIColor.whiteColor;
    self.navBar.backgroundColor = MainColor;
    self.view.backgroundColor = MainColor;
    [self.view addSubview:self.tableView];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:NotificationName_PayMoneySuccess object:nil];
}

- (NSMutableArray<DictModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (MyBillDetailHeader *)tableHeader {
    if (!_tableHeader) {
        _tableHeader = [[MyBillDetailHeader alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, KFit_W(250))];
        DDWeakSelf;
        _tableHeader.clickPay = ^{
            PayVC *vc = [[PayVC alloc] init];
            vc.billID = weakself.data.billID;
            vc.recent = weakself.data.amountPayable;
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _tableHeader;
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_MyBill_Detail,_billID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            NSArray *keyArray = @[@"总金额",@"已支付",@"支付日",@"支付状态",@"地址",@"账单周期",@"账单说明"];
            self.data = [BillModel mj_objectWithKeyValues:json[@"data"]];
            NSArray *valueArray = @[self.data.amount,self.data.amountpaid,self.data.shoureceivetime,
                                    self.data.status == 0 ? @"未支付" : @"已支付",self.data.adress,
                                    [NSString stringWithFormat:@"%@至%@",self.data.begintime,self.data.endtime],
                                    self.data.explain
            ];
            for (NSInteger i = 0; i < keyArray.count; i++) {
                DictModel *model = [[DictModel alloc] init];
                model.key = keyArray[i];
                model.value = valueArray[i];
                [self.dataSource addObject:model];
            }
            self.tableHeader.model = self.data;
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
        footer.backgroundColor = UIColor.whiteColor;
        [HelperTool drawRound:footer corner:UIRectCornerBottomLeft | UIRectCornerBottomRight radiu:5.f];
        _tableView.tableHeaderView = self.tableHeader;
        _tableView.tableFooterView = footer;
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
    return self.dataSource[indexPath.row].height;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBillDetailCell *cell = [MyBillDetailCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}



//修改statesBar颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

@interface MyBillDetailHeader()
@property (nonatomic, strong)UILabel *txtLab;
@property (nonatomic, strong)UILabel *priceLab;
@property (nonatomic, strong)UILabel *desLab;
@property (nonatomic, strong)UIButton *payBtn;
@end

@implementation MyBillDetailHeader
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
    [payBtn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payBtn];
    _payBtn = payBtn;
}

- (void)goPay {
    if (self.clickPay) {
        self.clickPay();
    }
}

- (void)setModel:(BillModel *)model {
    _model = model;
    if (model.status == 0) {
        _txtLab.text = @"待支付";
        _priceLab.text = model.amountPayable;
        _payBtn.hidden = NO;
    } else {
        _txtLab.text = @"已支付";
        _priceLab.text = model.amountpaid;
        _payBtn.hidden = YES;
        self.height = self.height - 60;
    }
    _desLab.text = model.title;
}

@end
