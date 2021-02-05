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
@property (nonatomic,weak) UILabel *clickTitle;
@property (nonatomic, strong) UILabel *totalMoneyLab;
@property (nonatomic, strong)UIButton *eyesBtn;
@property (nonatomic, strong)UILabel *msgTitle;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIButton *msgBtn;
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
        self.bottomView.hidden = YES;
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
            //待签约条数接
            NSInteger count = [json[@"data"][@"totalNums"] integerValue];
            if (count > 0) {
                self.bottomView.hidden = NO;
            } else {
                self.bottomView.hidden = YES;
            }
            self.msgTitle.text = [NSString stringWithFormat:@"你有%ld份待签约合同",count];
        }
        [self.scrollView.mj_header endRefreshing];
    } Failure:^(NSError * _Nonnull error) {
        [self.scrollView.mj_header endRefreshing];
    }];
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    CGFloat paddingLR = KFit_W(16);
    
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(paddingLR, KFit_W(30),SCREEN_WIDTH - paddingLR * 2,KFit_W(210));
    
    /**阴影处理*/
    headView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:254/255.0 blue:255/255.0 alpha:1.0].CGColor;
    headView.layer.cornerRadius = 4;
    headView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    headView.layer.shadowOffset = CGSizeMake(-1,2);
    headView.layer.shadowOpacity = 1;
    headView.layer.shadowRadius = 5;
    
    UIView *viewShadow = [[UIView alloc] init];
    viewShadow.frame = CGRectMake(paddingLR,KFit_W(30),SCREEN_WIDTH - paddingLR * 2,KFit_W(210));
    viewShadow.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:254/255.0 blue:255/255.0 alpha:1.0].CGColor;
    viewShadow.layer.cornerRadius = 4;
    viewShadow.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
    viewShadow.layer.shadowOffset = CGSizeMake(2,-1);
    viewShadow.layer.shadowOpacity = 1;
    viewShadow.layer.shadowRadius = 5;
    
    [self.scrollView addSubview:viewShadow];
    [self.scrollView addSubview:headView];
    
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
    
    UIButton *msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KFit_W(24), KFit_W(24))];
    [msgBtn setImage:[UIImage imageNamed:@"msg_navbar_icon"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(jumpToMessage) forControlEvents:UIControlEventTouchUpInside];
    msgBtn.right = topHeadRow.width - KFit_W(12);
    [topHeadRow addSubview:msgBtn];
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
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(KFit_W(24), headView.height - KFit_W(40), KFit_W(295), KFit_W(28))];
    _bottomView.layer.cornerRadius = KFit_W(14);
    _bottomView.backgroundColor = HEXColor(@"#F1FBFC", 1);
    [headView addSubview:_bottomView];
    _bottomView.hidden = YES;
    
    _msgTitle = [[UILabel alloc] init];
    _msgTitle.font = kFont(12);
    _msgTitle.textColor = HEXColor(@"#606266", 1);
    [_bottomView addSubview:_msgTitle];
    [_msgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(14));
        make.centerY.mas_equalTo(self.bottomView);
    }];
    
    UIButton *signingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KFit_W(42), _bottomView.height)];
    [signingBtn setTitle:@"去签约" forState:UIControlStateNormal];
    [signingBtn setTitleColor:HEXColor(@"#64D9C1", 1) forState:UIControlStateNormal];
    [signingBtn addTarget:self action:@selector(goSignOnline) forControlEvents:UIControlEventTouchUpInside];
    signingBtn.titleLabel.font = kFont(12);
    signingBtn.right = _bottomView.width - KFit_W(14);
       signingBtn.centerY = _bottomView.height * 0.5;
    [_bottomView addSubview:signingBtn];
    
    CommonlyUsedTools *tools = [[CommonlyUsedTools alloc] initWithFrame:CGRectMake(0, headView.bottom + KFit_W(60), SCREEN_WIDTH, KFit_W(50) * 2 + KFit_W(32))];
    tools.delegate = self;
    [self.scrollView addSubview:tools];
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
