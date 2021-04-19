//
//  PreviewConVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/10/19.
//  Copyright © 2020 apple. All rights reserved.
//

#import "PreviewConVC.h"
#import <WebKit/WebKit.h>

@interface PreviewConVC ()

@end

@implementation PreviewConVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"预览合同";
    [self requestConAddress];
}


- (void)requestConAddress {
    NSDictionary *dict = @{@"id":_conID,
                           @"contractType":@(_type)
    };
    [CddHud show:self.view];
    [NetTool postRequest:URLPost_Con_Download Params:dict Success:^(id  _Nonnull json) {
        if (JsonCode == 200) {
            [self downLoadConWithURL:json[@"data"][@"data"]];
        } else {
            [CddHud hideHUD:self.view];
        }
    } Failure:^(NSError * _Nonnull error) {
        [CddHud hideHUD:self.view];
    }];
}


- (void)downLoadConWithURL:(NSString *)url {
    [NetTool downLoadRequest:url Params:nil Success:^(id  _Nonnull json) {
        [CddHud hideHUD:self.view];
//        NSLog(@"---- %@",json);
        [self previewPDF:json];
    } Failure:^(NSError * _Nonnull error) {
        [CddHud hideHUD:self.view];
    }];
}


- (void)previewPDF:(NSURL *)filePath {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT - NAV_HEIGHT)];
    webView.backgroundColor = UIColor.whiteColor;
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
@end
