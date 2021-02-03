//
//  MyBillDetailCell.m
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MyBillDetailCell.h"
#import "DictModel.h"

@interface MyBillDetailCell()
@property (nonatomic, strong)UILabel *leftLab;
@property (nonatomic, strong)UILabel *rightLab;
@end


@implementation MyBillDetailCell

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
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.leftLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 14, KFit_W(60), KFit_W(20))];
    _leftLab.font = kFont(14);
    _leftLab.textColor = HEXColor(@"#333333", 1);
    [self.contentView addSubview:_leftLab];
    
    self.rightLab = [[UILabel alloc] initWithFrame:CGRectMake(_leftLab.right + 5, _leftLab.top, SCREEN_WIDTH, _leftLab.height)];
    _rightLab.width = SCREEN_WIDTH - 30 - _rightLab.left - 18;
    _rightLab.font = [UIFont systemFontOfSize:14];
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.textColor = HEXColor(@"#333333", 0.7);
    [self.contentView addSubview:_rightLab];
}

- (void)setModel:(DictModel *)model {
    _model = model;
    _leftLab.text = model.key;
    _rightLab.text = model.value;
    CGFloat height = [_rightLab.text boundingRectWithSize:CGSizeMake(_rightLab.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_rightLab.font} context:nil].size.height;
    if (height < 20) {
        _model.height = height + 30;
    } else {
        _model.height = 48;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MyBillDetailCell";
    MyBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyBillDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
