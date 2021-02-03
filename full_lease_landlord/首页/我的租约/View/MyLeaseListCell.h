//
//  MyLeaseListCell.h
//  FullLease
//
//  Created by apple on 2020/8/22.
//  Copyright © 2020 kad. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContractModel;
NS_ASSUME_NONNULL_BEGIN

@interface MyLeaseListCell : UITableViewCell
@property (nonatomic, strong)ContractModel *model;
@end

NS_ASSUME_NONNULL_END
