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
    [self addFooterWithRefresh:YES loadMoreBlock:loadMoreBlock];
}

- (void)addFooterWithRefresh:(BOOL)automaticallyRefresh loadMoreBlock:(void(^)(NSInteger pageIndex))loadMoreBlock {
    self.loadMoreBlock = loadMoreBlock;
    if (automaticallyRefresh) {
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.pageIndex += 1;
            if (self.loadMoreBlock) {
                self.loadMoreBlock(self.pageIndex);
            }
        }];
        
        footer.automaticallyRefresh = automaticallyRefresh;
        
//        footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
//        footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
//        [footer setTitle:@"加载中…" forState:MJRefreshStateRefreshing];
//        [footer setTitle:@"~~这是我的底线啦~~" forState:MJRefreshStateNoMoreData];
        
        self.mj_footer = footer;
    }
    else{
        MJRefreshBackNormalFooter * footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.pageIndex += 1;
            if (self.loadMoreBlock) {
                self.loadMoreBlock(self.pageIndex);
            }
        }];
        
//        footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
//        footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
//        [footer setTitle:@"加载中…" forState:MJRefreshStateRefreshing];
//        [footer setTitle:@"~~这是我的底线啦~~" forState:MJRefreshStateNoMoreData];
        
        self.mj_footer = footer;
    }
}


-(void)beginHeaderRefresh {
    
    [self.mj_header beginRefreshing];
}

- (void)resetNoMoreData {
    
    [self.mj_footer resetNoMoreData];
}

-(void)endHeaderRefresh {
    
    [self.mj_header endRefreshing];
    [self resetNoMoreData];
}

-(void)endFooterRefresh {
    [self.mj_footer endRefreshing];
}

- (void)endFooterNoMoreData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_footer endRefreshingWithNoMoreData];
    });
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
