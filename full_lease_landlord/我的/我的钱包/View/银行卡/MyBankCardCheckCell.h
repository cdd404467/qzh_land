//
//  MyBankCardCheckCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyBankCardCheckCell : UITableViewCell
@property (nonatomic, strong)BankCardModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
