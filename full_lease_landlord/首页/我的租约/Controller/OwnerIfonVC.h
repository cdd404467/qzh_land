//
//  OwnerIfonVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/31.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OwnerIfonVC : BaseViewController
@property (nonatomic, copy)NSString *conID;
//1是业主，2是租客
@property (nonatomic, assign)NSInteger type;
@end

NS_ASSUME_NONNULL_END
