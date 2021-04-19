//
//  HouseEntrustVC.m
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "HouseEntrustVC.h"
#import "EntrustOnlineVC.h"
#import <WebKit/WebKit.h>

@interface HouseEntrustVC ()

@end

@implementation HouseEntrustVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"房屋委托";
    [self setupUI];
}

- (void)setupUI {
    WKWebView *webView = [[WKWebView alloc] init];
    webView.scrollView.bounces = NO;
    webView.backgroundColor = UIColor.whiteColor;
    NSURL *url = [NSURL URLWithString:LightServicesH5];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAV_HEIGHT);
        make.bottom.mas_equalTo(-(TABBAR_HEIGHT + 30));
    }];
    
    
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
