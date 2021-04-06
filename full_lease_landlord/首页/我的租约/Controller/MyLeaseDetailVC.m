//
//  MyLeaseDetailVC.m
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MyLeaseDetailVC.h"
#import "BankCardView.h"
#import "EmptyCompensationVC.h"
#import "ContractModel.h"
#import "ContactManagerVC.h"
#import "OwnerIfonVC.h"
#import "MyBillVC.h"
#import "PreviewConVC.h"

@interface MyLeaseDetailVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UILabel *moneyLab;
@property (nonatomic, strong)UILabel *centRankLab;
@property (nonatomic, strong)UILabel *gainsLab;
@property (nonatomic, strong)StageView *stView;
@end

@implementation MyLeaseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXColor(@"#f8f8f8", 1);
    self.navTitle = @"租约详情";
    [self requestData];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    }
    return _scrollView;
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
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_Con_Detail_Dep,_conID];
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
//        NSLog(@"----- %@",json);
        if ([json[@"code"] integerValue] == 200) {
            ContractModel *model = [ContractModel mj_objectWithKeyValues:json[@"data"]];
            model.grading = [GradingModel mj_objectArrayWithKeyValuesArray:model.grading];
            [self setupUI:model];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI:(ContractModel *)model {
    [self.view addSubview:self.scrollView];
    
    MyLeaseDetailTopView *topView = [[MyLeaseDetailTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(116))];
    topView.backgroundColor = UIColor.whiteColor;
    DDWeakSelf;
    topView.tapClick = ^(NSInteger index) {
        [weakself jumpIndex:index];
    };
    [self.scrollView addSubview:topView];
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bottom + KFit_W(16), SCREEN_WIDTH, 200)];
    bottomBgView.backgroundColor = topView.backgroundColor;
    [self.scrollView addSubview:bottomBgView];
    
    NSArray *titleArr = @[model.adress,@"合同周期",@"月租金"];
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc] init];
        lab.font = kFont(14);
        lab.text = titleArr[i];
        lab.textColor = HEXColor(@"#1C1C1C", 1);
        [bottomBgView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KFit_W(22));
            make.top.mas_equalTo(KFit_W(12) + KFit_W(20 + 25) * i);
            make.height.mas_equalTo(KFit_W(20));
            if (i == 0) {
                make.right.mas_equalTo(KFit_H(-80));
            }
        }];
        
        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.font = kFont(14);
        rightLab.textColor = HEXColor(@"#333333", 1);
        rightLab.textAlignment = NSTextAlignmentRight;
        [bottomBgView addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.mas_equalTo(lab);
            make.right.mas_equalTo(KFit_W(-22));
        }];
        if (i == 0) {
            [self configState:rightLab model:model];
        } else if (i == 1) {
            rightLab.text = [NSString stringWithFormat:@"%@到%@",model.begintime,model.endtime];
        } else {
            _moneyLab = rightLab;
            rightLab.text = model.recent;
        }
    }
    
    UILabel *stage_1 = [[UILabel alloc] init];
    stage_1.font = kFont(16);
    stage_1.text = @"租金分阶";
    stage_1.textColor = HEXColor(@"#262626", 1);
    [bottomBgView addSubview:stage_1];
    [stage_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(22));
        make.height.mas_equalTo(KFit_W(22));
        make.top.mas_equalTo(self.moneyLab.mas_bottom).offset(KFit_W(32));
    }];
    
    if (model.grading.count == 0) {
        UILabel *centRankLab = [[UILabel alloc] init];
        centRankLab.text = @"无";
        centRankLab.textColor = HEXColor(@"#999999", 1);
        centRankLab.font = kFont(14);
        [bottomBgView addSubview:centRankLab];
        [centRankLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(stage_1);
            make.height.mas_equalTo(KFit_W(16));
            make.top.mas_equalTo(stage_1.mas_bottom).offset(KFit_W(20));
        }];
        _centRankLab = centRankLab;
    } else {
        [stage_1.superview layoutIfNeeded];
        StageView *stView = [[StageView alloc] init];
        stView.gradetype = model.gradingtype;
        stView.gradeValue =model.gradingvalue;
        stView.dataSource = model.grading;
        stView.top = stage_1.bottom + 2;
        [bottomBgView addSubview:stView];
        _stView = stView;
    }

    //最高涨幅
    UILabel *maxGains = [[UILabel alloc] init];
    maxGains.font = kFont(16);
    maxGains.text = @"租金最高涨幅";
    maxGains.textColor = HEXColor(@"#262626", 1);
    [bottomBgView addSubview:maxGains];
    [maxGains mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(22));
        make.height.mas_equalTo(KFit_W(22));
        if (model.grading.count == 0) {
            make.top.mas_equalTo(self.centRankLab.mas_bottom).offset(KFit_W(32));
        } else {
            make.top.mas_equalTo(self.stView.mas_bottom).offset(KFit_W(15));
        }
    }];
    UILabel *gainsLab = [[UILabel alloc] init];
    gainsLab.text = model.highestincrease;
    gainsLab.font = kFont(14);
    gainsLab.textColor = HEXColor(@"#333333", 1);
    gainsLab.textAlignment = NSTextAlignmentRight;
    [bottomBgView addSubview:gainsLab];
    [gainsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.mas_equalTo(maxGains);
        make.right.mas_equalTo(KFit_W(-22));
    }];
    _gainsLab = gainsLab;

    UILabel *gainstxtLab = [[UILabel alloc] init];
    gainstxtLab.text = @"每年约定租金之上的最高涨幅";
    gainstxtLab.textColor = HEXColor(@"#999999", 1);
    gainstxtLab.font = kFont(14);
    [bottomBgView addSubview:gainstxtLab];
    [gainstxtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stage_1);
        make.height.mas_equalTo(KFit_W(16));
        make.top.mas_equalTo(maxGains.mas_bottom).offset(KFit_W(20));
    }];

    //收款账号
    UILabel *bankCardAccount = [[UILabel alloc] init];
    bankCardAccount.font = kFont(16);
    bankCardAccount.text = @"收款账号";
    bankCardAccount.textColor = HEXColor(@"#262626", 1);
    [bottomBgView addSubview:bankCardAccount];
    [bankCardAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(22));
        make.height.mas_equalTo(KFit_W(22));
        make.top.mas_equalTo(gainstxtLab.mas_bottom).offset(KFit_W(32));
    }];
    
    BankCardView *bankView = [[BankCardView alloc] init];
    bankView.bankCardNum = model.account;
    bankView.bankCardName = model.bank;
    [bottomBgView addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(KFit_W(-16));
        make.top.mas_equalTo(bankCardAccount.mas_bottom).offset(KFit_W(10));
        make.height.mas_equalTo(KFit_W(113));
    }];
    
//    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    changeBtn.layer.cornerRadius = 5.f;
//    changeBtn.layer.borderWidth = 0.5f;
//    changeBtn.layer.borderColor = HEXColor(@"#979797", 1).CGColor;
//    changeBtn.backgroundColor = UIColor.whiteColor;
//    [changeBtn setTitle:@"换绑银行卡" forState:UIControlStateNormal];
//    [changeBtn setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
//    changeBtn.titleLabel.font = kFont(14);
//    [bottomBgView addSubview:changeBtn];
//    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(KFit_W(16));
//        make.width.mas_equalTo(KFit_W(162));
//        make.height.mas_equalTo(KFit_W(44));
//        make.top.mas_equalTo(bankView.mas_bottom).offset(53);
//    }];
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    contactBtn.layer.cornerRadius = 5.f;
    contactBtn.backgroundColor = MainColor;
    [contactBtn setTitle:@"联系管家" forState:UIControlStateNormal];
    [contactBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [contactBtn addTarget:self action:@selector(jumpToContactManager) forControlEvents:UIControlEventTouchUpInside];
    contactBtn.titleLabel.font = kFont(14);
    [bottomBgView addSubview:contactBtn];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-16));
        make.left.mas_equalTo(KFit_W(16));
        make.height.mas_equalTo(KFit_W(44));
        make.top.mas_equalTo(bankView.mas_bottom).offset(53);
    }];
    
    [contactBtn.superview layoutIfNeeded];
    bottomBgView.height = contactBtn.bottom + 30;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, bottomBgView.bottom);
}

- (void)jumpToContactManager {
    ContactManagerVC *vc = [[ContactManagerVC alloc] init];
    vc.conID = _conID;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)configState:(UILabel *)lab model:(ContractModel *)model {
    //1-待签约 4-待搬入5在租 6逾期 7已退租8 作废 9 退租审批中 10 退租未结账 2-续租在租
    NSString *title = [NSString string];
    UIColor *color = MainColor;
    if (model.status == 1) {
        title = @"待签约";
        color = HEXColor(@"#FFA200", 1);
    } else if (model.status == 2) {
        title = @"续租在租";
    } else if (model.status == 4) {
        title = @"待搬入";
    } else if (model.status == 5) {
        title = @"在租中";
    } else if (model.status == 6) {
        title = @"逾期";
    } else if (model.status == 7) {
        title = @"已退租";
        color = HEXColor(@"#BBBABB", 1);
    } else if (model.status == 8) {
        title = @"作废";
    } else if (model.status == 13) {
        title = @"退租审核中";
    } else if (model.status == 10) {
        title = @"退租未结账";
    } else {
        title = @"- - !";
        color = MainColor;
    }
    lab.text = title;
    lab.textColor = color;
}


@end

@implementation MyLeaseDetailTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    NSArray *titleArr = @[@"业主信息",@"账单信息",@"下载电子合同"];
    NSArray *iconArr = @[@"zuyue_icon_download_con",@"zuyue_icon_info",@"zuyue_icon_order"];
    
    CGFloat width = KFit_W(48);
    CGFloat leftGap = KFit_W(45);
    CGFloat centerGap = (SCREEN_WIDTH - leftGap * 2 - width * titleArr.count) / (titleArr.count - 1);
    
    for (NSInteger i = 0;i < titleArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = width / 2;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:iconArr[i]];
        imageView.tag = i;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftGap + i * (width + centerGap));
            make.width.height.mas_equalTo(width);
            make.top.mas_equalTo(22);
        }];
        [HelperTool addTapGesture:imageView withTarget:self andSEL:@selector(tapView:)];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.text = titleArr[i];
        nameLab.numberOfLines = 2;
        nameLab.textColor = HEXColor(@"#262626", 1);
        nameLab.font = kFont(13);
        nameLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView);
            make.top.mas_equalTo(imageView.mas_bottom).offset(9);
        }];
    }
}

- (void)tapView:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIImageView *tapView = (UIImageView *)tap.view;
    if (self.tapClick) {
        self.tapClick(tapView.tag);
    }
}
@end

@implementation StageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(16, 0, SCREEN_WIDTH - 32, 10);
    }
    return self;
}

- (void)setupUI {
    UILabel *perLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, KFit_W(20))];
    NSString *leftStr = [NSString string];
    NSString *rightStr = [NSString string];
    if (_gradetype == 1) {
        leftStr = @"按比例逐年新增";
        rightStr = [_gradeValue stringByAppendingFormat:@"%%"];
    } else if (_gradetype == 2) {
        leftStr = @"按金额逐年新增";
        rightStr = _gradeValue;
    } else {
        leftStr = @"自定义";
        rightStr = _gradeValue;
    }
    
    perLab.text = leftStr;
    perLab.textColor = HEXColor(@"333333", 1);
    perLab.font = kFont(14);
    [self addSubview:perLab];
    
    UILabel *percent = [[UILabel alloc] init];
    percent.text = rightStr;
    percent.textAlignment = NSTextAlignmentRight;
    percent.font = kFont(14);
    percent.textColor = HEXColor(@"333333", 0.8);
    [self addSubview:percent];
    [percent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(perLab);
    }];
    
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(perLab.left, perLab.bottom + 16, perLab.width, KFit_W(20))];
    txtLab.text = @"每年月租金";
    txtLab.textColor = HEXColor(@"333333", 1);
    txtLab.font = kFont(14);
    [self addSubview:txtLab];
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        GradingModel *model = _dataSource[i];
        UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(txtLab.left, txtLab.bottom + 10 * (i + 1) + 20 * i, KFit_W(100), 20)];
        leftLab.text = model.chinaAnnual;
        leftLab.textColor = HEXColor(@"333333", 0.8);
        leftLab.font = kFont(14);
        [self addSubview:leftLab];
        
        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.text = [NSString stringWithFormat:@"¥%@",model.amount];
        rightLab.textColor = HEXColor(@"333333", 1);
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = kFont(14);
        [self addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftLab);
            make.right.mas_equalTo(percent);
        }];
        
        if (i == self.dataSource.count - 1) {
            self.height = leftLab.bottom + 10;
        }
    }

}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self setupUI];
}


@end
