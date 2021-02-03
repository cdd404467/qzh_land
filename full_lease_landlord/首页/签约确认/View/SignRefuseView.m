//
//  SignRefuseView.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SignRefuseView.h"
#import "UIView+Border.h"

static CGFloat aniTime = 0.4;
typedef void(^CompleteBlock)(NSString *resaon);
@interface SignRefuseView()
@property (nonatomic, strong)UITextField *reasonTF;
@property (nonatomic, copy)CompleteBlock completeBlock;

@end


@implementation SignRefuseView

- (instancetype)initWithCompletion:(void (^)(NSString *text))completion {
    self = [super init];
    if (self) {
        self.completeBlock = completion;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    self.frame = SCREEN_BOUNDS;
    
    CGFloat width = KFit_W(280);
    CGFloat height = KFit_W(180);
    //背景图
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 8;
    bgView.frame = CGRectMake((SCREEN_WIDTH - width) / 2, SCREEN_HEIGHT + height, width, height);
    [self addSubview:bgView];
//    _bgView = bgView;
    
    UILabel *txtLab = [[UILabel alloc] init];
    txtLab.text = @"拒绝原因";
    txtLab.textAlignment = NSTextAlignmentCenter;
    txtLab.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:txtLab];
    [txtLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KFit_W(15));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(KFit_W(24));
    }];
    
    UITextField *reasonTF = [[UITextField alloc] init];
    [reasonTF becomeFirstResponder];
    reasonTF.layer.cornerRadius = 0.5;
    reasonTF.font = [UIFont systemFontOfSize:13];
    reasonTF.layer.borderColor = HEXColor(@"#CECECE", 1).CGColor;
    reasonTF.layer.borderWidth = 0.5;
    reasonTF.placeholder = @"  请填写原因";
    [bgView addSubview:reasonTF];
    [reasonTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(KFit_W(34));
        make.top.mas_equalTo(txtLab.mas_bottom).offset(KFit_W(19));
    }];
    _reasonTF = reasonTF;
    
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
    if (_reasonTF.text.length == 0) {
        [CddHud showTextOnly:@"请输入拒绝原因" view:UIApplication.sharedApplication.windows.firstObject];
        return;
    }
    if (self.completeBlock) {
        self.completeBlock(_reasonTF.text);
    }
    [self removeSignView];
}

//移除视图
- (void)removeSignView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}
@end
