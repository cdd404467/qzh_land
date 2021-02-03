//
//  LeaseBillDetailVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"
@class LeaseBillModel;
NS_ASSUME_NONNULL_BEGIN

@interface LeaseBillDetailVC : BaseViewController
@property (nonatomic, copy)NSString *billID;
@end

@interface LeaseBillDetailHeader : UIView
@property (nonatomic, strong)LeaseBillModel *model;
@property (nonatomic, assign)BOOL isPay;
@end
NS_ASSUME_NONNULL_END
