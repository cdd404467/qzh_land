//
//  MyWalletTBHeader.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/5.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TixianBlock)(void);
@interface MyWalletTBHeader : UIView
@property (nonatomic, copy)NSString *remainMoney;
@property (nonatomic, copy)NSString *addupMoney;
@property (nonatomic, copy)TixianBlock tixianBlock;
@end

NS_ASSUME_NONNULL_END

