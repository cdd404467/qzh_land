//
//  PayWebVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/9/25.
//  Copyright © 2020 apple. All rights reserved.
//

#import "PayWebVC.h"
#import <WebKit/WebKit.h>
#import "PayStateVC.h"

@interface PayWebVC ()<WKNavigationDelegate>
@property (nonatomic, strong)WKWebView *webView;
@end

@implementation PayWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"支付";
    [self loadWebView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPayState) name:NotificationName_ApplicationDidBecomeActive object:nil];
}

- (void)checkPayState {
    PayStateVC *vc = [[PayStateVC alloc] init];
    vc.billID = self.billID;
    vc.orderID = self.orderID;
    [self.navigationController pushViewController:vc animated:NO];
    NSMutableArray *newArr = [self.navigationController.viewControllers mutableCopy];
    [newArr removeObject:self];
    self.navigationController.viewControllers = [newArr copy];
}

- (void)loadWebView {
    //1.创建WKWebView
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - NAV_HEIGHT)];
    _webView.backgroundColor = UIColor.whiteColor;
    _webView.navigationDelegate = self;
    //2.创建URL
    NSURL *URL = [NSURL URLWithString:_urlString];
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //4.加载Request
    [_webView loadRequest:request];
    //5.添加到视图
    [self.view addSubview:_webView];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString containsString:@"weixin://"] || [navigationAction.request.URL.absoluteString containsString:@"alipays://"]  ) {
        // 通过浏览器访问
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler (WKNavigationActionPolicyAllow);
    }
    return ;//不添加会崩溃
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
