//
//  SmartDoorLockTypeView.h
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoorLockModel.h"

typedef void(^OneTimePasswordBlock)(void);
typedef void(^UpdatePasswordBlock)(void);
typedef void(^SendKeyBlock)(void);
typedef void(^KeyManagerBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface SmartDoorLockTypeView : UIView

@property (nonatomic, copy) OneTimePasswordBlock oneTimePWD;

@property (nonatomic, copy) UpdatePasswordBlock updatePWD;

@property (nonatomic, copy) SendKeyBlock sendKey;

@property (nonatomic, copy) KeyManagerBlock keyManager;

@property (nonatomic, strong) DoorLockModel *model;

@end

NS_ASSUME_NONNULL_END
