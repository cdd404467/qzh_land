//
//  MyBillDetailVC.h
//  FullLease
//
//  Created by apple on 2020/8/25.
//  Copyright © 2020 kad. All rights reserved.
//

#import "BaseViewController.h"


@class BillModel;
NS_ASSUME_NONNULL_BEGIN

@interface MyBillDetailVC : BaseViewController
@property (nonatomic, copy)NSString *billID;
@end



typedef void(^ClickPay)(void);
@interface MyBillDetailHeader : UIView
@property (nonatomic, strong)BillModel *model;
@property (nonatomic, copy)ClickPay clickPay;
@end
NS_ASSUME_NONNULL_END
