//
//  SignOnlineVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SignOnlineVC.h"
#import <WebKit/WebKit.h>

@interface SignOnlineVC ()

@end

@implementation SignOnlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"电子签约";
    [self signOnline];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)signOnline {
    
    NSDictionary *dict = @{@"id":_conID,
                           @"isRenters":@1
    };
    
    [NetTool postRequest:URLPost_Sign_Online Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [self loadWebView:json[@"data"]];
            [self.navBar.leftBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [self.navBar.leftBtn addTarget:self action:@selector(checkSignState) forControlEvents:UIControlEventTouchUpInside];
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)loadWebView:(NSString *)urlString {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - NAV_HEIGHT)];
    webView.backgroundColor = UIColor.whiteColor;
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)checkSignState {
    NSDictionary *dict = @{@"id":_conID,
                           @"isRenters":@1
    };
    
    [NetTool postRequest:URLPost_Sign_State Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            //0：未签 1：已签 2：拒签 3：已保全 其他：未知
            NSInteger state = [json[@"data"] integerValue];
            if (state == 0) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else if (state == 1) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else if (state == 2) {
                
            } else {
                
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
