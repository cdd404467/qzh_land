//
//  IncomeDetailVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IncomeDetailVC : BaseViewController
@property (nonatomic, copy)NSString *incomeID;
@end

@interface IncomeDetailTxtView : UIView
@property (nonatomic, strong)UILabel *leftLab;
@property (nonatomic, strong)UILabel *rightLab;
@end

NS_ASSUME_NONNULL_END
