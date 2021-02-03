//
//  SceneDelegate.m
//  full_lease_landlord
//
//  Created by apple on 2020/8/21.
//  Copyright © 2020 apple. All rights reserved.
//

#import "SceneDelegate.h"
#import "TabbarVC.h"
#import "KSGuaidViewManager.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
//    if(@available(iOS 13.0,*)){
      [self initWindow:scene];
//    }
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

- (void)initWindow:(UIScene *)scene {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window.frame = windowScene.coordinateSpace.bounds;
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

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
