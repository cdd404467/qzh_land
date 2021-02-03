//
//  MyBillListCell.m
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MyBillListCell.h"

@interface MyBillListCell()
@property (nonatomic, strong)UILabel *expLab;
@property (nonatomic, strong)UILabel *priceLab;
@property (nonatomic, strong)UILabel *timeLab;
@property (nonatomic, strong)UILabel *payTimeLab;
@property (nonatomic, strong)UILabel *payStateLab;
@end

@implementation MyBillListCell

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
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *topGap = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topGap.backgroundColor = TableColor;
    [self.contentView addSubview:topGap];
    
    UILabel *expLab = [[UILabel alloc] init];
    expLab.font = kFont(14);
    expLab.textColor = HEXColor(@"#333333", 1);
    [self.contentView addSubview:expLab];
    [expLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_H(16));
        make.top.mas_equalTo(topGap.mas_bottom).offset(KFit_W(23));
        make.height.mas_equalTo(KFit_H(20));
        make.width.mas_equalTo(KFit_H(100));
    }];
    _expLab = expLab;
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.font = kFont(13);
    priceLab.textColor = HEXColor(@"#FA6565", 1);
    priceLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-16));
        make.centerY.mas_equalTo(expLab);
        make.left.mas_equalTo(expLab.mas_right).offset(10);
    }];
    _priceLab = priceLab;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"#EEEEEE", 1);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(KFit_W(-16));
        make.top.mas_equalTo(expLab.mas_bottom).offset(8);
    }];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = kFont(13);
    timeLab.textColor = HEXColor(@"#999999", 1);
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(line);
        make.top.mas_equalTo(line.mas_bottom).offset(KFit_W(13));
        make.height.mas_equalTo(KFit_W(18));
    }];
    _timeLab = timeLab;
    
    UILabel *payTimeLab = [[UILabel alloc] init];
    payTimeLab.font = kFont(13);
    payTimeLab.textColor = HEXColor(@"#999999", 1);
    [self.contentView addSubview:payTimeLab];
    [payTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(line);
        make.top.mas_equalTo(timeLab.mas_bottom).offset(KFit_W(7));
        make.height.mas_equalTo(KFit_W(18));
    }];
    _payTimeLab = payTimeLab;
    
    UILabel *payStateLab = [[UILabel alloc] init];
    payStateLab.font = kFont(13);
    payStateLab.textColor = HEXColor(@"#999999", 1);
    [self.contentView addSubview:payStateLab];
    [payStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(line);
        make.top.mas_equalTo(payTimeLab.mas_bottom).offset(KFit_W(7));
        make.height.mas_equalTo(KFit_W(18));
    }];
    _payStateLab = payStateLab;
}

- (void)setModel:(BillModel *)model {
    _model = model;
    _expLab.text = model.sourcetypestr;
    _priceLab.text = [NSString stringWithFormat:@"¥%@",model.amountPayable];
    _timeLab.text = [NSString stringWithFormat:@"账单周期：%@至%@",model.begintime,model.endtime];
    _payTimeLab.text = [NSString stringWithFormat:@"支付日：%@",model.shoureceivetime];
    NSString *statusStr = model.status == 0 ? @"未支付" : @"已支付";
    _payStateLab.text = [NSString stringWithFormat:@"支付状态：%@",statusStr];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MyBillListCell";
    MyBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyBillListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
