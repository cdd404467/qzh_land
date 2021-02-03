//
//  ContractConfirmVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ContractConfirmVC.h"
#import <WebKit/WebKit.h>
#import "SignOnlineVC.h"

@interface ContractConfirmVC ()
@property (nonatomic, strong)WKWebView *webView;
@end

@implementation ContractConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"合同确认";
    [self requestData];
}

- (void)loadWebView:(NSString *)string {
    //1.创建WKWebView
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 59)];
    _webView.backgroundColor = UIColor.whiteColor;
    [_webView loadHTMLString:string baseURL:nil];
    [self.view addSubview:_webView];
}

- (void)requestData {
    NSDictionary *dict = @{@"id":_conID};
    [NetTool postRequest:URLPost_Preview_Con Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [self loadWebView:json[@"data"][@"content"]];
            [self setupUI];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.layer.cornerRadius = 4.f;
    [signBtn setTitle:@"电子签约" forState:UIControlStateNormal];
    signBtn.titleLabel.font = kFont(18);
    [signBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    signBtn.backgroundColor = HEXColor(@"28C3CE", 1);
    [signBtn addTarget:self action:@selector(signOnline) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signBtn];
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(TABBAR_HEIGHT));
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(49);
    }];
    
    [self.view addSubview:signBtn];
}

- (void)signOnline {
    SignOnlineVC *vc = [[SignOnlineVC alloc] init];
    vc.conID = _conID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
