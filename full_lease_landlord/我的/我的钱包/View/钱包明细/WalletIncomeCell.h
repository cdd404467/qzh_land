//
//  WalletIncomeCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/12.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletIncomeCell : UITableViewCell
@property (nonatomic, strong)WalletModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
