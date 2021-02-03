//
//  DoorLockNumberModel.h
//  FullLease
//
//  Created by wz on 2020/11/20.
//  Copyright © 2020 kad. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoorLockNumberModel : NSObject

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong)  NSString *startTime;
@property (nonatomic, assign) int frontDoor;
@property (nonatomic, strong) NSString *endTime;

@end

NS_ASSUME_NONNULL_END
