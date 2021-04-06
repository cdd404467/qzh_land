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

@property (assign, nonatomic) NSInteger pageCount;

- (void)addHeaderWithRefresh:(void(^)(NSInteger pageIndex))refreshBlock;


- (void)addFooterWithRefresh:(void(^)(NSInteger pageIndex))loadMoreBlock;


- (void)endRefreshWithDataCount:(NSInteger)count;


@end

NS_ASSUME_NONNULL_END
