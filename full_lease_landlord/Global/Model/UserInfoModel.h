//
//  UserInfoModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject
@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userPhone;

@property (nonatomic, copy) NSString *userFace;

@property (nonatomic, copy) NSString *userMoney;
@end

NS_ASSUME_NONNULL_END
