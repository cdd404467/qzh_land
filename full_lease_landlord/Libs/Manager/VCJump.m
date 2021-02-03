//
//  VCJump.m
//  full_lease_landlord
//
//  Created by apple on 2020/10/16.
//  Copyright © 2020 apple. All rights reserved.
//

#import "VCJump.h"
#import "ApnsModel.h"
#import "SignLeaseConListVC.h"
#import "IncomeListVC.h"
#import "WalletRecordVC.h"


@implementation VCJump
+ (void)jumpToWithModel_Apns:(NSDictionary *)dict {
    ApnsModel *model = [ApnsModel mj_objectWithKeyValues:dict];
    [self jumpPageWithType:model.type];
}


+ (void)jumpPageWithType:(NSInteger)type {
    UITabBarController *rootVC = (UITabBarController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    //签约
    if (type == 1) {
        SignLeaseConListVC *vc = [[SignLeaseConListVC alloc] init];
        BaseNavigationController *nav = rootVC.viewControllers[rootVC.selectedIndex];
        [nav pushViewController:vc animated:YES];
    }
    
    else if (type == 16) {
        rootVC.selectedIndex = 1;
        SignLeaseConListVC *vc = [[SignLeaseConListVC alloc] init];
        BaseNavigationController *nav = rootVC.viewControllers[rootVC.selectedIndex];
        [nav pushViewController:vc animated:YES];
    }
    //提现
    else if (type == 17) {
        rootVC.selectedIndex = 1;
        WalletRecordVC *vc = [[WalletRecordVC alloc] init];
        BaseNavigationController *nav = rootVC.viewControllers[rootVC.selectedIndex];
        [nav pushViewController:vc animated:YES];
    }
}


@end
