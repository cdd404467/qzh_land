//
//  WebViewVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/10/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import "WebViewVC.h"
#import <WebKit/WebKit.h>

@interface WebViewVC ()<WKNavigationDelegate>
@property (nonatomic, strong)WKWebView *webView;
@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = _webTitle;
    [self loadWebView];
}

- (void)loadWebView
{
    //1.创建WKWebView
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - NAV_HEIGHT - Bottom_Height_Dif)];
    _webView.backgroundColor = UIColor.whiteColor;
    _webView.navigationDelegate = self;
    //2.创建URL
    NSString *urlString = _webUrl;
    NSURL *URL = [NSURL URLWithString:urlString];
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //4.加载Request
    [_webView loadRequest:request];
    //5.添加到视图
    [self.view addSubview:_webView];
    
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

//添加KVO监听,计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"])
    {
//        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
//
//        if (newprogress == 1)
//        {
//            self.progressView.hidden = YES;
//            [self.progressView setProgress:0 animated:NO];
//        }
//        else
//        {
//            self.progressView.hidden = NO;
//            [self.progressView setProgress:newprogress animated:YES];
//        }
    } else if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        if (!isRightData(self.navTitle)) {
            self.navTitle = self.webView.title;
        }
    }
    
}
@end
