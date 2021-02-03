//
//  MyBillListCell.h
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyBillListCell : UITableViewCell
@property (nonatomic, strong)BillModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
