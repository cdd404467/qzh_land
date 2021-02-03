//
//  ManagerInfoModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/31.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManagerInfoModel : NSObject
//管家头像
@property (nonatomic, copy)NSString *keeperAvatar;
//管家手机号
@property (nonatomic, copy)NSString *mobile;
//管家真实姓名
@property (nonatomic, copy)NSString *realname;
@end

NS_ASSUME_NONNULL_END
