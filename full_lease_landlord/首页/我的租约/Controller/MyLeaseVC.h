//
//  MyLeaseVC.h
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLeaseVC : BaseViewController
//0-正常列表 1-联系管家过来的 2-我的页面跳转过来
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)NSInteger count;
@end

NS_ASSUME_NONNULL_END
