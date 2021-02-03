//
//  LeaseContractCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "LeaseContractCell.h"
#import "ZukeConModel.h"

@interface LeaseContractCell()
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)UILabel *stateLab;
@property (nonatomic, strong)UILabel *dateLab;
@property (nonatomic, strong)UILabel *moneyLab;
@end

@implementation LeaseContractCell

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

- (void)setModel:(ZukeConModel *)model {
    _model = model;
    _addressLab.text = [NSString stringWithFormat:@"%@%@",model.houseinfo.estateName,model.houseinfo.accurate];
    _dateLab.text = [NSString stringWithFormat:@"合同周期：%@至%@",model.contract.begintime,model.contract.endtime];
    _moneyLab.text = [NSString stringWithFormat:@"月租金：%@",model.contract.recent];
    //1-待签约 4-待搬入5在租 6逾期 7已退租8 作废 13 退租审批中 10 退租未结账 2-续租在租 11-待房东确认 12-房东拒绝
    NSString *title = [NSString string];
    UIColor *color = MainColor;
    switch (model.contract.status) {
        case 1:
        {
            title = @"待租客签约";
            color = HEXColor(@"#F5A623", 1);
        }
            break;
        case 2:
        {
            title = @"续租在租";
        }
            break;
        case 4:
        {
            title = @"待搬入";
            color = HEXColor(@"#3D7EFF", 1);
        }
            break;
        case 5:
        {
            title = @"在租中";
        }
            break;
        case 6:
        {
            title = @"逾期";
        }
            break;
        case 7:
        {
            title = @"已退租";
            color = HEXColor(@"#BBBABB", 1);
        }
            break;
        case 8:
        {
            title = @"作废";
        }
            break;
        case 13:
        {
            title = @"退租审核中";
        }
            break;
        case 10:
        {
            title = @"退租审批中";
        }
            break;
        case 11:
        {
            title = @"待房东确认";
            color = HEXColor(@"#F5A623", 1);
        }
            break;
        case 12:
        {
            title = @"房东已拒绝";
        }
            break;
        default:
        {
            title = @"- - !";
        }
            break;
    }
    _stateLab.backgroundColor = color;
    _stateLab.text = title;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"LeaseContractCell";
    LeaseContractCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LeaseContractCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
