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
@interface MyLeaseDetailTBHeader : UIView
@property (nonatomic, strong)UILabel *addressLab;
@property (nonatomic, strong)NSString *stateTxt;
@property (nonatomic, copy)TapClick tapClick;
@end
NS_ASSUME_NONNULL_END
