//
//  MyLeaseDetail2VC.m
//  full_lease_landlord
//
//  Created by apple on 2021/3/23.
//  Copyright © 2021 apple. All rights reserved.
//

#import "MyLeaseDetail2VC.h"
#import "UILabel+Insets.h"
#import "full_lease_landlord-Swift.h"
#import "ContactManagerVC.h"
#import "NSString+Extension.h"
#import "OwnerIfonVC.h"
#import "MyBillVC.h"
#import "PreviewConVC.h"
#import "ContractConfirmVC.h"


@interface MyLeaseDetail2VC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)MyLeaseDetailTBHeader *headerView;
@property (nonatomic, strong)ContractModel *dataSource;
@end

@implementation MyLeaseDetail2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"租约详情";
    self.navBar.backgroundColor = HEXColor(@"#ffffff", 0);
    [self.view insertSubview:self.tableView belowSubview:self.navBar];
    [self requestData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.sectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, KFit_W(16), 0, KFit_W(16));
        _tableView.separatorColor = HEXColor(@"#EEEEEE", 1);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif + 20, 0);
        _tableView.bounces = NO;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [self addFooter];
    }
    return _tableView;
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Con_Detail,_conID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----- %@",json);
        if ([json[@"code"] integerValue] == 200) {
            self.dataSource = [ContractModel mj_objectWithKeyValues:json[@"data"]];
            self.dataSource.grading = [GradingModel mj_objectArrayWithKeyValuesArray:self.dataSource.grading];
            self.dataSource.trentFree = [TrentFreeModel mj_objectArrayWithKeyValuesArray:self.dataSource.trentFree];
            self.dataSource.otherDeposit = [OtherModel mj_objectArrayWithKeyValuesArray:self.dataSource.otherDeposit];
            self.dataSource.extraCharge = [OtherModel mj_objectArrayWithKeyValuesArray:self.dataSource.extraCharge];
            self.headerView.addressLab.text = self.dataSource.adress;
            self.headerView.stateTxt = self.dataSource.statusStr;
            [self.tableView reloadData];
            [self.headerView disPlayDownLoad:self.dataSource];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (MyLeaseDetailTBHeader *)headerView {
    if (!_headerView) {
        _headerView = [[MyLeaseDetailTBHeader alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(265));
        DDWeakSelf;
        _headerView.tapClick = ^(NSInteger index) {
            [weakself jumpIndex:index];
        };
        _headerView.goSign = ^{
            ContractConfirmVC *vc = [[ContractConfirmVC alloc] init];
            vc.conID = weakself.conID;
            vc.type = 2;
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headerView;
}

- (void)jumpIndex:(NSInteger)index {
    if (index == 0) {
        OwnerIfonVC *vc = [[OwnerIfonVC alloc] init];
        vc.type = 1;
        vc.conID = _conID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 1) {
        MyBillVC *vc = [[MyBillVC alloc] init];
        vc.conID = _conID;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        PreviewConVC *vc = [[PreviewConVC alloc] init];
        vc.conID = _conID;
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)addFooter {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(110));
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.layer.cornerRadius = 5.f;
    contactBtn.backgroundColor = MainColor;
    [contactBtn setTitle:@"联系管家" forState:UIControlStateNormal];
    [contactBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [contactBtn addTarget:self action:@selector(jumpToContactManager) forControlEvents:UIControlEventTouchUpInside];
    contactBtn.titleLabel.font = kFont(14);
    [view addSubview:contactBtn];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-16));
        make.left.mas_equalTo(KFit_W(16));
        make.height.mas_equalTo(KFit_W(44));
        make.bottom.mas_equalTo(0);
    }];
    
    return view;
}

- (void)jumpToContactManager {
    ContactManagerVC *vc = [[ContactManagerVC alloc] init];
    vc.conID = _conID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentY = scrollView.contentOffset.y;
    CGFloat handY = KFit_W(60);
    if (currentY <= handY && currentY >= 0) {
        self.navTitle = @"租约详情";
        self.navBar.backgroundColor = HEXColor(@"#ffffff", currentY / handY);
        self.navBar.titleLabel.alpha = (handY - currentY) / handY + 0.1;
    } else if (currentY > handY && currentY <= handY * 2) {
        self.navTitle = self.dataSource.adress;
        self.navBar.backgroundColor = HEXColor(@"#ffffff", 1);
        self.navBar.titleLabel.alpha = (currentY - handY) / handY + 0.1;
    }
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}


//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return self.dataSource.grading.count;
    } else if (section == 2) {
        return self.dataSource.trentFree.count;
    } else if (section == 3) {
        return self.dataSource.otherDeposit.count;
    } else if (section == 4) {
        return self.dataSource.extraCharge.count;
    }
    return 1;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return KFit_W(56);
    } else if (indexPath.section == 1) {
        return self.dataSource.grading.count == 0 ? 0 : KFit_W(56);
    } else if (indexPath.section == 2) {
        return self.dataSource.trentFree.count == 0 ? 0 : KFit_W(52);
    } else if (indexPath.section == 3) {
        return self.dataSource.otherDeposit.count == 0 ? 0 : KFit_W(52);
    } else if (indexPath.section == 4) {
        return self.dataSource.extraCharge.count == 0 ? 0 : KFit_W(52);
    }
    return KFit_W(56);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return self.dataSource.grading.count == 0 ? 0 : KFit_W(45);
    } else if (section == 2) {
        return self.dataSource.trentFree.count == 0 ? 0 : KFit_W(45);
    } else if (section == 3) {
        return self.dataSource.otherDeposit.count == 0 ? 0 : KFit_W(45);
    } else if (section == 4) {
        return self.dataSource.extraCharge.count == 0 ? 0 : KFit_W(45);
    }
    return KFit_W(45);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titleArr = @[@"",@"租金分阶",@"免租期",@"加收费用",@"其他押金",@"收款账号"];
    MyLeaseDetailSecHeader *header = [tableView cddDequeueReusableHeaderFooter:MyLeaseDetailSecHeader.class];
    header.nameLab.text = titleArr[section];
    return header;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyLeaseDetailCell *cell = [tableView cddDequeueReusableCell:MyLeaseDetailCell.class];
    if (indexPath.section == 0) {
        NSArray *titleArr = @[@"合同周期",@"月租金",@"付款方式",@"支付时间"];
        NSArray *subTitleArr = @[[NSString stringWithFormat:@"%@至%@",RightDataSafe(self.dataSource.begintime),RightDataSafe(self.dataSource.endtime)],
                                [NSString stringWithFormat:@"¥%@",RightDataSafe(self.dataSource.recent)],
                                [NSString stringWithFormat:@"%@%@",RightDataSafe(self.dataSource.pinlvStr),RightDataSafe(self.dataSource.deposittypeStr)],
                                RightDataSafe(self.dataSource.paymentTime)];
        cell.leftLab.text = titleArr[indexPath.row];
        cell.rightLab.text = subTitleArr[indexPath.row];
    } else if (indexPath.section == 1) {
        GradingModel *model = self.dataSource.grading[indexPath.row];
        cell.leftLab.text = model.chinaAnnual;
        cell.rightLab.text = [NSString stringWithFormat:@"¥%@/月",model.amount];
    } else if (indexPath.section == 2) {
        TrentFreeModel *model = self.dataSource.trentFree[indexPath.row];
        cell.leftLab.text = [NSString stringWithFormat:@"%@至%@",model.begin,model.end];
        cell.rightLab.text = [NSString stringWithFormat:@"¥%@",model.amount.correctPrecision];
    } else if (indexPath.section == 3) {
        OtherModel *model = self.dataSource.otherDeposit[indexPath.row];
        cell.leftLab.text = model.name;
        cell.rightLab.text = [NSString stringWithFormat:@"¥%@(%@)",model.amount.correctPrecision,model.pinlvStr];
    } else if (indexPath.section == 4) {
        OtherModel *model = self.dataSource.extraCharge[indexPath.row];
        cell.leftLab.text = model.name;
        cell.rightLab.text = [NSString stringWithFormat:@"¥%@",model.amount.correctPrecision];
    } else {
        cell.leftLab.text = self.dataSource.bank;
        if (isRightData(self.dataSource.bankCardType)) {
            cell.subLab.text = self.dataSource.bankCardType;
        }
        cell.rightLab.text = self.dataSource.account;
    }
    cell.subLab.hidden = indexPath.section == 5 ? NO : YES;
    return cell;
}

@end

@interface MyLeaseDetailTBHeader()
@property (nonatomic, strong)UILabel *stateLab;
@property (nonatomic, strong)UIButton *goSignBtn;
@end

@implementation MyLeaseDetailTBHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self performSelector:@selector(setupUI)];
    }
    return self;
}

- (void)setupUI {
    UIImageView *bgImg = [[UIImageView alloc] init];
    bgImg.image = [UIImage imageNamed:@"zuyue_header_bg"];
    bgImg.userInteractionEnabled = YES;
    [self addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zuyue_address_sign"]];
    icon.frame = CGRectMake(KFit_W(18), KFit_W(116), KFit_W(44), KFit_W(44));
    [bgImg addSubview:icon];
    
    UIButton *goSignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goSignBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [goSignBtn setTitle:@"去签约" forState:UIControlStateNormal];
    [goSignBtn setTitleColor:MainColor forState:UIControlStateNormal];
    goSignBtn.adjustsImageWhenHighlighted = NO;
    goSignBtn.hidden = YES;
    [goSignBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [goSignBtn addTarget:self action:@selector(goSignPage) forControlEvents:UIControlEventTouchUpInside];
    [bgImg addSubview:goSignBtn];
    [goSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-KFit_W(12));
        make.top.mas_equalTo(icon);
        make.height.mas_equalTo(25);
    }];
    _goSignBtn = goSignBtn;
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.font = [UIFont systemFontOfSize:17];;
    addressLab.textColor = HEXColor(@"#111111", 1);
    [bgImg addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(12);
        make.top.mas_equalTo(icon);
        make.height.mas_equalTo(25);
    }];
    _addressLab = addressLab;
    
    UILabel *stateLab = [[UILabel alloc] init];
    stateLab.contentInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    stateLab.textColor = MainColor;
    stateLab.font = [UIFont systemFontOfSize:12];
    stateLab.layer.borderWidth = .5f;
    stateLab.layer.borderColor = MainColor.CGColor;
    stateLab.layer.cornerRadius = 3;
    [bgImg addSubview:stateLab];
    
    [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressLab);
        make.bottom.mas_equalTo(icon);
        make.height.mas_equalTo(20);
    }];
    
    _stateLab = stateLab;
    
    NSArray *titleArr = @[@"业主信息",@"账单信息",@"下载电子合同"];
    NSArray *iconArr = @[@"zuyue_icon2_yzinfo",@"zuyue_icon2_order",@"zuyue_icon2_download"];
    CGFloat width = KFit_W(77);
    CGFloat leftGap = KFit_W(23);
    CGFloat rightGap = KFit_W(90);
    CGFloat centerGap = (SCREEN_WIDTH - leftGap - width * titleArr.count - rightGap) / (titleArr.count - 1);
    
    for (NSInteger i = 0;i < titleArr.count; i++) {
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.tag = i;
        [iconBtn setTitleColor:HEXColor(@"#999999", 1) forState:UIControlStateNormal];
        iconBtn.titleLabel.font = kFont(12);
        [iconBtn setImage:[UIImage imageNamed:iconArr[i]] forState:UIControlStateNormal];
        [iconBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        iconBtn.adjustsImageWhenHighlighted = NO;
        [iconBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [iconBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:8];
        [self addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftGap + (width + centerGap) * i);
            make.top.mas_equalTo(icon.mas_bottom).offset(KFit_W(35));
            make.height.mas_equalTo(KFit_W(50));
            make.width.mas_equalTo(width);
        }];
        if (i == 2) {
            iconBtn.hidden = YES;
        }
    }
}

- (void)setStateTxt:(NSString *)stateTxt {
    self.stateLab.text = stateTxt;
    [self.stateLab.superview layoutIfNeeded];
    [self.stateLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.stateLab.width + 17);
    }];
}

- (void)clickBtn:(UIButton *)sender {
    if (self.tapClick) {
        self.tapClick(sender.tag);
    }
}

- (void)goSignPage {
    if (self.goSign) {
        self.goSign();
    }
}

- (void)disPlayDownLoad:(ContractModel *)model {
    UIButton *btn = (UIButton *)[self viewWithTag:2];
    //待签约显示去签约按钮，没有合同下载
    if (model.status == 1) {
        [self.addressLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.goSignBtn.mas_left).offset(-2);
            self.goSignBtn.hidden = NO;
        }];
        btn.hidden = YES;
    }
    //不是待签约
    else {
        [self.addressLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            self.goSignBtn.hidden = YES;
        }];
        //电子合同
        if (model.eleccontract == 2) {
            btn.hidden = NO;
        }
        //纸质合同
        else {
            btn.hidden = YES;
        }
    }
}
@end
