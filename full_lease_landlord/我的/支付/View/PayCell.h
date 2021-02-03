//
//  PayCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/22.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayCell : UITableViewCell
@property (nonatomic, strong)PayModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign)BOOL isLast;
@end

NS_ASSUME_NONNULL_END
