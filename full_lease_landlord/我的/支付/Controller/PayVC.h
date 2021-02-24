//
//  PayVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/9/22.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayVC : BaseViewController
@property (nonatomic, copy)NSString *billID;
@property (nonatomic, copy)NSString *recent;
@end

@interface PayTableHeader : UIView
@property (nonatomic, strong)UITextField *moneyTF;
@property (nonatomic, strong)UILabel *tipLab;
@end

NS_ASSUME_NONNULL_END
