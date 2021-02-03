//
//  WalletModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletModel : NSObject
@property (nonatomic, copy)NSString *createtime;
@property (nonatomic, copy)NSString *amount;
@property (nonatomic, copy)NSString *housename;
@property (nonatomic, copy)NSString *stage;
@property (nonatomic, copy)NSString *sign;
//1-手动提现 2-自动提现
@property (nonatomic, assign)NSInteger type;
//1-待处理 2-提现成功 3-提现失败
@property (nonatomic, assign)NSInteger status;

@end

NS_ASSUME_NONNULL_END
