//
//  PasswordShowRectView.m
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "PasswordShowRectView.h"

@interface PasswordShowRectView ()

@property (nonatomic, strong) NSMutableArray *numberLabs;

@property (nonatomic, weak) UILabel *titleLab;

@end

@implementation PasswordShowRectView

+(instancetype)createPasswordShowRectView:(NSString *)numbers frame:(CGRect)frame{
    return [[PasswordShowRectView alloc] initWithFrame:frame withNum:numbers];
}

-(instancetype)initWithFrame:(CGRect)frame withNum:(NSString *)numbers{
    if (self = [super initWithFrame:frame]) {
        self.passwordNums = numbers;
        [self setupSubviews];
    }
    return self;
}

-(NSMutableArray *)numberLabs{
    if (!_numberLabs) {
        _numberLabs = [NSMutableArray array];
    }
    return _numberLabs;;
}

-(void)setupSubviews{
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"房间锁密码";
    titleLab.textColor = UIColorFromHex(0x333333);
    titleLab.font = kFont(16);
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    self.titleLab = titleLab;
    
    UIView *numberView = [[UIView alloc] init];
    numberView.layer.cornerRadius = 4;
    numberView.layer.borderWidth = 1;
    numberView.layer.borderColor = [UIColorFromHex(0xE5E5E5) CGColor];
    numberView.clipsToBounds = YES;
    [self addSubview:numberView];
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(titleLab.mas_bottom).offset(15);
        make.height.mas_equalTo(JCWidth(48));
    }];

    for (int i = 0; i< self.passwordNums.length; i++) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = [self.passwordNums substringWithRange:NSMakeRange(i, 1)];
        lab.textColor = UIColorFromHex(0x333333);
        lab.font = kFont(18);
        lab.layer.borderColor = [UIColorFromHex(0xE5E5E5) CGColor];
        lab.layer.borderWidth = 0.5;
        lab.textAlignment = NSTextAlignmentCenter;
        [numberView addSubview:lab];
        [self.numberLabs addObject:lab];
    }
    
    // 实现masonry水平固定间隔方法
    [self.numberLabs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    // 设置array的垂直方向的约束
    [self.numberLabs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(JCWidth(48));
        make.top.mas_equalTo(numberView);
        make.bottom.mas_equalTo(numberView);
    }];
}

-(void)setPasswordNums:(NSString *)passwordNums{
    _passwordNums = passwordNums;
    
//    for (int i=0; i<passwordNums.length; i++) {
//        NSString *num = [passwordNums substringWithRange:NSMakeRange(i, 1)];
//        UILabel *lab = self.numberLabs[i];
//        lab.text = num;
//    }
}

-(void)setLockTitle:(NSString *)lockTitle{
    _lockTitle = lockTitle;
    
    self.titleLab.text = lockTitle;
}

@end
