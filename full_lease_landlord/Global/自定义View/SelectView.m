//
//  SelectView.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SelectView.h"

@implementation SelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *rightArrow = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"arrow_right"];
    rightArrow.image = [image imageWithChangeTintColor:HEXColor(@"999999", 1)];
    [self addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(9);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.textAlignment = NSTextAlignmentRight;
    textLab.textColor = HEXColor(@"999999", 1);
    textLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:textLab];
    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightArrow.mas_left).offset(-5);
        make.centerY.mas_equalTo(rightArrow);
    }];
    _textLab = textLab;
}


@end
