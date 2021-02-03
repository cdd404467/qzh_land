//
//  MyWalletCell.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyWalletCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UILabel *subTitleLab;
@end

NS_ASSUME_NONNULL_END
