//
//  SelectBankCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/11.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SelectBankCell.h"

@interface SelectBankCell()
@property (nonatomic, strong)UILabel *nameLab;
@end

@implementation SelectBankCell

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
        self.contentView.backgroundColor = HEXColor(@"#FAFAFA", 1);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.image = [UIImage imageNamed:@"select_bank_icon"];
    [self.contentView addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(KFit_W(22), KFit_W(22)));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.textColor = HEXColor(@"#333333", 1);
    nameLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImage.mas_right).offset(10);
        make.centerY.mas_equalTo(headerImage);
        make.right.mas_equalTo(-10);
    }];
    _nameLab = nameLab;
}

- (void)setModel:(BankCardModel *)model {
    _model = model;
    _nameLab.text = model.name;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"SelectBankCell";
    SelectBankCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SelectBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
