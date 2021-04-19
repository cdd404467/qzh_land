//
//  PreviewConVC.h
//  full_lease_landlord
//
//  Created by apple on 2020/10/19.
//  Copyright © 2020 apple. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PreviewConVC : BaseViewController
@property (nonatomic, copy)NSString *conID;
//0 - 租客 1-托管业主 2-业主
@property (nonatomic, assign)NSInteger type;
@end

NS_ASSUME_NONNULL_END
