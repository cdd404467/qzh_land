//
//  PayStateVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/25.
//  Copyright © 2020 apple. All rights reserved.
//

#import "PayStateVC.h"
#import "PayResultModel.h"
#import "MyBillDetailVC.h"
#import "PayVC.h"
#import "NSString+Extension.h"

@interface PayStateVC ()
@property (nonatomic, strong)UIImageView *stateImageView;
@property (nonatomic, strong)UILabel *desLab;
@property (nonatomic, strong)UIButton *bottomLeftBtn;
@property (nonatomic, strong)UIButton *bottomRightBtn;
@property (nonatomic, strong)PayCheckModel *model;
@end

@implementation PayStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"支付状态";
    [self setupUI];
    [self checkPayState];
    [self.navBar.leftBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.navBar.leftBtn addTarget:self action:@selector(backToDetail) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)backToDetail {
    BaseViewController *vc = self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)setupUI {
    UIImageView *stateImageView = [[UIImageView alloc] init];
    //pay_success_image
    stateImageView.image = [UIImage imageNamed:@"loading_img"];
    stateImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:stateImageView];
    [stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(86);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(NAV_HEIGHT + KFit_H(86));
    }];
    _stateImageView = stateImageView;
    
    [self beginAnimated];
    
    UILabel *desLab = [[UILabel alloc] init];
    desLab.text = @"支付结果查询中，请稍后...";
    desLab.font = [UIFont systemFontOfSize:16];
    desLab.textColor = HEXColor(@"#27C3CE", 1);
    desLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(stateImageView.mas_bottom).offset(KFit_W(28));
    }];
    _desLab = desLab;
    
    UIButton *bottomLeftBtn = [[UIButton alloc] init];
    [bottomLeftBtn setTitle:@"查看账单" forState:UIControlStateNormal];
    [bottomLeftBtn setTitleColor:MainColor forState:UIControlStateNormal];
    bottomLeftBtn.layer.borderWidth = 1;
    bottomLeftBtn.layer.borderColor = MainColor.CGColor;
    bottomLeftBtn.layer.cornerRadius = 4;
    [self.view addSubview:bottomLeftBtn];
    [bottomLeftBtn addTarget:self action:@selector(checkOrderDetail) forControlEvents:UIControlEventTouchUpInside];
    [bottomLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-Bottom_Height_Dif - 45);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo((SCREEN_WIDTH - 16 * 2 - 20) / 2);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
    }];
    _bottomLeftBtn = bottomLeftBtn;
    
    UIButton *bottomRightBtn = [[UIButton alloc] init];
    [bottomRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomRightBtn.backgroundColor = MainColor;
    bottomRightBtn.layer.cornerRadius = 4;
    [self.view addSubview:bottomRightBtn];
    [bottomRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.width.height.centerY.mas_equalTo(bottomLeftBtn);
    }];
    _bottomRightBtn = bottomRightBtn;
}

- (void)checkPayState {
    NSString *urlString = [NSString stringWithFormat:URLGet_Check_PayState,_orderID];
    DDWeakSelf;
    [NetTool getRequest:urlString Params:nil Success:^(id  _Nonnull json) {
        NSLog(@"---- %@",json);
        if (JsonCode == 200) {
            [self.bottomRightBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            self.model = [PayCheckModel mj_objectWithKeyValues:json[@"data"]];
            //待支付
            if ([self.model.status isEqualToString:@"WaitPay"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself checkPayState];
                });
                [self.bottomRightBtn addTarget:self action:@selector(backToMine) forControlEvents:UIControlEventTouchUpInside];
                [self.bottomRightBtn setTitle:@"返回我的" forState:UIControlStateNormal];
            }
            //支付成功
            else if ([self.model.status isEqualToString:@"Success"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_PayMoneySuccess object:nil userInfo:nil];
                [weakself stopAnimated];
                weakself.stateImageView.image = [UIImage imageNamed:@"pay_success_image"];
                if (self.model.unpaidAmount > 0) {
                    weakself.desLab.text = [NSString stringWithFormat:@"账单支付成功,账单总金额%@元,剩余%@元",self.model.amount.correctPrecision,@(self.model.unpaidAmount).stringValue.correctPrecision];
                    [self.bottomRightBtn setTitle:@"继续支付" forState:UIControlStateNormal];
                    [self.bottomRightBtn addTarget:self action:@selector(goOnPay) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    weakself.desLab.text = @"账单支付成功";
                    [self.bottomRightBtn setTitle:@"返回我的" forState:UIControlStateNormal];
                    [self.bottomRightBtn addTarget:self action:@selector(backToMine) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            //支付失败
            else {
                [weakself stopAnimated];
                weakself.stateImageView.image = [UIImage imageNamed:@"pay_fail_image"];
                weakself.desLab.text = @"账单支付失败";
                [self.bottomRightBtn setTitle:@"返回我的" forState:UIControlStateNormal];
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)backToMine {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//去看账单详情
- (void)checkOrderDetail {
    MyBillDetailVC *vc = [[MyBillDetailVC alloc] init];
    vc.billID = self.billID;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSArray *oldArr = self.navigationController.viewControllers;
    NSMutableArray *newArr = [NSMutableArray arrayWithCapacity:0];
    [newArr addObject:oldArr[0]];
    [newArr addObject:oldArr[1]];
    [newArr addObject:oldArr[oldArr.count - 1]];
    self.navigationController.viewControllers = [newArr copy];
}

//继续支付
- (void)goOnPay {
    PayVC *vc = [[PayVC alloc] init];
    vc.billID = self.billID;
    vc.recent = @(self.model.unpaidAmount).stringValue;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSArray *oldArr = self.navigationController.viewControllers;
    NSMutableArray *newArr = [NSMutableArray arrayWithCapacity:0];
    [newArr addObject:oldArr[0]];
    [newArr addObject:oldArr[1]];
    [newArr addObject:oldArr[2]];
    [newArr addObject:oldArr[oldArr.count - 1]];
    self.navigationController.viewControllers = [newArr copy];
}


- (void)beginAnimated {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [_stateImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimated {
    [_stateImageView.layer removeAllAnimations];
}

- (void)dealloc {
    [self stopAnimated];
}
@end
