//
//  AlertInputPhoneVIew.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/13.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^YesBlock)(void);
@interface AlertInputPhoneVIew : UIView
@property (nonatomic, strong) UITextField *codeTF;
@property (nonatomic, strong)UIButton *sendCodeBtn;
@property (nonatomic, strong)NSString *phone;
@property (nonatomic, copy)YesBlock yesBlock;
- (void)show;
- (void)remove;
@end

NS_ASSUME_NONNULL_END
