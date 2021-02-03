//
//  UIScrollView+MJRefresh.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/16.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (MJRefresh)

/**
 下拉刷新

 @param beginRefresh 是否自动刷新
 @param animation 是否需要动画
 @param refreshBlock 刷新回调
 */
//- (void)addHeaderWithRefresh:(BOOL)beginRefresh animation:(BOOL)animation refreshBlock:(void(^)(NSInteger pageIndex))refreshBlock;
//- (void)addHeaderWithRefresh:(BOOL)animation refreshBlock:(void(^)(NSInteger pageIndex))refreshBlock;
- (void)addHeaderWithRefresh:(void(^)(NSInteger pageIndex))refreshBlock;

/**
 上啦加载

 @param automaticallyRefresh 是否自动加载
 @param loadMoreBlock 加载回调
 */
- (void)addFooterWithRefresh:(BOOL)automaticallyRefresh loadMoreBlock:(void(^)(NSInteger pageIndex))loadMoreBlock;
- (void)addFooterWithRefresh:(void(^)(NSInteger pageIndex))loadMoreBlock;

/**
 普通请求结束刷新
 */
- (void)endFooterRefresh;


/**
 没有数据结束刷新
 */
- (void)endFooterNoMoreData;

@end

NS_ASSUME_NONNULL_END
