//
//  InputPasswordAlertView.h
//  full_lease_landlord
//
//  Created by apple on 2020/11/14.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputPasswordAlertView : UIView
- (void)show;
- (void)removeViews;
- (instancetype)initWithMoney:(NSString *)money completion:(void (^)(NSString *password))completion cancel:(nullable void (^)(void))cancelBlock;
@end

NS_ASSUME_NONNULL_END
