//
//  LeaseContractCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZukeConModel;
NS_ASSUME_NONNULL_BEGIN

@interface LeaseContractCell : UITableViewCell
@property (nonatomic, strong)ZukeConModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
