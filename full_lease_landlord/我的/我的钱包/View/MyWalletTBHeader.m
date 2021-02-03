//
//  MyWalletTBHeader.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MyWalletTBHeader.h"

@interface MyWalletTBHeader()
@property (nonatomic, strong)UILabel *remainLab;
@property (nonatomic, strong)UILabel *addupLab;
@end

@implementation MyWalletTBHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage imageNamed:@"mywallet_topBg"];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(8);
        make.right.bottom.mas_equalTo(-8);
    }];
    
    UILabel *txtRemainLab = [[UILabel alloc] init];
    txtRemainLab.text = @"钱包余额(元)";
    txtRemainLab.font = kFont(12);
    txtRemainLab.textColor = UIColor.whiteColor;
    [bgView addSubview:txtRemainLab];
    [txtRemainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(KFit_W(28));
        make.height.mas_equalTo(KFit_W(16));
    }];
    
    UILabel *remainLab = [[UILabel alloc] init];
    remainLab.font = kFont(36);
    remainLab.textColor = UIColor.whiteColor;
    [bgView addSubview:remainLab];
    [remainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(txtRemainLab);
        make.top.mas_equalTo(txtRemainLab.mas_bottom).offset(5);
        make.height.mas_equalTo(KFit_W(50));
        make.right.mas_equalTo(-80);
    }];
    _remainLab = remainLab;
    
    UIButton *withdrawalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withdrawalBtn.backgroundColor = UIColor.whiteColor;
    [withdrawalBtn setTitle:@"提现" forState:UIControlStateNormal];
    [withdrawalBtn setTitleColor:MainColor forState:UIControlStateNormal];
    withdrawalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    withdrawalBtn.layer.cornerRadius = 4.f;
    [withdrawalBtn addTarget:self action:@selector(tixian) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:withdrawalBtn];
    [withdrawalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(remainLab);
        make.right.mas_equalTo(-18);
        make.size.mas_equalTo(CGSizeMake(51, KFit_W(22)));
    }];
    
    UIImageView *addupImage = [[UIImageView alloc] init];
    addupImage.image = [UIImage imageNamed:@"addup_icon"];
    [self addSubview:addupImage];
    [addupImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(txtRemainLab);
        make.bottom.mas_equalTo(KFit_W(-32));
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    UILabel *addupLab = [[UILabel alloc] init];
    addupLab.font = kFont(12);
    addupLab.textColor = UIColor.whiteColor;
    [self addSubview:addupLab];
    [addupLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(addupImage);
        make.left.mas_equalTo(addupImage.mas_right).offset(6);
    }];
    _addupLab = addupLab;
}

- (void)tixian {
    if (self.tixianBlock) {
        self.tixianBlock();
    }
}

- (void)setRemainMoney:(NSString *)remainMoney {
    _remainMoney = remainMoney;
    _remainLab.text = remainMoney;
}

- (void)setAddupMoney:(NSString *)addupMoney {
    _addupMoney = addupMoney;
    _addupLab.text = [NSString stringWithFormat:@"累计收益：%@（元）",addupMoney];
}
@end

