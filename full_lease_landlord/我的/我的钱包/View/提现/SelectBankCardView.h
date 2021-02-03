//
//  SelectBankCardView.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface SelectBankCardView : UIView
- (instancetype)initWithDataSource:(NSArray *)dataSource completion:(void (^)(NSInteger index))completion cancel:(nullable void (^)(void))cancelBlock;
- (void)show;
@end

@interface SelectBankCardViewCell : UITableViewCell
@property (nonatomic, strong)BankCardModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
NS_ASSUME_NONNULL_END
