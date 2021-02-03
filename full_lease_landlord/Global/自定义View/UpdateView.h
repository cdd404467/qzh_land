//
//  UpdateView.h
//  FullLease
//
//  Created by apple on 2020/8/20.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateView : UIView
//文本
@property (nonatomic, copy)NSString *content;
//更新类型 1-可选，2-强制
@property (nonatomic, assign)NSInteger updateType;
//版本
@property (nonatomic, copy)NSString *version;
//更新地址
@property (nonatomic, copy)NSString *url;
@end

NS_ASSUME_NONNULL_END
