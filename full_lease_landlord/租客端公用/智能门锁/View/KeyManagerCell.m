//
//  KeyManagerCell.m
//  Door_Lock
//
//  Created by wz on 2020/11/29.
//

#import "KeyManagerCell.h"

@implementation KeyManagerCell

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
    titleLab.text = @"钥匙名称";
    titleLab.textColor = UIColorFromHex(0x333333);
    titleLab.font = kFont(14);
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.top.mas_equalTo(9.5);
        make.height.mas_equalTo(JCWidth(20));
    }];
    self.titleLab = titleLab;
    
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.text = @"2020-10-20 19:15 - 2020-11-28 00:00";
    subTitle.textColor = UIColorFromHex(0x999999);
    subTitle.font = kFont(12);
    [self.contentView addSubview:subTitle];
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(JCWidth(4));
    }];
    self.subTitle = subTitle;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromHex(0xEEEEEE);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(JCWidth(16));
        make.right.mas_equalTo(-JCWidth(16));
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)setModel:(KeyManagerListModel *)model{
    _model = model;
    
    self.titleLab.text = model.keyName;
    if (isRightData(model.startTime)) {
        self.subTitle.text = [NSString stringWithFormat:@"%@-%@",model.startTime,model.endTime];
    }else{
        self.subTitle.text = @"永久期限";
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
