//
//  LockCycleScrollGujiaCell.h
//  FullLease
//
//  Created by wz on 2020/11/23.
//  Copyright © 2020 kad. All rights reserved.
//

#import "GKCycleScrollViewCell.h"
#import "SmartDoorLockTypeView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LockCycleScrollGujiaCellDelegate <NSObject>

@optional

-(void)clickOneTimePasswordWithIndex:(NSInteger)index;

-(void)clickUpdatePasswordWithIndex:(NSInteger)index;

@end

@interface LockCycleScrollGujiaCell : GKCycleScrollViewCell

@property (nonatomic, weak) id<LockCycleScrollGujiaCellDelegate> delegate;

@property (nonatomic, strong) SmartDoorLockTypeView *smartDoorLockTypeView;

@property (nonatomic, strong) DoorLockModel *model;

@property (nonatomic, assign) NSInteger index;

-(void)refreshModel:(DoorLockModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
