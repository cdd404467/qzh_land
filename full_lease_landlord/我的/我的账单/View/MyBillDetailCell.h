//
//  MyBillDetailCell.h
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DictModel;

NS_ASSUME_NONNULL_BEGIN

@interface MyBillDetailCell : UITableViewCell
@property (nonatomic, strong)DictModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
