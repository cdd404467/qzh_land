//
//  IncomeListCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "IncomeListCell.h"

@interface IncomeListCell()
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UILabel *moneyLab;
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)UILabel *payTimeLab;
@end

@implementation IncomeListCell

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
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = kFont(14);
    titleLab.textColor = HEXColor(@"#333333", 1);
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(KFit_W(23));
        make.height.mas_equalTo(KFit_W(20));
        make.width.mas_equalTo(KFit_W(130));
    }];
    _titleLab = titleLab;
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.font = kFont(13);
    moneyLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-15));
        make.top.mas_equalTo(KFit_W(21));
    }];
    _moneyLab = moneyLab;
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textColor = HEXColor(@"#999999", 1);
    addressLab.font = kFont(13);
    [self.contentView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(KFit_W(10));
        make.height.mas_equalTo(KFit_W(18));
        make.right.mas_equalTo(moneyLab);
    }];
    _addressLab = addressLab;
    
    UILabel *payTimeLab = [[UILabel alloc] init];
    payTimeLab.text = @"2019-10-10 17:38";
    payTimeLab.textColor = HEXColor(@"#999999", 1);
    payTimeLab.font = kFont(13);
    [self.contentView addSubview:payTimeLab];
    [payTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(addressLab);
        make.top.mas_equalTo(addressLab.mas_bottom).offset(KFit_W(6));
    }];
    _payTimeLab = payTimeLab;
}

- (void)setModel:(IncomeListModel *)model {
    _model = model;
    _titleLab.text = model.title;
    //收入
    if (model.budgettype == 0) {
        _moneyLab.textColor = MainColor;
    }
    //支出
    else {
        _moneyLab.textColor = HEXColor(@"#FA6565", 1);
    }
    _moneyLab.text = model.amount;
    _addressLab.text = model.adress;
    _payTimeLab.text = model.createtime;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"IncomeListCell";
    IncomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[IncomeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
