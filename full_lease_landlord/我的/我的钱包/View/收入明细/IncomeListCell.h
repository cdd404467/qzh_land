//
//  IncomeListCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncomeListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)IncomeListModel *model;
@end

NS_ASSUME_NONNULL_END
