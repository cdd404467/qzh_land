//
//  MsgTypeListCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/1.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MsgTypeListCell.h"
#import <PPBadgeView.h>

@interface MsgTypeListCell()
@property (nonatomic, strong)UIImageView *headImageView;
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UILabel *subtxtLab;
@property (nonatomic, strong)UILabel *timeLab;
@property (nonatomic, strong)UILabel *badgeLab;
@end

@implementation MsgTypeListCell

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
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(17));
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(KFit_W(42));
    }];
    _headImageView = headImageView;
    
    //未读消息小红点
//    UILabel *badgeLab = [[UILabel alloc] init];
//    badgeLab.text = @"10";
//    badgeLab.textAlignment = NSTextAlignmentCenter;
//    badgeLab.backgroundColor = HEXColor(@"FA6565", 1);
////    badgeLab.hidden = YES;
//    badgeLab.layer.cornerRadius = KFit_W(17) / 2;
//    badgeLab.clipsToBounds = YES;
//    badgeLab.textColor = UIColor.whiteColor;
//    badgeLab.font = kFont(11);
//    [headImageView addSubview:badgeLab];
//    [badgeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(headImageView.mas_top).offset(-1);
//        make.width.height.mas_equalTo(KFit_W(17));
//        make.centerX.mas_equalTo(headImageView.mas_right);
//    }];
//    _badgeLab = badgeLab;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = kFont(14);
    titleLab.textColor = HEXColor(@"333333", 1);
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImageView.mas_right).offset(KFit_W(16));
        make.top.mas_equalTo(headImageView.mas_top).offset(3.5);
        make.height.mas_equalTo(20);
    }];
    _titleLab = titleLab;
    
    UILabel *subtxtLab = [[UILabel alloc] init];
    subtxtLab.font = kFont(11);
    subtxtLab.textColor = HEXColor(@"999999", 1);
    [self.contentView addSubview:subtxtLab];
    [subtxtLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(3);
    }];
    _subtxtLab = subtxtLab;
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.font = kFont(11);
    timeLab.textColor = HEXColor(@"999999", 1);
    timeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLab);
        make.right.mas_equalTo(KFit_W(-16));
    }];
    _timeLab = timeLab;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"eeeeee", 1);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(15));
        make.right.mas_equalTo(KFit_W(-15));
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setIconName:(NSString *)iconName {
    _headImageView.image = [UIImage imageNamed:iconName];
}

- (void)setTime:(NSString *)time {
    _timeLab.text = time;
}

- (void)setMsgCount:(NSString *)msgCount {
    [_headImageView pp_addBadgeWithNumber:msgCount.integerValue];
    if (msgCount.integerValue == 0) {
        _subtxtLab.text = @"暂无新消息";
    } else {
        _subtxtLab.text = [NSString stringWithFormat:@"您有%@条新消息",msgCount];
    }
}

- (void)setTitle:(NSString *)title {
    _titleLab.text = title;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MsgTypeListCell";
    MsgTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MsgTypeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
