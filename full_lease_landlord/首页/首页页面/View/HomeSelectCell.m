//
//  HomeSelectCell.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "HomeSelectCell.h"

@implementation HomeSelectCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *itemImg = [[UIImageView alloc] init];
    [self.contentView addSubview:itemImg];
    [itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(KFit_W(35));
    }];
    _itemImg = itemImg;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = HEXColor(@"#333333", 1);
    titleLab.font = kFont(14);
    [self.contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(itemImg);
        make.top.mas_equalTo(itemImg.mas_bottom).offset(6);
        make.height.mas_equalTo(KFit_W(20));
    }];
    _titleLab = titleLab;
}

@end
