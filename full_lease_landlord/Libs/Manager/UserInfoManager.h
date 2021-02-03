//
//  UserInfoManager.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoManager : NSObject
//是否登录
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic,strong) UserInfoModel* model;
+(UserInfoManager *)sharedInstance;
@end

NS_ASSUME_NONNULL_END
