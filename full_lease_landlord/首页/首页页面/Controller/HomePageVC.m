//
//  HomePageVC.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/21.
//  Copyright © 2020 apple. All rights reserved.
//

#import "HomePageVC.h"
#import <SDCycleScrollView.h>
#import "BannerModel.h"
#import "HomeSelectView.h"
#import "MyLeaseVC.h"
#import "HouseResourceVC.h"
#import "HouseEntrustVC.h"
#import "LeaseContractVC.h"
#import "UpdateView.h"
#import "MsgTypeListVC.h"
#import "SignLeaseConListVC.h"
#import <JPUSHService.h>
#import "WebViewVC.h"
#import "SystemTool.h"
#import "WXApiManager.h"
#import <zhPopupController.h>
#import "QrCodeView.h"
#import "full_lease_landlord-Swift.h"

@interface HomePageVC ()<SDCycleScrollViewDelegate,HomeSelectViewDelegate,WXApiManagerDelegate>
@property (nonatomic, weak) SDCycleScrollView *cycleScrollView;
@property (nonatomic, copy)NSArray *bannerArray;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"首页";
    self.navBar.rightBtn.hidden = NO;
//    NSLog(@"User_Token ------------- %@",User_Token);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestBanner) name:NotificationName_HomePageDataReload object:nil];
    [JPUSHService setBadge:0];
    Icon_BadgeValue = 0;
    UIImage *image = [UIImage imageNamed:@"msg_navbar_icon"];
    [self.navBar.rightBtn setImage:[image imageWithChangeTintColor:HEXColor(@"#333333", 1)] forState:UIControlStateNormal];
    [self.navBar.rightBtn addTarget:self action:@selector(jumpToMessage) forControlEvents:UIControlEventTouchUpInside];
    [self setupUI];
    [self performSelector:@selector(requestBanner)];
    [SystemTool requestSystemSetting];
    if (!isDebug) {
        [self checkVersionUpdate];
    }
    
}


- (void)requestBanner {
    [NetTool getRequest:URLGet_Banner_List Params:nil Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            self.bannerArray = [BannerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            NSMutableArray *imageUrls = [NSMutableArray array];
            for (BannerModel *model in self.bannerArray) {
                [imageUrls addObject:model.fileaddress];
            }
            self.cycleScrollView.imageURLStringsGroup = imageUrls;
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 版本检查更新
- (void)checkVersionUpdate {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *current_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dict = @{@"companyId":@647,
                           @"currentBanben":current_Version?:@"",
                           @"type":@7
    };
    [NetTool postRequest:URLPost_Check_Version Params:dict Success:^(id  _Nonnull json) {
        if ([json[@"code"] integerValue] == 200) {
            if ([json[@"data"][@"updateFlag"] integerValue] != 0) {
                UpdateView *updateView = [[UpdateView alloc] init];
                updateView.updateType = [json[@"data"][@"updateFlag"] integerValue];
                updateView.version = json[@"data"][@"responseObj"][@"banben"];
                NSString *handledStr = [json[@"data"][@"responseObj"][@"cont"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                updateView.content = handledStr;
//                updateView.url = RightDataSafe(json[@"data"][@"responseObj"][@"url"]);
                [UIApplication.sharedApplication.windows[0] addSubview:updateView];
            }
        }
    } Failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setupUI {
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(10, NAV_HEIGHT + 10, SCREEN_WIDTH - 20, KFit_W(200))];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView.autoScroll = YES;
    cycleScrollView.backgroundColor = BannerBgColor;
    cycleScrollView.autoScrollTimeInterval = 3.0;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView.clipsToBounds = true;
    cycleScrollView.placeholderImage = PlaceHolderImg;
    cycleScrollView.pageControlDotSize = CGSizeMake(6, 6);
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.layer.cornerRadius = 8;
    [self.view addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    HomeSelectView *homeSelectView = [[HomeSelectView alloc] initWithFrame:CGRectMake(0,cycleScrollView.bottom + KFit_W(30),SCREEN_WIDTH,KFit_W(255))];
    homeSelectView.delegate = self;
    [self.view addSubview:homeSelectView];
}

//点击回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *model = self.bannerArray[index];
    if (model.jumpWay == 1) {
        WebViewVC *vc = [[WebViewVC alloc] init];
        vc.webUrl = model.burl;
        vc.webTitle = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //跳转到原生
    else if (model.jumpWay == 2) {
        if (model.original == 1) {
            LandlordRecommendVC *vc = [[LandlordRecommendVC alloc] init];
            vc.urlString = model.burl;
            vc.navTitle = model.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark ---------------- homeBannerViewDelegate --------------------
-(void)selectBannerItemWithIndex:(NSInteger)index{
    if (!isUserLogin) {
        [self jumpToLoginWithComplete:nil];
        return;
    }
    if (index == 0) {
        MyLeaseVC *vc = [[MyLeaseVC alloc] init];
//        MyLease *vc = [[MyLease alloc] init];
//        TestSwift *vc = [[TestSwift alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 1) {
        HouseResourceVC *vc = [[HouseResourceVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 2) {
        SignLeaseConListVC *vc = [[SignLeaseConListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 3) {
        LeaseContractVC *vc = [[LeaseContractVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 4) {
        HouseEntrustVC *vc = [[HouseEntrustVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 5) {
        DecorateVC *vc = [[DecorateVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index == 6) {
        if ([WXApi isWXAppInstalled]) {
            [[WXApiManager sharedManager] launchMiniProgramWithUserName:@"gh_3b45348ad55f" path:@"/pages/index/index" type:WXMiniProgramTypeRelease];
            [WXApiManager sharedManager].delegate = self;
        } else {
            [CddHud showTextOnly:@"未安装微信app" view:self.view];
        }
    }
}

- (void)wxApiManagerLaunchMiniProgram:(BaseResp *)resp {
    if (resp.errCode != WXErrCodeUserCancel || resp.errCode != WXSuccess) {
        [AlertSystem alertTwo:@"跳转小程序失败，是否扫码打开小程序?" msg:nil cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
            [self showQrCode];
        } cancelCallBack:nil];
    }
}

- (void)showQrCode {
    QrCodeView *view = [[QrCodeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - KFit_W(100), SCREEN_WIDTH - KFit_W(100))];
    view.imageURL = MiniProgramQrcode;
    zhPopupController *popCtr = [[zhPopupController alloc] initWithView:view size:view.bounds.size];
    popCtr.dismissOnMaskTouched = YES;
    popCtr.becomeFirstResponded = YES;
    popCtr.keyboardChangeFollowed = YES;
    [popCtr showInView:self.view.window completion:NULL];
}



- (void)jumpToMessage {
    if (!isUserLogin) {
        [self jumpToLoginWithComplete:nil];
        return;
    }
    MsgTypeListVC *vc = [[MsgTypeListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
