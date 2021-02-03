//
//  SendKeyTimeCell.m
//  Door_Lock
//
//  Created by wz on 2020/11/29.
//

#import "SendKeyTimeCell.h"

@implementation SendKeyTimeCell

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
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"生效时间";
    titleLab.textColor = UIColorFromHex(0x333333);
    titleLab.font = kFont(14);
    [self.contentView addSubview: titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(JCWidth(16));
        make.centerY.equalTo(self.contentView);
    }];
    self.titleLab = titleLab;
    
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [self.contentView addSubview:arrowBtn];
    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-JCWidth(16));
        make.size.mas_equalTo(CGSizeMake(JCWidth(14), JCWidth(14)));
        make.centerY.equalTo(self.contentView);
    }];
    
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.text = @"";
    subTitle.textColor = UIColorFromHex(0x999999);
    subTitle.font = kFont(JCWidth(14));
    [self.contentView addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrowBtn.mas_left).offset(-JCWidth(10));
        make.centerY.equalTo(self.contentView);
    }];
    self.subTitle = subTitle;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
