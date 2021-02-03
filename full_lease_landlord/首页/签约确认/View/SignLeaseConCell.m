//
//  SignLeaseConCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SignLeaseConCell.h"

@interface SignLeaseConCell()
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)UILabel *stateLab;
@property (nonatomic, strong)UILabel *dateLab;
@property (nonatomic, strong)UILabel *moneyLab;
@end

@implementation SignLeaseConCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = TableColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(KFit_W(16), 0, SCREEN_WIDTH - KFit_W(32), KFit_W(108))];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 5;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = HEXColor(@"#000000", 0.05).CGColor;
    [self.contentView addSubview:bgView];
    
    
    UILabel *stateLab = [[UILabel alloc] init];
    stateLab.textAlignment = NSTextAlignmentRight;
    stateLab.textColor = MainColor;
    stateLab.font = kFont(12);
    [bgView addSubview:stateLab];
//    [stateLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-10));
        make.top.mas_equalTo(KFit_W(20));
        make.height.mas_equalTo(KFit_W(23));
//        make.width.mas_equalTo(KFit_W(52));
    }];
    _stateLab = stateLab;
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textColor = HEXColor(@"#333333", 1);
    addressLab.font = kFont(14);
    [bgView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.centerY.mas_equalTo(stateLab);
        make.height.mas_equalTo(KFit_W(20));
        make.right.mas_equalTo(stateLab.mas_left).offset(-5);
    }];
    _addressLab = addressLab;
    
    UILabel *dateLab = [[UILabel alloc] init];
    dateLab.textColor = HEXColor(@"#999999", 1);
    dateLab.font = kFont(13);
    [bgView addSubview:dateLab];
    [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressLab);
        make.top.mas_equalTo(addressLab.mas_bottom).offset(8);
        make.height.mas_equalTo(KFit_W(18));
        make.right.mas_equalTo(-5);
    }];
    _dateLab = dateLab;
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.textColor = HEXColor(@"#999999", 1);
    moneyLab.font = kFont(13);
    [bgView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressLab);
        make.top.mas_equalTo(dateLab.mas_bottom).offset(6);
        make.height.mas_equalTo(KFit_W(18));
        make.right.mas_equalTo(stateLab.mas_left).offset(-5);
    }];
    _moneyLab = moneyLab;
    
    UILabel *signLab = [[UILabel alloc] init];
    signLab.text = @"去签约";
    signLab.font = stateLab.font;
    signLab.layer.cornerRadius = 1.f;
    signLab.textAlignment = NSTextAlignmentCenter;
    signLab.textColor = HEXColor(@"#F5A623", 1);
    signLab.layer.borderWidth = 0.5;
    signLab.layer.borderColor = HEXColor(@"#F5A623", 1).CGColor;
    [bgView addSubview:signLab];
    [signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.mas_equalTo(stateLab);
        make.centerY.mas_equalTo(moneyLab);
        make.width.mas_equalTo(KFit_W(52));
    }];
}

- (void)setModel:(ZukeConModel *)model {
    _model = model;
    _addressLab.text = [NSString stringWithFormat:@"%@%@",model.houseinfo.estateName,model.houseinfo.accurate];
    _dateLab.text = [NSString stringWithFormat:@"合同周期：%@至%@",model.contract.begintime,model.contract.endtime];
    _moneyLab.text = [NSString stringWithFormat:@"月租金：%@",model.contract.recent];
    
    //1-待签约 4-待搬入5在租 6逾期 7已退租8 作废 9 退租审批中 10 退租未结账 2-续租在租
    NSString *title = [NSString string];
    NSInteger status = model.contract.status;
    if (status == 1) {
        title = @"待签约";
    } else if (status == 2) {
        title = @"续租在租";
    } else if (status == 4) {
        title = @"待搬入";
    } else if (status == 5) {
        title = @"在租中";
    } else if (status == 6) {
        title = @"逾期";
    } else if (status == 7) {
        title = @"已退租";
    } else if (status == 8) {
        title = @"作废";
    } else if (status == 10) {
        title = @"退租未结账 ";
    } else if (status == 11) {
        title = @"待房东确认";
    } else if (status == 12) {
        title = @"房东拒绝";
    } else if (status == 13) {
        title = @"退租审核中";
    } else {
        title = @" ";
    }
    _stateLab.text = title;
}

@end
