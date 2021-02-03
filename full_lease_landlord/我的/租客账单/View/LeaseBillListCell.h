//
//  LeaseBillListCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaseBillModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeaseBillListCell : UITableViewCell
@property (nonatomic, strong)LeaseBillModel *model;
@property (nonatomic, assign)NSInteger type;
@end

NS_ASSUME_NONNULL_END
