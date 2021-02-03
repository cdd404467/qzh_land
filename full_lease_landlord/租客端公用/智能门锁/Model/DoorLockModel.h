//
//  DoorLockModel.h
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoorGuojiaLockModel : NSObject

@property (nonatomic, strong) NSString *pwdId;
@property (nonatomic, strong) NSString *electricQuantity;
@property (nonatomic, assign) NSInteger passWordLength;

@end

@interface DoorLockBluetoothModel : NSObject

@property (nonatomic, strong) NSString *specialValue;
@property (nonatomic, strong) NSString *lockAlias;
@property (nonatomic, strong) NSString *keyStatus;
@property (nonatomic, strong) NSString *keyRight;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *keyId;
@property (nonatomic, strong) NSString *lockMac;
@property (nonatomic, strong) NSString *lockId;
@property (nonatomic, strong) NSString *electricQuantity;
@property (nonatomic, strong) NSString *lockData;
@property (nonatomic, strong) NSString *remoteEnable;
@property (nonatomic, strong) NSString *lockName;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *remarks;

@end


@interface DoorLockModel : NSObject

@property (nonatomic, strong) NSString *lockId;
@property (nonatomic, assign)  int frontDoor;
@property (nonatomic, strong) NSString *houseId;
@property (nonatomic, strong) DoorLockBluetoothModel *bluetooth;
@property (nonatomic, strong) NSString *doorAddress;
@property (nonatomic, strong) NSString *lockType;
@property (nonatomic, strong) DoorGuojiaLockModel *password;

@end





NS_ASSUME_NONNULL_END
