//
//  LockCycleScrollViewCell.h
//  FullLease
//
//  Created by wz on 2020/11/19.
//  Copyright © 2020 kad. All rights reserved.
//

#import "GKCycleScrollViewCell.h"
#import "SmartDoorLockView.h"
#import "DoorLockModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LockCycleScrollViewCellDelegate <NSObject>

@optional

-(void)clickOneTimePasswordWithIndex:(NSInteger)index;
-(void)clickSendKeyWithIndex:(NSInteger)index;
-(void)clickKeyManagerWithIndex:(NSInteger)index;

@end

@interface LockCycleScrollViewCell : GKCycleScrollViewCell

@property (nonatomic, weak) id<LockCycleScrollViewCellDelegate> delegate;

@property (nonatomic, strong) SmartDoorLockView *smartDoorLockView;

@property (nonatomic, strong) DoorLockModel *model;

@property (nonatomic, assign) NSInteger index;

-(void)refreshModel:(DoorLockModel *)model index:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
