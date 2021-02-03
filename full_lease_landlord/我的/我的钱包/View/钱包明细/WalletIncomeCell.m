//
//  WalletIncomeCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/12.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WalletIncomeCell.h"

@interface WalletIncomeCell()
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UILabel *moneyLab;
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)UILabel *timeLab;
@end

@implementation WalletIncomeCell

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

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"WalletIncomeCell";
    WalletIncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WalletIncomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH - 32, KFit_W(97))];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.shadowColor = RGBA(0, 0, 0, 0.08).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.layer.shadowOpacity = 1.0f;
    bgView.layer.cornerRadius = 4;
    [self.contentView addSubview:bgView];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_income_icon"]];
    [bgView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(13));
        make.top.mas_equalTo(KFit_W(19));
        make.size.mas_equalTo(CGSizeMake(KFit_W(17), KFit_W(17)));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = kFont(15);
    titleLab.textColor = HEXColor(@"#333333", 1);
    [bgView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.left.mas_equalTo(icon.mas_right).offset(10);
        make.right.mas_equalTo(KFit_W(-100));
    }];
    _titleLab = titleLab;
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.font = kFont(15);
    moneyLab.textAlignment = NSTextAlignmentRight;
    moneyLab.textColor = MainColor;
    [bgView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(icon);
        make.left.mas_equalTo(titleLab.mas_right).offset(3);
        make.right.mas_equalTo(-10);
    }];
    _moneyLab = moneyLab;
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.font = kFont(13);
    addressLab.textColor = HEXColor(@"#333333", 1);
    [bgView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(KFit_W(3));
        make.right.mas_equalTo(moneyLab);
        make.height.mas_equalTo(KFit_W(19));
    }];
    _addressLab = addressLab;
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = kFont(12);
    timeLab.textColor = HEXColor(@"#999999", 1);
    [bgView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(addressLab);
        make.top.mas_equalTo(addressLab.mas_bottom).offset(KFit_W(4));
        make.height.mas_equalTo(KFit_W(17));
    }];
    _timeLab = timeLab;
}

- (void)setModel:(WalletModel *)model {
    _model = model;
    _titleLab.text = [NSString stringWithFormat:@"%@%@期",model.sign,model.stage];
    _addressLab.text = model.housename;
    _moneyLab.text = [NSString stringWithFormat:@"+%@",model.amount];
    _timeLab.text = model.createtime;
}
@end
