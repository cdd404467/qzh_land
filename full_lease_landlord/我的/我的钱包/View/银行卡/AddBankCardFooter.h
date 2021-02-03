//
//  AddBankCardFooter.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/8.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapClickBlock)(NSInteger tag);
@interface AddBankCardFooter : UIView
@property (nonatomic, copy)TapClickBlock tapClickBlock;
@end

NS_ASSUME_NONNULL_END
