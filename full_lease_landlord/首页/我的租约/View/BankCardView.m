//
//  BankCardView.m
//  FullLease
//
//  Created by wz on 2020/8/8.
//  Copyright © 2020 kad. All rights reserved.
//

#import "BankCardView.h"

@interface BankCardView()
@property (nonatomic, strong)UILabel *bankNumLab;
@property (nonatomic, strong)UILabel *bankName;
@end

@implementation BankCardView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return  self;
}

-(void)setupUI {
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"bank_card"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UILabel *bankName = [[UILabel alloc] init];
    bankName.textColor = [UIColor whiteColor];
    bankName.font = kFont(16);
    [imageView addSubview:bankName];
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(28));
        make.top.mas_equalTo(KFit_W(20));
        make.right.mas_equalTo(KFit_W(-100));
        make.height.mas_equalTo(KFit_W(26));
    }];
    _bankName = bankName;
    
    
//    UIButton *unbundleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, JCWidth(48), JCWidth(20))];
//    [unbundleBtn setTitle:@"解绑" forState:UIControlStateNormal];
//    [unbundleBtn setTitleColor:color_theme forState:UIControlStateNormal];
//    unbundleBtn.backgroundColor = [UIColor whiteColor];
//    unbundleBtn.layer.cornerRadius = JCWidth(10);
//    unbundleBtn.titleLabel.font = kFont(12);
//    unbundleBtn.right = viewW - JCWidth(28);
//    unbundleBtn.top = JCWidth(18);
//    [imageView addSubview:unbundleBtn];
//    [unbundleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.right.mas_equalTo();
//    }];
    
    UILabel *bankType = [[UILabel alloc] init];
    bankType.text = @"储蓄卡";
    bankType.textColor = UIColor.whiteColor;
    bankType.font = kFont(13);
    [imageView addSubview:bankType];
    [bankType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankName);
        make.top.mas_equalTo(bankName.mas_bottom).offset(2);
        make.height.mas_equalTo(KFit_W(20));
    }];
    
    UILabel *bankNumLab = [[UILabel alloc] init];
    bankNumLab.textColor = UIColor.whiteColor;
    bankNumLab.font = bkFont(18);
    [imageView addSubview:bankNumLab];
    [bankNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankType);
        make.height.mas_equalTo(KFit_W(25));
        make.top.mas_equalTo(bankType.mas_bottom).offset(3);
    }];
    _bankNumLab = bankNumLab;
    
}

- (void)setBankCardNum:(NSString *)bankCardNum {
    _bankCardNum = bankCardNum;
    if (bankCardNum.length > 4) {
        _bankNumLab.text = [NSString stringWithFormat:@"· · ·   · · ·   · · ·   %@",[bankCardNum substringFromIndex:bankCardNum.length - 4]];
    } else {
        _bankNumLab.text = bankCardNum;
    }
}

- (void)setBankCardName:(NSString *)bankCardName {
    _bankCardName = bankCardName;
    _bankName.text = bankCardName;
}

@end
