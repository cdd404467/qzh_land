//
//  MyLeaseDetail2VC.h
//  full_lease_landlord
//
//  Created by apple on 2021/3/23.
//  Copyright © 2021 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLeaseDetail2VC : BaseViewController
@property (nonatomic, copy)NSString *conID;
@end

typedef void(^TapClick)(NSInteger index);
typedef void(^GoSign)(void);
@interface MyLeaseDetailTBHeader : UIView
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)NSString *stateTxt;
@property (nonatomic, copy)TapClick tapClick;
@property (nonatomic, copy)GoSign goSign;
- (void)disPlayDownLoad:(ContractModel *)model;
@end
NS_ASSUME_NONNULL_END
