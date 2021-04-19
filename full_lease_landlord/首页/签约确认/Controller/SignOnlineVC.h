//
//  SignOnlineVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignOnlineVC : BaseViewController
@property (nonatomic, copy)NSString *conID;
//1-租客 2-业主
@property (nonatomic, assign)NSInteger type;
@end

NS_ASSUME_NONNULL_END
