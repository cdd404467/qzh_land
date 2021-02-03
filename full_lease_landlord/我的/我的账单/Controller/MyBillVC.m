//
//  MyBillVC.m
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import "MyBillVC.h"
#import <SGPagingView.h>
#import "MyBillChildVC.h"

@interface MyBillVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本
@end

@implementation MyBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"我的账单";
    [self setupUI];
}

- (void)setupUI {
    CGFloat titleHeight = 42;
    NSArray *titleArr = @[@"未缴账单",@"完成账单"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
//    configure.indicatorStyle = SGIndicatorStyleCover;
//    configure.indicatorAdditionalWidth = 10;
    configure.titleColor = HEXColor(@"#333333", 1);
    configure.indicatorColor = MainColor;
    configure.indicatorAnimationTime = 0.3f;
    configure.showBottomSeparator = NO;
    configure.indicatorCornerRadius = 2.f;
//    configure.indicatorHeight = 30;
    configure.titleSelectedColor = MainColor;
    configure.titleFont = kFont(15);
    configure.titleSelectedFont = kFont(17);
    CGRect titleRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, titleHeight);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:_pageTitleView];
    
    NSMutableArray *childArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        MyBillChildVC *vc = [[MyBillChildVC alloc] init];
        vc.type = i;
        vc.conID = _conID;
        [childArr addObject:vc];
    }

    CGRect contentRect = CGRectMake(0, titleHeight + NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - titleHeight);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:contentRect parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    _pageContentScrollView.isAnimated = YES;
}


- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollViewWillBeginDragging {
    _pageTitleView.userInteractionEnabled = NO;
}

- (void)pageContentScrollViewDidEndDecelerating {
    _pageTitleView.userInteractionEnabled = YES;
}

@end
