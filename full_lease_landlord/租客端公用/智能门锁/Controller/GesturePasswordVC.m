//
//  GesturePasswordVC.m
//  FullLease
//
//  Created by apple on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "GesturePasswordVC.h"
#import "PCGestureUnlock.h"
#import "UpdateLockPasswordVC.h"
#import "SmartDoorLockVC.h"

@interface GesturePasswordVC ()<CircleViewDelegate>
@property (nonatomic, strong) PCCircleView *lockView;
@property (nonatomic, strong) PCLockLabel *msgLabel;
@property (nonatomic, strong) PCCircleInfoView *infoView;
@property (nonatomic, strong)UIButton *resetBtn;
@property (nonatomic, copy)NSString *password;
@end

@implementation GesturePasswordVC

+ (void)popGestureClose:(UIViewController *)VC
{
    // 禁用侧滑返回手势
    if ([VC.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势禁用
        for (UIGestureRecognizer *popGesture in VC.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = NO;
        }
    }
}

+ (void)popGestureOpen:(UIViewController *)VC
{
    // 启用侧滑返回手势
    if ([VC.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势启用
        for (UIGestureRecognizer *popGesture in VC.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = YES;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [GesturePasswordVC popGestureClose:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GesturePasswordVC popGestureOpen:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_type == 1) {
        self.navTitle = @"设置手势密码";
    } else if (_type == 2){
        self.navTitle = @"验证手势密码";
    } else if (_type == 3) {
        self.navTitle = @"重置手势密码";
    }
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    
    [self setupUI];
}



- (void)setupUI {
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, NAV_HEIGHT + 40, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.centerX = self.view.centerX;
    self.infoView = infoView;
    [self.view addSubview:infoView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.top = infoView.bottom + 15;
    self.msgLabel = msgLabel;
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    [self.view addSubview:msgLabel];
    
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.top = msgLabel.bottom + 20;
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake(0, lockView.bottom + 15, 150, 30);
    resetBtn.centerX = self.view.centerX;
    [resetBtn setTitle:@"重设密码" forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resetBtn addTarget:self action:@selector(didClickResetBtn) forControlEvents:UIControlEventTouchUpInside];
    [resetBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [self.view addSubview:resetBtn];
    _resetBtn = resetBtn;
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = resetBtn.frame;
    [forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitle:@"忘记手势密码?" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [self.view addSubview:forgetBtn];
    
    if (_type == 1 || _type == 3) {
        [self.lockView setType:CircleViewTypeSetting];
        resetBtn.hidden = YES;
        forgetBtn.hidden = YES;
    } else {
        [self.lockView setType:CircleViewTypeLogin];
        resetBtn.hidden = YES;
        infoView.hidden = YES;
    }
}

- (void)forgetPassword {
    UpdateLockPasswordVC *vc = [[UpdateLockPasswordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)checkOrSetPass {
    NSString *type = [NSString string];
    if (_type == 1 || _type == 3) {
        type = @"set";
    } else {
        type = @"check";
    }
    
    NSDictionary *dict = @{@"gestureCode":self.password,
                           @"operType":type
    };
    DDWeakSelf;
    [NetTool postRequest:URLPost_Set_ChectPass Params:dict Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            if ([json[@"data"][@"Code"] integerValue] == 0) {
                if (self.type == 1 || self.type == 3) {
                    [CddHud showTextOnly:@"手势密码设置成功" view:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakself.navigationController popToRootViewControllerAnimated:YES];
                    });
                } else if (self.type == 2) {
                    [self.msgLabel showNormalMsg:@"验证成功"];
                    SmartDoorLockVC *vc = [[SmartDoorLockVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    NSMutableArray *arr = [self.navigationController.viewControllers mutableCopy];
                    [arr removeObject:self];
                    self.navigationController.viewControllers = [arr copy];
                }
            } else {
                if (self.type == 1 || self.type == 3) {
                    [CddHud showTextOnly:@"手势密码设置失败" view:self.view];
                }
                else if (self.type == 2) {
                    [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
                }
            }
        } 
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 代理
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture {
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];

    // 看是否存在第一个密码
    if ([gestureOne length]) {
        self.resetBtn.hidden = NO;
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture {
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal {
    NSLog(@"获得第二个手势密码%@",gesture);
    if (equal) {
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        self.password = gesture;
        [self checkOrSetPass];
        
    } else {
        NSLog(@"两次手势不匹配！");
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        self.resetBtn.hidden = NO;
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal {
    self.password = gesture;
    if (_password.length < 4) {
        [self.msgLabel showWarnMsgAndShake:@"手势密码至少4位"];
        return;
    }
    [self checkOrSetPass];
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView {
    for (PCCircle *circle in circleView.subviews) {
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews {
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}

- (void)didClickResetBtn {
//    NSLog(@"点击了重设按钮");
    // 1.隐藏按钮
    self.resetBtn.hidden = YES;
    // 2.infoView取消选中
    [self infoViewDeselectedSubviews];
    // 3.msgLabel提示文字复位
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    // 4.清除之前存储的密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}
@end
