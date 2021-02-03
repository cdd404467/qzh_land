//
//  MutableCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/9.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MutableCell.h"

@interface MutableCell()<UITextFieldDelegate>
@property (nonatomic, assign)NSInteger type;

@end

@implementation MutableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.type = type;
        [self setupUIWithType:type];
    }
    return self;
}

- (void)setupUIWithType:(NSInteger)type {
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = HEXColor(@"#333333", 1);
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.mas_equalTo(self.contentView);
    }];
    _titleLab = titleLab;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = Cell_Line_Color;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    if (type == 0) {
        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.font = [UIFont systemFontOfSize:16];
        rightLab.textColor = HEXColor(@"#333333", 1);
        [self.contentView addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.left.mas_equalTo(130);
            make.centerY.mas_equalTo(self.contentView);
        }];
        _rightLab = rightLab;
    } else if (type == 1) {
        UIImageView *arrow = [[UIImageView alloc] init];
        arrow.image = [UIImage imageNamed:@"arrow_right_gray"];
        [self.contentView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.size.mas_equalTo(CGSizeMake(7, 12));
            make.centerY.mas_equalTo(titleLab);
        }];
        
        UILabel *rightLab = [[UILabel alloc] init];
        rightLab.font = [UIFont systemFontOfSize:14];
        rightLab.textColor = HEXColor(@"#333333", 1);
        [self.contentView addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrow.mas_left).offset(-10);
            make.centerY.mas_equalTo(titleLab);
        }];
        _rightLab = rightLab;
    } else if (type == 2) {
        UITextField *tf = [[UITextField alloc] init];
        tf.font = [UIFont systemFontOfSize:14];
        tf.textColor = HEXColor(@"#333333", 1);
        tf.delegate = self;
        [self.contentView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(130);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(22);
            make.centerY.mas_equalTo(titleLab);
        }];
        _tf = tf;
    } else if (type == 3){
        UITextField *tf = [[UITextField alloc] init];
        tf.font = [UIFont systemFontOfSize:14];
        tf.textColor = HEXColor(@"#333333", 1);
        tf.delegate = self;
        [self.contentView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(130);
            make.right.mas_equalTo(-95);
            make.height.mas_equalTo(22);
            make.centerY.mas_equalTo(titleLab);
        }];
        _tf = tf;
        
        UIButton *sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendCodeBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [sendCodeBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self .contentView addSubview:sendCodeBtn];
        [sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            make.width.mas_equalTo(74);
            make.height.mas_equalTo(22);
            make.centerY.mas_equalTo(tf);
        }];
        _sendCodeBtn = sendCodeBtn;
    }
}

- (void)setModel:(MutableCellModel *)model {
    _model = model;
    _titleLab.text = model.title;
    if (self.type == 1) {
        if (isRightData(model.subTitle)) {
            _rightLab.textColor = HEXColor(@"#333333", 1);
            _rightLab.text = model.subTitle;
        } else {
            _rightLab.textColor = HEXColor(@"#999999", 1);
            _rightLab.text = _placeHolder;
        }
    } if (self.type == 2 || self.type == 3) {
        _tf.text = model.subTitle;
    } else {
        _rightLab.text = model.subTitle;
    }
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    _model.subTitle = _tf.text;
}

- (void)btnClick {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView type:(NSInteger)type {
    static NSString *identifier = @"MutableCell";
    MutableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MutableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier type:type];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
