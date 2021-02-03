//
//  MeToolItemCell.m
//  FullLease
//
//  Created by wz on 2020/7/26.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MeToolItemCell.h"

@implementation MeToolItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    
////    ImgBtn *btn = [[ImgBtn alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, itemHeight)];
//    self.contentView.backgroundColor = [UIColor whiteColor];
//    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [showBtn setImage:[UIImage imageNamed:@"icon_shui_dian mei"] forState:UIControlStateNormal];
//    [showBtn setTitle:@"洗衣机" forState:UIControlStateNormal];
//    [showBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleTop imageTitleSpace:15];
//    [showBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    showBtn.titleLabel.font = kFont(12);
//    [self.contentView addSubview:showBtn];
//    self.showBtn = showBtn;
    UIImageView *iconImage = [[UIImageView alloc] init];
    [self.contentView addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.top.mas_equalTo(2);
        make.centerX.mas_equalTo(self.contentView);
    }];
    _iconImage = iconImage;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = kFont(12);
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = UIColor.grayColor;
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImage.mas_bottom).offset(9);
        make.centerX.mas_equalTo(iconImage);
    }];
    _nameLab = nameLab;
}

@end
