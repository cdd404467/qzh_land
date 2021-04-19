//
//  MineVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/21.
//  Copyright © 2020 apple. All rights reserved.
//

#import "MineVC.h"
#import "CommonlyUsedTools.h"
#import "MyBillVC.h"
#import "MsgTypeListVC.h"
#import "LeaseBillVC.h"
#import "MyLeaseVC.h"
#import "SignLeaseConListVC.h"
#import <PPBadgeView.h>
#import "MyWalletVC.h"
#import "SmartDoorLockListVC.h"
#import "NSString+Extension.h"
#import "full_lease_landlord-Swift.h"


@interface MineVC ()<CommonlyUsedToolsDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *userImg;
@property (nonatomic, strong) UILabel *clickTitle;
@property (nonatomic, strong) UILabel *totalMoneyLab;
@property (nonatomic, strong)UIButton *eyesBtn;
@property (nonatomic, strong)UIView *headView;
@property (nonatomic, strong)UIButton *msgBtn;
@property (nonatomic, strong)GoSignView *conView;
@property (nonatomic, strong)GoSignView *agreementView;
@property (nonatomic, assign)NSInteger conCount;
@property (nonatomic, assign)NSInteger ownerConCount;
@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserInfo) name:NotificationName_UserLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayUserInfo) name:NotificationName_UserExitLogin object:nil];
    [self setupUI];
    if (isUserLogin) {
        [self requestInfo];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isUserLogin) {
        [self requestInfo];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATEBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - Top_Height_Dif)];
//        _scrollView.bounces = NO;
        DDWeakSelf;
        _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (isUserLogin) {
                [weakself requestInfo];
            }
        }];
    }
    return _scrollView;
}

//显示信息
- (void)displayUserInfo {
    if (isUserLogin) {
        self.clickTitle.text = User_Name;
        [self requestInfo];
    } else {
        self.clickTitle.text = @"立即登录";
        self.conView.hidden = YES;
        self.agreementView.hidden = YES;
        [self changeFrame];
        [self.msgBtn pp_hiddenBadge];
        [self displayMoney];
    }
}

- (void)requestInfo {
    [NetTool getRequest:URLGet_MinePage_Info Params:nil Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            //累计收益
            NSString *totalRevenue = [json[@"data"][@"wallet"][@"totalRevenue"] stringValue];
            NSMutableDictionary *mDict = [User_Info mutableCopy];
            [mDict setValue:[totalRevenue correctPrecision] forKey:@"userMoney"];
            [UserDefault setObject:[mDict copy] forKey:@"userInfo"];
            [self displayMoney];
            //消息数量
            NSInteger msgNum = [json[@"data"][@"numberMessages"] integerValue];
            if (msgNum > 0) {
                [self.msgBtn pp_addDotWithColor:UIColor.redColor];
                [self.msgBtn pp_showBadge];
            } else {
                [self.msgBtn pp_hiddenBadge];
            }
            //租客合同待签约条数接
            NSInteger count = [json[@"data"][@"totalNums"] integerValue];
            self.conCount = count;
            if (count > 0) {
                self.conView.hidden = NO;
            } else {
                self.conView.hidden = YES;
            }
            self.conView.msgTitle.text = [NSString stringWithFormat:@"你有%ld份待签约合同",count];
            //业主合同待签约条数
            NSInteger ownerCount = [json[@"data"][@"ownerTotalNums"] integerValue];
            self.ownerConCount = ownerCount;
            if (ownerCount > 0) {
                self.agreementView.hidden = NO;
            } else {
                self.agreementView.hidden = YES;
            }
            self.agreementView.msgTitle.text = [NSString stringWithFormat:@"你有%ld份待签约服务协议",ownerCount];
        }
        [self.scrollView.mj_header endRefreshing];
        [self changeFrame];
    } Failure:^(NSError * _Nonnull error) {
        [self.scrollView.mj_header endRefreshing];
    }];
}

- (void)changeFrame {
    if (self.conView.hidden == NO && self.agreementView.hidden == NO) {
        [self.agreementView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.conView.mas_bottom).offset(KFit_W(10));
            make.left.right.height.mas_equalTo(self.conView);
        }];
    } else if (self.conView.hidden == YES && self.agreementView.hidden == YES) {
        [self.agreementView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.conView);
            make.left.right.mas_equalTo(self.conView);
            make.height.mas_equalTo(0);
        }];
    } else {
        [self.agreementView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.conView);
            make.left.right.height.mas_equalTo(self.conView);
        }];
    }
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    CGFloat paddingLR = KFit_W(16);
    UIView *headView = [[UIView alloc] init];
    headView.layer.backgroundColor = UIColor.whiteColor.CGColor;
    headView.layer.cornerRadius = 5;
    headView.layer.shadowColor = HEXColor(@"#000000", 0.09).CGColor;
    headView.layer.shadowOffset = CGSizeMake(0,0);
    headView.layer.shadowOpacity = 1;
    headView.layer.shadowRadius = 5;
    [self.scrollView addSubview:headView];
    _headView = headView;
    
    UIView *topHeadRow = [[UIView alloc] initWithFrame:CGRectMake(0, KFit_W(14), headView.width, KFit_W(70))];
    [headView addSubview:topHeadRow];
    
    self.userImg = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userImg.frame = CGRectMake(KFit_W(12), KFit_W(16), KFit_W(54), KFit_W(54));
    self.userImg.layer.cornerRadius = self.userImg.width/2;
    self.userImg.layer.borderWidth = KFit_W(2);
    self.userImg.layer.masksToBounds = true;
    self.userImg.layer.borderColor = UIColor.whiteColor.CGColor;
    self.userImg.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.userImg.adjustsImageWhenHighlighted = NO;
    [self.userImg setImage:[UIImage imageNamed:@"default_user_photo"] forState:UIControlStateNormal];
    [HelperTool addTapGesture:self.userImg withTarget:self andSEL:@selector(clickLogin)];
    [topHeadRow addSubview:self.userImg];
    
    UILabel *clickTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KFit_W(228), KFit_W(30))];
    clickTitle.text = isUserLogin ? User_Name : @"立即登录";
    clickTitle.font = kFont(18);
    clickTitle.left = self.userImg.right + KFit_W(6);
    clickTitle.centerY = self.userImg.centerY;
    [HelperTool addTapGesture:clickTitle withTarget:self andSEL:@selector(clickLogin)];
    self.clickTitle  = clickTitle;
    [topHeadRow addSubview:clickTitle];
    
    UIButton *msgBtn = [[UIButton alloc] init];
    [msgBtn setImage:[UIImage imageNamed:@"msg_navbar_icon"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(jumpToMessage) forControlEvents:UIControlEventTouchUpInside];
    [topHeadRow addSubview:msgBtn];
    [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KFit_W(24), KFit_W(24)));
        make.right.mas_equalTo(topHeadRow.mas_right).offset(-KFit_W(12));
        make.top.mas_equalTo(0);
    }];
    _msgBtn = msgBtn;
    
    UILabel *totaltxt = [[UILabel alloc] initWithFrame:CGRectMake(_userImg.left, topHeadRow.bottom + KFit_W(15), 70, 15)];
    totaltxt.textColor = HEXColor(@"#333333", 1);
    totaltxt.font = kFont(12);
    totaltxt.text = @"累计收益(元)";
    [headView addSubview:totaltxt];
    [totaltxt sizeToFit];
    
    _eyesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _eyesBtn.frame = CGRectMake(totaltxt.right + 6, 0, 17, 13);
    _eyesBtn.centerY = totaltxt.centerY;
    [_eyesBtn setImage:[UIImage imageNamed:@"icon_eye_open"] forState:UIControlStateNormal];
    [_eyesBtn setImage:[UIImage imageNamed:@"icon_eye_close"] forState:UIControlStateSelected];
    [_eyesBtn addTarget:self action:@selector(moneyCanSee) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_eyesBtn];
    
    _totalMoneyLab = [[UILabel alloc] initWithFrame:CGRectMake(totaltxt.left, totaltxt.bottom + KFit_W(12), 200, 15)];
    _totalMoneyLab.textColor = HEXColor(@"#333333", 1);
    _totalMoneyLab.font = kFont(18);
    _totalMoneyLab.text = isUserLogin ? User_Money : @"0";
    [headView addSubview:_totalMoneyLab];
    
    GoSignView *conView = [[GoSignView alloc] init];
    [conView.signingBtn addTarget:self action:@selector(goSignOnline) forControlEvents:UIControlEventTouchUpInside];
    conView.hidden = YES;
    conView.layer.cornerRadius = KFit_W(14);
    [headView addSubview:conView];
    [conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalMoneyLab.mas_bottom).offset(KFit_W(28));
        make.left.mas_equalTo(KFit_W(15));
        make.right.mas_equalTo(KFit_W(-15));
        make.height.mas_equalTo(KFit_W(28));
    }];
    _conView = conView;
    
    GoSignView *agreementView = [[GoSignView alloc] init];
    [agreementView.signingBtn addTarget:self action:@selector(goAgreeMent) forControlEvents:UIControlEventTouchUpInside];
    agreementView.hidden = YES;
    agreementView.layer.cornerRadius = conView.layer.cornerRadius;
    [headView addSubview:agreementView];
    [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.conView);
        make.left.right.mas_equalTo(self.conView);
        make.height.mas_equalTo(0);
    }];
    _agreementView = agreementView;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(paddingLR);
        make.right.mas_equalTo(self.view.mas_right).offset(-paddingLR);
        make.top.mas_equalTo(KFit_W(30));
        make.bottom.mas_equalTo(agreementView.mas_bottom).offset(KFit_W(15));
    }];
    
    [topHeadRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(KFit_W(14));
        make.width.mas_equalTo(headView);
        make.height.mas_equalTo(KFit_W(70));
    }];
    
    CommonlyUsedTools *tools = [[CommonlyUsedTools alloc] init];
    tools.delegate = self;
    [self.scrollView addSubview:tools];
    [tools mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(headView.mas_bottom).offset(KFit_W(60));
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(KFit_W(50) * 2 + KFit_W(32));
    }];
}

#pragma mark - 代理点击事件
- (void)clickToolItem:(NSInteger)index {
    if (index != 5 && !isUserLogin) {
        [self jumpToLoginWithComplete:nil];
        return;
    }
    if (index == 0) {
        MyWalletVC *vc = [[MyWalletVC alloc] init];
//        TestSwift *vc = [[TestSwift alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 1) {
        MyBillVC *vc = [[MyBillVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 2) {
        LeaseBillVC *vc = [[LeaseBillVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 3) {
        MyLeaseVC *vc = [[MyLeaseVC alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 4) {
        SmartDoorLockListVC *vc = [[SmartDoorLockListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 5) {
        SystemSettingsVC *vc = [[SystemSettingsVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)goSignOnline {
    SignLeaseConListVC *vc = [[SignLeaseConListVC alloc] init];
    vc.count = self.conCount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goAgreeMent {
    MyLeaseVC *vc = [[MyLeaseVC alloc] init];
    vc.type = 2;
    vc.count = self.ownerConCount;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)moneyCanSee {
    _eyesBtn.selected = !_eyesBtn.selected;
    [self displayMoney];
}

- (void)displayMoney {
    _totalMoneyLab.text = _eyesBtn.selected ? @"******" : isUserLogin ? User_Money : @"0";
}


- (void)jumpToMessage {
    if (!isUserLogin) {
        [self jumpToLoginWithComplete:nil];
        return;
    }
    MsgTypeListVC *vc = [[MsgTypeListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**点击登录按钮*/
-(void)clickLogin{
    if (!isUserLogin) {
        [self jumpToLoginWithComplete:nil];
    }
}
@end
