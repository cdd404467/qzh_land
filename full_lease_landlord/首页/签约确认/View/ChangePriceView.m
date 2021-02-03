//
//  ChangePriceView.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ChangePriceView.h"
#import "UIView+Border.h"

static CGFloat aniTime = 0.4;
typedef void(^CompleteBlock)(NSString *resaon);
@interface ChangePriceView()
@property (nonatomic, copy)CompleteBlock completeBlock;

@end

@implementation ChangePriceView

- (instancetype)initWithMaxPrice:(NSString *)priceStr completion:(void (^)(NSString *text))completion {
    self = [super init];
    if (self) {
        self.completeBlock = completion;
        [self setupUIWithprice:priceStr];
    }
    
    return self;
}

- (void)setupUIWithprice:(NSString *)priceStr {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    self.frame = SCREEN_BOUNDS;
    
    CGFloat width = KFit_W(280);
    CGFloat height = KFit_W(208);
    //背景图
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 8;
    bgView.frame = CGRectMake((SCREEN_WIDTH - width) / 2, SCREEN_HEIGHT + height, width, height);
    [self addSubview:bgView];
    
    UILabel *txtLab = [[UILabel alloc] init];
    txtLab.text = @"新月租金";
    txtLab.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:txtLab];
    [txtLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KFit_W(55));
        make.left.mas_equalTo(KFit_W(36));
        make.height.mas_equalTo(KFit_W(24));
    }];
    [txtLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    
    UILabel *signLab = [[UILabel alloc] init];
    signLab.text = @"      ¥";
    signLab.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:signLab];
    [signLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(txtLab);
        make.left.mas_equalTo(txtLab.mas_right).offset(0);
    }];
    [signLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UITextField *zujinTF = [[UITextField alloc] init];
    [zujinTF becomeFirstResponder];
    zujinTF.keyboardType = UIKeyboardTypeDecimalPad;
    zujinTF.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:zujinTF];
    [zujinTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signLab.mas_right).offset(8);
        make.centerY.mas_equalTo(signLab);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-35);
    }];
    _zujinTF = zujinTF;
    
    UIView *bLine = [[UIView alloc] init];
    bLine.backgroundColor = HEXColor(@"#2D84FF", 1);
    [bgView addSubview:bLine];
    [bLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signLab);
        make.right.mas_equalTo(zujinTF);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(zujinTF.mas_bottom).offset(0);
    }];
    
    UILabel *desLab = [[UILabel alloc] init];
    desLab.text = priceStr;
    desLab.font = [UIFont systemFontOfSize:12];
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.textColor = HEXColor(@"999999", 1);
    [bgView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(bLine.mas_bottom).offset(KFit_W(25));
        make.height.mas_equalTo(18);
    }];
    
    //跳过
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, bgView.height - 50, bgView.width / 2, 50);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:HEXColor(@"BBBABB", 1) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn addTarget:self action:@selector(removeSignView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    [cancelBtn addBorder:HEXColor(@"f1f1f1", 1) width:0.5 direction:BorderDirectionRight];
    
    //更新
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(cancelBtn.right, cancelBtn.top, cancelBtn.width, cancelBtn.height);
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:MainColor forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [okBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:okBtn];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"f1f1f1", 1);
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-49.5);
    }];
    
    [UIView animateWithDuration:aniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        bgView.centerY = self.centerY - 50;
    }];
}

- (void)show {
    [UIApplication.sharedApplication.windows[0] addSubview:self];
}

- (void)confirm {
    if (self.completeBlock) {
        self.completeBlock(_zujinTF.text);
    }
    [self removeSignView];
}

//移除视图
- (void)removeSignView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

@end
