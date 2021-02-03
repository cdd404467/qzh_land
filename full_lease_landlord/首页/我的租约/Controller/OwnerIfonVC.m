//
//  OwnerIfonVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/31.
//  Copyright © 2020 apple. All rights reserved.
//

#import "OwnerIfonVC.h"
#import "BankCardView.h"
#import "LandInfoModel.h"

@interface OwnerIfonVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)LandInfoModel *dataSource_land;
@property (nonatomic, strong)LeaseInfoModel *dataSource_lease;
@end

@implementation OwnerIfonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = _type == 1 ? @"业主信息" : @"租客信息";
    [self requestData];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        _scrollView.backgroundColor = HEXColor(@"#F5F5F5", 1);
    }
    return _scrollView;
}

- (void)requestData {
    NSString *urlString = [NSString string];
    if (_type == 1) {
        urlString = [NSString stringWithFormat:URLGet_Check_LandInfo,_conID];
    } else if (_type == 2) {
        urlString = [NSString stringWithFormat:URLGet_Check_LeaseInfo,_conID];
    }
    
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        NSLog(@"----- %@",json);
        if (JsonCode == 200) {
            if (self.type == 1) {
                self.dataSource_land = [LandInfoModel mj_objectWithKeyValues:json[@"data"]];
            } else if (self.type == 2) {
                self.dataSource_lease= [LeaseInfoModel mj_objectWithKeyValues:json[@"data"]];
            }
            [self setupUI];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    NSArray *titleArr = @[@"姓名",@"电话",@"身份证",@"实名认证"];
    NSArray *textArr = [NSArray array];

    if (_type == 1) {
        textArr = @[RightDataSafe(_dataSource_land.name),
                    RightDataSafe(_dataSource_land.phone),
                    RightDataSafe(_dataSource_land.document),
                    _dataSource_land.certification == 1 ? @"已认证" : @"未认证"
        ];
    } else if (_type == 2) {
        textArr = @[RightDataSafe(_dataSource_lease.name),
                    RightDataSafe(_dataSource_lease.phone),
                    RightDataSafe(_dataSource_lease.document),
                    _dataSource_lease.issign == 1 ? @"已认证" : @"未认证"
        ];
    }
    
    CGFloat height = 0;
    for (NSInteger i = 0;i < 4; i++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 48 * i, SCREEN_WIDTH, 48)];
        bgView.backgroundColor = UIColor.whiteColor;
        [self.scrollView addSubview:bgView];
        if (i == 3) {
            bgView.top = bgView.top + 8;
            height = bgView.bottom;
        }
        
        UILabel *leftLab = [[UILabel alloc] init];
        leftLab.textColor = HEXColor(@"#1C1C1C", 1);
        leftLab.font = [UIFont systemFontOfSize:14];
        leftLab.text = titleArr[i];
        [bgView addSubview:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.mas_equalTo(bgView);
            make.width.mas_equalTo(80);
        }];
        
        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.font = [UIFont systemFontOfSize:14];
        rightLab.text = textArr[i];
        [bgView addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.centerY.mas_equalTo(bgView);
        }];
        if (i == 3) {
            if (_type == 1) {
                rightLab.textColor = _dataSource_land.certification == 1 ? MainColor : HEXColor(@"#999999", 1);
            } else {
                rightLab.textColor = _dataSource_lease.issign == 1 ? MainColor : HEXColor(@"#999999", 1);
            }
            
        }
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = HEXColor(@"#EEEEEE", 1);
        [bgView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    if (_type == 1) {
        UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(16, height + 26, 200, 22)];
        txtLab.text = @"收款账号";
        txtLab.font = [UIFont systemFontOfSize:15];
        txtLab.textColor = HEXColor(@"#333333", 1);
        [self.scrollView addSubview:txtLab];
        
        BankCardView *bankView = [[BankCardView alloc] init];
        bankView.bankCardNum = _dataSource_land.bankcarNo;
        bankView.bankCardName = _dataSource_land.bank;
        [self.scrollView addSubview:bankView];
        [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(16);
            make.right.mas_equalTo(self.view.mas_right).offset(-16);
            make.top.mas_equalTo(txtLab.mas_bottom).offset(12);
            make.height.mas_equalTo(KFit_W(113));
        }];
    }
}


@end
