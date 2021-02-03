//
//  SendKeyCell.m
//  FullLease
//
//  Created by wz on 2020/11/24.
//  Copyright © 2020 kad. All rights reserved.
//

#import "SendKeyCell.h"

@interface SendKeyCell()<UITextFieldDelegate>

@end

@implementation SendKeyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews{
    UILabel *topMark = [[UILabel alloc] init];
    topMark.text = @"*";
    topMark.textColor = [UIColor redColor];
    topMark.font = kFont(12);
    [self.contentView addSubview:topMark];
    [topMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.top.mas_equalTo(JCWidth(20));
        make.width.mas_equalTo(8);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"接受者";
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = UIColorFromHex(0x333333);
    titleLab.font = kFont(14);
    [self.contentView addSubview: titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topMark.mas_right).offset(JCWidth(6));
        make.centerY.equalTo(self.contentView);
    }];
    self.titleLab = titleLab;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请填写";
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = kFont(14);
    textField.delegate = self;
    [self.contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-JCWidth(16));
        make.left.equalTo(titleLab.mas_right).offset(JCWidth(10));
        make.centerY.equalTo(self.contentView);
    }];
    self.textField  = textField;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromHex(0xEEEEEE);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.right.mas_equalTo(-JCWidth(16));
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    [titleLab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [textField setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

-(void)textFieldDidChangeSelection:(UITextField *)textField{
    if (self.inputText) {
        self.inputText(textField.text);
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.inputText) {
        self.inputText(textField.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
