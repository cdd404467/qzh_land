//
//  DoorLockCell.h
//  Door_Lock
//
//  Created by wz on 2020/11/25.
//

#import <UIKit/UIKit.h>
#import "DoorLockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoorLockCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *electricityLab;

@property (nonatomic, strong) DoorLockModel *model;
@end

NS_ASSUME_NONNULL_END
