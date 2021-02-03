//
//  DoorLockCell.m
//  Door_Lock
//
//  Created by wz on 2020/11/25.
//

#import "DoorLockCell.h"

@implementation DoorLockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubviews];
    }
    return  self;
}

-(void)setupSubviews{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = @"门锁名称";
    self.titleLab.textColor = HEXColor(@"#333333", 1);
    self.titleLab.font = kFont(14);
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(KFit_W(16));
        make.top.equalTo(self.contentView).offset(KFit_W(22));
    }];
    
    self.subTitleLab = [[UILabel alloc] init];
    self.subTitleLab.text = @"管理员";
    self.subTitleLab.textColor = HEXColor(@"#999999", 1);
    self.subTitleLab.font = kFont(12);
    [self.contentView addSubview:self.subTitleLab];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.titleLab.mas_bottom).offset(KFit_W(8));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXColor(@"#EEEEEE", 1);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.right.mas_equalTo(-KFit_W(16));
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.contentView);
    }];
    
    self.electricityLab = [[UILabel alloc] init];
    self.electricityLab.text = @"52%";
    self.electricityLab.textColor = HEXColor(@"#606266", 1);
    self.electricityLab.font = kFont(14);
    [self.contentView addSubview:self.electricityLab];
    [self.electricityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-KFit_W(16));
        make.centerY.equalTo(self.titleLab);
    }];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.image = [UIImage imageNamed:@"electricity"];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.electricityLab.mas_left).offset(-KFit_W(10));
        make.size.mas_equalTo(CGSizeMake(KFit_W(20), KFit_W(20)));
        make.centerY.equalTo(self.titleLab);
    }];
}

-(void)setModel:(DoorLockModel *)model{
    _model = model;
    
    self.titleLab.text = self.model.bluetooth.lockAlias;
    self.subTitleLab.text = [model.bluetooth.keyRight isEqualToString:@"1"]?@"管理员":@"普通用户";
    self.electricityLab.text = [NSString stringWithFormat:@"%@%%",model.bluetooth.electricQuantity];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
