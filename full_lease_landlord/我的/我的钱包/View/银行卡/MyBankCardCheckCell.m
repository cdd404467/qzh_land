//
//  MyBankCardCheckCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MyBankCardCheckCell.h"

@interface MyBankCardCheckCell()
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UILabel *subTitleLab;
@property (nonatomic, strong)UIButton *selectBtn;
@end

@implementation MyBankCardCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _selectBtn.selected = selected;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = TableColor;
        [self setupUI];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MyBankCardCheckCell";
    MyBankCardCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyBankCardCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, KFit_W(10), SCREEN_WIDTH - 32, KFit_W(60))];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.shadowColor = RGBA(0, 0, 0, 0.08).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.layer.shadowOpacity = 1.0f;
    bgView.layer.cornerRadius = 4;
    [self.contentView addSubview:bgView];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_bank_icon_1"]];
    [bgView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(8));
        make.centerY.mas_equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(KFit_W(34), KFit_W(34)));
    }];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = kFont(13);
    nameLab.textColor = HEXColor(@"#333333", 1);
    [bgView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(5);
        make.top.mas_equalTo(icon);
        make.right.mas_equalTo(KFit_W(30));
    }];
    _nameLab = nameLab;
    
    UILabel *subTitleLab = [[UILabel alloc] init];
    subTitleLab.font = nameLab.font;
    subTitleLab.textColor = nameLab.textColor;
    [bgView addSubview:subTitleLab];
    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(nameLab);
        make.bottom.mas_equalTo(icon);
    }];
    _subTitleLab = subTitleLab;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"btn_bg_normal"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"btn_bg_select"] forState:UIControlStateSelected];
    selectBtn.adjustsImageWhenHighlighted = NO;
    selectBtn.userInteractionEnabled = NO;
    [bgView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(icon);
    }];
    _selectBtn = selectBtn;
}

- (void)setModel:(BankCardModel *)model {
    _model = model;
    _nameLab.text = model.bankname;
    _subTitleLab.text = [NSString stringWithFormat:@"尾号%@%@",model.account,model.bankCardType];
}

@end
