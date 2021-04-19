//
//  UIScrollView+MJRefresh.m
//  full_lease_landlord
//
//  Created by apple on 2020/11/16.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UIScrollView+MJRefresh.h"
#import <MJRefresh.h>
#import <objc/runtime.h>


typedef void(^RefreshBlock)(NSInteger pageIndex);
typedef void(^LoadMoreBlock)(NSInteger pageIndex);

@interface UIScrollView()

/**页码*/
@property (assign, nonatomic) NSInteger pageIndex;
/**下拉时候触发的block*/
@property (nonatomic, copy) RefreshBlock refreshBlock;
/**上拉时候触发的block*/
@property (nonatomic, copy) LoadMoreBlock loadMoreBlock;

@end

@implementation UIScrollView (MJRefresh)

- (void)addHeaderWithRefresh:(void(^)(NSInteger pageIndex))refreshBlock {
    self.pageIndex = 1;
    __weak typeof(self) weakSelf = self;
    self.refreshBlock = refreshBlock;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndex = 1;
        if (weakSelf.refreshBlock) {
            weakSelf.refreshBlock(weakSelf.pageIndex);
        }
    }];

    self.mj_header = header;
}

- (void)addFooterWithRefresh:(void(^)(NSInteger pageIndex))loadMoreBlock {
    self.pageIndex = 1;
    __weak typeof(self) weakSelf = self;
    self.loadMoreBlock = loadMoreBlock;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageIndex += 1;
        if (weakSelf.loadMoreBlock) {
            weakSelf.loadMoreBlock(weakSelf.pageIndex);
        }
    }];
    
    footer.automaticallyRefresh = YES;
    self.mj_footer = footer;
}

- (void)resetNoMoreData {
    [self.mj_footer resetNoMoreData];
}

- (void)endRefreshWithDataCount:(NSInteger)count {
    if (count == 0 && self.pageIndex == 1) {
        self.mj_footer.hidden = YES;
    } else {
        self.mj_footer.hidden = NO;
    }
    
    if (count < self.pageCount || count < 5) {
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshingWithNoMoreData];
    } else {
        if (self.mj_header.isRefreshing) {
            [self.mj_header endRefreshing];
            [self.mj_footer resetNoMoreData];
        }
        if (self.mj_footer.isRefreshing) {
            [self.mj_footer endRefreshing];
        }
    }
}



/* 添加属性 */
static void *pagaIndexKey = &pagaIndexKey;
- (void)setPageIndex:(NSInteger)pageIndex{
    objc_setAssociatedObject(self, &pagaIndexKey, @(pageIndex), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)pageIndex
{
    return [objc_getAssociatedObject(self, &pagaIndexKey) integerValue];
}

static void *pagaCountKey = &pagaCountKey;
- (void)setPageCount:(NSInteger)pageCount {
    objc_setAssociatedObject(self, &pagaCountKey, @(pageCount), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)pageCount
{
    return [objc_getAssociatedObject(self, &pagaCountKey) integerValue];
}


static void *RefreshBlockKey = &RefreshBlockKey;
- (void)setRefreshBlock:(void (^)(void))RefreshBlock{
    objc_setAssociatedObject(self, &RefreshBlockKey, RefreshBlock, OBJC_ASSOCIATION_COPY);
}

- (RefreshBlock)refreshBlock
{
    return objc_getAssociatedObject(self, &RefreshBlockKey);
}

static void *LoadMoreBlockKey = &LoadMoreBlockKey;
- (void)setLoadMoreBlock:(LoadMoreBlock)loadMoreBlock{
    objc_setAssociatedObject(self, &LoadMoreBlockKey, loadMoreBlock, OBJC_ASSOCIATION_COPY);
}

- (LoadMoreBlock)loadMoreBlock
{
    return objc_getAssociatedObject(self, &LoadMoreBlockKey);
}

@end
