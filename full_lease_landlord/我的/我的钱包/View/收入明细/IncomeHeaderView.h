//
//  IncomeHeaderView.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectBlock)(void);
@interface IncomeHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)SelectBlock selectBlock;
@property (nonatomic, strong)UIButton *timeBtn;
@property (nonatomic, strong)UILabel *spendLab;
@property (nonatomic, strong)UILabel *incomeLab;
@property (nonatomic, copy)NSString *timeStr;
@end

NS_ASSUME_NONNULL_END
