//
//  PayManagerCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/10.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayManagerCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)UILabel *titleLab;
@end

NS_ASSUME_NONNULL_END
