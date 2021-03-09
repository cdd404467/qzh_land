//
//  LeaseBillListCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LeaseBillListCell.h"
#import "NSString+Extension.h"

@interface LeaseBillListCell()
@property (nonatomic, strong)UILabel *zuyueNumLab;
@property (nonatomic, strong)UILabel *overdueLab;
@property (nonatomic, strong)UILabel *moneyLab;
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)UILabel *orderCycleLab;
@property (nonatomic, strong)UILabel *payDateLab;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *stateImage;
@end

@implementation LeaseBillListCell

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
        self.backgroundColor = TableColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = HEXColor(@"#F9AAA4", 1);
    bgView.layer.cornerRadius = 8.f;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-35);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(KFit_W(124));
    }];
    _bgView = bgView;
    
    UILabel *zuyueNumLab = [[UILabel alloc] init];
    zuyueNumLab.textColor = HEXColor(@"#333333", 1);
    zuyueNumLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [bgView addSubview:zuyueNumLab];
    [zuyueNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(KFit_W(14));
        make.height.mas_equalTo(KFit_W(20));
    }];
    _zuyueNumLab = zuyueNumLab;
    
    UILabel *overdueLab = [[UILabel alloc] init];
    overdueLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [bgView addSubview:overdueLab];
    [overdueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(zuyueNumLab.mas_right).offset(5);
        make.centerY.mas_equalTo(zuyueNumLab);
        make.height.mas_equalTo(KFit_W(20));
    }];
    _overdueLab = overdueLab;
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.textAlignment = NSTextAlignmentRight;
    moneyLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [bgView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(zuyueNumLab);
    }];
    _moneyLab = moneyLab;
    
    UIImageView *stateImage = [[UIImageView alloc] init];
    [bgView addSubview:stateImage];
    [stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(15);
        make.right.mas_equalTo(bgView.mas_right).offset(19);
        make.width.mas_equalTo(94);
        make.height.mas_equalTo(103);
    }];
    _stateImage = stateImage;
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textColor = UIColor.whiteColor;
    addressLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [bgView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(zuyueNumLab);
        make.top.mas_equalTo(zuyueNumLab.mas_bottom).offset(KFit_W(11));
        make.height.mas_equalTo(KFit_W(16));
        make.right.mas_equalTo(stateImage.mas_left).offset(5);
    }];
    _addressLab = addressLab;
    
    UILabel *orderCycleLab = [[UILabel alloc] init];
    orderCycleLab.textColor = UIColor.whiteColor;
    orderCycleLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [bgView addSubview:orderCycleLab];
    [orderCycleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressLab.mas_bottom).offset(KFit_W(7));
        make.height.left.mas_equalTo(addressLab);
        make.right.mas_equalTo(addressLab);
    }];
    _orderCycleLab = orderCycleLab;
    
    UILabel *payDateLab = [[UILabel alloc] init];
    payDateLab.textColor = UIColor.whiteColor;
    payDateLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [bgView addSubview:payDateLab];
    [payDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderCycleLab.mas_bottom).offset(KFit_W(7));
        make.height.left.mas_equalTo(addressLab);
        make.right.mas_equalTo(addressLab);
    }];
    _payDateLab = payDateLab;
}

- (void)setModel:(LeaseBillModel *)model {
    _model = model;
    if (model.stage.integerValue == 0) {
        _zuyueNumLab.text = [NSString stringWithFormat:@"%@-押金",model.sourcetypestr];
    } else {
        _zuyueNumLab.text = [NSString stringWithFormat:@"%@-%@期",model.sourcetypestr,model.stage];
    }
    NSString *price = model.status == 0 ? model.amountPayable.correctPrecision : model.amount.correctPrecision;
    _moneyLab.text = [NSString stringWithFormat:@"¥%@",price];
    _addressLab.text = [NSString stringWithFormat:@"地址: %@",model.adress];
    _orderCycleLab.text = [NSString stringWithFormat:@"账单周期: %@至%@",model.begintime,model.endtime];
    _payDateLab.text = [NSString stringWithFormat:@"支付日: %@",model.shoureceivetime];
    //未完成账单
    if (_type == 0) {
        //1 逾期XX天  2 今日支付  3 XX天后付款
        if (model.shoureceivetimeStatus == 1) {
            _bgView.backgroundColor = HEXColor(@"#F9AAA4", 1);
            _stateImage.image = [UIImage imageNamed:@"zuke_img_red"];
            _overdueLab.textColor = HEXColor(@"#D0021B", 1);
            _moneyLab.textColor = HEXColor(@"#D0021B", 1);
        } else if (model.shoureceivetimeStatus == 2) {
            _bgView.backgroundColor = HEXColor(@"#27C3CE", 1);
            _stateImage.image = [UIImage imageNamed:@"zuke_img_blue"];
            _overdueLab.textColor = HEXColor(@"#333333", 1);
            _moneyLab.textColor = HEXColor(@"#333333", 1);
        } else {
            _bgView.backgroundColor = HEXColor(@"#FBCF86", 1);
            _stateImage.image = [UIImage imageNamed:@"zuke_img_yellow"];
            _overdueLab.textColor = HEXColor(@"#333333", 1);
            _moneyLab.textColor = HEXColor(@"#AD7210", 1);
        }
        _overdueLab.text = [NSString stringWithFormat:@"(%@)",model.shoureceivetimeDesc];
    }
    //已完成账单
    else {
        _bgView.backgroundColor = HEXColor(@"#27C3CE", 1);
        _stateImage.image = [UIImage imageNamed:@"zuke_img_blue"];
        _overdueLab.text = @"";
        _overdueLab.textColor = HEXColor(@"#333333", 1);
    }
    
    
}

@end
