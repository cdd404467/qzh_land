//
//  HouseResourceListCell.m
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "HouseResourceListCell.h"
#import <YYText.h>
#import "HouseInfoModel.h"
#import "PaddingLabel.h"

@interface HouseResourceListCell()
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)UILabel *stateLab;
@property (nonatomic, strong)YYLabel *desLab;
@property (nonatomic, strong)UILabel *moneyLab;
@property (nonatomic, strong)NSMutableArray<PaddingLabel *> *tagsLabArr;
@end

@implementation HouseResourceListCell

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
    bgView.layer.cornerRadius = 8;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = HEXColor(@"#000000", 0.05).CGColor;
    [self.contentView addSubview:bgView];
    _bgView = bgView;
    
    UILabel *stateLab = [[UILabel alloc] init];
    stateLab.textAlignment = NSTextAlignmentRight;
    stateLab.font = kFont(14);
    [bgView addSubview:stateLab];
    [stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-14));
        make.top.mas_equalTo(KFit_W(20));
        make.height.mas_equalTo(KFit_W(20));
        make.width.mas_equalTo(KFit_W(50));
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
        make.right.mas_equalTo(stateLab.mas_left).offset(0);
    }];
    _addressLab = addressLab;
    
    YYLabel *desLab = [[YYLabel alloc] init];
    [bgView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressLab);
        make.top.mas_equalTo(addressLab.mas_bottom).offset(9);
        make.height.mas_equalTo(KFit_W(18));
        make.right.mas_equalTo(-5);
    }];
    _desLab = desLab;
    
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.textColor = HEXColor(@"#999999", 1);
    moneyLab.font = kFont(13);
    [bgView addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressLab);
        make.top.mas_equalTo(desLab.mas_bottom).offset(9);
        make.height.mas_equalTo(KFit_W(18));
        make.width.mas_equalTo(KFit_W(130));
    }];
    _moneyLab = moneyLab;
    
    self.tagsLabArr = [NSMutableArray arrayWithCapacity:0];
    //有欠款
    for (NSInteger i =0;i < 3; i++) {
        PaddingLabel *arrears = [[PaddingLabel alloc] init];
        arrears.backgroundColor = HEXColor(@"#FA6565", 1);
        arrears.layer.cornerRadius = 4.f;
        arrears.textColor = UIColor.whiteColor;
        arrears.textAlignment = NSTextAlignmentRight;
        arrears.font = kFont(10);
        arrears.leftEdge = 6;
        arrears.rightEdge = arrears.leftEdge;
//        arrears.contentEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 6);
        [bgView addSubview:arrears];
        [arrears mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
               make.right.mas_equalTo(stateLab);
            } else {
                make.right.mas_equalTo(self.tagsLabArr[i - 1].mas_left).offset(-6);
            }
            make.centerY.mas_equalTo(moneyLab);
            make.height.mas_equalTo(18);
        }];
        [self.tagsLabArr addObject:arrears];
    }
}

- (void)setModel:(HouseInfoModel *)model {
    _model = model;
    _addressLab.text = model.specificAddress;
    _moneyLab.text = [NSString stringWithFormat:@"¥%@",model.finalAmount];
    
    //1未租 2已租 3装修中 4作废 5未审核 6锁定
    //空置天数(1,5)显示
    if (_model.status == 1 || _model.status == 5) {
        NSString *text = [NSString stringWithFormat:@"空置%@天",model.vacantDays];
        NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
        mText.yy_font = kFont(12);
        mText.yy_color = HEXColor(@"#999999", 1);
        [mText yy_setColor:HEXColor(@"#FA6565", 1) range:NSMakeRange(2, model.vacantDays.length)];
        _desLab.attributedText = mText;
    } else if (_model.status == 2) {
        NSString *text = [NSString stringWithFormat:@"%@(%@)",model.tenantName,model.tenantPhone];
        NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
        mText.yy_font = kFont(12);
        mText.yy_color = HEXColor(@"#999999", 1);
        _desLab.attributedText = mText;
    } else {
        NSString *text = @"";
        NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
        _desLab.attributedText = mText;
    }
    
    //文字状态颜色和背景颜色
    _stateLab.text = model.statusStr;
    UIColor *textColor;
    UIColor *backgroundColor;
    if (model.status == 1) {
        textColor = HEXColor(@"#FA6565", 1);
        backgroundColor = HEXColor(@"#FEEAE9", 1);
    } else if (model.status == 2) {
        textColor = HEXColor(@"#333333", 1);
        backgroundColor = UIColor.whiteColor;
    } else if (model.status == 3) {
        textColor = HEXColor(@"#333333", 1);
        backgroundColor = UIColor.whiteColor;
    } else if (model.status == 4) {
        textColor = HEXColor(@"#BFBFBF", 1);
        backgroundColor = HEXColor(@"#000000", 0.08);
    } else if (model.status == 5) {
        textColor = HEXColor(@"#27C3CE", 1);
        backgroundColor = HEXColor(@"#E7F5F2", 1);
    } else {
        textColor = HEXColor(@"#333333", 1);
        backgroundColor = UIColor.whiteColor;
    }
    _stateLab.textColor = textColor;
    _bgView.backgroundColor = backgroundColor;
    
    for (PaddingLabel *lab in self.tagsLabArr) {
        lab.hidden = YES;
    }
    
    for (NSInteger i = 0; i < model.contractBillStatusDesc.count;i++) {
        TagsViewModel *tagModel = model.contractBillStatusDesc[i];
        PaddingLabel *lab = self.tagsLabArr[i];
        lab.text = tagModel.content;
        lab.textColor = HEXColor(tagModel.typeface, 1);
        lab.backgroundColor = HEXColor(tagModel.background, 1);
        lab.hidden = NO;
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"HouseResourceListCell";
    HouseResourceListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HouseResourceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
