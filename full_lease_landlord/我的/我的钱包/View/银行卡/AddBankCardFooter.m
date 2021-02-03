//
//  AddBankCardFooter.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import "AddBankCardFooter.h"
#import "UIView+Effects.h"

@implementation AddBankCardFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    for (NSInteger i = 0; i < 2; i++) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = UIColor.whiteColor;
        bgView.layer.cornerRadius = 4.f;
        bgView.tag = 100 + i;
        bgView.layer.borderColor = HEXColor(@"#999999", 1).CGColor;
        bgView.layer.borderWidth = 0.5f;
        [HelperTool addTapGesture:bgView withTarget:self andSEL:@selector(tapClick:)];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10 + (67 + 10) * i);
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(67);
        }];
//        bgView.shadowRadius(4).shadowOffset(CGSizeMake(2.5, 0.5)).shadowColor(HEXColor(@"#000000", 0.05)).showVisual();
        
        UIButton *addBankCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBankCardBtn.userInteractionEnabled = NO;
        [addBankCardBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [addBankCardBtn setImage:[UIImage imageNamed:@"add_bankcard_icon"] forState:UIControlStateNormal];
        addBankCardBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [addBankCardBtn setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
        [bgView addSubview:addBankCardBtn];
        [addBankCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgView);
            make.left.mas_equalTo(26);
            make.size.mas_equalTo(CGSizeMake(120, 40));
        }];
        
        if (i == 0) {
            [addBankCardBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
        } else if (i == 1) {
            [addBankCardBtn setTitle:@"添加支付宝" forState:UIControlStateNormal];
            UILabel *lab = [[UILabel alloc] init];
            lab.text = @"实时到账";
            lab.textColor = HEXColor(@"#999999", 1);
            lab.font = [UIFont systemFontOfSize:12];
            lab.textAlignment = NSTextAlignmentRight;
            [bgView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-26);
                make.centerY.mas_equalTo(addBankCardBtn);
            }];
        }
        
    }
    
}

- (void)tapClick:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    if (self.tapClickBlock) {
        self.tapClickBlock(tap.view.tag - 100);
    }
}


- (void)tt {
    NSLog(@"-- 11111");
}

@end
