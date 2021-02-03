//
//  IncomeHeaderView.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import "IncomeHeaderView.h"

@interface IncomeHeaderView()
@property (nonatomic, strong)UIView *btnBg;
@end

@implementation IncomeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXColor(@"#F6F6F6", 1);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *btnBg = [[UIView alloc] init];
    [self.contentView addSubview:btnBg];
    [btnBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(KFit_W(100));
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    btnBg.layer.shadowColor = RGBA(0, 0, 0, 0.3).CGColor;
    btnBg.layer.shadowOffset = CGSizeMake(0, 3);
    btnBg.layer.shadowOpacity = 1.0f;
    _btnBg = btnBg;
    
    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeBtn setImage:[UIImage imageNamed:@"sel_arrow_down"] forState:UIControlStateNormal];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [timeBtn setTitleColor:HEXColor(@"333333", 1) forState:UIControlStateNormal];
    timeBtn.backgroundColor = HEXColor(@"f1f1f1", 1);
    timeBtn.layer.cornerRadius = 15;
    [timeBtn addTarget:self action:@selector(selectTime) forControlEvents:UIControlEventTouchUpInside];
    [btnBg addSubview:timeBtn];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _timeBtn = timeBtn;
    
    UILabel *spendLab = [[UILabel alloc] init];
    spendLab.textAlignment = NSTextAlignmentRight;
    spendLab.textColor = HEXColor(@"#999999", 1);
    spendLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:spendLab];
    [spendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    _spendLab = spendLab;
    
    UILabel *incomeLab = [[UILabel alloc] init];
    incomeLab.textAlignment = NSTextAlignmentRight;
    incomeLab.textColor = HEXColor(@"#999999", 1);
    incomeLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:incomeLab];
    [incomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12);
        make.height.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    _incomeLab = incomeLab;
    
}

- (void)selectTime {
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (void)setTimeStr:(NSString *)timeStr {
    _timeStr = timeStr;
    if (timeStr.length > 10) {
        [_btnBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KFit_W(200));
        }];
    } else {
        [_btnBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(KFit_W(100));
        }];
    }
    [_timeBtn setTitle:timeStr forState:UIControlStateNormal];
    [_timeBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleRight imageTitleSpace:4];
}

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"IncomeHeaderView";
    IncomeHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (header == nil) {
        header = [[IncomeHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    return header;
}
@end
