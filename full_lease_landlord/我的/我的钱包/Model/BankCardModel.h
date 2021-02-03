//
//  BankCardModel.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/11.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCardModel : NSObject
@property (nonatomic, copy)NSString *bankCardID;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSInteger type;

//我的银行卡列表
@property (nonatomic, copy)NSString *bankname;
@property (nonatomic, copy)NSString *bankCardType;
@property (nonatomic, copy)NSString *account;

//提现时多久到账
@property (nonatomic, copy)NSString *timeToAccount;
@end

NS_ASSUME_NONNULL_END
