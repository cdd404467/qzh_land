//
//  BankCardListCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BankCardListCell.h"

@interface BankCardListCell()
@property (nonatomic, strong)UILabel *bankNameLab;
@property (nonatomic, strong)UILabel *bankTypeLab;
@property (nonatomic, strong)UILabel *bankNumLab;
@property (nonatomic, strong)UIImageView *bgView;
@end

@implementation BankCardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.layer.cornerRadius = 6.f;
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = HEXColor(@"#27C3CE", 1);
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(112);
    }];
    _bgView = bgView;
    
//    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bankcard_logo"]];
//    [bgView addSubview:logoImage];
//    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(bgView);
//        make.right.mas_equalTo(-65);
//        make.size.mas_equalTo(CGSizeMake(124, 95));
//    }];
    
    UIButton *unBindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    unBindBtn.backgroundColor = HEXColor(@"#F8F8F8", 0.4);
    unBindBtn.layer.cornerRadius = 4.f;
    [unBindBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [unBindBtn setTitle:@"解绑" forState:UIControlStateNormal];
    unBindBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [unBindBtn addTarget:self action:@selector(unbindClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:unBindBtn];
    [unBindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake(50, 24));
    }];
    
    UILabel *bankNameLab = [[UILabel alloc] init];
    bankNameLab.textColor = UIColor.whiteColor;
    bankNameLab.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:bankNameLab];
    [bankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(29);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(unBindBtn);
    }];
    _bankNameLab = bankNameLab;
    
    UILabel *bankTypeLab = [[UILabel alloc] init];
    bankTypeLab.textColor = HEXColor(@"#EDEDED", 1);
    bankTypeLab.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:bankTypeLab];
    [bankTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankNameLab);
        make.top.mas_equalTo(bankNameLab.mas_bottom).offset(4);
        make.height.mas_equalTo(16);
    }];
    _bankTypeLab = bankTypeLab;
    
    UILabel *bankNumLab = [[UILabel alloc] init];
    bankNumLab.textColor = UIColor.whiteColor;
    bankNumLab.font = [UIFont systemFontOfSize:19];
    [bgView addSubview:bankNumLab];
    [bankNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankNameLab);
        make.top.mas_equalTo(bankTypeLab.mas_bottom).offset(17);
        make.height.mas_equalTo(26);
    }];
    _bankNumLab = bankNumLab;
}

- (void)setModel:(BankCardModel *)model {
    _model = model;
    _bankNameLab.text = model.bankname;
    _bankTypeLab.text = model.bankCardType;
    _bankNumLab.text = model.account;
    if (model.type == 1) {
        _bgView.image = [UIImage imageNamed:@"bankcard_Bg"];
    } else if (model.type == 2) {
        _bgView.image = [UIImage imageNamed:@"alipay_Bg"];
    } else {
        _bgView.image = [UIImage imageWithColor:UIColor.grayColor];
    }
}

- (void)unbindClick {
    if (self.unBindBlock) {
        self.unBindBlock(_model.bankCardID);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"BankCardListCell";
    BankCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[BankCardListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
