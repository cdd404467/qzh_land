//
//  MyWalletCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MyWalletCell.h"

@implementation MyWalletCell

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
        self.contentView.backgroundColor = TableColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 16 * 2, 58)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.shadowColor = RGBA(0, 0, 0, 0.06).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    bgView.layer.shadowOpacity = 1.0f;
    bgView.layer.cornerRadius = 4;
    [self.contentView addSubview:bgView];
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    [bgView addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.size.mas_equalTo(CGSizeMake(34, 34));
        make.centerY.mas_equalTo(bgView);
    }];
    _headerImage = headerImage;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = HEXColor(@"#333333", 1);
    [bgView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImage.mas_right).offset(10);
        make.centerY.mas_equalTo(headerImage);
    }];
    _titleLab = titleLab;
    
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"arrow_right_gray"];
    [bgView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(7, 12));
        make.centerY.mas_equalTo(headerImage);
    }];
    
    UILabel *subTitleLab = [[UILabel alloc] init];
    subTitleLab.font = [UIFont systemFontOfSize:11];
    subTitleLab.textColor = HEXColor(@"#999999", 1);
    subTitleLab.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:subTitleLab];
    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrow.mas_left).offset(-10);
        make.centerY.mas_equalTo(arrow);
    }];
    _subTitleLab = subTitleLab;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MyWalletCell";
    MyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
