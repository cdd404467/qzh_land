//
//  BankCardListCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^UnBindBlock)(NSString *bankcardID);
@interface BankCardListCell : UITableViewCell
@property (nonatomic, strong)BankCardModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)UnBindBlock unBindBlock;
@end

NS_ASSUME_NONNULL_END
