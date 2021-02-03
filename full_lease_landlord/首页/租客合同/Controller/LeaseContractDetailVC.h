//
//  LeaseContractDetailVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/29.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeaseContractDetailVC : BaseViewController
@property (nonatomic, copy)NSString *conID;
@end

typedef void(^TapClick)(NSInteger index);
@interface LeaseConDetailTopView : UIView
@property (nonatomic, copy)TapClick tapClick;
@end

NS_ASSUME_NONNULL_END
