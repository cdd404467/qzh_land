//
//  AppDelegate+Init.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/21.
//  Copyright © 2020 apple. All rights reserved.
//

#import "AppDelegate+Init.h"
#import "TabbarVC.h"
#import <IQKeyboardManager.h>
#import "KSGuaidViewManager.h"
#import "ApnsModel.h"
#import "VCJump.h"


@implementation AppDelegate (Init)
- (void)initAll {
    //初始化试图
//    [self initWindow];
//    [self initThirdParty];
}

//- (void)initWindow {
//    //初始化window
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    if(@available(iOS 13.0,*)) {
//        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
//    }
//    //加载根视图视图
//    TabbarVC *rootVC = [[TabbarVC alloc] init];
//    rootVC.selectedIndex = 0;
//    self.window.rootViewController = rootVC;
//    [self.window makeKeyAndVisible];
//}

//- (void)initThirdParty {
//    [self guidePage];
//    /*** IQKeyBoard ***/
//    [IQKeyboardManager sharedManager].enable = YES;
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
//    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;    // 输入框距离键盘的距离
//}

//- (void)guidePage {
//    KSGuaidManager.images = @[[UIImage imageNamed:@"guidepage_1"],
//                              [UIImage imageNamed:@"guidepage_2"],
//                              [UIImage imageNamed:@"guidepage_3"],
//                              [UIImage imageNamed:@"guidepage_4"]
//    ];
//    CGSize size = [UIScreen mainScreen].bounds.size;
//    KSGuaidManager.dismissButtonCenter = CGPointMake(size.width / 2, size.height - 70);
//    KSGuaidManager.pageIndicatorTintColor = HEXColor(@"#DCDCDC", 1);
//    KSGuaidManager.currentPageIndicatorTintColor = HEXColor(@"#FF6108", 1);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [KSGuaidManager begin];
//    });
//}

//从通知栏点击跳转
- (void)dealWithApsWithDict:(NSDictionary *)dict {
    [VCJump jumpToWithModel_Apns:dict];
}


@end
