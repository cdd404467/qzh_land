//
//  HouseEntrustVC.m
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "HouseEntrustVC.h"
#import "EntrustOnlineVC.h"

@interface HouseEntrustVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation HouseEntrustVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"房屋委托";
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 30)];
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, KFit_W(1267));
    }
    return _scrollView;
}


- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.contentSize.height)];
    bgImageView.image = [UIImage imageNamed:@"house_entrust_bg"];
    [self.scrollView addSubview:bgImageView];
    
    UIButton *phoneAskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneAskBtn.layer.cornerRadius = 4.f;
    phoneAskBtn.clipsToBounds = YES;
    [phoneAskBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
    phoneAskBtn.backgroundColor = HEXColor(@"#74A0F7", 1);
    [phoneAskBtn setImage:[UIImage imageNamed:@"icon_phone_ask"] forState:UIControlStateNormal];
    [phoneAskBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [phoneAskBtn addTarget:self action:@selector(contactPhone) forControlEvents:UIControlEventTouchUpInside];
    phoneAskBtn.titleLabel.font = kFont(16);
    phoneAskBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:phoneAskBtn];
    [phoneAskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(24));
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(- Bottom_Height_Dif - KFit_W(12));
        make.width.mas_equalTo(KFit_W(150));
    }];
    [phoneAskBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    
    UIButton *entrustBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [entrustBtn setTitle:@"在线委托" forState:UIControlStateNormal];
    entrustBtn.backgroundColor = HEXColor(@"#4478CF", 1);
    entrustBtn.layer.cornerRadius = 4.f;
    entrustBtn.clipsToBounds = YES;
    [entrustBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [entrustBtn setImage:[UIImage imageNamed:@"icon_house_entrust"] forState:UIControlStateNormal];
    [entrustBtn addTarget:self action:@selector(jumpToEntrustOnline) forControlEvents:UIControlEventTouchUpInside];
    entrustBtn.titleLabel.font = kFont(16);
    entrustBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:entrustBtn];
    [entrustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-24));
        make.height.width.bottom.mas_equalTo(phoneAskBtn);
    }];
    [entrustBtn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:5];
}

- (void)jumpToEntrustOnline {
    EntrustOnlineVC *vc = [[EntrustOnlineVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)contactPhone {
    if (isRightData(ContactPhone))
        Phone_Call(ContactPhone);
}

@end
