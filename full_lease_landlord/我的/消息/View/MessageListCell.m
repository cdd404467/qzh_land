//
//  MessageListCell.m
//  FullLease
//
//  Created by apple on 2020/8/17.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MessageListCell.h"
#import <PPBadgeView.h>
#import "MsgModel.h"

@interface MessageListCell()
@property (nonatomic, weak) UILabel *titleLab;
@property (nonatomic, weak) UILabel *timeLab;
@property (nonatomic, weak) UILabel *contentLab;
@end

@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(KFit_W(12));
    }];
    
    UIImageView *rightArrow = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"arrow_right"];
    rightArrow.image = [image imageWithChangeTintColor:HEXColor(@"999999", 1)];
    [bgView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(KFit_W(-20));
        make.top.mas_equalTo(KFit_W(28));
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = HEXColor(@"333333", 1);
    [bgView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(17));
        make.centerY.mas_equalTo(rightArrow);
    }];
    self.titleLab = titleLab;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"eeeeee", 1);
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(KFit_W(-16));
        make.top.mas_equalTo(KFit_W(50));
    }];
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.font = kFont(13);
    contentLab.textColor = HEXColor(@"5f5f5f", 1);
    [bgView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(KFit_W(24));
        make.left.mas_equalTo(titleLab);
        make.right.mas_equalTo(rightArrow);
    }];
    self.contentLab = contentLab;
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = kFont(12);
    timeLab.textColor = HEXColor(@"999999", 1);
    [bgView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(contentLab);
        make.top.mas_equalTo(contentLab.mas_bottom).offset(8);
    }];
    self.timeLab = timeLab;
}

- (void)setModel:(MsgModel *)model {
    _model = model;
    _titleLab.text = model.title;
    _contentLab.text = model.content;
    _timeLab.text = model.createTimeStr;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MessageListCell";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
