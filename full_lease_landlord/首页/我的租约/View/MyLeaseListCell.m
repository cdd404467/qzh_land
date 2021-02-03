//
//  MyLeaseListCell.m
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MyLeaseListCell.h"
#import "ContractModel.h"

@interface MyLeaseListCell()
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)UILabel *stateLab;
@property (nonatomic, strong)UILabel *dateLab;
@property (nonatomic, strong)UILabel *moneyLab;
@end

@implementation MyLeaseListCell

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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(KFit_W(16), 0, SCREEN_WIDTH - KFit_W(32), KFit_W(108))];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 5;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = HEXColor(@"#000000", 0.05).CGColor;
    [self.contentView addSubview:bgView];
    
    
    UILabel *stateLab = [[UILabel alloc] init];
    stateLab.textAlignment = NSTextAlignmentCenter;
    stateLab.textColor = UIColor.whiteColor;
    stateLab.font = kFont(12);
    [bgView addSubview:stateLab];
    [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-10));
        make.top.mas_equalTo(KFit_W(20));
        make.height.mas_equalTo(KFit_W(23));
        make.width.mas_equalTo(KFit_W(70));
    }];
    _stateLab = stateLab;
    [stateLab.superview layoutIfNeeded];
    [HelperTool drawRound:stateLab radiu:3];
    
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
        make.right.mas_equalTo(-5);
    }];
    _moneyLab = moneyLab;
    
}


- (void)setModel:(ContractModel *)model {
    _model = model;
    _addressLab.text = model.adress;
    _dateLab.text = [NSString stringWithFormat:@"合同周期: %@至%@",model.begintime,model.endtime];
    _moneyLab.text = [NSString stringWithFormat:@"月租金: %@",model.recent];
    
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
    } else if (model.status == 9) {
        title = @"退租审批中";
    } else if (model.status == 10) {
        title = @"退租未结账";
    } else {
        title = @" ";
        color = MainColor;
    }
    
    _stateLab.text = title;
    _stateLab.backgroundColor = color;
}

@end
