//
//  PayCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/22.
//  Copyright © 2020 apple. All rights reserved.
//

#import "PayCell.h"
#import "NSString+Extension.h"

@interface PayCell()
@property (nonatomic, strong)UIImageView *paytypeImage;
@property (nonatomic, strong)UILabel *nameLab;
@property (nonatomic, strong)UIButton *selectBtn;
@property (nonatomic, strong)UILabel *poundageLab;
@property (nonatomic, strong)UIView *bgView;
@end

@implementation PayCell

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

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.bottom.mas_equalTo(0);
    }];
    _bgView = bgView;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"#EEEEEE", 1);
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIImageView *paytypeImage = [[UIImageView alloc] init];
    [bgView addSubview:paytypeImage];
    [paytypeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(self.contentView);
    }];
    _paytypeImage = paytypeImage;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.textColor = HEXColor(@"#565656", 1);
    nameLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(paytypeImage.mas_right).offset(8);
        make.centerY.mas_equalTo(paytypeImage);
    }];
    _nameLab = nameLab;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"btn_bg_normal"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"btn_bg_select"] forState:UIControlStateSelected];
    selectBtn.adjustsImageWhenHighlighted = NO;
    selectBtn.userInteractionEnabled = NO;
    [bgView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(nameLab);
    }];
    _selectBtn = selectBtn;
    
    UILabel *poundageLab = [[UILabel alloc] init];
    poundageLab.textAlignment = NSTextAlignmentRight;
    poundageLab.textColor = HEXColor(@"#818181", 1);
    poundageLab.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:poundageLab];
    [poundageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(selectBtn.mas_left).offset(-23);
        make.centerY.mas_equalTo(nameLab);
    }];
    _poundageLab = poundageLab;
}

- (void)setModel:(PayModel *)model {
    _model = model;
    [_paytypeImage sd_setImageWithURL:[NSURL URLWithString:model.iconClass]];
    _nameLab.text = model.value;
    _poundageLab.text = [NSString stringWithFormat:@"手续费:%@",model.feeAmount.correctPrecision];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"PayCell";
    PayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
