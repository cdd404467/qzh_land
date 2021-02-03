//
//  BaseViewController.h
//  SH
//
//  Created by i7colors on 2019/9/2.
//  Copyright © 2019 surhoo. All rights reserved.
//

#import "CustomNavBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
//有tableView的页面用到的属性
@property (nonatomic, assign)NSInteger pageNumber;
@property (nonatomic, assign)int totalNumber;
//返回按钮模式 - 0:返回箭头 1:关闭箭头
@property (nonatomic, assign) NSInteger backMode;

//nav 返回按钮的
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) CustomNavBar *navBar;
@property (nonatomic, copy) NSString *navTitle;
- (void)jumpToLoginWithComplete:(void (^ __nullable)(void))handler;
@end

NS_ASSUME_NONNULL_END
