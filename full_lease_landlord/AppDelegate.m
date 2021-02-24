//
//  AppDelegate.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/21.
//  Copyright © 2020 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageVC.h"
#import <JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "AvoidCrash.h"
#import "TabbarVC.h"
#import <IQKeyboardManager.h>
#import "KSGuaidViewManager.h"
#import "SignLeaseConListVC.h"
#import "AppDelegate+Init.h"
#import <TTLock/TTLock.h>
#import "WXApiManager.h"
#import <AlipaySDK/AlipaySDK.h>

#if !TARGET_IPHONE_SIMULATOR
#import <AipOcrSdk/AipOcrSdk.h>
#endif
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initWindow];
    [self initThirdParty];
    [self guidePage];
    //注册通知
    [self registerAPNs:launchOptions application:application];
    if (!isDebug) {
        [AvoidCrash makeAllEffective];
    }
    return YES;
}

//从后台回到前台（即将到前台）
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_ApplicationWillEnterForeground object:nil userInfo:nil];
}

//已经回到前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_ApplicationDidBecomeActive object:nil userInfo:nil];
    
}

//app即将被挂起
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

//已经在后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

//打开app处理URL
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString *urlString = url.absoluteString;
    if (url && urlString.length > 2 && [[urlString substringToIndex:2] isEqualToString:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
        }];
    }
    
    return YES;
}

#pragma mark - APN代理
//推送通知获取设备
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册 APNs 失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"APNs注册失败: %@", error);
}

// Required, iOS 7 Support - 处于后台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateBackground) {

    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 Support 点击
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    NSLog(@"2------ %@",userInfo);
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [self dealWithApsWithDict:userInfo];
            [JPUSHService handleRemoteNotification:userInfo];
        }
    }
    completionHandler();  // 系统要求执行这个方法
}


// iOS 10 Support 在前台收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)) {
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"1------ %@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [self msgCountWithDict:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    //UNNotificationPresentationOptionAlert
    ///UNNotificationPresentationOptionBadge
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
}


// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        从通知界面直接进入应用
        NSLog(@"---1212");
    }else{
//        从通知设置界面进入应用
        NSLog(@"---1212 ----- ");
    }
}


- (void)registerAPNs:(NSDictionary *)launchOptions application:(UIApplication *)application {
    /*** 注册极光推送 ***/
    //初始化 APNs 代码
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setLogOFF];
    //初始化 JPush 代码
    [JPUSHService setupWithOption:launchOptions appKey:@"87ee6a45759c50410a9cc454" channel:@"App Store" apsForProduction:YES];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode ==0) {
            NSLog(@"registrationID--- %@",registrationID);
            [UserDefault setObject:registrationID forKey:@"jpushID"];
        }
    }];
    
    // app未启动的状态下，在这里处理远程通知
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        
    }
    
    //注册监听推送
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(customJpushHandle:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)guidePage {
    KSGuaidManager.images = @[[UIImage imageNamed:@"guidepage_1"],
                              [UIImage imageNamed:@"guidepage_2"],
                              [UIImage imageNamed:@"guidepage_3"],
                              [UIImage imageNamed:@"guidepage_4"]
    ];
    CGSize size = [UIScreen mainScreen].bounds.size;
    KSGuaidManager.dismissButtonCenter = CGPointMake(size.width / 2, size.height - 70);
    KSGuaidManager.pageIndicatorTintColor = HEXColor(@"#DCDCDC", 1);
    KSGuaidManager.currentPageIndicatorTintColor = HEXColor(@"#FF6108", 1);
    dispatch_async(dispatch_get_main_queue(), ^{
        [KSGuaidManager begin];
    });
}

#pragma mark - UISceneSession lifecycle
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


- (void)initThirdParty {
    /*** IQKeyBoard ***/
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;    // 输入框距离键盘的距离
#if !TARGET_IPHONE_SIMULATOR
    [[AipOcrService shardService] authWithAK:@"Qk8vCsW72ThVfOSX0qYBsQeQ" andSK:@"DZNlmW8XGBWnGw138RWL9EgFXkGHpqXq"];
#endif
    /*** 注册微信 - 官方SDK ***/
    [WXApi registerApp:wxAppID universalLink:@"https://qzhimg.comprorent.com/"];
    [TTLock setupBluetooth:^(TTBluetoothState state) {
        NSLog(@"##############  TTLock is working, bluetooth state: %ld  ##############",(long)state);
    }];
}

- (void)initWindow {
    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    if(@available(iOS 13.0,*)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    //加载根视图视图
    TabbarVC *rootVC = [[TabbarVC alloc] init];
    rootVC.selectedIndex = 0;
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}
@end
