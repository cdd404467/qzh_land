//
//  HouseResourceListCell.h
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HouseInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface HouseResourceListCell : UITableViewCell
@property (nonatomic, strong)HouseInfoModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
